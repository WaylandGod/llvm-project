#ifndef THIRD_PARTY_LLVM_LLVM_TOOLS_CLANG_TOOLS_EXTRA_TEST_CLANG_TIDY_INPUTS_GTEST_GTEST_TYPED_TEST_H_
#define THIRD_PARTY_LLVM_LLVM_TOOLS_CLANG_TOOLS_EXTRA_TEST_CLANG_TIDY_INPUTS_GTEST_GTEST_TYPED_TEST_H_

#define TYPED_TEST_SUITE(CaseName, Types, ...)
#define TYPED_TEST_CASE TYPED_TEST_SUITE

#define TYPED_TEST_SUITE_P(SuiteName)
#define TYPED_TEST_CASE_P TYPED_TEST_SUITE_P

#define REGISTER_TYPED_TEST_SUITE_P(SuiteName, ...)
#define REGISTER_TYPED_TEST_CASE_P REGISTER_TYPED_TEST_SUITE_P

#define INSTANTIATE_TYPED_TEST_SUITE_P(Prefix, SuiteName, Types, ...)
#define INSTANTIATE_TYPED_TEST_CASE_P INSTANTIATE_TYPED_TEST_SUITE_P

#endif  // THIRD_PARTY_LLVM_LLVM_TOOLS_CLANG_TOOLS_EXTRA_TEST_CLANG_TIDY_INPUTS_GTEST_GTEST_TYPED_TEST_H_
