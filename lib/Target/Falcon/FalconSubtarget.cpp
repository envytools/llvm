//===-- FalconSubtarget.cpp - Falcon Subtarget Information ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the Falcon specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "FalconSubtarget.h"
#include "Falcon.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "falcon-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "FalconGenSubtargetInfo.inc"

void FalconSubtarget::anchor() {}

FalconSubtarget::FalconSubtarget(const Triple &TT, const std::string &CPU,
                           const std::string &FS, const TargetMachine &TM)
    : FalconGenSubtargetInfo(TT, CPU, FS), InstrInfo(), FrameLowering(*this),
      TLInfo(TM, *this) {}
