//===-- FalconMCExpr.cpp - Falcon specific MC expression classes --------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the implementation of the assembly expression modifiers
// accepted by the Falcon architecture (e.g. "%hi", "%lo", ...).
//
//===----------------------------------------------------------------------===//

#include "FalconMCExpr.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCObjectStreamer.h"
#include "llvm/MC/MCSymbolELF.h"
#include "llvm/Object/ELF.h"


using namespace llvm;

#define DEBUG_TYPE "sparcmcexpr"

const FalconMCExpr*
FalconMCExpr::create(VariantKind Kind, const MCExpr *Expr,
                      MCContext &Ctx) {
    return new (Ctx) FalconMCExpr(Kind, Expr);
}

void FalconMCExpr::printImpl(raw_ostream &OS, const MCAsmInfo *MAI) const {

  bool closeParen = printVariantKind(OS, Kind);

  const MCExpr *Expr = getSubExpr();
  Expr->print(OS, MAI);

  if (closeParen)
    OS << ')';
}

bool FalconMCExpr::printVariantKind(raw_ostream &OS, VariantKind Kind)
{
  bool closeParen = true;
  switch (Kind) {
  case VK_Falcon_None:     closeParen = false; break;
  case VK_Falcon_S8:       OS << "%s8(";  break;
  case VK_Falcon_S16:      OS << "%s16(";  break;
  case VK_Falcon_U8:       OS << "%u8(";  break;
  case VK_Falcon_U16:      OS << "%u16(";  break;
  case VK_Falcon_U24:      OS << "%u24(";  break;
  case VK_Falcon_U32:      OS << "%u32(";  break;
  case VK_Falcon_LO16:     OS << "%lo16(";  break;
  case VK_Falcon_HI16:     OS << "%hi16(";  break;
  case VK_Falcon_HI8:      OS << "%hi8(";  break;
  case VK_Falcon_PC8:      OS << "%pc8(";  break;
  case VK_Falcon_PC16:     OS << "%pc16(";  break;
  }
  return closeParen;
}

FalconMCExpr::VariantKind FalconMCExpr::parseVariantKind(StringRef name)
{
  return StringSwitch<FalconMCExpr::VariantKind>(name)
    .Case("s8",    VK_Falcon_S8)
    .Case("s16",   VK_Falcon_S16)
    .Case("u8",    VK_Falcon_U8)
    .Case("u16",   VK_Falcon_U16)
    .Case("u24",   VK_Falcon_U24)
    .Case("u32",   VK_Falcon_U32)
    .Case("lo16",  VK_Falcon_LO16)
    .Case("hi16",  VK_Falcon_HI16)
    .Case("hi8",   VK_Falcon_HI8)
    .Case("pc8",   VK_Falcon_PC8)
    .Case("pc16",  VK_Falcon_PC16)
    .Default(VK_Falcon_None);
}

bool
FalconMCExpr::evaluateAsRelocatableImpl(MCValue &Res,
                                       const MCAsmLayout *Layout,
                                       const MCFixup *Fixup) const {
  return getSubExpr()->evaluateAsRelocatable(Res, Layout, Fixup);
}

void FalconMCExpr::visitUsedExpr(MCStreamer &Streamer) const {
  Streamer.visitUsedExpr(*getSubExpr());
}
