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
  const FalconFrameLowering *TFI = getFrameLowering(MF);
  BitVector Reserved(getNumRegs());
  if (TFI->hasFP(MF)) {
    Reserved.set(Falcon::R0);
    Reserved.set(Falcon::R0H);
    Reserved.set(Falcon::R0B);
  }
  // XXX global GPRs
  // XXX global PREDs
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

  unsigned i = 0;
  MachineInstr &MI = *II;
  MachineFunction &MF = *MI.getParent()->getParent();
  DebugLoc DL = MI.getDebugLoc();

  while (!MI.getOperand(i).isFI()) {
    ++i;
    assert(i < MI.getNumOperands() && "Instr doesn't have FrameIndex operand!");
  }

  unsigned FrameReg;
  int FrameIndex = MI.getOperand(i).getIndex();
  const FalconFrameLowering *TFI = getFrameLowering(MF);
  int64_t Offset = (TFI->getFrameIndexReference(MF, FrameIndex, FrameReg) +
                    MI.getOperand(FIOperandNum + 1).getImm());
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  MachineBasicBlock &MBB = *MI.getParent();
  unsigned OpcodeSPI8;
  unsigned reg;
  bool isStore;

  switch (MI.getOpcode()) {
  case Falcon::MOVrfi: {
    reg = MI.getOperand(0).getReg();
    bool Small = Offset < 0x100;

    if (FrameReg == Falcon::SP) {
      BuildMI(MBB, ++II, DL, TII.get(Falcon::S2Rrr), reg)
          .addReg(FrameReg);
      if (Offset)
        BuildMI(MBB, II, DL, TII.get(Small ? Falcon::ADDwri8 : Falcon::ADDwri16), reg)
            .addReg(reg)
            .addImm(Offset);
    } else {
      BuildMI(MBB, II, DL, TII.get(Small ? Falcon::ADDwrri8 : Falcon::ADDwrri16), reg)
          .addReg(FrameReg)
          .addImm(Offset);
    }

    // Remove MOVrfi
    MI.eraseFromParent();
    return;
  }

  case Falcon::STbrmri8:
    OpcodeSPI8 = Falcon::STbrmspi8;
    reg = MI.getOperand(2).getReg();
    isStore = true;
    break;
  case Falcon::SThrmri8:
    OpcodeSPI8 = Falcon::SThrmspi8;
    reg = MI.getOperand(2).getReg();
    isStore = true;
    break;
  case Falcon::STwrmri8:
    OpcodeSPI8 = Falcon::STwrmspi8;
    reg = MI.getOperand(2).getReg();
    isStore = true;
    break;

  case Falcon::LDbrmri8:
    OpcodeSPI8 = Falcon::LDbrmspi8;
    reg = MI.getOperand(0).getReg();
    isStore = false;
    break;
  case Falcon::LDhrmri8:
    OpcodeSPI8 = Falcon::LDhrmspi8;
    reg = MI.getOperand(0).getReg();
    isStore = false;
    break;
  case Falcon::LDwrmri8:
    OpcodeSPI8 = Falcon::LDwrmspi8;
    reg = MI.getOperand(0).getReg();
    isStore = false;
    break;

  default:
    llvm_unreachable("frameindex in funny instruction");
  }

  // XXX: what if it does not fit?
  if (FrameReg == Falcon::SP) {
    if (isStore)
      BuildMI(MBB, ++II, DL, TII.get(OpcodeSPI8))
          .addImm(Offset)
          .addReg(reg);
    else
      BuildMI(MBB, ++II, DL, TII.get(OpcodeSPI8))
          .addReg(reg)
          .addImm(Offset);
    MI.eraseFromParent();
  } else {
    MI.getOperand(FIOperandNum).ChangeToRegister(FrameReg, false);
    MI.getOperand(FIOperandNum+1).ChangeToImmediate(Offset);
  }

  // XXX

#if 0
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
  const FalconFrameLowering *TFI = getFrameLowering(MF);
  return TFI->hasFP(MF) ? Falcon::R0 : Falcon::SP;
}
