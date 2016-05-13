//===-- FalconMCFixups.h - Falcon-specific fixup entries --------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCFIXUPS_H
#define LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCFIXUPS_H

#include "llvm/MC/MCFixup.h"

namespace llvm {
namespace Falcon {
enum FixupKind {
  FK_FALCON_8 = FirstTargetFixupKind,
  FK_FALCON_16,
  FK_FALCON_24,
  FK_FALCON_32,
  FK_FALCON_S8,
  FK_FALCON_S16,
  FK_FALCON_LO16,
  FK_FALCON_HI16,
  FK_FALCON_HI8,
  FK_FALCON_8S1,
  FK_FALCON_8S2,

  // Marker
  LastTargetFixupKind,
  NumTargetFixupKinds = LastTargetFixupKind - FirstTargetFixupKind
};
} // end namespace Falcon
} // end namespace llvm

#endif
