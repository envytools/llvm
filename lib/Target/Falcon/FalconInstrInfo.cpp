//===-- FalconInstrInfo.cpp - Falcon Instruction Information ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the Falcon implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "Falcon.h"
#include "FalconInstrInfo.h"
#include "FalconSubtarget.h"
#include "FalconTargetMachine.h"
#include "MCTargetDesc/FalconMCTargetDesc.h"
#include "llvm/CodeGen/LiveVariables.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

#define GET_INSTRINFO_CTOR_DTOR
#include "FalconGenInstrInfo.inc"

using namespace llvm;

FalconInstrInfo::FalconInstrInfo()
    : FalconGenInstrInfo(Falcon::ADJCALLSTACKDOWN, Falcon::ADJCALLSTACKUP) {}

void FalconInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                               MachineBasicBlock::iterator I, DebugLoc DL,
                               unsigned DestReg, unsigned SrcReg,
                               bool KillSrc) const {
  if (Falcon::GPR8RegClass.contains(DestReg, SrcReg))
    BuildMI(MBB, I, DL, get(Falcon::MOVbrr), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc));
  else if (Falcon::GPR16RegClass.contains(DestReg, SrcReg))
    BuildMI(MBB, I, DL, get(Falcon::MOVhrr), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc));
  else if (Falcon::GPR32RegClass.contains(DestReg, SrcReg))
    BuildMI(MBB, I, DL, get(Falcon::MOVwrr), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc));
  else if (Falcon::GPR32RegClass.contains(DestReg) && Falcon::SRRRegClass.contains(SrcReg))
    BuildMI(MBB, I, DL, get(Falcon::S2Rrr), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc));
  else if (Falcon::SRWRegClass.contains(DestReg) && Falcon::GPR32RegClass.contains(SrcReg))
    BuildMI(MBB, I, DL, get(Falcon::R2Srr), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc));
  else
    llvm_unreachable("Impossible reg-to-reg copy");
}

static void transferDeadCC(MachineInstr *OldMI, MachineInstr *NewMI) {
  for (auto &Reg : { Falcon::CC_C, Falcon::CC_O, Falcon::CC_S, Falcon::CC_Z }) {
    if (OldMI->registerDefIsDead(Reg)) {
      MachineOperand *CCDef = NewMI->findRegisterDefOperand(Reg);
      if (CCDef != nullptr)
        CCDef->setIsDead(true);
    }
  }
}

// Used to return from convertToThreeAddress after replacing two-address
// instruction OldMI with three-address instruction NewMI.
static MachineInstr *finishConvertToThreeAddress(MachineInstr *OldMI,
                                                 MachineInstr *NewMI,
                                                 LiveVariables *LV) {
  if (LV) {
    unsigned NumOps = OldMI->getNumOperands();
    for (unsigned I = 1; I < NumOps; ++I) {
      MachineOperand &Op = OldMI->getOperand(I);
      if (Op.isReg() && Op.isKill())
        LV->replaceKillInstruction(Op.getReg(), OldMI, NewMI);
    }
  }
  transferDeadCC(OldMI, NewMI);
  return NewMI;
}

MachineInstr *
FalconInstrInfo::convertToThreeAddress(MachineFunction::iterator &MFI,
                                       MachineBasicBlock::iterator &MBBI,
                                       LiveVariables *LV) const {
  MachineInstr *MI = MBBI;
  MachineBasicBlock *MBB = MI->getParent();
  MachineFunction *MF = MBB->getParent();
  unsigned Opcode = MI->getOpcode();
  unsigned NumOps = MI->getNumOperands();

#if 0
  MachineRegisterInfo &MRI = MF->getRegInfo();
#endif

  MachineOperand &Dest = MI->getOperand(0);
  MachineOperand &Src = MI->getOperand(1);

  int ThreeOperandOpcode = Falcon::getThreeOperandOpcode(Opcode);
  if (ThreeOperandOpcode >= 0) {
    // Create three address instruction without adding the implicit
    // operands. Those will instead be copied over from the original
    // instruction by the loop below.
    MachineInstrBuilder MIB(*MF,
                            MF->CreateMachineInstr(get(ThreeOperandOpcode),
                                  MI->getDebugLoc(), /*NoImplicit=*/true));
    MIB.addOperand(Dest);
    // Keep the kill state, but drop the tied flag.
    MIB.addReg(Src.getReg(), getKillRegState(Src.isKill()), Src.getSubReg());
    // Keep the remaining operands as-is.
    for (unsigned I = 2; I < NumOps; ++I)
      MIB.addOperand(MI->getOperand(I));
    MBB->insert(MI, MIB);
    return finishConvertToThreeAddress(MI, MIB, LV);
  }
  return nullptr;
}

void FalconInstrInfo::storeRegToStackSlot(MachineBasicBlock &MBB,
                                       MachineBasicBlock::iterator I,
                                       unsigned SrcReg, bool IsKill, int FI,
                                       const TargetRegisterClass *RC,
                                       const TargetRegisterInfo *TRI) const {
  DebugLoc DL;
  if (I != MBB.end())
    DL = I->getDebugLoc();

  // XXX PRED
  if (RC == &Falcon::GPR8RegClass)
    BuildMI(MBB, I, DL, get(Falcon::STbrmri8))
        .addFrameIndex(FI)
        .addImm(0)
        .addReg(SrcReg, getKillRegState(IsKill));
  else if (RC == &Falcon::GPR16RegClass)
    BuildMI(MBB, I, DL, get(Falcon::SThrmri8))
        .addFrameIndex(FI)
        .addImm(0)
        .addReg(SrcReg, getKillRegState(IsKill));
  else if (RC == &Falcon::GPR32RegClass)
    BuildMI(MBB, I, DL, get(Falcon::STwrmri8))
        .addFrameIndex(FI)
        .addImm(0)
        .addReg(SrcReg, getKillRegState(IsKill));
  else
    llvm_unreachable("Can't store this register to stack slot");
}

void FalconInstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator I,
                                        unsigned DestReg, int FI,
                                        const TargetRegisterClass *RC,
                                        const TargetRegisterInfo *TRI) const {
  DebugLoc DL;
  if (I != MBB.end())
    DL = I->getDebugLoc();

  // XXX PRED
  if (RC == &Falcon::GPR8RegClass)
    BuildMI(MBB, I, DL, get(Falcon::LDbrmri8), DestReg)
        .addFrameIndex(FI)
        .addImm(0);
  else if (RC == &Falcon::GPR16RegClass)
    BuildMI(MBB, I, DL, get(Falcon::LDhrmri8), DestReg)
        .addFrameIndex(FI)
        .addImm(0);
  else if (RC == &Falcon::GPR32RegClass)
    BuildMI(MBB, I, DL, get(Falcon::LDwrmri8), DestReg)
        .addFrameIndex(FI)
        .addImm(0);
  else
    llvm_unreachable("Can't load this register from stack slot");
}

bool FalconInstrInfo::AnalyzeBranch(MachineBasicBlock &MBB,
                                 MachineBasicBlock *&TBB,
                                 MachineBasicBlock *&FBB,
                                 SmallVectorImpl<MachineOperand> &Cond,
                                 bool AllowModify) const {
  // Start from the bottom of the block and work up, examining the
  // terminator instructions.
  MachineBasicBlock::iterator I = MBB.end();
  while (I != MBB.begin()) {
    --I;
    if (I->isDebugValue())
      continue;

    // Working from the bottom, when we see a non-terminator
    // instruction, we're done.
    if (!isUnpredicatedTerminator(*I))
      break;

    // A terminator that isn't a branch can't easily be handled
    // by this analysis.
    if (!I->isBranch())
      return true;

    // Handle unconditional branches.
    if (I->getOpcode() == Falcon::BRAi8) {
      if (!AllowModify) {
        TBB = I->getOperand(0).getMBB();
        continue;
      }

      // If the block has any instructions after a BRA, delete them.
      while (std::next(I) != MBB.end())
        std::next(I)->eraseFromParent();
      Cond.clear();
      FBB = 0;

      // Delete the BRA if it's equivalent to a fall-through.
      if (MBB.isLayoutSuccessor(I->getOperand(0).getMBB())) {
        TBB = 0;
        I->eraseFromParent();
        I = MBB.end();
        continue;
      }

      // TBB is used to indicate the unconditinal destination.
      TBB = I->getOperand(0).getMBB();
      continue;
    }
    // Cannot handle conditional branches
    // XXX
    return true;
  }

  return false;
}

unsigned FalconInstrInfo::InsertBranch(MachineBasicBlock &MBB,
                                    MachineBasicBlock *TBB,
                                    MachineBasicBlock *FBB,
                                    ArrayRef<MachineOperand> Cond,
                                    DebugLoc DL) const {
  // Shouldn't be a fall through.
  assert(TBB && "InsertBranch must not be told to insert a fallthrough");

  // XXX
#if 0
  if (Cond.empty()) {
    // Unconditional branch
    assert(!FBB && "Unconditional branch with multiple successors!");
    BuildMI(&MBB, DL, get(Falcon::JMP)).addMBB(TBB);
    return 1;
  }
#endif

  llvm_unreachable("Unexpected conditional branch");
}

unsigned FalconInstrInfo::RemoveBranch(MachineBasicBlock &MBB) const {
  MachineBasicBlock::iterator I = MBB.end();
  unsigned Count = 0;

  // XXX
#if 0
  while (I != MBB.begin()) {
    --I;
    if (I->isDebugValue())
      continue;
    if (I->getOpcode() != Falcon::JMP)
      break;
    // Remove the branch.
    I->eraseFromParent();
    I = MBB.end();
    ++Count;
  }
#endif

  return Count;
}
