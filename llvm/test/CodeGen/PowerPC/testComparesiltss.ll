; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:   --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:   --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,LE

@glob = local_unnamed_addr global i16 0, align 2

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_iltss(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: test_iltss:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i16 %a, %b
  %conv2 = zext i1 %cmp to i32
  ret i32 %conv2
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_iltss_sext(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: test_iltss_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i16 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_iltss_sext_z(i16 signext %a) {
; CHECK-LABEL: test_iltss_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    srawi r3, r3, 31
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i16 %a, 0
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind
define void @test_iltss_store(i16 signext %a, i16 signext %b) {
; BE-LABEL: test_iltss_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    sub r3, r3, r4
; BE-NEXT:    ld r5, .LC0@toc@l(r5)
; BE-NEXT:    rldicl r3, r3, 1, 63
; BE-NEXT:    sth r3, 0(r5)
; BE-NEXT:    blr
;
; LE-LABEL: test_iltss_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sub r3, r3, r4
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    rldicl r3, r3, 1, 63
; LE-NEXT:    sth r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp slt i16 %a, %b
  %conv3 = zext i1 %cmp to i16
  store i16 %conv3, i16* @glob, align 2
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_iltss_sext_store(i16 signext %a, i16 signext %b) {
; BE-LABEL: test_iltss_sext_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    sub r3, r3, r4
; BE-NEXT:    ld r5, .LC0@toc@l(r5)
; BE-NEXT:    sradi r3, r3, 63
; BE-NEXT:    sth r3, 0(r5)
; BE-NEXT:    blr
;
; LE-LABEL: test_iltss_sext_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sub r3, r3, r4
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    sradi r3, r3, 63
; LE-NEXT:    sth r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp slt i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @glob, align 2
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_iltss_sext_z_store(i16 signext %a) {
; BE-LABEL: test_iltss_sext_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r4, r2, .LC0@toc@ha
; BE-NEXT:    srwi r3, r3, 15
; BE-NEXT:    ld r4, .LC0@toc@l(r4)
; BE-NEXT:    sth r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_iltss_sext_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    addis r4, r2, glob@toc@ha
; LE-NEXT:    srwi r3, r3, 15
; LE-NEXT:    sth r3, glob@toc@l(r4)
; LE-NEXT:    blr
entry:
  %cmp = icmp slt i16 %a, 0
  %sub = sext i1 %cmp to i16
  store i16 %sub, i16* @glob, align 2
  ret void
}
