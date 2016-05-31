//===-- FalconMCTargetDesc.cpp - Falcon Target Descriptions ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file provides Falcon specific target descriptions.
//
//===----------------------------------------------------------------------===//

#include "Falcon.h"
#include "FalconMCTargetDesc.h"
#include "FalconMCAsmInfo.h"
#include "InstPrinter/FalconInstPrinter.h"
#include "llvm/MC/MCCodeGenInfo.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

#define GET_INSTRINFO_MC_DESC
#include "FalconGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "FalconGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "FalconGenRegisterInfo.inc"

using namespace llvm;

const unsigned FalconMC::GPR8Regs[16] = {
  Falcon::R0B, Falcon::R1B, Falcon::R2B, Falcon::R3B,
  Falcon::R4B, Falcon::R5B, Falcon::R6B, Falcon::R7B,
  Falcon::R8B, Falcon::R9B, Falcon::R10B, Falcon::R11B,
  Falcon::R12B, Falcon::R13B, Falcon::R14B, Falcon::R15B,
};

const unsigned FalconMC::GPR16Regs[16] = {
  Falcon::R0H, Falcon::R1H, Falcon::R2H, Falcon::R3H,
  Falcon::R4H, Falcon::R5H, Falcon::R6H, Falcon::R7H,
  Falcon::R8H, Falcon::R9H, Falcon::R10H, Falcon::R11H,
  Falcon::R12H, Falcon::R13H, Falcon::R14H, Falcon::R15H,
};

const unsigned FalconMC::GPR32Regs[16] = {
  Falcon::R0, Falcon::R1, Falcon::R2, Falcon::R3,
  Falcon::R4, Falcon::R5, Falcon::R6, Falcon::R7,
  Falcon::R8, Falcon::R9, Falcon::R10, Falcon::R11,
  Falcon::R12, Falcon::R13, Falcon::R14, Falcon::R15,
};

const unsigned FalconMC::FLAGRegs[32] = {
  Falcon::P0, Falcon::P1, Falcon::P2, Falcon::P3,
  Falcon::P4, Falcon::P5, Falcon::P6, Falcon::P7,
  Falcon::CC_C, Falcon::CC_O, Falcon::CC_S, Falcon::CC_Z,
  0, 0, 0, 0,
  Falcon::IE0, Falcon::IE1, 0, 0,
  Falcon::SIE0, Falcon::SIE1, 0, 0,
  Falcon::TA, 0, 0, 0, 0, 0, 0, 0,
};

const unsigned FalconMC::SRRegs[16] = {
  Falcon::IV0, Falcon::IV1, 0, Falcon::TV,
  Falcon::SP, Falcon::PC, Falcon::XCBASE, Falcon::XDBASE,
  Falcon::FLAGS, Falcon::CX, Falcon::CAUTH, Falcon::XPORTS,
  Falcon::TSTAT, 0, 0, 0,
};

static MCInstrInfo *createFalconMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitFalconMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createFalconMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitFalconMCRegisterInfo(X, Falcon::PC);
  return X;
}

static MCSubtargetInfo *createFalconMCSubtargetInfo(const Triple &TT,
                                                    StringRef CPU, StringRef FS) {
  return createFalconMCSubtargetInfoImpl(TT, CPU, FS);
}

static MCCodeGenInfo *createFalconMCCodeGenInfo(const Triple &TT, Reloc::Model RM,
                                                CodeModel::Model CM,
                                                CodeGenOpt::Level OL) {
  MCCodeGenInfo *X = new MCCodeGenInfo();
  X->initMCCodeGenInfo(RM, CM, OL);
  return X;
}

static MCStreamer *createFalconMCStreamer(const Triple &T,
                                          MCContext &Ctx, MCAsmBackend &MAB,
                                          raw_pwrite_stream &OS, MCCodeEmitter *Emitter,
                                          bool RelaxAll) {
  return createELFStreamer(Ctx, MAB, OS, Emitter, RelaxAll);
}

static MCInstPrinter *createFalconMCInstPrinter(const Triple &T,
                                                unsigned SyntaxVariant,
                                                const MCAsmInfo &MAI,
                                                const MCInstrInfo &MII,
                                                const MCRegisterInfo &MRI) {
  if (SyntaxVariant == 0)
    return new FalconInstPrinter(MAI, MII, MRI);
  return 0;
}

static MCRelocationInfo *createFalconMCRelocationInfo(const Triple &TheTriple,
                                                      MCContext &Ctx) {
  return llvm::createMCRelocationInfo(TheTriple, Ctx);
}

namespace {

class FalconMCInstrAnalysis : public MCInstrAnalysis {
public:
  FalconMCInstrAnalysis(const MCInstrInfo *Info) : MCInstrAnalysis(Info) {}

  bool evaluateBranch(const MCInst &Inst, uint64_t Addr,
                      uint64_t Size, uint64_t &Target) const override {
    unsigned TargetOp = Inst.getNumOperands() - 1;
    // We only handle PCRel branches for now.
    if (!Inst.getOperand(TargetOp).isImm())
      return false;

    Target = Inst.getOperand(TargetOp).getImm();
    return true;
  }
};

}

static MCInstrAnalysis *createFalconMCInstrAnalysis(const MCInstrInfo *Info) {
  return new FalconMCInstrAnalysis(Info);
}

extern "C" void LLVMInitializeFalconTargetMC() {
  // Register the MC asm info.
  RegisterMCAsmInfo<FalconMCAsmInfo> X(TheFalconTarget);

  // Register the MC codegen info.
  TargetRegistry::RegisterMCCodeGenInfo(TheFalconTarget, createFalconMCCodeGenInfo);

  // Register the MC instruction info.
  TargetRegistry::RegisterMCInstrInfo(TheFalconTarget, createFalconMCInstrInfo);

  // Register the MC register info.
  TargetRegistry::RegisterMCRegInfo(TheFalconTarget, createFalconMCRegisterInfo);

  // Register the MC subtarget info.
  TargetRegistry::RegisterMCSubtargetInfo(TheFalconTarget,
                                          createFalconMCSubtargetInfo);

  // Register the MC instruction analysis.
  TargetRegistry::RegisterMCInstrAnalysis(TheFalconTarget, createFalconMCInstrAnalysis);

  // Register the object streamer
  TargetRegistry::RegisterELFStreamer(TheFalconTarget, createFalconMCStreamer);

  // Register the MCInstPrinter.
  TargetRegistry::RegisterMCInstPrinter(TheFalconTarget, createFalconMCInstPrinter);

  // Register the MC code emitter
  TargetRegistry::RegisterMCCodeEmitter(TheFalconTarget, createFalconMCCodeEmitter);

  // Register the MC relocation info.
  TargetRegistry::RegisterMCRelocationInfo(TheFalconTarget, createFalconMCRelocationInfo);

  // Register the ASM Backend
  TargetRegistry::RegisterMCAsmBackend(TheFalconTarget, createFalconMCAsmBackend);
}
