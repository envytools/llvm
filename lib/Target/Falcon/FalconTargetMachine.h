//===-- FalconTargetMachine.h - Define TargetMachine for Falcon --- C++ ---===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the Falcon specific subclass of TargetMachine.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_FALCONTARGETMACHINE_H
#define LLVM_LIB_TARGET_FALCON_FALCONTARGETMACHINE_H

#include "FalconSubtarget.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
class FalconTargetMachine : public LLVMTargetMachine {
  std::unique_ptr<TargetLoweringObjectFile> TLOF;
  FalconSubtarget Subtarget;

public:
  FalconTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                   StringRef FS, const TargetOptions &Options,
                   Optional<Reloc::Model> RM,
                   CodeModel::Model CM, CodeGenOpt::Level OL);

  const FalconSubtarget *getSubtargetImpl() const { return &Subtarget; }
  const FalconSubtarget *getSubtargetImpl(const Function &) const override {
    return &Subtarget;
  }

  TargetPassConfig *createPassConfig(PassManagerBase &PM) override;

  TargetLoweringObjectFile *getObjFileLowering() const override {
    return TLOF.get();
  }
};
}

#endif
