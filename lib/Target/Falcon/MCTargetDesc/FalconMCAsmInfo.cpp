//===-- FalconMCAsmInfo.cpp - Falcon asm properties -----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "FalconMCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCSectionELF.h"

using namespace llvm;

FalconMCAsmInfo::FalconMCAsmInfo(const Triple &TT) {
	// XXX
//  SupportsDebugInformation = true;

  UseIntegratedAssembler = true;
}
