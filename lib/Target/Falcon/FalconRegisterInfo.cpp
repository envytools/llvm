//===-- FalconRegisterInfo.cpp - Falcon Register Information ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the Falcon implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "Falcon.h"
#include "FalconRegisterInfo.h"
#include "FalconSubtarget.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Target/TargetFrameLowering.h"
#include "llvm/Target/TargetInstrInfo.h"

#define GET_REGINFO_TARGET_DESC
#include "FalconGenRegisterInfo.inc"
using namespace llvm;

FalconRegisterInfo::FalconRegisterInfo()
    : FalconGenRegisterInfo(Falcon::PC) {}

const MCPhysReg *
FalconRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  return CSR_SaveList;
}

BitVector FalconRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());
  // XXX
  Reserved.set(Falcon::IE0);
  Reserved.set(Falcon::IE1);
  Reserved.set(Falcon::SIE0);
  Reserved.set(Falcon::SIE1);
  Reserved.set(Falcon::TA);
  Reserved.set(Falcon::SP);
  Reserved.set(Falcon::IV0);
  Reserved.set(Falcon::IV1);
  Reserved.set(Falcon::TV);
  Reserved.set(Falcon::TSTAT);
  return Reserved;
}

void FalconRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                          int SPAdj, unsigned FIOperandNum,
                                          RegScavenger *RS) const {
  assert(SPAdj == 0 && "Unexpected");
  // XXX

#if 0

  unsigned i = 0;
  MachineInstr &MI = *II;
  MachineFunction &MF = *MI.getParent()->getParent();
  DebugLoc DL = MI.getDebugLoc();

  while (!MI.getOperand(i).isFI()) {
    ++i;
    assert(i < MI.getNumOperands() && "Instr doesn't have FrameIndex operand!");
  }

  unsigned FrameReg = getFrameRegister(MF);
  int FrameIndex = MI.getOperand(i).getIndex();
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  MachineBasicBlock &MBB = *MI.getParent();

  if (MI.getOpcode() == Falcon::MOV_rr) {
    int Offset = MF.getFrameInfo()->getObjectOffset(FrameIndex);

    MI.getOperand(i).ChangeToRegister(FrameReg, false);
    unsigned reg = MI.getOperand(i - 1).getReg();
    BuildMI(MBB, ++II, DL, TII.get(Falcon::ADD_ri), reg)
        .addReg(reg)
        .addImm(Offset);
    return;
  }

  int Offset = MF.getFrameInfo()->getObjectOffset(FrameIndex) +
               MI.getOperand(i + 1).getImm();

  if (!isInt<32>(Offset))
    llvm_unreachable("bug in frame offset");

  if (MI.getOpcode() == Falcon::FI_ri) {
    // architecture does not really support FI_ri, replace it with
    //    MOV_rr <target_reg>, frame_reg
    //    ADD_ri <target_reg>, imm
    unsigned reg = MI.getOperand(i - 1).getReg();

    BuildMI(MBB, ++II, DL, TII.get(Falcon::MOV_rr), reg)
        .addReg(FrameReg);
    BuildMI(MBB, II, DL, TII.get(Falcon::ADD_ri), reg)
        .addReg(reg)
        .addImm(Offset);

    // Remove FI_ri instruction
    MI.eraseFromParent();
  } else {
    MI.getOperand(i).ChangeToRegister(FrameReg, false);
    MI.getOperand(i + 1).ChangeToImmediate(Offset);
  }
#endif
}

unsigned FalconRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  // XXX
  return Falcon::SP;
}
