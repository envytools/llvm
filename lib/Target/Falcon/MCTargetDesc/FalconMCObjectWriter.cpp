//===-- FalconMCObjectWriter.cpp - Falcon ELF writer ----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/FalconMCTargetDesc.h"
#include "MCTargetDesc/FalconMCFixups.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCValue.h"

using namespace llvm;

namespace {
class FalconObjectWriter : public MCELFObjectTargetWriter {
public:
  FalconObjectWriter(uint8_t OSABI);

  ~FalconObjectWriter() override;

protected:
  // Override MCELFObjectTargetWriter.
  unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                        const MCFixup &Fixup, bool IsPCRel) const override;
};
} // end anonymous namespace

FalconObjectWriter::FalconObjectWriter(uint8_t OSABI)
  : MCELFObjectTargetWriter(/*Is64Bit=*/false, OSABI, ELF::EM_FALCON,
                            /*HasRelocationAddend=*/ true) {}

FalconObjectWriter::~FalconObjectWriter() {
}

// Return the relocation type for an absolute value of MCFixupKind Kind.
static unsigned getAbsoluteReloc(MCContext &Ctx, const MCFixup &Fixup) {
  switch (unsigned(Fixup.getKind())) {
  case FK_Data_1:
  case Falcon::FK_FALCON_U8:
  case Falcon::FK_FALCON_U8R:
    return ELF::R_FALCON_8;

  case FK_Data_2:
  case Falcon::FK_FALCON_U16:
    return ELF::R_FALCON_16;

  case Falcon::FK_FALCON_U24:
    return ELF::R_FALCON_24;

  case FK_Data_4:
  case Falcon::FK_FALCON_U32:
    return ELF::R_FALCON_32;

  case Falcon::FK_FALCON_S8:
  case Falcon::FK_FALCON_S8R:
    return ELF::R_FALCON_S8;

  case Falcon::FK_FALCON_S16:
    return ELF::R_FALCON_S16;

  case Falcon::FK_FALCON_LO16: return ELF::R_FALCON_LO16;
  case Falcon::FK_FALCON_HI16: return ELF::R_FALCON_HI16;
  case Falcon::FK_FALCON_HI8: return ELF::R_FALCON_HI8;
  case Falcon::FK_FALCON_U8S1: return ELF::R_FALCON_8S1;
  case Falcon::FK_FALCON_U8S2: return ELF::R_FALCON_8S2;
  default:
    Ctx.reportError(Fixup.getLoc(), "Unsupported absolute relocation");
    return ELF::R_FALCON_NONE;
  }
}

// Return the relocation type for a PC-relative value of MCFixupKind Kind.
static unsigned getPCRelReloc(MCContext &Ctx, const MCFixup &Fixup) {
  switch (unsigned(Fixup.getKind())) {
  case Falcon::FK_FALCON_S8:
  case Falcon::FK_FALCON_S8R:
  case Falcon::FK_FALCON_PC8:
  case Falcon::FK_FALCON_PC8R:
  case FK_Data_1:
  case FK_PCRel_1:
    return ELF::R_FALCON_PC8;

  case Falcon::FK_FALCON_S16:
  case Falcon::FK_FALCON_PC16:
  case FK_Data_2:
  case FK_PCRel_2:
    return ELF::R_FALCON_PC16;

  case Falcon::FK_FALCON_U32:
  case FK_Data_4:
  case FK_PCRel_4:
    return ELF::R_FALCON_PC32;

  default:
    Ctx.reportError(Fixup.getLoc(), "Unsupported PC-relative relocation");
    return ELF::R_FALCON_NONE;
  }
}

unsigned FalconObjectWriter::getRelocType(MCContext &Ctx,
                                           const MCValue &Target,
                                           const MCFixup &Fixup,
                                           bool IsPCRel) const {
  MCSymbolRefExpr::VariantKind Modifier = Target.getAccessVariant();
  switch (Modifier) {
  case MCSymbolRefExpr::VK_None:
    if (IsPCRel)
      return getPCRelReloc(Ctx, Fixup);
    return getAbsoluteReloc(Ctx, Fixup);

  default:
    llvm_unreachable("Modifier not supported");
  }
}

MCObjectWriter *llvm::createFalconELFObjectWriter(raw_pwrite_stream &OS,
                                                uint8_t OSABI) {
  MCELFObjectTargetWriter *MOTW = new FalconObjectWriter(OSABI);
  return createELFObjectWriter(MOTW, OS, /*IsLittleEndian=*/true);
}
