// RUN: mlir-opt %s | FileCheck %s

// CHECK: #map0 = affine_map<(d0, d1)[s0] -> (d0 + s0, d1)>

// CHECK-LABEL: func @alloc() {
func @alloc() {
^bb0:
  // Test simple alloc.
  // CHECK: %0 = alloc() : memref<1024x64xf32, 1>
  %0 = alloc() : memref<1024x64xf32, affine_map<(d0, d1) -> (d0, d1)>, 1>

  %c0 = "std.constant"() {value = 0: index} : () -> index
  %c1 = "std.constant"() {value = 1: index} : () -> index

  // Test alloc with dynamic dimensions.
  // CHECK: %1 = alloc(%c0, %c1) : memref<?x?xf32, 1>
  %1 = alloc(%c0, %c1) : memref<?x?xf32, affine_map<(d0, d1) -> (d0, d1)>, 1>

  // Test alloc with no dynamic dimensions and one symbol.
  // CHECK: %2 = alloc()[%c0] : memref<2x4xf32, #map0, 1>
  %2 = alloc()[%c0] : memref<2x4xf32, affine_map<(d0, d1)[s0] -> ((d0 + s0), d1)>, 1>

  // Test alloc with dynamic dimensions and one symbol.
  // CHECK: %3 = alloc(%c1)[%c0] : memref<2x?xf32, #map0, 1>
  %3 = alloc(%c1)[%c0] : memref<2x?xf32, affine_map<(d0, d1)[s0] -> (d0 + s0, d1)>, 1>

  // Alloc with no mappings.
  // b/116054838 Parser crash while parsing ill-formed AllocOp
  // CHECK: %4 = alloc() : memref<2xi32>
  %4 = alloc() : memref<2 x i32>

  // CHECK:   return
  return
}

// CHECK-LABEL: func @dealloc() {
func @dealloc() {
^bb0:
  // CHECK: %0 = alloc() : memref<1024x64xf32>
  %0 = alloc() : memref<1024x64xf32, affine_map<(d0, d1) -> (d0, d1)>, 0>

  // CHECK: dealloc %0 : memref<1024x64xf32>
  dealloc %0 : memref<1024x64xf32, affine_map<(d0, d1) -> (d0, d1)>, 0>
  return
}

// CHECK-LABEL: func @load_store
func @load_store() {
^bb0:
  // CHECK: %0 = alloc() : memref<1024x64xf32, 1>
  %0 = alloc() : memref<1024x64xf32, affine_map<(d0, d1) -> (d0, d1)>, 1>

  %1 = constant 0 : index
  %2 = constant 1 : index

  // CHECK: %1 = load %0[%c0, %c1] : memref<1024x64xf32, 1>
  %3 = load %0[%1, %2] : memref<1024x64xf32, affine_map<(d0, d1) -> (d0, d1)>, 1>

  // CHECK: store %1, %0[%c0, %c1] : memref<1024x64xf32, 1>
  store %3, %0[%1, %2] : memref<1024x64xf32, affine_map<(d0, d1) -> (d0, d1)>, 1>

  return
}

// CHECK-LABEL: func @dma_ops()
func @dma_ops() {
  %c0 = constant 0 : index
  %stride = constant 32 : index
  %elt_per_stride = constant 16 : index

  %A = alloc() : memref<256 x f32, affine_map<(d0) -> (d0)>, 0>
  %Ah = alloc() : memref<256 x f32, affine_map<(d0) -> (d0)>, 1>
  %tag = alloc() : memref<1 x f32>

  %num_elements = constant 256 : index

  dma_start %A[%c0], %Ah[%c0], %num_elements, %tag[%c0] : memref<256 x f32>, memref<256 x f32, 1>, memref<1 x f32>
  dma_wait %tag[%c0], %num_elements : memref<1 x f32>
  // CHECK: dma_start %0[%c0], %1[%c0], %c256, %2[%c0] : memref<256xf32>, memref<256xf32, 1>, memref<1xf32>
  // CHECK-NEXT:  dma_wait %2[%c0], %c256 : memref<1xf32>

  // DMA with strides
  dma_start %A[%c0], %Ah[%c0], %num_elements, %tag[%c0], %stride, %elt_per_stride : memref<256 x f32>, memref<256 x f32, 1>, memref<1 x f32>
  dma_wait %tag[%c0], %num_elements : memref<1 x f32>
  // CHECK-NEXT  dma_start %0[%c0], %1[%c0], %c256, %2[%c0], %c32, %c16 : memref<256xf32>, memref<256xf32, 1>, memref<1xf32>
  // CHECK-NEXT  dma_wait %2[%c0], %c256 : memref<1xf32>

  return
}
