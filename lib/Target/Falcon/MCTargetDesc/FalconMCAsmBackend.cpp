//===-- FalconMCAsmBackend.cpp - Falcon assembler backend -----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/FalconMCTargetDesc.h"
#include "MCTargetDesc/FalconMCExpr.h"
#include "MCTargetDesc/FalconMCFixups.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixupKindInfo.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCObjectWriter.h"

using namespace llvm;

static unsigned adjustFixupValue(const MCFixup &Fixup, uint64_t Value, MCContext *Ctx) {
  switch (unsigned(Fixup.getKind())) {
  default:
    return Value;

  case Falcon::FK_FALCON_S8:
  case Falcon::FK_FALCON_PC8:
  case FK_PCRel_1:
    if (Ctx && Value >= 0x80 && Value < uint64_t(-0x80))
      Ctx->reportError(Fixup.getLoc(), "s8 fixup value out of range");
    return Value;

  case Falcon::FK_FALCON_S16:
  case Falcon::FK_FALCON_PC16:
  case FK_PCRel_2:
    if (Ctx && Value >= 0x8000 && Value < uint64_t(-0x8000))
      Ctx->reportError(Fixup.getLoc(), "s16 fixup value out of range");
    return Value;

  case Falcon::FK_FALCON_U8:
    if (Ctx && Value >= 0x100)
      Ctx->reportError(Fixup.getLoc(), "u8 fixup value out of range");
    return Value;

  case Falcon::FK_FALCON_U16:
    if (Ctx && Value >= 0x10000)
      Ctx->reportError(Fixup.getLoc(), "u16 fixup value out of range");
    return Value;

  case Falcon::FK_FALCON_U24:
    if (Ctx && Value >= 0x1000000)
      Ctx->reportError(Fixup.getLoc(), "u24 fixup value out of range");
    return Value;

  case Falcon::FK_FALCON_HI8:
    if (Ctx && Value >= 0x1000000)
      Ctx->reportError(Fixup.getLoc(), "hi8 fixup value out of range");
    // fallthru
  case Falcon::FK_FALCON_HI16:
    return Value >> 16;

  case Falcon::FK_FALCON_U8S1:
    if (Ctx && Value >= 0x200)
      Ctx->reportError(Fixup.getLoc(), "u8s1 fixup value out of range");
    if (Ctx && Value & 1)
      Ctx->reportError(Fixup.getLoc(), "u8s1 fixup value unaligned");
    return Value >> 1;

  case Falcon::FK_FALCON_U8S2:
    if (Ctx && Value >= 0x400)
      Ctx->reportError(Fixup.getLoc(), "u8s2 fixup value out of range");
    if (Ctx && Value & 3)
      Ctx->reportError(Fixup.getLoc(), "u8s2 fixup value unaligned");
    return Value >> 2;
  }
}

namespace {
class FalconMCAsmBackend : public MCAsmBackend {
public:
  FalconMCAsmBackend() {}

  // Override MCAsmBackend
  unsigned getNumFixupKinds() const override {
    return Falcon::NumTargetFixupKinds;
  }
  const MCFixupKindInfo &getFixupKindInfo(MCFixupKind Kind) const override;
  void applyFixup(const MCFixup &Fixup, char *Data, unsigned DataSize,
                  uint64_t Value, bool IsPCRel) const override;
  bool mayNeedRelaxation(const MCInst &Inst) const override;
  bool fixupNeedsRelaxation(const MCFixup &Fixup, uint64_t Value,
                            const MCRelaxableFragment *Fragment,
                            const MCAsmLayout &Layout) const override;
  void relaxInstruction(const MCInst &Inst, MCInst &Res) const override;
  MCObjectWriter *createObjectWriter(raw_pwrite_stream &OS) const override {
    return createFalconELFObjectWriter(OS, 0);
  }
  bool writeNopData(uint64_t Count, MCObjectWriter *OW) const override {
    if (Count == 0)
      return true;
    return false;
  }

  void processFixupValue(const MCAssembler &Asm, const MCAsmLayout &Layout,
                         const MCFixup &Fixup, const MCFragment *DF,
                         const MCValue &Target, uint64_t &Value,
                         bool &IsResolved) override;
};
} // end anonymous namespace

const MCFixupKindInfo &
FalconMCAsmBackend::getFixupKindInfo(MCFixupKind Kind) const {
  const static MCFixupKindInfo Infos[Falcon::NumTargetFixupKinds] = {
    { "FK_FALCON_U8", 0, 8, 0 },
    { "FK_FALCON_U8R", 0, 8, 0 },
    { "FK_FALCON_U16", 0, 16, 0 },
    { "FK_FALCON_U24", 0, 24, 0 },
    { "FK_FALCON_U32", 0, 32, 0 },
    { "FK_FALCON_S8", 0, 8, 0 },
    { "FK_FALCON_S8R", 0, 8, 0 },
    { "FK_FALCON_S16", 0, 16, 0 },
    { "FK_FALCON_LO16", 0, 16, 0 },
    { "FK_FALCON_HI16", 0, 16, 0 },
    { "FK_FALCON_HI8", 0, 8, 0 },
    { "FK_FALCON_U8S1", 0, 8, 0 },
    { "FK_FALCON_U8S2", 0, 8, 0 },
    { "FK_FALCON_PC8", 0, 8, MCFixupKindInfo::FKF_IsPCRel },
    { "FK_FALCON_PC8R", 0, 8, MCFixupKindInfo::FKF_IsPCRel },
    { "FK_FALCON_PC16", 0, 16, MCFixupKindInfo::FKF_IsPCRel },
  };

  if (Kind < FirstTargetFixupKind)
    return MCAsmBackend::getFixupKindInfo(Kind);

  assert(unsigned(Kind - FirstTargetFixupKind) < getNumFixupKinds() &&
         "Invalid kind!");
  return Infos[Kind - FirstTargetFixupKind];
}

void FalconMCAsmBackend::applyFixup(const MCFixup &Fixup, char *Data,
                                     unsigned DataSize, uint64_t Value,
                                     bool IsPCRel) const {
  MCFixupKind Kind = Fixup.getKind();
  unsigned Offset = Fixup.getOffset();
  unsigned Size = (getFixupKindInfo(Kind).TargetSize + 7) / 8;
  Value = adjustFixupValue(Fixup, Value, nullptr);

  assert(Offset + Size <= DataSize && "Invalid fixup offset!");

  // Little-endian insertion of Size bytes.
  for (unsigned I = 0; I != Size; ++I)
    Data[Offset + I] |= uint8_t(Value >> (I * 8));
}

void FalconMCAsmBackend::processFixupValue(
    const MCAssembler &Asm, const MCAsmLayout &Layout, const MCFixup &Fixup,
    const MCFragment *DF, const MCValue &Target, uint64_t &Value,
    bool &IsResolved) {

  // Try to get the encoded value for the fixup as-if we're mapping it into
  // the instruction. This allows adjustFixupValue() to issue a diagnostic
  // if the value is invalid.
  if (IsResolved)
    (void)adjustFixupValue(Fixup, Value, &Asm.getContext());
}

bool FalconMCAsmBackend::mayNeedRelaxation(const MCInst &Inst) const {
  bool isPCRel;
  int RelaxedOpcode = Falcon::getRelaxedOpcode(Inst.getOpcode(), isPCRel);
  if (RelaxedOpcode == -1)
    return false;

  unsigned RelaxableOp = Inst.getNumOperands() - 1;
  if (!Inst.getOperand(RelaxableOp).isExpr())
    return isPCRel;;

  if (auto FE = dyn_cast<FalconMCExpr>(Inst.getOperand(RelaxableOp).getExpr())) {
    // Do not relax instructions if the mode is forced.
    if (FE->getKind() != FalconMCExpr::VK_Falcon_None)
      return false;
  }

  return true;
}

bool FalconMCAsmBackend::fixupNeedsRelaxation(const MCFixup &Fixup,
                                              uint64_t Value,
                                              const MCRelaxableFragment *Fragment,
                                              const MCAsmLayout &Layout) const {
  switch (unsigned(Fixup.getKind())) {
  case Falcon::FK_FALCON_S8R:
  case Falcon::FK_FALCON_PC8R:
    return int8_t(Value) != int64_t(Value);
  case Falcon::FK_FALCON_U8R:
    return uint8_t(Value) != Value;
  default:
    // Other fixups are not relaxable.
    return false;
  }
}

void FalconMCAsmBackend::relaxInstruction(const MCInst &Inst, MCInst &Res) const {
  int RelaxedOpcode = Falcon::getRelaxedOpcode(Inst.getOpcode());
  if (RelaxedOpcode == -1)
    llvm_unreachable("relaxing unknown instruction");
  Res = Inst;
  Res.setOpcode(RelaxedOpcode);
}

MCAsmBackend *llvm::createFalconMCAsmBackend(const Target &T,
                                             const MCRegisterInfo &MRI,
                                             const Triple &TT, StringRef CPU) {
  return new FalconMCAsmBackend();
}
