//===-- FalconOperands.td - Operand Description for Falcon Target ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the Falcon operands in TableGen format.
//
//===----------------------------------------------------------------------===//

// Immediates.

class ImmediateAsmOperand<string name, list<AsmOperandClass> supers = []>
  : AsmOperandClass {
  let Name = name;
  let RenderMethod = "addImmOperands";
  let SuperClasses = supers;
}

class Immediate<ValueType vt, code pred, SDNodeXForm xform, string asmop>
  : PatLeaf<(vt imm), pred, xform>, Operand<vt> {
  let PrintMethod = "print"##asmop##"Operand";
  let EncoderMethod = "encode"##asmop##"Operand";
  let DecoderMethod = "decode"##asmop##"Operand";
  let ParserMatchClass = !cast<AsmOperandClass>(asmop);
}

def SIMM8 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(int8_t(N->getZExtValue()), SDLoc(N), MVT::i32);
}]>;
def SIMM16 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(int16_t(N->getZExtValue()), SDLoc(N), MVT::i32);
}]>;
def UIMM8 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(uint8_t(N->getZExtValue()), SDLoc(N), MVT::i32);
}]>;
def UIMM8S1 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(uint8_t(N->getZExtValue() >> 1), SDLoc(N), MVT::i32);
}]>;
def UIMM8S2 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(uint8_t(N->getZExtValue() >> 2), SDLoc(N), MVT::i32);
}]>;
def UIMM16 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(uint16_t(N->getZExtValue()), SDLoc(N), MVT::i32);
}]>;
def HI16 : SDNodeXForm<imm, [{
  uint64_t Value = N->getZExtValue() >> 16;
  return CurDAG->getTargetConstant(uint16_t(Value), SDLoc(N), MVT::i16);
}]>;
def HI16ZX8 : SDNodeXForm<imm, [{
  uint64_t Value = N->getZExtValue() >> 16;
  return CurDAG->getTargetConstant(uint8_t(Value), SDLoc(N), MVT::i16);
}]>;
def UIMM32 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(uint32_t(N->getZExtValue()), SDLoc(N), MVT::i32);
}]>;

def S16Imm : ImmediateAsmOperand<"S16Imm">;
def S8Imm : ImmediateAsmOperand<"S8Imm", [S16Imm]>;
def U32Imm : ImmediateAsmOperand<"U32Imm">;
def U16Imm : ImmediateAsmOperand<"U16Imm">;
def U8Imm : ImmediateAsmOperand<"U8Imm", [U16Imm]>;
def U16XImm : ImmediateAsmOperand<"U16XImm">;
def U8XImm : ImmediateAsmOperand<"U8XImm", [U16XImm]>;

def imm24 : PatLeaf<(i32 imm), [{
  return isUInt<24>(N->getZExtValue());
}]>;

def imm24lb : PatLeaf<(i32 imm), [{
  uint64_t Value = N->getZExtValue();
  return isUInt<24>(Value) && int8_t(Value) == int16_t(Value);
}]>;

def imm32lb : PatLeaf<(i32 imm), [{
  uint64_t Value = N->getZExtValue();
  return int8_t(Value) == int16_t(Value);
}]>;

def imm32zx8 : Immediate<i32, [{
   return isUInt<8>(N->getZExtValue());
}], UIMM8, "U8Imm">;
def imm32zx8s1 : Immediate<i32, [{
   return isShiftedUInt<8, 1>(N->getZExtValue());
}], UIMM8S1, "U8Imm">;
def imm32zx8s2 : Immediate<i32, [{
   return isShiftedUInt<8, 2>(N->getZExtValue());
}], UIMM8S2, "U8Imm">;
def imm32sx8 : Immediate<i32, [{
   return isInt<8>(N->getSExtValue());
}], SIMM8, "S8Imm">;
def imm32zx16 : Immediate<i32, [{
   return isUInt<16>(N->getZExtValue());
}], UIMM16, "U16Imm">;
def imm32sx16 : Immediate<i32, [{
   return isInt<16>(N->getSExtValue());
}], SIMM16, "S16Imm">;
def immhi16 : Immediate<i32, [{
   return isShiftedUInt<16, 16>(N->getZExtValue());
}], HI16, "U16Imm">;
def immhi16zx8 : Immediate<i32, [{
   return isShiftedUInt<8, 16>(N->getZExtValue());
}], HI16ZX8, "U8Imm">;
def imm16zx8 : Immediate<i16, [{
   return isUInt<8>(N->getZExtValue());
}], UIMM8, "U8Imm">;
def imm16sx8 : Immediate<i16, [{
   return isInt<8>(N->getSExtValue());
}], SIMM8, "S8Imm">;
def imm16 : Immediate<i16, [{
   return true;
}], UIMM16, "U16Imm">;
def simm16 : Immediate<i16, [{
   return true;
}], SIMM16, "S16Imm">;
def imm8 : Immediate<i8, [{
   return true;
}], UIMM8, "U8Imm">;
def simm8 : Immediate<i8, [{
   return true;
}], SIMM8, "S8Imm">;
def imm8x16 : Immediate<i8, [{
   return true;
}], UIMM16, "U16Imm">;
def simm8x16 : Immediate<i8, [{
   return true;
}], SIMM16, "S16Imm">;
def imm32 : Immediate<i32, [{
   return true;
}], UIMM32, "U32Imm">;
def imm32zx8x : Immediate<i32, [{
   return isUInt<8>(N->getZExtValue());
}], UIMM8, "U8XImm">;
def imm32zx16x : Immediate<i32, [{
   return isUInt<16>(N->getZExtValue());
}], UIMM16, "U16XImm">;

// pcrels.

class PCRelOperand<ValueType vt, AsmOperandClass asmop> : Operand<vt> {
  let PrintMethod = "printPCRelOperand";
  let ParserMatchClass = asmop;
}
def PCRel16 : ImmediateAsmOperand<"PCRel16">;
def pcrel16 : PCRelOperand<OtherVT, PCRel16> {
  let EncoderMethod = "getPC16Encoding";
  let DecoderMethod = "decodePCOperand<16>";
}
def PCRel8 : ImmediateAsmOperand<"PCRel8", [PCRel16]>;
def pcrel8 : PCRelOperand<OtherVT, PCRel8> {
  let EncoderMethod = "getPC8Encoding";
  let DecoderMethod = "decodePCOperand<8>";
}

// Memory operands.

def MemReg : AsmOperandClass {
  let Name = "MemReg";
  let RenderMethod = "addMemRegOperands";
}

def MemRegReg : AsmOperandClass {
  let Name = "MemRegReg";
  let RenderMethod = "addMemRegRegOperands";
}

def MemSpReg : AsmOperandClass {
  let Name = "MemSpReg";
  let RenderMethod = "addMemSpRegOperands";
}

def MemRegImm0 : AsmOperandClass {
  let Name = "MemRegImm0";
  let RenderMethod = "addMemRegImmOperands";
}
def MemRegImm1 : AsmOperandClass {
  let Name = "MemRegImm1";
  let RenderMethod = "addMemRegImmOperands";
}
def MemRegImm2 : AsmOperandClass {
  let Name = "MemRegImm2";
  let RenderMethod = "addMemRegImmOperands";
}

def MemSpImm0 : AsmOperandClass {
  let Name = "MemSpImm0";
  let RenderMethod = "addMemSpImmOperands";
}
def MemSpImm1 : AsmOperandClass {
  let Name = "MemSpImm1";
  let RenderMethod = "addMemSpImmOperands";
}
def MemSpImm2 : AsmOperandClass {
  let Name = "MemSpImm2";
  let RenderMethod = "addMemSpImmOperands";
}

def memr : Operand<i32>, ComplexPattern<i32, 1, "SelectMemReg"> {
  let PrintMethod = "printMemReg";
  let MIOperandInfo = (ops GPR32:$base);
  let EncoderMethod = "getMemRegEncoding";
  let DecoderMethod = "decodeMemRegOperands";
  let ParserMatchClass = MemReg;
}

def memrr : Operand<i32> {
  let PrintMethod = "printMemRegReg";
  let MIOperandInfo = (ops GPR32:$base, GPR32:$idx);
  let EncoderMethod = "getMemRegRegEncoding";
  let DecoderMethod = "decodeMemRegRegOperands";
  let ParserMatchClass = MemRegReg;
}

def memrr0 : ComplexPattern<i32, 2, "SelectMemRegReg<0>">;
def memrr1 : ComplexPattern<i32, 2, "SelectMemRegReg<1>">;
def memrr2 : ComplexPattern<i32, 2, "SelectMemRegReg<2>">;

def memri0 : Operand<i32>, ComplexPattern<i32, 2, "SelectMemRegImm<0, true>"> {
  let PrintMethod = "printMemRegImm";
  let MIOperandInfo = (ops GPR32:$base, imm32zx8:$idx);
  let EncoderMethod = "getMemRegImmEncoding<0>";
  let DecoderMethod = "decodeMemRegImmOperands<0>";
  let ParserMatchClass = MemRegImm0;
}

def memri1 : Operand<i32>, ComplexPattern<i32, 2, "SelectMemRegImm<1, true>"> {
  let PrintMethod = "printMemRegImm";
  let MIOperandInfo = (ops GPR32:$base, imm32zx8s1:$idx);
  let EncoderMethod = "getMemRegImmEncoding<1>";
  let DecoderMethod = "decodeMemRegImmOperands<1>";
  let ParserMatchClass = MemRegImm1;
}

def memri2 : Operand<i32>, ComplexPattern<i32, 2, "SelectMemRegImm<2, true>"> {
  let PrintMethod = "printMemRegImm";
  let MIOperandInfo = (ops GPR32:$base, imm32zx8s2:$idx);
  let EncoderMethod = "getMemRegImmEncoding<2>";
  let DecoderMethod = "decodeMemRegImmOperands<2>";
  let ParserMatchClass = MemRegImm2;
}

def memrinz0 : ComplexPattern<i32, 2, "SelectMemRegImm<0, false>">;
def memrinz1 : ComplexPattern<i32, 2, "SelectMemRegImm<1, false>">;
def memrinz2 : ComplexPattern<i32, 2, "SelectMemRegImm<2, false>">;

def memspr : Operand<i32> {
  let PrintMethod = "printMemSpReg";
  let MIOperandInfo = (ops GPR32:$idx);
  let EncoderMethod = "getMemRegEncoding";
  let DecoderMethod = "decodeMemRegOperands";
  let ParserMatchClass = MemSpReg;
}

def memspi0 : Operand<i32> {
  let PrintMethod = "printMemSpImm";
  let MIOperandInfo = (ops imm32zx8:$idx);
  let EncoderMethod = "getMemImmEncoding<0>";
  let DecoderMethod = "decodeMemImmOperands<0>";
  let ParserMatchClass = MemSpImm0;
}

def memspi1 : Operand<i32> {
  let PrintMethod = "printMemSpImm";
  let MIOperandInfo = (ops imm32zx8s1:$idx);
  let EncoderMethod = "getMemImmEncoding<1>";
  let DecoderMethod = "decodeMemImmOperands<1>";
  let ParserMatchClass = MemSpImm1;
}

def memspi2 : Operand<i32> {
  let PrintMethod = "printMemSpImm";
  let MIOperandInfo = (ops imm32zx8s2:$idx);
  let EncoderMethod = "getMemImmEncoding<2>";
  let DecoderMethod = "decodeMemImmOperands<2>";
  let ParserMatchClass = MemSpImm2;
}

def memfi : ComplexPattern<i32, 2, "SelectMemFI", [add, frameindex]>;
