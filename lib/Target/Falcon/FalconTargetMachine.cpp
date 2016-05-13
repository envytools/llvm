//===-- FalconTargetMachine.cpp - Define TargetMachine for Falcon ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Implements the info about Falcon target spec.
//
//===----------------------------------------------------------------------===//

#include "Falcon.h"
#include "FalconTargetMachine.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"
using namespace llvm;

extern "C" void LLVMInitializeFalconTarget() {
  // Register the target.
  RegisterTargetMachine<FalconTargetMachine> X(TheFalconTarget);
}

// DataLayout: little or big endian
static std::string computeDataLayout(const Triple &TT) {
  return "e-m:e-p:32:32-i32:32-n8:16:32-S32";
}

static Reloc::Model getEffectiveRelocModel(Optional<Reloc::Model> RM) {
  if (!RM.hasValue())
    return Reloc::Static;
  return *RM;
}

FalconTargetMachine::FalconTargetMachine(const Target &T, const Triple &TT,
                                   StringRef CPU, StringRef FS,
                                   const TargetOptions &Options,
                                   Optional<Reloc::Model> RM,
                                   CodeModel::Model CM, CodeGenOpt::Level OL)
    : LLVMTargetMachine(T, computeDataLayout(TT), TT, CPU, FS, Options,
                        getEffectiveRelocModel(RM), CM, OL),
      TLOF(make_unique<TargetLoweringObjectFileELF>()),
      Subtarget(TT, CPU, FS, *this) {
  initAsmInfo();
}
namespace {
// Falcon Code Generator Pass Configuration Options.
class FalconPassConfig : public TargetPassConfig {
public:
  FalconPassConfig(FalconTargetMachine *TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  FalconTargetMachine &getFalconTargetMachine() const {
    return getTM<FalconTargetMachine>();
  }

  bool addInstSelector() override;
};
}

TargetPassConfig *FalconTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new FalconPassConfig(this, PM);
}

// Install an instruction selector pass using
// the ISelDag to gen Falcon code.
bool FalconPassConfig::addInstSelector() {
  addPass(createFalconISelDag(getFalconTargetMachine()));
  return false;
}
