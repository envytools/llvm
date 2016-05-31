//===-- FalconMCCodeEmitter.cpp - Convert Falcon code to machine code -----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the FalconMCCodeEmitter class.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/FalconMCTargetDesc.h"
#include "MCTargetDesc/FalconMCExpr.h"
#include "MCTargetDesc/FalconMCFixups.h"
#include "MCTargetDesc/FalconMCInstrMap.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "mccodeemitter"

namespace {
class FalconMCCodeEmitter : public MCCodeEmitter {
  FalconMCCodeEmitter(const FalconMCCodeEmitter &) = delete;
  void operator=(const FalconMCCodeEmitter &) = delete;
  const MCInstrInfo &MCII;
  const MCRegisterInfo &MRI;
  MCContext &Ctx;

public:
  FalconMCCodeEmitter(const MCInstrInfo &mcii, const MCRegisterInfo &mri, MCContext &ctx)
    : MCII(mcii), MRI(mri), Ctx(ctx) {}

  ~FalconMCCodeEmitter() {}

  // getBinaryCodeForInstr - TableGen'erated function for getting the
  // binary encoding for an instruction.
  uint64_t getBinaryCodeForInstr(const MCInst &MI,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  // getMachineOpValue - Return binary encoding of operand. If the machine
  // operand requires relocation, record the relocation and return zero.
  unsigned getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  uint64_t getMemRegEncoding(const MCInst &MI, unsigned Op,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  uint64_t getMemRegRegEncoding(const MCInst &MI, unsigned Op,
                                SmallVectorImpl<MCFixup> &Fixups,
                                const MCSubtargetInfo &STI) const;

  template<unsigned shift>
  uint64_t getMemRegImmEncoding(const MCInst &MI, unsigned Op,
                                SmallVectorImpl<MCFixup> &Fixups,
                                const MCSubtargetInfo &STI) const;

  template<unsigned shift>
  uint64_t getMemImmEncoding(const MCInst &MI, unsigned Op,
                                SmallVectorImpl<MCFixup> &Fixups,
                                const MCSubtargetInfo &STI) const;

  uint64_t getPC8Encoding(const MCInst &MI, unsigned Op,
                                SmallVectorImpl<MCFixup> &Fixups,
                                const MCSubtargetInfo &STI) const;

  uint64_t getPC16Encoding(const MCInst &MI, unsigned Op,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  uint64_t encodeS8ImmOperand(const MCInst &MI, unsigned Op,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  uint64_t encodeS16ImmOperand(const MCInst &MI, unsigned Op,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  uint64_t encodeU8ImmOperand(const MCInst &MI, unsigned Op,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  uint64_t encodeU8XImmOperand(const MCInst &MI, unsigned Op,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const {
    return encodeU8ImmOperand(MI, Op, Fixups, STI);
  }

  uint64_t encodeU16ImmOperand(const MCInst &MI, unsigned Op,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  uint64_t encodeU16XImmOperand(const MCInst &MI, unsigned Op,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const {
    return encodeU16ImmOperand(MI, Op, Fixups, STI);
  }

  void encodeInstruction(const MCInst &MI, raw_ostream &OS,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const override;
};
}

MCCodeEmitter *llvm::createFalconMCCodeEmitter(const MCInstrInfo &MCII,
                                            const MCRegisterInfo &MRI,
                                            MCContext &Ctx) {
  return new FalconMCCodeEmitter(MCII, MRI, Ctx);
}

unsigned FalconMCCodeEmitter::getMachineOpValue(const MCInst &MI,
                                             const MCOperand &MO,
                                             SmallVectorImpl<MCFixup> &Fixups,
                                             const MCSubtargetInfo &STI) const {
  if (MO.isReg())
    return MRI.getEncodingValue(MO.getReg());
  if (MO.isImm())
    return static_cast<unsigned>(MO.getImm());

  llvm_unreachable("encoding unknown operand type");
}

void FalconMCCodeEmitter::encodeInstruction(const MCInst &MI, raw_ostream &OS,
                                         SmallVectorImpl<MCFixup> &Fixups,
                                         const MCSubtargetInfo &STI) const {
  uint64_t Bits = getBinaryCodeForInstr(MI, Fixups, STI);
  unsigned Size = MCII.get(MI.getOpcode()).getSize();
  for (unsigned I = 0; I != Size; ++I) {
    OS << uint8_t(Bits >> I * 8);
  }
}

// Encode Falcon Memory Operands
uint64_t FalconMCCodeEmitter::getMemRegEncoding(const MCInst &MI, unsigned OpNum,
                                                SmallVectorImpl<MCFixup> &Fixups,
                                                const MCSubtargetInfo &STI) const {
  const MCOperand RegOp = MI.getOperand(OpNum);
  assert(RegOp.isReg() && "First operand is not register.");
  uint64_t RegEnc = MRI.getEncodingValue(RegOp.getReg());
  return RegEnc;
}

uint64_t FalconMCCodeEmitter::getMemRegRegEncoding(const MCInst &MI, unsigned OpNum,
                                                   SmallVectorImpl<MCFixup> &Fixups,
                                                   const MCSubtargetInfo &STI) const {
  const MCOperand RegOp = MI.getOperand(OpNum);
  const MCOperand IdxOp = MI.getOperand(OpNum + 1);
  assert(RegOp.isReg() && "First operand is not register.");
  assert(IdxOp.isReg() && "Second operand is not register.");
  uint64_t RegEnc = MRI.getEncodingValue(RegOp.getReg());
  uint64_t IdxEnc = MRI.getEncodingValue(IdxOp.getReg());
  return RegEnc | IdxEnc << 4;
}

template<unsigned shift>
uint64_t FalconMCCodeEmitter::getMemRegImmEncoding(const MCInst &MI, unsigned OpNum,
                                                   SmallVectorImpl<MCFixup> &Fixups,
                                                   const MCSubtargetInfo &STI) const {
  const MCOperand RegOp = MI.getOperand(OpNum);
  const MCOperand IdxOp = MI.getOperand(OpNum + 1);
  assert(RegOp.isReg() && "First operand is not register.");
  uint64_t RegEnc = MRI.getEncodingValue(RegOp.getReg());
  if (IdxOp.isImm()) {
    uint64_t IdxEnc = IdxOp.getImm() >> shift;
    return RegEnc | IdxEnc << 4;
  } else if (IdxOp.isExpr()) {
    static const unsigned FixupKinds[3] = {
      Falcon::FK_FALCON_U8,
      Falcon::FK_FALCON_U8S1,
      Falcon::FK_FALCON_U8S2,
    };
    const MCExpr *Expr = IdxOp.getExpr();
    Fixups.push_back(MCFixup::create(2, Expr, MCFixupKind(FixupKinds[shift])));
    return RegEnc;
  } else {
    llvm_unreachable("Second operand is not immediate.");
  }
}

template<unsigned shift>
uint64_t FalconMCCodeEmitter::getMemImmEncoding(const MCInst &MI, unsigned OpNum,
                                                SmallVectorImpl<MCFixup> &Fixups,
                                                const MCSubtargetInfo &STI) const {
  const MCOperand IdxOp = MI.getOperand(OpNum);
  if (IdxOp.isImm()) {
    uint64_t IdxEnc = IdxOp.getImm() >> shift;
    return IdxEnc;
  } else if (IdxOp.isExpr()) {
    static const unsigned FixupKinds[3] = {
      Falcon::FK_FALCON_U8,
      Falcon::FK_FALCON_U8S1,
      Falcon::FK_FALCON_U8S2,
    };
    const MCExpr *Expr = IdxOp.getExpr();
    Fixups.push_back(MCFixup::create(2, Expr, MCFixupKind(FixupKinds[shift])));
    return 0;
  } else {
    llvm_unreachable("Second operand is not immediate.");
  }
}

uint64_t FalconMCCodeEmitter::getPC8Encoding(const MCInst &MI, unsigned OpNum,
                                                 SmallVectorImpl<MCFixup> &Fixups,
                                                 const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  const MCExpr *Expr;
  uint64_t Offset = 2;
  unsigned Fixup = Falcon::FK_FALCON_PC8R;
  if (Falcon::getRelaxedOpcode(MI.getOpcode()) == -1)
    Fixup = Falcon::FK_FALCON_PC8;
  if (MO.isImm())
    Expr = MCConstantExpr::create(MO.getImm() + Offset, Ctx);
  else {
    Expr = MO.getExpr();
    if (auto FE = dyn_cast<FalconMCExpr>(Expr)) {
      if (FE->getKind() != FalconMCExpr::VK_Falcon_PC8)
        llvm_unreachable("Unexpected FalconMCExpr kind.");
      Expr = FE->getSubExpr();
      Fixup = Falcon::FK_FALCON_PC8;
    }
    if (Offset) {
      // The operand value is relative to the start of MI, but the fixup
      // is relative to the operand field itself, which is Offset bytes
      // into MI.  Add Offset to the relocation value to cancel out
      // this difference.
      const MCExpr *OffsetExpr = MCConstantExpr::create(Offset, Ctx);
      Expr = MCBinaryExpr::createAdd(Expr, OffsetExpr, Ctx);
    }
  }
  Fixups.push_back(MCFixup::create(Offset, Expr, MCFixupKind(Fixup)));
  return 0;
}

uint64_t FalconMCCodeEmitter::getPC16Encoding(const MCInst &MI, unsigned OpNum,
                                                 SmallVectorImpl<MCFixup> &Fixups,
                                                 const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  const MCExpr *Expr;
  uint64_t Offset = 2;
  unsigned Fixup = Falcon::FK_FALCON_PC16;
  if (MO.isImm())
    Expr = MCConstantExpr::create(MO.getImm() + Offset, Ctx);
  else {
    Expr = MO.getExpr();
    if (auto FE = dyn_cast<FalconMCExpr>(Expr)) {
      if (FE->getKind() != FalconMCExpr::VK_Falcon_PC16)
        llvm_unreachable("Unexpected FalconMCExpr kind.");
      Expr = FE->getSubExpr();
    }
    if (Offset) {
      // The operand value is relative to the start of MI, but the fixup
      // is relative to the operand field itself, which is Offset bytes
      // into MI.  Add Offset to the relocation value to cancel out
      // this difference.
      const MCExpr *OffsetExpr = MCConstantExpr::create(Offset, Ctx);
      Expr = MCBinaryExpr::createAdd(Expr, OffsetExpr, Ctx);
    }
  }
  Fixups.push_back(MCFixup::create(Offset, Expr, MCFixupKind(Fixup)));
  return 0;
}

uint64_t FalconMCCodeEmitter::encodeS8ImmOperand(const MCInst &MI, unsigned OpNum,
                                                 SmallVectorImpl<MCFixup> &Fixups,
                                                 const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  if (MO.isImm())
    return getMachineOpValue(MI, MO, Fixups, STI);
  else {
    uint64_t Offset = 2;
    const MCExpr *Expr = MO.getExpr();
    unsigned Fixup = Falcon::FK_FALCON_S8R;
    if (Falcon::getRelaxedOpcode(MI.getOpcode()) == -1)
      Fixup = Falcon::FK_FALCON_S8;
    if (auto FE = dyn_cast<FalconMCExpr>(Expr)) {
      if (FE->getKind() != FalconMCExpr::VK_Falcon_S8)
        llvm_unreachable("Unexpected FalconMCExpr kind.");
      Expr = FE->getSubExpr();
      Fixup = Falcon::FK_FALCON_S8;
    }
    Fixups.push_back(MCFixup::create(Offset, Expr, MCFixupKind(Fixup)));
    return 0;
  }
}

uint64_t FalconMCCodeEmitter::encodeS16ImmOperand(const MCInst &MI, unsigned OpNum,
                                                  SmallVectorImpl<MCFixup> &Fixups,
                                                  const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  if (MO.isImm())
    return getMachineOpValue(MI, MO, Fixups, STI);
  else {
    uint64_t Offset = 2;
    const MCExpr *Expr = MO.getExpr();
    unsigned Fixup = Falcon::FK_FALCON_S16;
    if (auto FE = dyn_cast<FalconMCExpr>(Expr)) {
      switch (FE->getKind()) {
      case FalconMCExpr::VK_Falcon_S16:
        break;
      case FalconMCExpr::VK_Falcon_LO16:
        Fixup = Falcon::FK_FALCON_LO16;
        break;
      default:
        llvm_unreachable("Unexpected FalconMCExpr kind.");
      }
      Expr = FE->getSubExpr();
    }
    Fixups.push_back(MCFixup::create(Offset, Expr, MCFixupKind(Fixup)));
    return 0;
  }
}

uint64_t FalconMCCodeEmitter::encodeU8ImmOperand(const MCInst &MI, unsigned OpNum,
                                                 SmallVectorImpl<MCFixup> &Fixups,
                                                 const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  if (MO.isImm())
    return getMachineOpValue(MI, MO, Fixups, STI);
  else {
    uint64_t Offset = 2;
    const MCExpr *Expr = MO.getExpr();
    unsigned Fixup = Falcon::FK_FALCON_U8R;
    if (Falcon::getRelaxedOpcode(MI.getOpcode()) == -1)
      Fixup = Falcon::FK_FALCON_U8;
    if (auto FE = dyn_cast<FalconMCExpr>(Expr)) {
      switch (FE->getKind()) {
      case FalconMCExpr::VK_Falcon_U8:
        Fixup = Falcon::FK_FALCON_U8;
        break;
      case FalconMCExpr::VK_Falcon_HI8:
        Fixup = Falcon::FK_FALCON_HI8;
        break;
      default:
        llvm_unreachable("Unexpected FalconMCExpr kind.");
      }
      Expr = FE->getSubExpr();
    }
    Fixups.push_back(MCFixup::create(Offset, Expr, MCFixupKind(Fixup)));
    return 0;
  }
}

uint64_t FalconMCCodeEmitter::encodeU16ImmOperand(const MCInst &MI, unsigned OpNum,
                                                  SmallVectorImpl<MCFixup> &Fixups,
                                                  const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  if (MO.isImm())
    return getMachineOpValue(MI, MO, Fixups, STI);
  else {
    uint64_t Offset = 2;
    const MCExpr *Expr = MO.getExpr();
    unsigned Fixup = Falcon::FK_FALCON_U16;
    if (auto FE = dyn_cast<FalconMCExpr>(Expr)) {
      switch (FE->getKind()) {
      case FalconMCExpr::VK_Falcon_U16:
        break;
      case FalconMCExpr::VK_Falcon_HI16:
        Fixup = Falcon::FK_FALCON_HI16;
        break;
      default:
        llvm_unreachable("Unexpected FalconMCExpr kind.");
      }
      Expr = FE->getSubExpr();
    }
    Fixups.push_back(MCFixup::create(Offset, Expr, MCFixupKind(Fixup)));
    return 0;
  }
}

#include "FalconGenMCCodeEmitter.inc"
