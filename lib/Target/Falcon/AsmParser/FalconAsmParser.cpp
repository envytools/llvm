//===-- FalconAsmParser.cpp - Parse Falcon assembly instructions ----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/FalconMCTargetDesc.h"
#include "MCTargetDesc/FalconMCExpr.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
#include "llvm/MC/MCParser/MCTargetAsmParser.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

namespace {

class FalconOperand : public MCParsedAsmOperand {
public:
private:
  enum OperandKind {
    KindInvalid,
    KindToken,
    KindReg,
    KindImm,
    KindMem,
  };

  OperandKind Kind;
  SMLoc StartLoc, EndLoc;

  // A string of length Length, starting at Data.
  struct TokenOp {
    const char *Data;
    unsigned Length;
  };

  struct MemOp {
    unsigned RegBase : 16;
    unsigned RegIdx : 16;
    const MCExpr *Disp;
  };

  struct ImmOp {
    FalconMCExpr::VariantKind Kind;
    const MCExpr *Expr;
  };

  union {
    TokenOp Token;
    unsigned RegNo;
    ImmOp Imm;
    MemOp Mem;
  };

  void addExpr(MCInst &Inst, const MCExpr *Expr) const {
    // Add as immediates when possible.  Null MCExpr = 0.
    if (!Expr)
      Inst.addOperand(MCOperand::createImm(0));
    else if (auto *CE = dyn_cast<MCConstantExpr>(Expr))
      Inst.addOperand(MCOperand::createImm(CE->getValue()));
    else
      Inst.addOperand(MCOperand::createExpr(Expr));
  }

public:
  FalconOperand(OperandKind kind, SMLoc startLoc, SMLoc endLoc)
      : Kind(kind), StartLoc(startLoc), EndLoc(endLoc) {}

  // Create particular kinds of operand.
  static std::unique_ptr<FalconOperand> createInvalid(SMLoc StartLoc,
                                                       SMLoc EndLoc) {
    return make_unique<FalconOperand>(KindInvalid, StartLoc, EndLoc);
  }
  static std::unique_ptr<FalconOperand> createToken(StringRef Str, SMLoc Loc) {
    auto Op = make_unique<FalconOperand>(KindToken, Loc, Loc);
    Op->Token.Data = Str.data();
    Op->Token.Length = Str.size();
    return Op;
  }
  static std::unique_ptr<FalconOperand>
  createReg(unsigned RegNo, SMLoc StartLoc, SMLoc EndLoc) {
    auto Op = make_unique<FalconOperand>(KindReg, StartLoc, EndLoc);
    Op->RegNo = RegNo;
    return Op;
  }
  static std::unique_ptr<FalconOperand>
  createImm(FalconMCExpr::VariantKind Kind, const MCExpr *Expr, SMLoc StartLoc, SMLoc EndLoc) {
    auto Op = make_unique<FalconOperand>(KindImm, StartLoc, EndLoc);
    Op->Imm.Kind = Kind;
    Op->Imm.Expr = Expr;
    return Op;
  }
  static std::unique_ptr<FalconOperand>
  createMem(unsigned RegBase, const MCExpr *Disp, unsigned RegIdx,
            SMLoc StartLoc, SMLoc EndLoc) {
    auto Op = make_unique<FalconOperand>(KindMem, StartLoc, EndLoc);
    Op->Mem.RegBase = RegBase;
    Op->Mem.RegIdx = RegIdx;
    Op->Mem.Disp = Disp;
    return Op;
  }

  // Token operands
  bool isToken() const override {
    return Kind == KindToken;
  }
  StringRef getToken() const {
    assert(Kind == KindToken && "Not a token");
    return StringRef(Token.Data, Token.Length);
  }

  // Register operands.
  bool isReg() const override {
    return Kind == KindReg;
  }
  unsigned getReg() const override {
    assert(Kind == KindReg && "Not a register");
    return RegNo;
  }

  // Immediate operands.
  bool isImm() const override {
    return Kind == KindImm;
  }
  bool isExpr(FalconMCExpr::VariantKind ImmKind) const {
    return Kind == KindImm && Imm.Kind == ImmKind;
  }
  bool isImm(int64_t MinValue, int64_t MaxValue, bool matchExpr) const {
    if (Kind != KindImm)
      return false;
    if (Imm.Kind != FalconMCExpr::VK_Falcon_None)
      return false;
    if (auto *CE = dyn_cast<MCConstantExpr>(Imm.Expr)) {
      int64_t Value = CE->getValue();
      return Value >= MinValue && Value <= MaxValue;
    }
    return matchExpr;
  }
  const MCExpr *getImm() const {
    assert(Kind == KindImm && "Not an immediate");
    return Imm.Expr;
  }

  // Memory operands.
  bool isMem() const override {
    return Kind == KindMem;
  }

  // Override MCParsedAsmOperand.
  SMLoc getStartLoc() const override { return StartLoc; }
  SMLoc getEndLoc() const override { return EndLoc; }
  void print(raw_ostream &OS) const override;

  // Used by the TableGen code to add particular types of operand
  // to an instruction.
  void addRegOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands");
    Inst.addOperand(MCOperand::createReg(getReg()));
  }
  void addImmOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands");
    addExpr(Inst, getImm());
  }
  void addMemRegOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands");
    Inst.addOperand(MCOperand::createReg(Mem.RegBase));
  }
  void addMemRegImmOperands(MCInst &Inst, unsigned N) const {
    assert(N == 2 && "Invalid number of operands");
    Inst.addOperand(MCOperand::createReg(Mem.RegBase));
    addExpr(Inst, Mem.Disp);
  }
  void addMemSpImmOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands");
    addExpr(Inst, Mem.Disp);
  }
  void addMemSpRegOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands");
    Inst.addOperand(MCOperand::createReg(Mem.RegIdx));
  }
  void addMemRegRegOperands(MCInst &Inst, unsigned N) const {
    assert(N == 2 && "Invalid number of operands");
    Inst.addOperand(MCOperand::createReg(Mem.RegBase));
    Inst.addOperand(MCOperand::createReg(Mem.RegIdx));
  }

  static bool isGPR32(unsigned Reg) {
    for (unsigned GPReg : FalconMC::GPR32Regs) {
      if (Reg == GPReg)
        return true;
    }
    return false;
  }

  template<unsigned shift>
  static bool isDisp(const MCExpr *Disp) {
    if (!Disp)
      return false;
    if (auto *CE = dyn_cast<MCConstantExpr>(Disp)) {
      int64_t Value = CE->getValue();
      if (Value & ((1 << shift) - 1))
        return false;
      if (Value >= (1 << (shift + 8)))
        return false;
    }
    return true;
  }

  // Used by the TableGen code to check for particular operand types.
  bool isMemReg() const {
    return Kind == KindMem &&
           Mem.Disp == nullptr &&
           isGPR32(Mem.RegBase) &&
           Mem.RegIdx == 0;
  }
  template<unsigned shift>
  bool isMemRegImm() const {
    return Kind == KindMem &&
      isDisp<shift>(Mem.Disp) &&
      Mem.RegIdx == 0 &&
      isGPR32(Mem.RegBase);
  }
  bool isMemRegImm0() const { return isMemRegImm<0>(); }
  bool isMemRegImm1() const { return isMemRegImm<1>(); }
  bool isMemRegImm2() const { return isMemRegImm<2>(); }
  template<unsigned shift>
  bool isMemSpImm() const {
    return Kind == KindMem &&
      isDisp<shift>(Mem.Disp) &&
      Mem.RegIdx == 0 &&
      Mem.RegBase == Falcon::SP;
  }
  bool isMemSpImm0() const { return isMemSpImm<0>(); }
  bool isMemSpImm1() const { return isMemSpImm<1>(); }
  bool isMemSpImm2() const { return isMemSpImm<2>(); }
  bool isMemSpReg() const {
    return Kind == KindMem &&
           Mem.Disp == nullptr &&
           Mem.RegBase == Falcon::SP &&
           isGPR32(Mem.RegIdx);
  }
  bool isMemRegReg() const {
    return Kind == KindMem &&
           Mem.Disp == nullptr &&
           isGPR32(Mem.RegBase) &&
           isGPR32(Mem.RegIdx);
  }
  bool isU8Imm() const { return isExpr(FalconMCExpr::VK_Falcon_U8) || isExpr(FalconMCExpr::VK_Falcon_HI8) || isImm(0, 255, true); }
  bool isU8XImm() const { return isExpr(FalconMCExpr::VK_Falcon_U8) || isExpr(FalconMCExpr::VK_Falcon_HI8) || isImm(0, 255, false); }
  bool isS8Imm() const { return isExpr(FalconMCExpr::VK_Falcon_S8) || isImm(-128, 127, true); }
  bool isS8XImm() const { return isExpr(FalconMCExpr::VK_Falcon_S8) || isImm(-128, 127, false); }
  bool isU16Imm() const { return isExpr(FalconMCExpr::VK_Falcon_U16) || isExpr(FalconMCExpr::VK_Falcon_HI16) || isImm(0, 65535, true); }
  bool isU16XImm() const { return isExpr(FalconMCExpr::VK_Falcon_U16) || isExpr(FalconMCExpr::VK_Falcon_HI16) || isImm(0, 65535, false); }
  bool isS16Imm() const { return isExpr(FalconMCExpr::VK_Falcon_S16) || isExpr(FalconMCExpr::VK_Falcon_LO16) || isImm(-32768, 32767, true); }
  bool isS16XImm() const { return isExpr(FalconMCExpr::VK_Falcon_S16) || isExpr(FalconMCExpr::VK_Falcon_LO16) || isImm(-32768, 32767, false); }
  bool isU24Imm() const { return isExpr(FalconMCExpr::VK_Falcon_U24) || isImm(0, 0xffffff, true); }
  bool isU24XImm() const { return isExpr(FalconMCExpr::VK_Falcon_U24) || isImm(0, 0xffffff, false); }
  bool isU32Imm() const { return isExpr(FalconMCExpr::VK_Falcon_U32) || isImm(0, 0xffffffff, true); }
};

class FalconAsmParser : public MCTargetAsmParser {
#define GET_ASSEMBLER_HEADER
#include "FalconGenAsmMatcher.inc"

private:
  MCAsmParser &Parser;

  bool parseRegister(unsigned &RegNo);

  bool parseOperand(OperandVector &Operands, StringRef Mnemonic);

public:
  FalconAsmParser(const MCSubtargetInfo &sti, MCAsmParser &parser,
                  const MCInstrInfo &MII,
                  const MCTargetOptions &Options)
    : MCTargetAsmParser(Options, sti), Parser(parser) {
    MCAsmParserExtension::Initialize(Parser);

    // Initialize the set of available features.
    setAvailableFeatures(ComputeAvailableFeatures(getSTI().getFeatureBits()));
  }

  // Override MCTargetAsmParser.
  bool ParseDirective(AsmToken DirectiveID) override;
  bool ParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) override;
  bool ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                        SMLoc NameLoc, OperandVector &Operands) override;
  bool MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                               OperandVector &Operands, MCStreamer &Out,
                               uint64_t &ErrorInfo,
                               bool MatchingInlineAsm) override;
};
} // end anonymous namespace

#define GET_REGISTER_MATCHER
#define GET_SUBTARGET_FEATURE_NAME
#define GET_MATCHER_IMPLEMENTATION
#include "FalconGenAsmMatcher.inc"

void FalconOperand::print(raw_ostream &OS) const {
  llvm_unreachable("Not implemented");
}

// Parse one register.
bool FalconAsmParser::parseRegister(unsigned &RegNo) {
  SMLoc StartLoc = Parser.getTok().getLoc();

  // Eat the % prefix.
  if (Parser.getTok().isNot(AsmToken::Percent))
    return Error(Parser.getTok().getLoc(), "register expected");
  Parser.Lex();

  // Expect a register name.
  if (Parser.getTok().isNot(AsmToken::Identifier))
    return Error(StartLoc, "invalid register");

  StringRef Name = Parser.getTok().getString();

  RegNo = MatchRegisterName(Name);

  if (RegNo == 0)
    return Error(StartLoc, "invalid register");

  Parser.Lex();
  return false;
}

bool FalconAsmParser::ParseDirective(AsmToken DirectiveID) {
  return true;
}

bool FalconAsmParser::ParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                     SMLoc &EndLoc) {
  StartLoc = Parser.getTok().getLoc();
  if (parseRegister(RegNo))
    return true;
  EndLoc = SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);
  return false;
}

bool FalconAsmParser::ParseInstruction(ParseInstructionInfo &Info,
                                        StringRef Name, SMLoc NameLoc,
                                        OperandVector &Operands) {
  Operands.push_back(FalconOperand::createToken(Name, NameLoc));

  // Read the remaining operands.
  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    // Read the first operand.
    if (parseOperand(Operands, Name)) {
      Parser.eatToEndOfStatement();
      return true;
    }

    // Read any subsequent operands.
    while (getLexer().is(AsmToken::Comma)) {
      Parser.Lex();
      if (parseOperand(Operands, Name)) {
        Parser.eatToEndOfStatement();
        return true;
      }
    }
    if (getLexer().isNot(AsmToken::EndOfStatement)) {
      SMLoc Loc = getLexer().getLoc();
      Parser.eatToEndOfStatement();
      return Error(Loc, "unexpected token in argument list");
    }
  }

  // Consume the EndOfStatement.
  Parser.Lex();
  return false;
}

bool FalconAsmParser::parseOperand(OperandVector &Operands,
                                    StringRef Mnemonic) {
  SMLoc StartLoc = Parser.getTok().getLoc();
  if (Parser.getTok().is(AsmToken::Percent)) {
    unsigned Reg;
    Parser.Lex();

    // Expect a register name.
    if (Parser.getTok().isNot(AsmToken::Identifier))
      return Error(StartLoc, "invalid register");

    StringRef Name = Parser.getTok().getString();
    Parser.Lex();

    Reg = MatchRegisterName(Name);

    if (Reg == 0) {
      // Not a register - try immediate expression.
      FalconMCExpr::VariantKind Kind = FalconMCExpr::parseVariantKind(Name);
      if (Kind == FalconMCExpr::VK_Falcon_None) {
        return true;
      }
      // Skip LParen
      if (getLexer().isNot(AsmToken::LParen))
        return true;
      Parser.Lex();
      const MCExpr *Expr = nullptr;
      if (getParser().parseExpression(Expr))
        return true;
      // Skip RParen
      if (getLexer().isNot(AsmToken::RParen))
        return true;
      Parser.Lex();
      SMLoc EndLoc =
        SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);
      Expr = FalconMCExpr::create(Kind, Expr, getContext());
      Operands.push_back(FalconOperand::createImm(Kind, Expr, StartLoc, EndLoc));
      return false;
    }

    if (getLexer().is(AsmToken::LParen)) {
      Parser.Lex();
      unsigned Reg2;
      if (parseRegister(Reg2))
        return true;
      // Eat the )
      if (Parser.getTok().isNot(AsmToken::RParen))
        return Error(Parser.getTok().getLoc(), "closing ) expected");
      Parser.Lex();
      SMLoc EndLoc =
        SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);
      Operands.push_back(FalconOperand::createMem(Reg2, nullptr, Reg, StartLoc, EndLoc));
      return false;
    }

    SMLoc EndLoc =
      SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);
    Operands.push_back(FalconOperand::createReg(Reg, StartLoc, EndLoc));
    return false;
  }

  const MCExpr *Expr = nullptr;
  if (getLexer().isNot(AsmToken::LParen)) {
    if (getParser().parseExpression(Expr))
      return true;
  }

  if (getLexer().is(AsmToken::LParen)) {
    Parser.Lex();
    unsigned Reg;
    if (parseRegister(Reg))
      return true;
    // Eat the )
    if (Parser.getTok().isNot(AsmToken::RParen))
      return Error(Parser.getTok().getLoc(), "closing ) expected");
    Parser.Lex();
    SMLoc EndLoc =
      SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);
    Operands.push_back(FalconOperand::createMem(Reg, Expr, 0, StartLoc, EndLoc));
    return false;
  }

  SMLoc EndLoc =
    SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);
  Operands.push_back(FalconOperand::createImm(FalconMCExpr::VK_Falcon_None, Expr, StartLoc, EndLoc));
  return false;
}

bool FalconAsmParser::MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                                               OperandVector &Operands,
                                               MCStreamer &Out,
                                               uint64_t &ErrorInfo,
                                               bool MatchingInlineAsm) {
  MCInst Inst;
  unsigned MatchResult;

  MatchResult = MatchInstructionImpl(Operands, Inst, ErrorInfo,
                                     MatchingInlineAsm);
  switch (MatchResult) {
  case Match_Success:
    Inst.setLoc(IDLoc);
    Out.EmitInstruction(Inst, getSTI());
    return false;

  case Match_MissingFeature: {
    assert(ErrorInfo && "Unknown missing feature!");
    // Special case the error message for the very common case where only
    // a single subtarget feature is missing
    std::string Msg = "instruction requires:";
    uint64_t Mask = 1;
    for (unsigned I = 0; I < sizeof(ErrorInfo) * 8 - 1; ++I) {
      if (ErrorInfo & Mask) {
        Msg += " ";
        Msg += getSubtargetFeatureName(ErrorInfo & Mask);
      }
      Mask <<= 1;
    }
    return Error(IDLoc, Msg);
  }

  case Match_InvalidOperand: {
    SMLoc ErrorLoc = IDLoc;
    if (ErrorInfo != ~0ULL) {
      if (ErrorInfo >= Operands.size())
        return Error(IDLoc, "too few operands for instruction");

      ErrorLoc = ((FalconOperand &)*Operands[ErrorInfo]).getStartLoc();
      if (ErrorLoc == SMLoc())
        ErrorLoc = IDLoc;
    }
    return Error(ErrorLoc, "invalid operand for instruction");
  }

  case Match_MnemonicFail:
    return Error(IDLoc, "invalid instruction");
  }

  llvm_unreachable("Unexpected match type");
}

// Force static initialization.
extern "C" void LLVMInitializeFalconAsmParser() {
  RegisterMCAsmParser<FalconAsmParser> X(TheFalconTarget);
}
