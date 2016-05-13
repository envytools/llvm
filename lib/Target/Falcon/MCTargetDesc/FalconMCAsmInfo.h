//===-- FalconMCAsmInfo.h - Falcon asm properties -------------*- C++ -*--====//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declaration of the FalconMCAsmInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCASMINFO_H
#define LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {
class Triple;

class FalconMCAsmInfo : public MCAsmInfoELF {
public:
  explicit FalconMCAsmInfo(const Triple &TT);
};
}

#endif
