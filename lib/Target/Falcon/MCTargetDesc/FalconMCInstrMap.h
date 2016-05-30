//====- FalconMCInstrMAp.h - Falcon instruction mappings --*- C++ -*-=====//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes Falcon instruction mappings, used for relaxation
// and two-operand to three-operand conversion.
// "%hi" or "%lo" etc.,
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCINSTRMAP_H
#define LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCINSTRMAP_H

namespace llvm {

namespace Falcon {
  LLVM_READONLY int getRelaxedOpcode(uint16_t Opcode);
  LLVM_READONLY int getThreeOperandOpcode(uint16_t Opcode);
}

} // end namespace llvm.

#endif
