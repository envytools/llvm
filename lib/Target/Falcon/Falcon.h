//===- Falcon.h - Top-level interface for Falcon representation -*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_FALCON_H
#define LLVM_LIB_TARGET_FALCON_FALCON_H

#include "MCTargetDesc/FalconMCTargetDesc.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
class FalconTargetMachine;

FunctionPass *createFalconISelDag(FalconTargetMachine &TM);
}

#endif
