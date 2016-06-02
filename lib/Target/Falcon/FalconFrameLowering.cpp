//===-- FalconFrameLowering.cpp - Falcon Frame Information ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the Falcon implementation of TargetFrameLowering class.
//
//===----------------------------------------------------------------------===//

#include "FalconFrameLowering.h"
#include "FalconInstrInfo.h"
#include "FalconSubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

using namespace llvm;

bool FalconFrameLowering::hasFP(const MachineFunction &MF) const {
  return MF.getFrameInfo()->hasVarSizedObjects();
}

int FalconFrameLowering::getFrameIndexReference(const MachineFunction &MF,
                                                int FI,
                                                unsigned &FrameReg) const {
  const MachineFrameInfo *MFFrame = MF.getFrameInfo();
  const TargetRegisterInfo *RI = MF.getSubtarget().getRegisterInfo();

  // Fill in FrameReg output argument.
  FrameReg = RI->getFrameRegister(MF);

  // XXX
  // Start with the offset of FI from the top of the caller-allocated frame
  // This initial offset is therefore negative.
  int64_t Offset = (MFFrame->getObjectOffset(FI) +
                    MFFrame->getOffsetAdjustment());

  // Make the offset relative to the incoming stack pointer.
  Offset -= getOffsetOfLocalArea();

  // Make the offset relative to the bottom of the frame.
  Offset += MFFrame->getStackSize();

  return Offset;
}

// XXX

void FalconFrameLowering::emitPrologue(MachineFunction &MF,
                                    MachineBasicBlock &MBB) const {}

void FalconFrameLowering::emitEpilogue(MachineFunction &MF,
                                    MachineBasicBlock &MBB) const {}

void FalconFrameLowering::determineCalleeSaves(MachineFunction &MF,
                                            BitVector &SavedRegs,
                                            RegScavenger *RS) const {
  TargetFrameLowering::determineCalleeSaves(MF, SavedRegs, RS);
}
