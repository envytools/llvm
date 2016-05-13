//===-- FalconOperators.td - Operator Description for Falcon Target -------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the Falcon operators in TableGen format.
//
//===----------------------------------------------------------------------===//

def SDTSethi : SDTypeProfile<1, 2, [
  SDTCisVT<0, i32>, SDTCisVT<1, i32>, SDTCisVT<2, i32>
]>;

def SDTCmp : SDTypeProfile<0, 2, [
  SDTCisInt<0>,
  SDTCisSameAs<0, 1>
]>;

def SDTUnary : SDTypeProfile<1, 1, [
  SDTCisInt<0>,
  SDTCisSameAs<0, 1>
]>;

def SDTTest : SDTypeProfile<0, 1, [
  SDTCisInt<0>
]>;

def SDTBinary : SDTypeProfile<1, 2, [
  SDTCisInt<0>,
  SDTCisSameAs<0, 1>,
  SDTCisSameAs<0, 2>
]>;

def SDTIns : SDTypeProfile<1, 3, [
  SDTCisInt<0>,
  SDTCisSameAs<0, 1>,
  SDTCisSameAs<0, 2>,
  SDTCisSameAs<0, 3>
]>;

def SDTCallSeqStart : SDCallSeqStart<[SDTCisVT<0, i32>]>;
def SDTCallSeqEnd   : SDCallSeqEnd<[SDTCisVT<0, i32>, SDTCisVT<1, i32>]>;
def SDTCall         : SDTypeProfile<0, -1, [SDTCisVT<0, i32>]>;

def SDTBraf         : SDTypeProfile<0, 2,
                                            [SDTCisVT<0, i1>,
                                             SDTCisVT<1, OtherVT>]>;
def SDTBra         : SDTypeProfile<0, 1, [SDTCisVT<0, OtherVT>]>;
def add_cosz : SDNode<"FalconISD::ADD_COSZ", SDTBinary, [SDNPOutGlue]>;
def sub_cosz : SDNode<"FalconISD::SUB_COSZ", SDTBinary, [SDNPOutGlue]>;
def adc_cosz : SDNode<"FalconISD::ADC_COSZ", SDTBinary, [SDNPOutGlue, SDNPInGlue]>;
def sbb_cosz : SDNode<"FalconISD::SBB_COSZ", SDTBinary, [SDNPOutGlue, SDNPInGlue]>;
def shl_cosz : SDNode<"FalconISD::SHL_COSZ", SDTBinary, [SDNPOutGlue]>;
def shr_cosz : SDNode<"FalconISD::SHR_COSZ", SDTBinary, [SDNPOutGlue]>;
def sar_cosz : SDNode<"FalconISD::SAR_COSZ", SDTBinary, [SDNPOutGlue]>;
def shlc_cosz : SDNode<"FalconISD::SHLC_COSZ", SDTBinary, [SDNPOutGlue, SDNPInGlue]>;
def shrc_cosz : SDNode<"FalconISD::SHRC_COSZ", SDTBinary, [SDNPOutGlue, SDNPInGlue]>;
def not_osz : SDNode<"FalconISD::NOT_OSZ", SDTUnary, [SDNPOutGlue]>;
def neg_osz : SDNode<"FalconISD::NEG_OSZ", SDTUnary, [SDNPOutGlue]>;
def hswap_osz : SDNode<"FalconISD::HSWAP_OSZ", SDTUnary, [SDNPOutGlue]>;
def tst_osz : SDNode<"FalconISD::TST_OSZ", SDTTest, [SDNPOutGlue]>;
def cmp_cosz : SDNode<"FalconISD::CMP_COSZ", SDTCmp, [SDNPOutGlue]>;
def cmps_cz : SDNode<"FalconISD::CMPS_CZ", SDTCmp, [SDNPOutGlue]>;
def cmpu_cz : SDNode<"FalconISD::CMPU_CZ", SDTCmp, [SDNPOutGlue]>;

def sext_sz : SDNode<"FalconISD::SEXT_SZ", SDTBinary, [SDNPOutGlue]>;
def and_cosz : SDNode<"FalconISD::AND_COSZ", SDTBinary, [SDNPOutGlue]>;
def or_cosz : SDNode<"FalconISD::OR_COSZ", SDTBinary, [SDNPOutGlue]>;
def xor_cosz : SDNode<"FalconISD::XOR_COSZ", SDTBinary, [SDNPOutGlue]>;
def mulu : SDNode<"FalconISD::MULU", SDTBinary, []>;
def muls : SDNode<"FalconISD::MULS", SDTBinary, []>;
def extr_sz : SDNode<"FalconISD::EXTR_SZ", SDTBinary, [SDNPOutGlue]>;
def extrs_sz : SDNode<"FalconISD::EXTRS_SZ", SDTBinary, [SDNPOutGlue]>;
def getb_sz : SDNode<"FalconISD::GETB_SZ", SDTBinary, [SDNPOutGlue]>;
def insrt : SDNode<"FalconISD::INS", SDTIns, []>;
def clrb : SDNode<"FalconISD::CLRB", SDTBinary, []>;
def setb : SDNode<"FalconISD::SETB", SDTBinary, []>;
def tglb : SDNode<"FalconISD::TGLB", SDTBinary, []>;

def sethi : SDNode<"FalconISD::SETHI", SDTSethi>;
def retflag : SDNode<"FalconISD::RET_FLAG", SDTNone,
                     [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;
def iret : SDNode<"FalconISD::IRET", SDTNone,
                     [SDNPHasChain, SDNPOptInGlue]>;
def call : SDNode<"FalconISD::CALL", SDTCall,
                             [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue,
                              SDNPVariadic]>;
def callseq_start: SDNode<"ISD::CALLSEQ_START", SDTCallSeqStart,
                             [SDNPHasChain, SDNPOutGlue]>;
def callseq_end  : SDNode<"ISD::CALLSEQ_END",   SDTCallSeqEnd,
                             [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

def braf : SDNode<"FalconISD::BRAF", SDTBraf, [SDNPHasChain]>;
def branf : SDNode<"FalconISD::BRANF", SDTBraf, [SDNPHasChain]>;
def brac : SDNode<"FalconISD::BRAC", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def branc : SDNode<"FalconISD::BRANC", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def brao : SDNode<"FalconISD::BRAO", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def brano : SDNode<"FalconISD::BRANO", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def bras : SDNode<"FalconISD::BRAS", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def brans : SDNode<"FalconISD::BRANS", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def braz : SDNode<"FalconISD::BRAZ", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def branz : SDNode<"FalconISD::BRANZ", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def braa : SDNode<"FalconISD::BRAA", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def brana : SDNode<"FalconISD::BRANA", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def bral : SDNode<"FalconISD::BRAL", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def brale : SDNode<"FalconISD::BRALE", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def brag : SDNode<"FalconISD::BRAG", SDTBra, [SDNPHasChain, SDNPInGlue]>;
def brage : SDNode<"FalconISD::BRAGE", SDTBra, [SDNPHasChain, SDNPInGlue]>;

def hi8    : SDNode<"FalconISD::Hi8", SDTIntUnaryOp>;
def lo16    : SDNode<"FalconISD::Lo16", SDTIntUnaryOp>;
