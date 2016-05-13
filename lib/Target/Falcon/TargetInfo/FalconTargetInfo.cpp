//===-- FalconTargetInfo.cpp - Falcon Target Implementation ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Falcon.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

Target llvm::TheFalconTarget;

extern "C" void LLVMInitializeFalconTargetInfo() {
  RegisterTarget<Triple::falcon, /*HasJIT=*/false>
    X(TheFalconTarget, "falcon", "Falcon");
}

