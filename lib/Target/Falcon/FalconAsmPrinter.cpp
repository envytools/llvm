//===-- FalconAsmPrinter.cpp - Falcon LLVM assembly writer ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains a printer that converts from our internal representation
// of machine-dependent LLVM code to the Falcon assembly language.
//
//===----------------------------------------------------------------------===//

#include "Falcon.h"
#include "FalconInstrInfo.h"
#include "FalconMCInstLower.h"
#include "FalconTargetMachine.h"
#include "InstPrinter/FalconInstPrinter.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "asm-printer"

namespace {
class FalconAsmPrinter : public AsmPrinter {
public:
  explicit FalconAsmPrinter(TargetMachine &TM, std::unique_ptr<MCStreamer> Streamer)
      : AsmPrinter(TM, std::move(Streamer)) {}

  const char *getPassName() const override { return "Falcon Assembly Printer"; }

  void EmitInstruction(const MachineInstr *MI) override;
};
}

void FalconAsmPrinter::EmitInstruction(const MachineInstr *MI) {

  FalconMCInstLower MCInstLowering(OutContext, *this);

  MCInst TmpInst;
  MCInstLowering.Lower(MI, TmpInst);
  EmitToStreamer(*OutStreamer, TmpInst);
}

// Force static initialization.
extern "C" void LLVMInitializeFalconAsmPrinter() {
  RegisterAsmPrinter<FalconAsmPrinter> X(TheFalconTarget);
}
