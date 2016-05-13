//===-- FalconRegisterInfo.td - Falcon Register defs -------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the Falcon register file
//===----------------------------------------------------------------------===//

class FalconReg<string n> : Register<n> {
  let Namespace = "Falcon";
}

class FalconRegWithSubregs<string n, list<Register> subregs> : RegisterWithSubRegs<n, subregs> {
  let Namespace = "Falcon";
}

class FalconSubRegIndex<int size, int start> : SubRegIndex<size, start> {
  let Namespace = "Falcon";
}

def subreg_b : FalconSubRegIndex<8, 0>;
def subreg_w : FalconSubRegIndex<16, 0>;

// GPRs
class GPR8<bits<16> Enc, string n> : FalconReg<n> {
  let HWEncoding = Enc;
}

class GPR16<bits<16> Enc, string n, GPR8 lo> : FalconRegWithSubregs<n, [lo]> {
  let HWEncoding = Enc;
  let SubRegIndices = [subreg_b];
}

class GPR32<bits<16> Enc, string n, GPR16 lo> : FalconRegWithSubregs<n, [lo]> {
  let HWEncoding = Enc;
  let SubRegIndices = [subreg_w];
}

foreach I = 0-15 in {
  def R#I#B : GPR8<I, "r"#I#"b">;
  def R#I#H : GPR16<I, "r"#I#"h", !cast<GPR8>("R"#I#"B")>;
  def R#I : GPR32<I, "r"#I, !cast<GPR16>("R"#I#"H")>;
}

def GPR8 : RegisterClass<"Falcon", [i8], 8, (add (sequence "R%uB", 0, 15))>;
def GPR16 : RegisterClass<"Falcon", [i16], 16, (add (sequence "R%uH", 0, 15))>;
def GPR32 : RegisterClass<"Falcon", [i32], 32, (add (sequence "R%u", 0, 15))>;

// SRs
class SR<bits<16> Enc, string n> : FalconReg<n> {
  let HWEncoding = Enc;
}

def IV0 : SR<0, "iv0">, DwarfRegNum<[0x10]>;
def IV1 : SR<1, "iv1">, DwarfRegNum<[0x11]>;
def TV : SR<3, "tv">, DwarfRegNum<[0x13]>;
def SP : SR<4, "sp">, DwarfRegNum<[0x14]>;
def PC : SR<5, "pc">, DwarfRegNum<[0x15]>;
def XCBASE : SR<6, "xcbase">, DwarfRegNum<[0x16]>;
def XDBASE : SR<7, "xdbase">, DwarfRegNum<[0x17]>;
// FLAGS defined later
// XXX features
def CX : SR<9, "cx">, DwarfRegNum<[0x19]>;
def CAUTH : SR<0xa, "cauth">, DwarfRegNum<[0x1a]>;
// XXX subregs?
def XPORTS : SR<0xb, "xports">, DwarfRegNum<[0x1b]>;
// XXX features
def TSTAT : SR<0xc, "tstat">, DwarfRegNum<[0x1c]>;

class FLAG<bits<16> Enc, string n> : FalconReg<n> {
  let HWEncoding = Enc;
}

foreach I = 0-7 in {
  def P#I : FLAG<I, "p"#I>;
  def subreg_fl_p#I : FalconSubRegIndex<1, I>;
}

def PRED : RegisterClass<"Falcon", [i1], 1, (add (sequence "P%u", 0, 7))>;

def CC_C : FLAG<8, "ccc">;
def CC_O : FLAG<9, "cco">;
def CC_S : FLAG<10, "ccs">;
def CC_Z : FLAG<11, "ccz">;
def subreg_fl_cc_c : FalconSubRegIndex<1, 8>;
def subreg_fl_cc_o : FalconSubRegIndex<1, 9>;
def subreg_fl_cc_s : FalconSubRegIndex<1, 10>;
def subreg_fl_cc_z : FalconSubRegIndex<1, 11>;

// XXX: Falcon v4 has more
def IE0 : FLAG<16, "ie0">;
def IE1 : FLAG<17, "ie1">;
def SIE0 : FLAG<20, "sie0">;
def SIE1 : FLAG<21, "sie1">;
def TA : FLAG<24, "ta">;
def subreg_fl_ie0 : FalconSubRegIndex<1, 16>;
def subreg_fl_ie1 : FalconSubRegIndex<1, 17>;
def subreg_fl_sie0 : FalconSubRegIndex<1, 20>;
def subreg_fl_sie1 : FalconSubRegIndex<1, 21>;
def subreg_fl_ta : FalconSubRegIndex<1, 24>;

// XXX prettify
def FLAG: RegisterClass<"Falcon", [i1], 1, (add P0, P1, P2, P3, P4, P5, P6, P7, CC_C, CC_O, CC_S, CC_Z, IE0, IE1, SIE0, SIE1, TA)>;

let HWEncoding = 8, SubRegIndices = [
  subreg_fl_p0,
  subreg_fl_p1,
  subreg_fl_p2,
  subreg_fl_p3,
  subreg_fl_p4,
  subreg_fl_p5,
  subreg_fl_p6,
  subreg_fl_p7,
  subreg_fl_cc_c,
  subreg_fl_cc_o,
  subreg_fl_cc_s,
  subreg_fl_cc_z,
  subreg_fl_ie0,
  subreg_fl_ie1,
  subreg_fl_sie0,
  subreg_fl_sie1,
  subreg_fl_ta
] in
  def FLAGS : FalconRegWithSubregs<"flags", [P0, P1, P2, P3, P4, P5, P6, P7, CC_C, CC_O, CC_S, CC_Z, IE0, IE1, SIE0, SIE1, TA]>, DwarfRegNum<[0x18]>;

def SR : RegisterClass<"Falcon", [i32], 32, (add IV0, IV1, TV, SP, PC, XDBASE, XCBASE, FLAGS, CX, CAUTH, XPORTS, TSTAT)>;
