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
  CCIfType<[i1], CCAssignToReg<[P0, P1]>>,
  CCIfType<[i8], CCAssignToReg<[R0B, R1B]>>,
  CCIfType<[i16], CCAssignToReg<[R0H, R1H]>>,
  CCIfType<[i32], CCAssignToReg<[R0, R1]>>
]>;

// Falcon C Calling convention.
def CC_Falcon : CallingConv<[
  CCIfType<[i1], CCAssignToReg<[P0, P1, P2, P3]>>,
  CCIfType<[i8], CCAssignToReg<[R0B, R1B, R2B, R3B, R4B, R5B]>>,
  CCIfType<[i16], CCAssignToReg<[R0H, R1H, R2H, R3H, R4H, R5H]>>,
  CCIfType<[i32], CCAssignToReg<[R0, R1, R2, R3, R4, R5]>>,
  CCAssignToStack<4, 4>
]>;

def CSR : CalleeSavedRegs<(add R8, R9, R10, R11, R12, R13, R14, R15)>;
