//===-- FalconCallingConv.td - Calling Conventions Falcon --*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This describes the calling conventions for the Falcon architecture.
//
//===----------------------------------------------------------------------===//

// Falcon C return-value convention.
def RetCC_Falcon : CallingConv<[
  CCIfType<[i1], CCAssignToReg<[P0, P1, P2, P3]>>,
  CCIfType<[i8], CCAssignToReg<[R10B, R11B, R12B, R13B]>>,
  CCIfType<[i16], CCAssignToReg<[R10H, R11H, R12H, R13H]>>,
  CCIfType<[i32], CCAssignToReg<[R10, R11, R12, R13]>>
]>;

// Falcon C Calling convention.
def CC_Falcon : CallingConv<[
  CCIfType<[i1], CCAssignToReg<[P0, P1, P2, P3]>>,
  CCIfType<[i8], CCAssignToReg<[R10B, R11B, R12B, R13B, R14B, R15B]>>,
  CCIfType<[i16], CCAssignToReg<[R10H, R11H, R12H, R13H, R14H, R15H]>>,
  CCIfType<[i32], CCAssignToReg<[R10, R11, R12, R13, R14, R15]>>,
  CCAssignToStack<4, 4>
]>;

def CSR : CalleeSavedRegs<(add R0, R1, R2, R3, R4, R5, R6, R7, R8, P4, P5, P6, P7)>;
