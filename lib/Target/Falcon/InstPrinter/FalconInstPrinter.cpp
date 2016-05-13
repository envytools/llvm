//===-- FalconInstPrinter.cpp - Convert Falcon MCInst to asm syntax -------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This class prints an Falcon MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#include "Falcon.h"
#include "FalconInstPrinter.h"
#include "MCTargetDesc/FalconMCExpr.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FormattedStream.h"
using namespace llvm;

#define DEBUG_TYPE "asm-printer"

// Include the auto-generated portion of the assembly writer.
#include "FalconGenAsmWriter.inc"

void FalconInstPrinter::printInst(const MCInst *MI, raw_ostream &O,
                               StringRef Annot, const MCSubtargetInfo &STI) {
  printInstruction(MI, O);
  printAnnotation(O, Annot);
}

/* XXX all wrong */

void FalconInstPrinter::printOperand(const MCInst *MI, unsigned OpNum,
                                  raw_ostream &O, const char *Modifier) {
  assert((Modifier == 0 || Modifier[0] == 0) && "No modifiers supported");
  const MCOperand &Op = MI->getOperand(OpNum);
  if (Op.isReg()) {
    O << '%' << getRegisterName(Op.getReg());
  } else if (Op.isImm()) {
    O << (int32_t)Op.getImm();
  } else {
    assert(Op.isExpr() && "Expected an expression");
    O << *Op.getExpr();
  }
}

void FalconInstPrinter::printPCRelOperand(const MCInst *MI, int OpNum,
                                           raw_ostream &O) {
  const MCOperand &MO = MI->getOperand(OpNum);
  if (MO.isImm()) {
    O << "0x";
    O.write_hex(MO.getImm());
  } else {
    MO.getExpr()->print(O, &MAI);
  }
}

template <unsigned N>
static void printUImmOperand(const MCInst *MI, int OpNum, raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNum);
  if (Op.isImm()) {
    int64_t Value = Op.getImm();
    assert(isUInt<N>(Value) && "Invalid uimm argument");
    O << Value;
  } else {
    O << *Op.getExpr();
  }
}

template <unsigned N>
static void printSImmOperand(const MCInst *MI, int OpNum, raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNum);
  if (Op.isImm()) {
    int64_t Value = Op.getImm();
    assert(isInt<N>(Value) && "Invalid simm argument");
    O << Value;
  } else {
    O << *Op.getExpr();
  }
}

void FalconInstPrinter::printS8ImmOperand(const MCInst *MI, int OpNum,
                                          raw_ostream &O) {
  printSImmOperand<8>(MI, OpNum, O);
}

void FalconInstPrinter::printS8XImmOperand(const MCInst *MI, int OpNum,
                                          raw_ostream &O) {
  printSImmOperand<8>(MI, OpNum, O);
}

void FalconInstPrinter::printU8ImmOperand(const MCInst *MI, int OpNum,
                                          raw_ostream &O) {
  printUImmOperand<8>(MI, OpNum, O);
}

void FalconInstPrinter::printU8XImmOperand(const MCInst *MI, int OpNum,
                                          raw_ostream &O) {
  printUImmOperand<8>(MI, OpNum, O);
}

void FalconInstPrinter::printS16ImmOperand(const MCInst *MI, int OpNum,
                                           raw_ostream &O) {
  printSImmOperand<16>(MI, OpNum, O);
}

void FalconInstPrinter::printS16XImmOperand(const MCInst *MI, int OpNum,
                                           raw_ostream &O) {
  printSImmOperand<16>(MI, OpNum, O);
}

void FalconInstPrinter::printU16ImmOperand(const MCInst *MI, int OpNum,
                                           raw_ostream &O) {
  printUImmOperand<16>(MI, OpNum, O);
}

void FalconInstPrinter::printU16XImmOperand(const MCInst *MI, int OpNum,
                                           raw_ostream &O) {
  printUImmOperand<16>(MI, OpNum, O);
}

void FalconInstPrinter::printU32ImmOperand(const MCInst *MI, int OpNum,
                                           raw_ostream &O) {
  printUImmOperand<32>(MI, OpNum, O);
}

void FalconInstPrinter::printMemReg(const MCInst *MI, int OpNum,
                                    raw_ostream &O) {
  const MCOperand &RegOp = MI->getOperand(OpNum);
  assert(RegOp.isReg() && "Register operand not a register");
  O << '(' << '%' << getRegisterName(RegOp.getReg()) << ')';
}

void FalconInstPrinter::printMemRegReg(const MCInst *MI, int OpNum,
                                       raw_ostream &O) {
  const MCOperand &RegOp = MI->getOperand(OpNum);
  const MCOperand &IdxOp = MI->getOperand(OpNum + 1);
  assert(RegOp.isReg() && "Register operand not a register");
  assert(IdxOp.isReg() && "Register operand not a register");
  O << '%' << getRegisterName(IdxOp.getReg()) << '(' << '%' << getRegisterName(RegOp.getReg()) << ')';
}

void FalconInstPrinter::printMemRegImm(const MCInst *MI, int OpNum,
                                       raw_ostream &O) {
  const MCOperand &RegOp = MI->getOperand(OpNum);
  const MCOperand &IdxOp = MI->getOperand(OpNum + 1);
  assert(RegOp.isReg() && "Register operand not a register");
  if (IdxOp.isImm())
    O << formatDec(IdxOp.getImm());
  else if (IdxOp.isExpr())
    O << *IdxOp.getExpr();
  else
    llvm_unreachable("Immediate operand not an immediate");
  O << '(' << '%' << getRegisterName(RegOp.getReg()) << ')';
}

void FalconInstPrinter::printMemSpReg(const MCInst *MI, int OpNum,
                                       raw_ostream &O) {
  const MCOperand &IdxOp = MI->getOperand(OpNum);
  assert(IdxOp.isReg() && "Register operand not a register");
  O << '%' << getRegisterName(IdxOp.getReg()) << '(' << '%' << getRegisterName(Falcon::SP) << ')';
}

void FalconInstPrinter::printMemSpImm(const MCInst *MI, int OpNum,
                                       raw_ostream &O) {
  const MCOperand &IdxOp = MI->getOperand(OpNum);
  if (IdxOp.isImm())
    O << formatDec(IdxOp.getImm());
  else if (IdxOp.isExpr())
    O << *IdxOp.getExpr();
  else
    llvm_unreachable("Immediate operand not an immediate");
  O << '(' << '%' << getRegisterName(Falcon::SP) << ')';
}
