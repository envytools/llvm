//===-- FalconMCTargetDesc.h - Falcon Target Descriptions -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file provides Falcon specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCTARGETDESC_H
#define LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCTARGETDESC_H

#include "llvm/Support/DataTypes.h"
#include "llvm/Config/config.h"

namespace llvm {
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class StringRef;
class Target;
class Triple;
class raw_ostream;
class raw_pwrite_stream;

extern Target TheFalconTarget;

namespace FalconMC {
// Maps of asm register numbers to LLVM register numbers, with 0 indicating
// an invalid register.
extern const unsigned GPR8Regs[16];
extern const unsigned GPR16Regs[16];
extern const unsigned GPR32Regs[16];
extern const unsigned FLAGRegs[32];
extern const unsigned SRRegs[16];
}

MCCodeEmitter *createFalconMCCodeEmitter(const MCInstrInfo &MCII,
                                         const MCRegisterInfo &MRI,
                                         MCContext &Ctx);

MCAsmBackend *createFalconMCAsmBackend(const Target &T, const MCRegisterInfo &MRI,
                                       const Triple &TT, StringRef CPU);

MCObjectWriter *createFalconELFObjectWriter(raw_pwrite_stream &OS, uint8_t OSABI);
}

// Defines symbolic names for Falcon registers.  This defines a mapping from
// register name to register number.
//
#define GET_REGINFO_ENUM
#include "FalconGenRegisterInfo.inc"

// Defines symbolic names for the Falcon instructions.
//
#define GET_INSTRINFO_ENUM
#include "FalconGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "FalconGenSubtargetInfo.inc"

#endif
