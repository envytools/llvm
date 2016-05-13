//===- IntrinsicsFalcon.td - Defines Falcon intrinsics -----*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the Falcon-specific intrinsics.
//
//===----------------------------------------------------------------------===//

let TargetPrefix = "falcon" in {
  // Halt the microprocessor.
  def int_falcon_hlt : Intrinsic<[], [], [IntrNoReturn]>, GCCBuiltin<"__falcon_hlt">;

  // IO ops.
  def int_falcon_iord : Intrinsic<[llvm_i32_ty], [llvm_i32_ty]>, GCCBuiltin<"__falcon_iord">;
  def int_falcon_iordb : Intrinsic<[llvm_i32_ty], [llvm_i32_ty]>, GCCBuiltin<"__falcon_iordb">;
  def int_falcon_iowr : Intrinsic<[], [llvm_i32_ty, llvm_i32_ty]>, GCCBuiltin<"__falcon_iowr">;
  def int_falcon_iowrb : Intrinsic<[], [llvm_i32_ty, llvm_i32_ty]>, GCCBuiltin<"__falcon_iowrb">;

  // Data transfer ops.
  def int_falcon_xdwait : Intrinsic<[], []>, GCCBuiltin<"__falcon_xdwait">;
  def int_falcon_xdbar : Intrinsic<[], []>, GCCBuiltin<"__falcon_xdbar">;
  def int_falcon_xcwait : Intrinsic<[], []>, GCCBuiltin<"__falcon_xcwait">;
  def int_falcon_xcld : Intrinsic<[], [llvm_i32_ty, llvm_i32_ty]>, GCCBuiltin<"__falcon_xcld">;
  def int_falcon_xdld : Intrinsic<[], [llvm_i32_ty, llvm_i32_ty]>, GCCBuiltin<"__falcon_xdld">;
  def int_falcon_xdst : Intrinsic<[], [llvm_i32_ty, llvm_i32_ty]>, GCCBuiltin<"__falcon_xdst">;

  // TLB ops.
  def int_falcon_itlb : Intrinsic<[], [llvm_i32_ty]>, GCCBuiltin<"__falcon_itlb">;
  def int_falcon_ptlb : Intrinsic<[llvm_i32_ty], [llvm_i32_ty]>, GCCBuiltin<"__falcon_ptlb">;
  def int_falcon_vtlb : Intrinsic<[llvm_i32_ty], [llvm_i32_ty]>, GCCBuiltin<"__falcon_vtlb">;

  // Crypto op.
  def int_falcon_cc : Intrinsic<[], [llvm_i32_ty, llvm_i32_ty]>, GCCBuiltin<"__falcon_cc">;
}
