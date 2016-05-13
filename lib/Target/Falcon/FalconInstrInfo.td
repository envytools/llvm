//===-- FalconInstrInfo.td - Target Description for Falcon Target ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the Falcon instructions in TableGen format.
//
//===----------------------------------------------------------------------===//

include "FalconOperands.td"
include "FalconOperators.td"
include "FalconInstrFormats.td"

// Conditional code predicates - used for pattern matching for jump instructions
// XXX

// Sized instructions.

multiclass InstSB_COSZ_8<
  string name,
  SDNode pat,
  bits<2> mode,
  bits<4> op2,
  RegisterClass GPR,
  Immediate uimm8,
  bit isCommutable = 0
> {
  let Defs = [CC_C, CC_O, CC_S, CC_Z] in {
    def NAME # "rri8" :
      InstSBRRI8<mode, op2, GPR, uimm8, name, []>,
      FalconThreeInst<NAME # "ri8", "3">;

    let isConvertibleToThreeAddress = 1 in
      def NAME # "ri8" :
        InstSBRI8<mode, op2, GPR, uimm8, name,
          [(set GPR:$R2, (pat GPR:$R1, uimm8:$I8))]>,
        FalconThreeInst<NAME # "ri8", "2">;

    def NAME # "rrr" :
      InstSBRRR<mode, op2, GPR, name, []>,
      FalconThreeInst<NAME # "rr", "3">;

    let isCommutable = isCommutable, isConvertibleToThreeAddress = 1 in
      def NAME # "rr" :
        InstSBRR<mode, op2, GPR, name,
          [(set GPR:$R3, (pat GPR:$R1, GPR:$R2))]>,
        FalconThreeInst<NAME # "rr", "2">;
  }
}

multiclass InstSB_COSZ<
  string name,
  SDNode pat,
  bits<2> mode,
  bits<4> op2,
  RegisterClass GPR,
  Immediate uimm8,
  Immediate uimm16,
  bit isCommutable = 0
> {
  defm NAME : InstSB_COSZ_8<name, pat, mode, op2, GPR, uimm8, isCommutable>;

  let Defs = [CC_C, CC_O, CC_S, CC_Z] in {
    def NAME # "rri16" :
      InstSBRRI16<mode, op2, GPR, uimm16, name, []>,
      FalconThreeInst<NAME # "ri16", "3">;

    let isConvertibleToThreeAddress = 1 in
    def NAME # "ri16" :
      InstSBRI16<mode, op2, GPR, uimm16, name,
        [(set GPR:$R2, (pat GPR:$R1, uimm16:$I16))]>,
      FalconThreeInst<NAME # "ri16", "2">;
  }
}

multiclass InstSB_COSZ_Carry_8<
  string name,
  SDNode pat,
  bits<2> mode,
  bits<4> op2,
  RegisterClass GPR,
  Immediate uimm8,
  bit isCommutable = 0
> {
  let Defs = [CC_C, CC_O, CC_S, CC_Z], Uses = [CC_C] in {
    def NAME # "rri8" :
      InstSBRRI8<mode, op2, GPR, uimm8, name, []>,
      FalconThreeInst<NAME # "ri", "3">;

    let isConvertibleToThreeAddress = 1 in
      def NAME # "ri8" :
        InstSBRI8<mode, op2, GPR, uimm8, name,
          [(set GPR:$R2, (pat GPR:$R1, uimm8:$I8))]>,
        FalconThreeInst<NAME # "ri", "2">;

    def NAME # "rrr" :
      InstSBRRR<mode, op2, GPR, name, []>,
      FalconThreeInst<NAME # "rr", "3">;

    let isCommutable = isCommutable, isConvertibleToThreeAddress = 1 in
      def NAME # "rr" :
        InstSBRR<mode, op2, GPR, name,
          [(set GPR:$R3, (pat GPR:$R1, GPR:$R2))]>,
        FalconThreeInst<NAME # "rr", "2">;
  }
}

multiclass InstSB_COSZ_Carry<
  string name,
  SDNode pat,
  bits<2> mode,
  bits<4> op2,
  RegisterClass GPR,
  Immediate uimm8,
  Immediate uimm16,
  bit isCommutable = 0
> {
  defm NAME : InstSB_COSZ_Carry_8<name, pat, mode, op2, GPR, uimm8, isCommutable>;

  let Defs = [CC_C, CC_O, CC_S, CC_Z], Uses = [CC_C] in {
    def NAME # "rri16" :
      InstSBRRI16<mode, op2, GPR, uimm16, name, []>,
      FalconThreeInst<NAME # "ri16", "3">;

    let isConvertibleToThreeAddress = 1 in
    def NAME # "ri16" :
      InstSBRI16<mode, op2, GPR, uimm16, name,
        [(set GPR:$R2, (pat GPR:$R1, uimm16:$I16))]>,
      FalconThreeInst<NAME # "ri16", "2">;
  }
}

multiclass InstSU_OSZ<
  string name,
  SDNode pat,
  bits<2> mode,
  bits<4> op2,
  RegisterClass GPR
> {
  let Defs = [CC_O, CC_S, CC_Z] in {
    def NAME # "rr" : InstSURR<mode, op2, GPR, name, []>,
      FalconThreeInst<NAME # "r", "3">;

    let isConvertibleToThreeAddress = 1 in
    def NAME # "r" : InstSUR<mode, op2, GPR, name,
      [(set GPR:$R2, (pat GPR:$R1))]>,
      FalconThreeInst<NAME # "r", "2">;
  }
}

multiclass InstSized<
  bits<2> mode,
  ValueType vt,
  RegisterClass GPR,
  Immediate uimm8x,
  Immediate uimm16,
  Immediate simm8x,
  Immediate simm16,
  Immediate uimm8,
  Operand memri,
  ComplexPattern memrinz,
  ComplexPattern memrrx,
  Operand memspi
> {

  // Instructions - compares

  let Defs = [CC_C, CC_Z] in {
    def CMPU # NAME # ri8 : InstSCRI8<mode, 0x4, GPR, uimm8x, "cmpu",
      [(cmpu_cz GPR:$R1, uimm8x:$I8)]>;
    def CMPU # NAME # ri16 : InstSCRI16<mode, 0x4, GPR, uimm16, "cmpu",
      [(cmpu_cz GPR:$R1, uimm16:$I16)]>;
    def CMPU # NAME # rr : InstSCRR<mode, 0x4, GPR, "cmpu",
      [(cmpu_cz GPR:$R1, GPR:$R2)]>;

    def CMPS # NAME # ri8 : InstSCRI8<mode, 0x5, GPR, simm8x, "cmps",
      [(cmps_cz GPR:$R1, simm8x:$I8)]>;
    def CMPS # NAME # ri16 : InstSCRI16<mode, 0x5, GPR, simm16, "cmps",
      [(cmps_cz GPR:$R1, simm16:$I16)]>;
    def CMPS # NAME # rr : InstSCRR<mode, 0x5, GPR, "cmps",
      [(cmps_cz GPR:$R1, GPR:$R2)]>;
  }

  let Defs = [CC_C, CC_O, CC_S, CC_Z] in {
    def CMP # NAME # ri8 : InstSCRI8<mode, 0x6, GPR, simm8x, "cmp",
      [(cmp_cosz GPR:$R1, simm8x:$I8)]>;
    def CMP # NAME # ri16 : InstSCRI16<mode, 0x6, GPR, simm16, "cmp",
      [(cmp_cosz GPR:$R1, simm16:$I16)]>;
    def CMP # NAME # rr : InstSCRR<mode, 0x6, GPR, "cmp",
      [(cmp_cosz GPR:$R1, GPR:$R2)]>;
  }

  // Instructions - sized binary

  defm ADD # NAME : InstSB_COSZ<"add", add_cosz, mode, 0x0, GPR, uimm8x, uimm16, 1>;
  defm ADC # NAME : InstSB_COSZ_Carry<"adc", adc_cosz, mode, 0x1, GPR, uimm8x, uimm16, 1>;
  defm SUB # NAME : InstSB_COSZ<"sub", sub_cosz, mode, 0x2, GPR, uimm8x, uimm16>;
  defm SBB # NAME : InstSB_COSZ_Carry<"sbb", sbb_cosz, mode, 0x3, GPR, uimm8x, uimm16>;
  defm SHL # NAME : InstSB_COSZ_8<"shl", shl_cosz, mode, 0x4, GPR, uimm8>;
  defm SHR # NAME : InstSB_COSZ_8<"shr", shr_cosz, mode, 0x5, GPR, uimm8>;
  defm SAR # NAME : InstSB_COSZ_8<"sar", sar_cosz, mode, 0x7, GPR, uimm8>;
  defm SHLC # NAME : InstSB_COSZ_Carry_8<"shlc", shlc_cosz, mode, 0xc, GPR, uimm8>;
  defm SHRC # NAME : InstSB_COSZ_Carry_8<"shrc", shrc_cosz, mode, 0xd, GPR, uimm8>;

  def : Pat<(add GPR:$s1, GPR:$s2), (!cast<PatFrag>("ADD" # NAME # "rr") GPR:$s1, GPR:$s2)>;
  def : Pat<(add GPR:$s1, uimm8x:$s2), (!cast<PatFrag>("ADD" # NAME # "ri8") GPR:$s1, uimm8x:$s2)>;
  def : Pat<(add GPR:$s1, uimm16:$s2), (!cast<PatFrag>("ADD" # NAME # "ri16") GPR:$s1, uimm16:$s2)>;
  def : Pat<(addc GPR:$s1, GPR:$s2), (!cast<PatFrag>("ADD" # NAME # "rr") GPR:$s1, GPR:$s2)>;
  def : Pat<(addc GPR:$s1, uimm8x:$s2), (!cast<PatFrag>("ADD" # NAME # "ri8") GPR:$s1, uimm8x:$s2)>;
  def : Pat<(addc GPR:$s1, uimm16:$s2), (!cast<PatFrag>("ADD" # NAME # "ri16") GPR:$s1, uimm16:$s2)>;
  def : Pat<(adde GPR:$s1, GPR:$s2), (!cast<PatFrag>("ADC" # NAME # "rr") GPR:$s1, GPR:$s2)>;
  def : Pat<(adde GPR:$s1, uimm8x:$s2), (!cast<PatFrag>("ADC" # NAME # "ri8") GPR:$s1, uimm8x:$s2)>;
  def : Pat<(adde GPR:$s1, uimm16:$s2), (!cast<PatFrag>("ADC" # NAME # "ri16") GPR:$s1, uimm16:$s2)>;
  def : Pat<(sub GPR:$s1, GPR:$s2), (!cast<PatFrag>("SUB" # NAME # "rr") GPR:$s1, GPR:$s2)>;
  // XXX these patterns are wrong
  def : Pat<(sub GPR:$s1, uimm8x:$s2), (!cast<PatFrag>("SUB" # NAME # "ri8") GPR:$s1, uimm8x:$s2)>;
  def : Pat<(sub GPR:$s1, uimm16:$s2), (!cast<PatFrag>("SUB" # NAME # "ri16") GPR:$s1, uimm16:$s2)>;
  def : Pat<(shl GPR:$s1, GPR:$s2), (!cast<PatFrag>("SHL" # NAME # "rr") GPR:$s1, GPR:$s2)>;
  def : Pat<(shl GPR:$s1, uimm8:$s2), (!cast<PatFrag>("SHL" # NAME # "ri8") GPR:$s1, uimm8:$s2)>;
  def : Pat<(srl GPR:$s1, GPR:$s2), (!cast<PatFrag>("SHR" # NAME # "rr") GPR:$s1, GPR:$s2)>;
  def : Pat<(srl GPR:$s1, uimm8:$s2), (!cast<PatFrag>("SHR" # NAME # "ri8") GPR:$s1, uimm8:$s2)>;
  def : Pat<(sra GPR:$s1, GPR:$s2), (!cast<PatFrag>("SAR" # NAME # "rr") GPR:$s1, GPR:$s2)>;
  def : Pat<(sra GPR:$s1, uimm8:$s2), (!cast<PatFrag>("SAR" # NAME # "ri8") GPR:$s1, uimm8:$s2)>;

  // Instructions - sized unary
  defm NOT # NAME : InstSU_OSZ<"not", not_osz, mode, 0x0, GPR>;
  defm NEG # NAME : InstSU_OSZ<"neg", neg_osz, mode, 0x1, GPR>;
  defm HSWAP # NAME : InstSU_OSZ<"hswap", hswap_osz, mode, 0x3, GPR>;
  def MOV # NAME # rr : InstSURR<mode, 0x2, GPR, "mov", []>;
  def MOV # NAME # r : InstSUR<mode, 0x2, GPR, "mov", []>;

  def CLR # NAME # r : InstSZR<mode, 0x4, GPR, "clr",
    [(set GPR:$R1, 0)]>;
  let Defs = [CC_O, CC_S, CC_Z] in
    def TST # NAME # r : InstSTR<mode, 0x5, GPR, "tst",
      [(tst_osz GPR:$R1)]>;

  def : Pat<(not GPR:$s), (!cast<PatFrag>("NOT" # NAME # "r") GPR:$s)>;
  def : Pat<(ineg GPR:$s), (!cast<PatFrag>("NEG" # NAME # "r") GPR:$s)>;

  // Instructions - sized loads and stores
  // XXX pat
  def LD # NAME # rmrr : InstSLRMRR<mode, 0x8, GPR, "ld",
    [(set GPR:$R3, (load memrrx:$MRR))]>;
  def LD # NAME # rmri8 : InstSLRMRI8<mode, 0x8, GPR, memri, "ld",
    [(set GPR:$R2, (load memri:$MRI8))]>;
  def LD # NAME # rmspr : InstSLRMSPR<mode, 0x0, GPR, "ld", []>;
  def LD # NAME # rmspi8 : InstSLRMSPI8<mode, 0x0, GPR, memspi, "ld", []>;
  def ST # NAME # rmr : InstSSRMR<mode, 0x0, GPR, "st",
    [(store GPR:$R2, memr:$MR)]>;
  def ST # NAME # rmri8 : InstSSRMRI8<mode, 0x0, GPR, memri, "st",
    [(store GPR:$R2, memrinz:$MRI8)]>;
  def ST # NAME # rmspr : InstSSRMSPR<mode, 0x1, GPR, "st", []>;
  def ST # NAME # rmspi8 : InstSSRMSPI8<mode, 0x1, GPR, memspi, "st", []>;
}

defm b : InstSized<0, i8, GPR8, imm8, imm8x16, simm8, simm8x16, imm8, memri0, memrinz0, memrr0, memspi0>;
defm h : InstSized<1, i16, GPR16, imm16zx8x, imm16, imm16sx8x, simm16, imm16zx8, memri1, memrinz1, memrr1, memspi1>;
defm w : InstSized<2, i32, GPR32, imm32zx8x, imm32zx16, imm32sx8x, imm32sx16, imm32zx8, memri2, memrinz2, memrr2, memspi2>;

// Instructions - Unsized binary

multiclass InstUB<
  string name,
  SDNode pat,
  bits<4> op2,
  Immediate mimm8,
  Immediate mimm16,
  bit isCommutable = 0
> {
  def NAME # "rri8" :
    InstUBRRI8<op2, mimm8, name, []>,
    FalconThreeInst<name # "ri8", "3">;

  let isConvertibleToThreeAddress = 1 in
    def NAME # "ri8" :
      InstUBRI8<op2, mimm8, name,
        [(set GPR32:$R2, (pat GPR32:$R1, mimm8:$I8))]>,
      FalconThreeInst<name # "ri8", "2">;

  def NAME # "rrr" :
    InstUBRRR<op2, name, []>,
    FalconThreeInst<name # "rr", "3">;

  let isCommutable = isCommutable, isConvertibleToThreeAddress = 1 in
    def NAME # "rr" :
      InstUBRR<op2, name,
        [(set GPR32:$R3, (pat GPR32:$R1, GPR32:$R2))]>,
      FalconThreeInst<name # "rr", "2">;

  def NAME # "rri16" :
    InstUBRRI16<op2, mimm16, name, []>,
    FalconThreeInst<name # "ri16", "3">;

  let isConvertibleToThreeAddress = 1 in
  def NAME # "ri16" :
    InstUBRI16<op2, mimm16, name,
      [(set GPR32:$R2, (pat GPR32:$R1, mimm16:$I16))]>,
    FalconThreeInst<name # "ri16", "2">;
}

defm MULU : InstUB<"mulu", mulu, 0x0, imm32zx8x, imm32zx16, 1>;
defm MULS : InstUB<"muls", muls, 0x1, imm32sx8x, imm32sx16, 1>;
let Defs = [CC_C, CC_O, CC_S, CC_Z] in {
  defm AND : InstUB<"and", and_cosz, 0x4, imm32zx8x, imm32zx16, 1>;
  defm OR : InstUB<"or", or_cosz, 0x5, imm32zx8x, imm32zx16, 1>;
  defm XOR : InstUB<"xor", xor_cosz, 0x6, imm32zx8x, imm32zx16, 1>;
}

def : Pat<(and GPR32:$s1, GPR32:$s2), (ANDrr GPR32:$s1, GPR32:$s2)>;
def : Pat<(and GPR32:$s1, imm32zx8x:$s2), (ANDri8 GPR32:$s1, imm32zx8x:$s2)>;
def : Pat<(and GPR32:$s1, imm32zx16:$s2), (ANDri16 GPR32:$s1, imm32zx16:$s2)>;
def : Pat<(or GPR32:$s1, GPR32:$s2), (ORrr GPR32:$s1, GPR32:$s2)>;
def : Pat<(or GPR32:$s1, imm32zx8x:$s2), (ORri8 GPR32:$s1, imm32zx8x:$s2)>;
def : Pat<(or GPR32:$s1, imm32zx16:$s2), (ORri16 GPR32:$s1, imm32zx16:$s2)>;
def : Pat<(xor GPR32:$s1, GPR32:$s2), (XORrr GPR32:$s1, GPR32:$s2)>;
def : Pat<(xor GPR32:$s1, imm32zx8x:$s2), (XORri8 GPR32:$s1, imm32zx8x:$s2)>;
def : Pat<(xor GPR32:$s1, imm32zx16:$s2), (XORri16 GPR32:$s1, imm32zx16:$s2)>;

let Defs = [CC_S, CC_Z] in {
  def SEXTrri8 : InstUBRRI8<0x2, imm32zx8, "sext", []>,
    FalconThreeInst<"sextri8", "3">;
  def SEXTrrr : InstUBRRR<0x2, "sext", []>,
    FalconThreeInst<"sextrr", "3">;
  let isConvertibleToThreeAddress = 1 in {
    def SEXTri8 : InstUBRI8<0x2, imm32zx8, "sext",
        [(set GPR32:$R2, (sext_sz GPR32:$R1, imm32zx8:$I8))]>,
      FalconThreeInst<"sextri8", "2">;
    def SEXTrr : InstUBRR<0x2, "sext",
        [(set GPR32:$R3, (sext_sz GPR32:$R1, GPR32:$R2))]>,
      FalconThreeInst<"sextrr", "2">;
  }

  def EXTRSrri8 : InstUBRRI8<0x3, imm32zx8x, "extrs",
      [(set GPR32:$R2, (extrs_sz GPR32:$R1, imm32zx8x:$I8))]>;
  def EXTRSrri16 : InstUBRRI16<0x3, imm32zx16, "extrs",
      [(set GPR32:$R2, (extrs_sz GPR32:$R1, imm32zx16:$I16))]>;
  def EXTRSrrr : InstUBRRR<0x3, "extrs",
      [(set GPR32:$R3, (extrs_sz GPR32:$R1, GPR32:$R2))]>;

  def EXTRrri8 : InstUBRRI8<0x7, imm32zx8x, "extr",
      [(set GPR32:$R2, (extr_sz GPR32:$R1, imm32zx8x:$I8))]>;
  def EXTRrri16 : InstUBRRI16<0x7, imm32zx16, "extr",
      [(set GPR32:$R2, (extr_sz GPR32:$R1, imm32zx16:$I16))]>;
  def EXTRrrr : InstUBRRR<0x7, "extr",
      [(set GPR32:$R3, (extr_sz GPR32:$R1, GPR32:$R2))]>;

  def GETBrri8 : InstUBRRI8<0x8, imm32zx8, "getb",
      [(set GPR32:$R2, (getb_sz GPR32:$R1, imm32zx8:$I8))]>;
  def GETBrrr : InstUBRRR<0x8, "getb",
      [(set GPR32:$R3, (getb_sz GPR32:$R1, GPR32:$R2))]>;
}

def INSrri8 : InstUTRRI8<0xb, "ins",
      [(set GPR32:$R3, (insrt GPR32:$R1, GPR32:$R2, imm32zx8x:$I8))]>;
def INSrri16 : InstUTRRI16<0xb, "ins",
      [(set GPR32:$R3, (insrt GPR32:$R1, GPR32:$R2, imm32zx16:$I16))]>;

def SETBri8 : InstUBRI8<0x9, imm32zx8, "setb",
    [(set GPR32:$R2, (setb GPR32:$R1, imm32zx8:$I8))]>;
def SETBrr : InstUBRR<0x9, "setb",
    [(set GPR32:$R3, (setb GPR32:$R1, GPR32:$R2))]>;
def CLRBri8 : InstUBRI8<0xa, imm32zx8, "clrb",
    [(set GPR32:$R2, (clrb GPR32:$R1, imm32zx8:$I8))]>;
def CLRBrr : InstUBRR<0xa, "clrb",
    [(set GPR32:$R3, (clrb GPR32:$R1, GPR32:$R2))]>;
def TGLBri8 : InstUBRI8<0xb, imm32zx8, "tglb",
    [(set GPR32:$R2, (tglb GPR32:$R1, imm32zx8:$I8))]>;
def TGLBrr : InstUBRR<0xb, "tglb",
    [(set GPR32:$R3, (tglb GPR32:$R1, GPR32:$R2))]>;

def DIVrri8 : InstUBRRI8<0xc, imm32zx8x, "div", [(set GPR32:$R2, (udiv GPR32:$R1, imm32zx8x:$I8))]>;
def DIVrri16 : InstUBRRI16<0xc, imm32zx16, "div", [(set GPR32:$R2, (udiv GPR32:$R1, imm32zx16:$I16))]>;
def DIVrrr : InstUBRRR<0xc, "div", [(set GPR32:$R3, (udiv GPR32:$R1, GPR32:$R2))]>;
def MODrri8 : InstUBRRI8<0xd, imm32zx8x, "mod", [(set GPR32:$R2, (urem GPR32:$R1, imm32zx8x:$I8))]>;
def MODrri16 : InstUBRRI16<0xd, imm32zx16, "mod", [(set GPR32:$R2, (urem GPR32:$R1, imm32zx16:$I16))]>;
def MODrrr : InstUBRRR<0xd, "mod", [(set GPR32:$R3, (urem GPR32:$R1, GPR32:$R2))]>;

// XXX what is hasCtrlDep?
let isReturn = 1, isTerminator = 1, isBarrier = 1, hasCtrlDep = 1 in {
  def RET : InstUM<0x00, "ret", [(retflag)]>;
  def IRET : InstUM<0x01, "iret", [(iret)]>;
}

let isTerminator = 1, isBarrier = 1, hasCtrlDep = 1 in
  def HLT : InstUM<0x02, "hlt", [(int_falcon_hlt)]>;

// XXX attrs for these...
def XDWAIT : InstUM<0x03, "xdwait", [(int_falcon_xdwait)]>;
def XDBAR : InstUM<0x06, "xdbar", [(int_falcon_xdbar)]>;
def XCWAIT : InstUM<0x07, "xcwait", [(int_falcon_xcwait)]>;
// No intrinsics for those - we treat them as syscalls.
let isCall = 1 in {
  def TRAP0 : InstUM<0x08, "trap\t0", []>;
  def TRAP1 : InstUM<0x09, "trap\t1", []>;
  def TRAP2 : InstUM<0x0a, "trap\t2", []>;
  def TRAP3 : InstUM<0x0b, "trap\t3", []>;
}

// XXX patterns for these?
let Defs = [SP], Uses = [SP] in {
  def POPr : InstUDR<0x0, "pop", []>;
  def PUSHr : InstUSR<0x0, "push", []>;
  def ADDSPr : InstUSR<0x1, "addsp", []>;
  def ADDSPi8 : InstUSI8<0x30, imm32sx8x, "addsp", []>;
  def ADDSPi16 : InstUSI16<0x30, imm32sx16, "addsp", []>;
}
let isBranch = 1, isIndirectBranch = 1, isTerminator = 1, isBarrier = 1, hasCtrlDep = 1 in {
  def JMPr : InstUSR<0x4, "jmp", [(brind GPR32:$R1)]>;
}
// XXX wrong
let isReturn = 1, isCall = 1, isTerminator = 1, isBarrier = 1, hasCtrlDep = 1 in {
  def JMPi8 : InstUSI8<0x20, imm32zx8x, "jmp", []>;
  // XXX ext to 24
  def JMPi16 : InstUSI16<0x20, imm32zx16, "jmp", []>;
}
// XXX wrong
let isCall = 1 in {
  def CALLr : InstUSR<0x5, "call", [(call GPR32:$R1)]>;
  def CALLi8 : InstUSI8<0x21, imm32zx8x, "call", [(call imm32zx8x:$I8)]>;
  // XXX ext to 24
  def CALLi16 : InstUSI16<0x21, imm32zx16, "call", [(call imm32zx16:$I16)]>;
}
// XXX
def ITLBr : InstUSR<0x8, "itlb", [(int_falcon_itlb GPR32:$R1)]>;

let Defs = [FLAGS], Uses = [FLAGS] in {
  def SETFr : InstUSR<0x9, "setf", []>;
  def CLRFr : InstUSR<0xa, "clrf", []>;
  def TGLFr : InstUSR<0xb, "tglf", []>;
  def PUTFrr : InstURSRR<0x8, "putf", []>;
}
let Defs = [CC_S, CC_Z], Uses = [FLAGS] in {
  def GETFrr : InstUURR<0xc, "getf", []>;
}

def SETFi8 : InstOI8<0xf4, 0x31, (outs FLAG:$I8), (ins), "setf\t$I8", [(set FLAG:$I8, -1)]>;
def CLRFi8 : InstOI8<0xf4, 0x32, (outs FLAG:$I8), (ins), "clrf\t$I8", [(set FLAG:$I8, 0)]>;
let Constraints = "$F = $I8" in
  def TGLFi8 : InstOI8<0xf4, 0x33, (outs FLAG:$F), (ins FLAG:$I8), "tglf\t$I8", [(set FLAG:$F, (not FLAG:$I8))]>;
let Defs = [CC_S, CC_Z] in
  def GETFri8 : InstORI8<3, 0x30, 0xc, (outs GPR32:$R1), (ins FLAG:$I8), "getf\t$R1, $I8", [(set GPR32:$R1, (zext FLAG:$I8))]>;
def PUTFri8 : InstORI8<3, 0x32, 0x8, (outs FLAG:$I8), (ins GPR32:$R1), "putf\t$I8, $R1", [(set FLAG:$I8, (trunc GPR32:$R1))]>;

def WAITi8 : InstOI8<0xf4, 0x28, (outs), (ins FLAG:$I8), "wait\t$I8", []>;

def : Pat<(i32 (anyext FLAG:$val)), (GETFri8 FLAG:$val)>;

// XXX: remaining i1 exts

def PTLBrr : InstUURR<0x2, "ptlb", [(set GPR32:$R2, (int_falcon_ptlb GPR32:$R1))]>;
def VTLBrr : InstUURR<0x3, "vtlb", [(set GPR32:$R2, (int_falcon_vtlb GPR32:$R1))]>;

def XCLDrr : InstUSRR<0x4, "xcld", [(int_falcon_xcld GPR32:$R1, GPR32:$R2)]>;
def XDLDrr : InstUSRR<0x5, "xdld", [(int_falcon_xdld GPR32:$R1, GPR32:$R2)]>;
def XDSTrr : InstUSRR<0x6, "xdst", [(int_falcon_xdst GPR32:$R1, GPR32:$R2)]>;

def R2Srr : InstUUSR<0x0, "mov", []>;
def S2Rrr : InstUURS<0x1, "mov", []>;

def CCri8 : InstUSRI8<0xc, "cc", []>;
def CCi8 : InstUSI8<0x3c, imm32zx8x, "cc", []>;
def CCi16 : InstUSI16<0x3c, imm32zx16, "cc", []>;

// XXX: patterns don't exactly work

def IORDrmri8 : InstULRMRI8<0xf, "iord",
    [(set GPR32:$R2, (int_falcon_iord memri2:$MRI8))]>;
def IORDrmrr : InstULRMRR<0xf, "iord",
    [(set GPR32:$R3, (int_falcon_iord memrr2:$MRR))]>;
def IORDBrmri8 : InstULRMRI8<0xe, "iordb",
    [(set GPR32:$R2, (int_falcon_iordb memri2:$MRI8))]>;
def IORDBrmrr : InstULRMRR<0xe, "iordb",
    [(set GPR32:$R3, (int_falcon_iordb memrr2:$MRR))]>;

def IOWRrmr : InstUSRMR<0x0, "iowr",
  [(int_falcon_iowr memr:$MR, GPR32:$R2)]>;
def IOWRrmri8 : InstUSRMRI8<0x0, "iowr",
  [(int_falcon_iowr memrinz2:$MRI8, GPR32:$R2)]>;
def IOWRBrmr : InstUSRMR<0x1, "iowrb",
  [(int_falcon_iowrb memr:$MR, GPR32:$R2)]>;
def IOWRBrmri8 : InstUSRMRI8<0x1, "iowrb",
  [(int_falcon_iowrb memrinz2:$MRI8, GPR32:$R2)]>;

// XXX: traps

def MOVri8 : InstUURI8<0x7, "mov", [(set GPR32:$R1, imm32sx8x:$I8)]>;
def MOVri16 : InstUURI16<0x7, "mov", [(set GPR32:$R1, imm32sx16:$I16)]>;
let Constraints = "$R2 = $R1" in {
  def SETHIri8 : InstUBRI8<0x3, imm32zx8x, "sethi", [(set GPR32:$R2, (sethi GPR32:$R1, imm32zx8x:$I8))]>;
  def SETHIri16 : InstUBRI16<0x3, imm32zx16, "sethi", [(set GPR32:$R2, (sethi GPR32:$R1, imm32zx16:$I16))]>;
}

let isBranch = 1, isTerminator = 1, isBarrier = 1, hasCtrlDep = 1 in {
  def BRAi8 : InstUJRI8<0x0e, "bra", [(br bb:$I8)]>;
  def BRAi16 : InstUJRI16<0x0e, "bra", [(br bb:$I16)]>;
}

let isBranch = 1, isTerminator = 1, hasCtrlDep = 1 in {
  def BRAFi8 : InstUJRFI8<0x0, "braf", [(braf PRED:$F, bb:$I8)]>;
  def BRAFi16 : InstUJRFI16<0x0, "braf", [(braf PRED:$F, bb:$I16)]>;
  def BRANFi8 : InstUJRFI8<0x1, "branf", [(branf PRED:$F, bb:$I8)]>;
  def BRANFi16 : InstUJRFI16<0x1, "branf", [(branf PRED:$F, bb:$I16)]>;
  let Uses = [CC_C] in {
    def BRACi8 : InstUJRI8<0x08, "brac", [(brac bb:$I8)]>;
    def BRACi16 : InstUJRI16<0x08, "brac", [(brac bb:$I16)]>;
    def BRANCi8 : InstUJRI8<0x18, "branc", [(branc bb:$I8)]>;
    def BRANCi16 : InstUJRI16<0x18, "branc", [(branc bb:$I16)]>;
  }
  let Uses = [CC_O] in {
    def BRAOi8 : InstUJRI8<0x09, "brao", [(brao bb:$I8)]>;
    def BRAOi16 : InstUJRI16<0x09, "brao", [(brao bb:$I16)]>;
    def BRANOi8 : InstUJRI8<0x19, "brano", [(brano bb:$I8)]>;
    def BRANOi16 : InstUJRI16<0x19, "brano", [(brano bb:$I16)]>;
  }
  let Uses = [CC_S] in {
    def BRASi8 : InstUJRI8<0x0a, "bras", [(bras bb:$I8)]>;
    def BRASi16 : InstUJRI16<0x0a, "bras", [(bras bb:$I16)]>;
    def BRANSi8 : InstUJRI8<0x1a, "brans", [(brans bb:$I8)]>;
    def BRANSi16 : InstUJRI16<0x1a, "brans", [(brans bb:$I16)]>;
  }
  let Uses = [CC_Z] in {
    def BRAZi8 : InstUJRI8<0x0b, "braz", [(braz bb:$I8)]>;
    def BRAZi16 : InstUJRI16<0x0b, "braz", [(braz bb:$I16)]>;
    def BRANZi8 : InstUJRI8<0x1b, "branz", [(branz bb:$I8)]>;
    def BRANZi16 : InstUJRI16<0x1b, "branz", [(branz bb:$I16)]>;
  }
  let Uses = [CC_C, CC_Z] in {
    def BRAAi8 : InstUJRI8<0x0c, "braa", [(braa bb:$I8)]>;
    def BRAAi16 : InstUJRI16<0x0c, "braa", [(braa bb:$I16)]>;
    def BRANAi8 : InstUJRI8<0x0d, "brana", [(brana bb:$I8)]>;
    def BRANAi16 : InstUJRI16<0x0d, "brana", [(brana bb:$I16)]>;
  }
  let Uses = [CC_O, CC_S] in {
    def BRAGi8 : InstUJRI8<0x1c, "brag", [(brag bb:$I8)]>;
    def BRAGi16 : InstUJRI16<0x1c, "brag", [(brag bb:$I16)]>;
    def BRALEi8 : InstUJRI8<0x1d, "brale", [(brale bb:$I8)]>;
    def BRALEi16 : InstUJRI16<0x1d, "brale", [(brale bb:$I16)]>;
  }
  let Uses = [CC_O, CC_S, CC_Z] in {
    def BRALi8 : InstUJRI8<0x1e, "bral", [(bral bb:$I8)]>;
    def BRALi16 : InstUJRI16<0x1e, "bral", [(bral bb:$I16)]>;
    def BRAGEi8 : InstUJRI8<0x1f, "brage", [(brage bb:$I8)]>;
    def BRAGEi16 : InstUJRI16<0x1f, "brage", [(brage bb:$I16)]>;
  }
}

// XXX

// Pseudos

let Defs = [SP], Uses = [SP] in {
  def ADJCALLSTACKDOWN : Pseudo<0, (outs), (ins imm32:$amt),
                                "#ADJCALLSTACKDOWN $amt", [(callseq_start timm:$amt)]>;
  def ADJCALLSTACKUP : Pseudo<0, (outs), (ins imm32:$amt, imm32:$amt2),
                                "#ADJCALLSTACKUP $amt $amt2", [(callseq_end timm:$amt, timm:$amt2)]>;
}

// Non-insn patterns

// truncations

def : Pat<(i16 (trunc GPR32:$src)),
           (EXTRACT_SUBREG GPR32:$src, subreg_w)>;
def : Pat<(i8 (trunc GPR16:$src)),
           (EXTRACT_SUBREG GPR16:$src, subreg_b)>;
def : Pat<(i8 (trunc GPR32:$src)),
           (EXTRACT_SUBREG (i16 (EXTRACT_SUBREG GPR32:$src, subreg_w)), subreg_b)>;

// anyext

def : Pat<(i16 (anyext GPR8:$src)),
              (INSERT_SUBREG (i16 (IMPLICIT_DEF)), GPR8:$src, subreg_b)>;
def : Pat<(i32 (anyext GPR16:$src)),
              (INSERT_SUBREG (i32 (IMPLICIT_DEF)), GPR16:$src, subreg_w)>;
def : Pat<(i32 (anyext GPR8:$src)),
              (INSERT_SUBREG (i32 (IMPLICIT_DEF)), (INSERT_SUBREG (i16 (IMPLICIT_DEF)), GPR8:$src, subreg_b), subreg_w)>;

// sethi
def : Pat<(or (and GPR32:$src1, 0xffff), immhi16zx8:$src2), (SETHIri8 GPR32:$src1, (HI16ZX8 immhi16zx8:$src2))>;
def : Pat<(or (and GPR32:$src1, 0xffff), immhi16:$src2), (SETHIri16 GPR32:$src1, (HI16 immhi16:$src2))>;
def : Pat<(and GPR32:$src1, 0xffff), (SETHIri8 GPR32:$src1, 0)>;
def : Pat<(or GPR32:$src1, 0xffff0000), (SETHIri16 GPR32:$src1, 0xffff)>;
def : Pat<(i32 immhi16zx8:$val), (SETHIri8 (CLRwr), (HI16ZX8 imm:$val))>;
def : Pat<(i32 immhi16:$val), (SETHIri16 (CLRwr), (HI16 imm:$val))>;
def : Pat<(i32 imm24lb:$val), (SETHIri8 (MOVri8 (SIMM8 imm:$val)), (HI16ZX8 imm:$val))>;
def : Pat<(i32 imm32lb:$val), (SETHIri16 (MOVri8 (SIMM8 imm:$val)), (HI16 imm:$val))>;
def : Pat<(i32 imm24:$val), (SETHIri8 (MOVri16 (SIMM16 imm:$val)), (HI16ZX8 imm:$val))>;
def : Pat<(i32 imm:$val), (SETHIri16 (MOVri16 (SIMM16 imm:$val)), (HI16 imm:$val))>;

// short consts

def : Pat<(i8 imm8:$val), (EXTRACT_SUBREG (i16 (EXTRACT_SUBREG (MOVri8 (SIMM8 imm:$val)), subreg_w)), subreg_b)>;
def : Pat<(i16 imm16sx8x:$val), (EXTRACT_SUBREG (MOVri8 (SIMM8 imm:$val)), subreg_w)>;
def : Pat<(i16 imm16:$val), (EXTRACT_SUBREG (MOVri16 (SIMM16 imm:$val)), subreg_w)>;

def : Pat<(lo16 tglobaladdr:$sym), (MOVri16 tglobaladdr:$sym)>;
def : Pat<(sethi i32:$base, (hi8 tglobaladdr:$sym)), (SETHIri8 i32:$base, tglobaladdr:$sym)>;

def : Pat<(lo16 tblockaddress:$sym), (MOVri16 tblockaddress:$sym)>;
def : Pat<(sethi i32:$base, (hi8 tblockaddress:$sym)), (SETHIri8 i32:$base, tblockaddress:$sym)>;
