//====- FalconMCExpr.h - Falcon specific MC expression classes --*- C++ -*-=====//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes Falcon-specific MCExprs, used for modifiers like
// "%hi" or "%lo" etc.,
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCEXPR_H
#define LLVM_LIB_TARGET_FALCON_MCTARGETDESC_FALCONMCEXPR_H

#include "FalconMCFixups.h"
#include "llvm/MC/MCExpr.h"

namespace llvm {

class StringRef;
class FalconMCExpr : public MCTargetExpr {
public:
  enum VariantKind {
    VK_Falcon_None,
    VK_Falcon_S8,
    VK_Falcon_S16,
    VK_Falcon_U8,
    VK_Falcon_U16,
    VK_Falcon_U24,
    VK_Falcon_U32,
    VK_Falcon_LO16,
    VK_Falcon_HI16,
    VK_Falcon_HI8,
    VK_Falcon_PC8,
    VK_Falcon_PC16,
  };

private:
  const VariantKind Kind;
  const MCExpr *Expr;

  explicit FalconMCExpr(VariantKind Kind, const MCExpr *Expr)
      : Kind(Kind), Expr(Expr) {}

public:
  /// @name Construction
  /// @{

  static const FalconMCExpr *create(VariantKind Kind, const MCExpr *Expr,
                                 MCContext &Ctx);
  /// @}
  /// @name Accessors
  /// @{

  /// getOpcode - Get the kind of this expression.
  VariantKind getKind() const { return Kind; }

  /// getSubExpr - Get the child of this expression.
  const MCExpr *getSubExpr() const { return Expr; }

  /// @}
  void printImpl(raw_ostream &OS, const MCAsmInfo *MAI) const override;
  bool evaluateAsRelocatableImpl(MCValue &Res,
                                 const MCAsmLayout *Layout,
                                 const MCFixup *Fixup) const override;
  void visitUsedExpr(MCStreamer &Streamer) const override;
  MCFragment *findAssociatedFragment() const override {
    return getSubExpr()->findAssociatedFragment();
  }

  void fixELFSymbolsInTLSFixups(MCAssembler&) const override {}

  static bool classof(const MCExpr *E) {
    return E->getKind() == MCExpr::Target;
  }

  static bool classof(const FalconMCExpr *) { return true; }

  static VariantKind parseVariantKind(StringRef name);
  static bool printVariantKind(raw_ostream &OS, VariantKind Kind);
};

} // end namespace llvm.

#endif
