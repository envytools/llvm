//===-- FalconInstrFormats.td - Falcon Instruction Formats -*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

class InstFalcon<int size, dag outs, dag ins, string asmstr, list<dag> pattern>
  : Instruction {
  let Size = size;

  let Namespace = "Falcon";
  let DecoderNamespace = "Falcon";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = asmstr;
  let Pattern = pattern;
}

// Class used for mapping two-address variants to three-address variants.

class FalconThreeInst<string Key, string Value> {
  string ThreeKey = Key;
  string ThreeValue = Value;
}

def getThreeOperandOpcode : InstrMapping {
  let FilterClass = "FalconThreeInst";
  let RowFields = ["ThreeKey"];
  let ColFields = ["ThreeValue"];
  let KeyCol = ["2"];
  let ValueCols = [["3"]];
}

class FalconRelaxInst<string Key, string Value> {
  string RelaxKey = Key;
  string RelaxValue = Value;
}

def getRelaxedOpcode : InstrMapping {
  let FilterClass = "FalconRelaxInst";
  let RowFields = ["RelaxKey"];
  let ColFields = ["RelaxValue"];
  let KeyCol = ["8"];
  let ValueCols = [["16"]];
}

class Pseudo<int size, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon<size, outs, ins, asmstr, pattern> {
  let isPseudo = 1;
}

class InstFalcon2<dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon<2, outs, ins, asmstr, pattern> {
  field bits<16> Inst;
  field bits<16> SoftFail = 0;
}

class InstFalcon3<dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon<3, outs, ins, asmstr, pattern> {
  field bits<24> Inst;
  field bits<24> SoftFail = 0;
}

class InstFalcon4<dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon<4, outs, ins, asmstr, pattern> {
  field bits<32> Inst;
  field bits<32> SoftFail = 0;
}

class InstFalcon5<dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon<5, outs, ins, asmstr, pattern> {
  field bits<40> Inst;
  field bits<40> SoftFail = 0;
}

// Templates - 2 byte

class InstOR<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon2<outs, ins, asmstr, pattern> {
  bits<4> R1;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = op2;
  let Inst{15-12} = R1;
}

class InstO<bits<8> op, bits<8> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon2<outs, ins, asmstr, pattern> {
  let Inst{7-0} = op;
  let Inst{15-8} = op2;
}

// Templates - 3 byte

class InstORRI8<bits<2> mode, bits<2> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<4> R2;
  bits<8> I8;
  let Inst{3-0} = op2;
  let Inst{5-4} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = R2;
  let Inst{15-12} = R1;
  let Inst{23-16} = I8;
}

class InstORMRI8<bits<2> mode, bits<2> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> R2;
  bits<12> MRI8;
  let Inst{3-0} = op2;
  let Inst{5-4} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = R2;
  let Inst{23-12} = MRI8;
}

class InstORI8<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<8> I8;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = op2;
  let Inst{15-12} = R1;
  let Inst{23-16} = I8;
}

class InstORMSPI8<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<8> MSPI8;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = op2;
  let Inst{15-12} = R1;
  let Inst{23-16} = MSPI8;
}

class InstORR<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<4> R2;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = R2;
  let Inst{15-12} = R1;
  let Inst{19-16} = op2;
  let Inst{23-20} = 0;
}

class InstORMSPR<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> MSPR;
  bits<4> R1;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = MSPR;
  let Inst{15-12} = R1;
  let Inst{19-16} = op2;
  let Inst{23-20} = 0;
}

class InstORMR<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> MR;
  bits<4> R2;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = R2;
  let Inst{15-12} = MR;
  let Inst{19-16} = op2;
  let Inst{23-20} = 0;
}

class InstORRR<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<4> R2;
  bits<4> R3;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = R2;
  let Inst{15-12} = R1;
  let Inst{19-16} = op2;
  let Inst{23-20} = R3;
}

class InstORMRR<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<8> MRR;
  bits<4> R3;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = MRR{7-4};
  let Inst{15-12} = MRR{3-0};
  let Inst{19-16} = op2;
  let Inst{23-20} = R3;
}

class InstOI8<bits<8> op, bits<8> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<8> I8;
  let Inst{7-0} = op;
  let Inst{15-8} = op2;
  let Inst{23-16} = I8;
}

class InstOFI8<bits<8> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<3> F;
  bits<8> I8;
  let Inst{7-0} = op;
  let Inst{10-8} = F;
  let Inst{11} = 0;
  let Inst{15-12} = op2;
  let Inst{23-16} = I8;
}

// Templates - 4 byte

class InstORRI16<bits<2> mode, bits<2> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon4<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<4> R2;
  bits<16> I16;
  let Inst{3-0} = op2;
  let Inst{5-4} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = R2;
  let Inst{15-12} = R1;
  let Inst{31-16} = I16;
}

class InstORI16<bits<2> mode, bits<6> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon4<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<16> I16;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = op2;
  let Inst{15-12} = R1;
  let Inst{31-16} = I16;
}

class InstOI16<bits<8> op, bits<8> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon4<outs, ins, asmstr, pattern> {
  bits<16> I16;
  let Inst{7-0} = op;
  let Inst{15-8} = op2;
  let Inst{31-16} = I16;
}

class InstOFI16<bits<8> op, bits<4> op2, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon4<outs, ins, asmstr, pattern> {
  bits<3> F;
  bits<16> I16;
  let Inst{7-0} = op;
  let Inst{10-8} = F;
  let Inst{11} = 0;
  let Inst{15-12} = op2;
  let Inst{31-16} = I16;
}

// Falcon 4 template

class InstI24<bits<8> op, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon4<outs, ins, asmstr, pattern> {
  bits<24> I24;
  let Inst{7-0} = op;
  let Inst{31-8} = I24;
}

// Falcon 5 templates

class InstRI8<bits<4> op, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon2<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<8> I8;
  let Inst{3-0} = R1;
  let Inst{7-4} = op;
  let Inst{15-8} = I8;
}

class InstRI16<bits<4> op, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<16> I16;
  let Inst{3-0} = R1;
  let Inst{7-4} = op;
  let Inst{23-8} = I16;
}

class InstRI24<bits<4> op, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon4<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<24> I24;
  let Inst{3-0} = R1;
  let Inst{7-4} = op;
  let Inst{31-8} = I24;
}

class InstRI32<bits<4> op, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon5<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<32> I32;
  let Inst{3-0} = R1;
  let Inst{7-4} = op;
  let Inst{39-8} = I32;
}

class InstRR<bits<2> mode, bits<6> op, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon2<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<4> R2;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = R2;
  let Inst{15-12} = R1;
}

class InstRRI8<bits<2> mode, bits<6> op, dag outs, dag ins, string asmstr, list<dag> pattern>
  : InstFalcon3<outs, ins, asmstr, pattern> {
  bits<4> R1;
  bits<4> R2;
  bits<8> I8;
  let Inst{5-0} = op;
  let Inst{7-6} = mode;
  let Inst{11-8} = R2;
  let Inst{15-12} = R1;
  let Inst{23-16} = I8;
}

// XXX: op 33, 38

// Sized Sink instructions (compares and stores)

// Sized, Store, Reg, Reg, Imm8
class InstSSRMRI8<bits<2> mode, bits<4> op, RegisterClass GPR, Operand memri, string asmname, list<dag> pattern>
  : InstORMRI8<mode, 0, op, (outs), (ins memri:$MRI8, GPR:$R2), asmname # "\t$MRI8, $R2", pattern>;

// Sized, Store, Reg, Reg
class InstSSRMR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstORMR<mode, 0x38, op, (outs), (ins memr:$MR, GPR:$R2), asmname # "\t$MR, $R2", pattern>;

// Sized, Store, Reg, Imm8
class InstSSRMSPI8<bits<2> mode, bits<4> op, RegisterClass GPR, Operand memspi, string asmname, list<dag> pattern>
  : InstORMSPI8<mode, 0x30, op, (outs), (ins memspi:$MSPI8, GPR:$R1), asmname # "\t$MSPI8, $R1", pattern>;

// Sized, Store, Reg, Reg
class InstSSRMSPR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstORMSPR<mode, 0x38, op, (outs), (ins memspr:$MSPR, GPR:$R1), asmname # "\t$MSPR, $R1", pattern>;

// Sized, Compare, Reg, Imm8
class InstSCRI8<bits<2> mode, bits<4> op, RegisterClass GPR, Immediate mimm8, string asmname, list<dag> pattern>
  : InstORI8<mode, 0x30, op, (outs), (ins GPR:$R1, mimm8:$I8), asmname # "\t$R1, $I8", pattern>,
    FalconRelaxInst<asmname # "ri" # mode, "8">;

// Sized, Compare, Reg, Imm16
class InstSCRI16<bits<2> mode, bits<4> op, RegisterClass GPR, Immediate mimm16, string asmname, list<dag> pattern>
  : InstORI16<mode, 0x31, op, (outs), (ins GPR:$R1, mimm16:$I16), asmname # "\t$R1, $I16", pattern>,
    FalconRelaxInst<asmname # "ri" # mode, "16">;

// Sized, Compare, Reg, Reg
class InstSCRR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstORR<mode, 0x38, op, (outs), (ins GPR:$R1, GPR:$R2), asmname # "\t$R1, $R2", pattern>;

// Sized Binary instructions (A = op(B, C) or A = op(A, B)) - includes indexed loads

// Sized, Binary, Reg, Reg, Imm8
class InstSBRRI8<bits<2> mode, bits<4> op, RegisterClass GPR, Immediate mimm8, string asmname, list<dag> pattern>
  : InstORRI8<mode, 1, op, (outs GPR:$R2), (ins GPR:$R1, mimm8:$I8), asmname # "\t$R2, $R1, $I8", pattern>,
    FalconRelaxInst<asmname # "rri" # mode, "8">;

// Sized, Binary, Reg, Reg, Imm16
class InstSBRRI16<bits<2> mode, bits<4> op, RegisterClass GPR, Immediate mimm16, string asmname, list<dag> pattern>
  : InstORRI16<mode, 2, op, (outs GPR:$R2), (ins GPR:$R1, mimm16:$I16), asmname # "\t$R2, $R1, $I16", pattern>,
    FalconRelaxInst<asmname # "rri" # mode, "16">;

// Sized, Binary, Reg, Imm8
class InstSBRI8<bits<2> mode, bits<4> op, RegisterClass GPR, Immediate mimm8, string asmname, list<dag> pattern>
  : InstORI8<mode, 0x36, op, (outs GPR:$R2), (ins GPR:$R1, mimm8:$I8), asmname # "\t$R1, $I8", pattern>,
    FalconRelaxInst<asmname # "ri" # mode, "8"> {
  let Constraints = "$R2 = $R1";
}

// Sized, Binary, Reg, Imm16
class InstSBRI16<bits<2> mode, bits<4> op, RegisterClass GPR, Immediate mimm16, string asmname, list<dag> pattern>
  : InstORI16<mode, 0x37, op, (outs GPR:$R2), (ins GPR:$R1, mimm16:$I16), asmname # "\t$R1, $I16", pattern>,
    FalconRelaxInst<asmname # "ri" # mode, "16"> {
  let Constraints = "$R2 = $R1";
}

// Sized, Binary, Reg, Reg
class InstSBRR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstORR<mode, 0x3b, op, (outs GPR:$R3), (ins GPR:$R1, GPR:$R2), asmname # "\t$R1, $R2", pattern> {
  let Constraints = "$R3 = $R1";
}

// Sized, Binary, Reg, Reg, Reg
class InstSBRRR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstORRR<mode, 0x3c, op, (outs GPR:$R3), (ins GPR:$R1, GPR:$R2), asmname # "\t$R3, $R1, $R2", pattern>;

// Sized unary load instructions (A = load(B))

// Sized, Load, Reg, Imm8
class InstSLRMSPI8<bits<2> mode, bits<4> op, RegisterClass GPR, Operand memspi, string asmname, list<dag> pattern>
  : InstORMSPI8<mode, 0x34, op, (outs GPR:$R1), (ins memspi:$MSPI8), asmname # "\t$R1, $MSPI8", pattern>;

// Sized, Load, Reg, Reg
class InstSLRMSPR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstORMSPR<mode, 0x3a, op, (outs GPR:$R1), (ins memspr:$MSPR), asmname # "\t$R1, $MSPR", pattern>;

// Sized, Load, Reg, Reg, Imm8
class InstSLRMRI8<bits<2> mode, bits<4> op, RegisterClass GPR, Operand memri, string asmname, list<dag> pattern>
  : InstORMRI8<mode, 1, op, (outs GPR:$R2), (ins memri:$MRI8), asmname # "\t$R2, $MRI8", pattern>;

// Sized, Load, Reg, Reg, Reg
class InstSLRMRR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstORMRR<mode, 0x3c, op, (outs GPR:$R3), (ins memrr:$MRR), asmname # "\t$R3, $MRR", pattern>;

// Sized unary instructions (A = op(B) or A = op(A))

// Sized, Unary, Reg, Reg
class InstSURR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstORR<mode, 0x39, op, (outs GPR:$R2), (ins GPR:$R1), asmname # "\t$R2, $R1", pattern>;

// Sized, Unary, Reg
class InstSUR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstOR<mode, 0x3d, op, (outs GPR:$R2), (ins GPR:$R1), asmname # "\t$R1", pattern> {
  let Constraints = "$R2 = $R1";
}

class InstSZR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstOR<mode, 0x3d, op, (outs GPR:$R1), (ins), asmname # "\t$R1", pattern>;

class InstSTR<bits<2> mode, bits<4> op, RegisterClass GPR, string asmname, list<dag> pattern>
  : InstOR<mode, 0x3d, op, (outs), (ins GPR:$R1), asmname # "\t$R1", pattern>;

// Unsized binary instructions

// Unsized, Binary, Reg, Reg, Imm8
class InstUBRRI8<bits<4> op, Immediate mimm8, string asmname, list<dag> pattern>
  : InstORRI8<3, 0, op, (outs GPR32:$R2), (ins GPR32:$R1, mimm8:$I8), asmname # "\t$R2, $R1, $I8", pattern>,
    FalconRelaxInst<asmname # "rri", "8">;

// Unsized, Binary, Reg, Reg, Imm16
class InstUBRRI16<bits<4> op, Immediate mimm16, string asmname, list<dag> pattern>
  : InstORRI16<3, 2, op, (outs GPR32:$R2), (ins GPR32:$R1, mimm16:$I16), asmname # "\t$R2, $R1, $I16", pattern>,
    FalconRelaxInst<asmname # "rri", "16">;

// Unsized, Binary, Reg, Imm8
class InstUBRI8<bits<4> op, Immediate mimm8, string asmname, list<dag> pattern>
  : InstORI8<3, 0x30, op, (outs GPR32:$R2), (ins GPR32:$R1, mimm8:$I8), asmname # "\t$R1, $I8", pattern>,
    FalconRelaxInst<asmname # "ri", "8"> {
  let Constraints = "$R2 = $R1";
}

// Unsized, Binary, Reg, Imm16
class InstUBRI16<bits<4> op, Immediate mimm16, string asmname, list<dag> pattern>
  : InstORI16<3, 0x31, op, (outs GPR32:$R2), (ins GPR32:$R1, mimm16:$I16), asmname # "\t$R1, $I16", pattern>,
    FalconRelaxInst<asmname # "ri", "16"> {
  let Constraints = "$R2 = $R1";
}

// Unsized, Binary, Reg, Reg
class InstUBRR<bits<4> op, string asmname, list<dag> pattern>
  : InstORR<3, 0x3d, op, (outs GPR32:$R3), (ins GPR32:$R1, GPR32:$R2), asmname # "\t$R1, $R2", pattern> {
  let Constraints = "$R3 = $R1";
}

// Unsized, Binary, Reg, Reg, Reg
class InstUBRRR<bits<4> op, string asmname, list<dag> pattern>
  : InstORRR<3, 0x3f, op, (outs GPR32:$R3), (ins GPR32:$R1, GPR32:$R2), asmname # "\t$R3, $R1, $R2", pattern>;

// Unsized, Load, Reg, Reg, Imm8
class InstULRMRI8<bits<4> op, string asmname, list<dag> pattern>
  : InstORMRI8<3, 0, op, (outs GPR32:$R2), (ins memri2:$MRI8), asmname # "\t$R2, $MRI8", pattern>;

// Unsized, Load, Reg, Reg, Reg
class InstULRMRR<bits<4> op, string asmname, list<dag> pattern>
  : InstORMRR<3, 0x3f, op, (outs GPR32:$R3), (ins memrr:$MRR), asmname # "\t$R3, $MRR", pattern>;

// Unsized, Ternary, Reg, Reg, Imm8
class InstUTRRI8<bits<4> op, string asmname, list<dag> pattern>
  : InstORRI8<3, 0, op, (outs GPR32:$R3), (ins GPR32:$R1, GPR32:$R2, imm32zx8:$I8), asmname # "\t$R2, $R1, $I8", pattern>,
    FalconRelaxInst<asmname # "rri", "8"> {
  let Constraints = "$R3 = $R1";
}

// Unsized, Ternary, Reg, Reg, Imm16
class InstUTRRI16<bits<4> op, string asmname, list<dag> pattern>
  : InstORRI16<3, 2, op, (outs GPR32:$R3), (ins GPR32:$R1, GPR32:$R2, imm32zx16:$I16), asmname # "\t$R2, $R1, $I16", pattern>,
    FalconRelaxInst<asmname # "rri", "16"> {
  let Constraints = "$R3 = $R1";
}

// Unsized unary instructions

// Unsized, Unary, Reg, Imm8
class InstUURI8<bits<4> op, string asmname, list<dag> pattern>
  : InstORI8<3, 0x30, op, (outs GPR32:$R1), (ins imm32sx8:$I8), asmname # "\t$R1, $I8", pattern>,
    FalconRelaxInst<asmname # "ri", "8">;

// Unsized, Unary, Reg, Imm16
class InstUURI16<bits<4> op, string asmname, list<dag> pattern>
  : InstORI16<3, 0x31, op, (outs GPR32:$R1), (ins imm32sx16:$I16), asmname # "\t$R1, $I16", pattern>,
    FalconRelaxInst<asmname # "ri", "16">;

// Unsized, Unary, Reg, Reg
class InstUURR<bits<4> op, string asmname, list<dag> pattern>
  : InstORR<3, 0x3e, op, (outs GPR32:$R2), (ins GPR32:$R1), asmname # "\t$R2, $R1", pattern>;

// Unsized, Unary, SReg, Reg
class InstUUSR<bits<4> op, string asmname, list<dag> pattern>
  : InstORR<3, 0x3e, op, (outs SR:$R2), (ins GPR32:$R1), asmname # "\t$R2, $R1", pattern>;

// Unsized, Unary, Reg, SReg
class InstUURS<bits<4> op, string asmname, list<dag> pattern>
  : InstORR<3, 0x3e, op, (outs GPR32:$R2), (ins SR:$R1), asmname # "\t$R2, $R1", pattern>;

// Unsized sink instructions

// Unsized, Sink, Reg, Reg, Imm8
class InstUSRMRI8<bits<4> op, string asmname, list<dag> pattern>
  : InstORMRI8<3, 1, op, (outs), (ins memri2:$MRI8, GPR32:$R2), asmname # "\t$MRI8, $R2", pattern>;

// Unsized, Sink, Reg, Imm8
class InstUSRI8<bits<4> op, string asmname, list<dag> pattern>
  : InstORI8<3, 0x32, op, (outs), (ins imm32zx8:$I8, GPR32:$R1), asmname # "\t$I8, $R1", pattern>;

// Unsized, Sink, Reg
class InstUSR<bits<4> op, string asmname, list<dag> pattern>
  : InstOR<3, 0x39, op, (outs), (ins GPR32:$R1), asmname # "\t$R1", pattern>;

// Unsized, Sink, Reg, Reg
class InstUSRR<bits<4> op, string asmname, list<dag> pattern>
  : InstORR<3, 0x3a, op, (outs), (ins GPR32:$R1, GPR32:$R2), asmname # "\t$R1, $R2", pattern>;

// Unsized, Sink, Reg, Reg
class InstURSRR<bits<4> op, string asmname, list<dag> pattern>
  : InstORR<3, 0x3a, op, (outs), (ins GPR32:$R1, GPR32:$R2), asmname # "\t$R2, $R1", pattern>;

// Unsized, Def, Reg
class InstUDR<bits<4> op, string asmname, list<dag> pattern>
  : InstOR<3, 0x3c, op, (outs GPR32:$R1), (ins), asmname # "\t$R1", pattern>;

// Unsized, Store, Reg, Reg
class InstUSRMR<bits<4> op, string asmname, list<dag> pattern>
  : InstORMR<3, 0x3a, op, (outs), (ins memr:$MR, GPR32:$R2), asmname # "\t$MR, $R2", pattern>;

// Unsized misc

// Unsized, Jump Relative, Imm8
class InstUJRI8<bits<8> op, string asmname, list<dag> pattern>
  : InstOI8<0xf4, op, (outs), (ins pcrel8:$I8), asmname # "\t$I8", pattern>,
    FalconRelaxInst<asmname, "8">;

// Unsized, Jump Relative, Imm16
class InstUJRI16<bits<8> op, string asmname, list<dag> pattern>
  : InstOI16<0xf5, op, (outs), (ins pcrel16:$I16), asmname # "\t$I16", pattern>,
    FalconRelaxInst<asmname, "16">;

// Unsized, Jump Relative, Imm8
class InstUJRFI8<bits<4> op, string asmname, list<dag> pattern>
  : InstOFI8<0xf4, op, (outs), (ins PRED:$F, pcrel8:$I8), asmname # "\t$F, $I8", pattern>,
    FalconRelaxInst<asmname, "8">;

// Unsized, Jump Relative, Imm16
class InstUJRFI16<bits<4> op, string asmname, list<dag> pattern>
  : InstOFI16<0xf5, op, (outs), (ins PRED:$F, pcrel16:$I16), asmname # "\t$F, $I16", pattern>,
    FalconRelaxInst<asmname, "16">;

// Unsized, Sink, Imm8
class InstUSI8<bits<8> op, Immediate mimm8, string asmname, list<dag> pattern>
  : InstOI8<0xf4, op, (outs), (ins mimm8:$I8), asmname # "\t$I8", pattern>,
    FalconRelaxInst<asmname # "i", "8">;

// Unsized, Sink, Imm16
class InstUSI16<bits<8> op, Immediate mimm16, string asmname, list<dag> pattern>
  : InstOI16<0xf5, op, (outs), (ins mimm16:$I16), asmname # "\t$I16", pattern>,
    FalconRelaxInst<asmname # "i", "16">;

// Unsized, Misc
class InstUM<bits<8> op, string asmname, list<dag> pattern>
  : InstO<0xf8, op, (outs), (ins), asmname, pattern>;
