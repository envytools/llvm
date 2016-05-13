//===-- FalconISelLowering.h - Falcon DAG Lowering Interface ----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the interfaces that Falcon uses to lower LLVM code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_FALCONISELLOWERING_H
#define LLVM_LIB_TARGET_FALCON_FALCONISELLOWERING_H

#include "Falcon.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/Target/TargetLowering.h"

namespace llvm {
class FalconSubtarget;
namespace FalconISD {
enum NodeType : unsigned {
  FIRST_NUMBER = ISD::BUILTIN_OP_END,
  // Arithmetic instructions with flag results.
  ADD_COSZ, ADC_COSZ, SUB_COSZ, SBB_COSZ,
  SHL_COSZ, SHR_COSZ, SAR_COSZ, SHLC_COSZ, SHRC_COSZ,
  NOT_OSZ, NEG_OSZ, HSWAP_OSZ, TST_OSZ,
  CMP_COSZ, CMPS_CZ, CMPU_CZ,
  AND_COSZ, OR_COSZ, XOR_COSZ,
  SEXT_SZ, EXTR_SZ, EXTRS_SZ, GETB_SZ,
  INS, CLRB, SETB, TGLB, MULU, MULS,
  // Return instructions
  RET_FLAG,
  IRET,
  CALL,
  BRAF, BRANF,
  BRAC, BRANC,
  BRAO, BRANO,
  BRAS, BRANS,
  BRAZ, BRANZ,
  BRAA, BRANA,
  BRAL, BRAG,
  BRALE, BRAGE,
  SETHI,
  Hi8,
  Lo16,
};
}

class FalconTargetLowering : public TargetLowering {
public:
  explicit FalconTargetLowering(const TargetMachine &TM, const FalconSubtarget &STI);

  // Provide custom lowering hooks for some operations.
  SDValue LowerOperation(SDValue Op, SelectionDAG &DAG) const override;

  // This method returns the name of a target specific DAG node.
  const char *getTargetNodeName(unsigned Opcode) const override;

  MachineBasicBlock *
  EmitInstrWithCustomInserter(MachineInstr *MI,
                              MachineBasicBlock *BB) const override;

  SDValue PerformDAGCombine(SDNode *N, DAGCombinerInfo &DCI) const override;

private:
  SDValue LowerGlobalAddress(SDValue Op, SelectionDAG &DAG) const;

  // Lower the result values of a call, copying them out of physregs into vregs
  SDValue LowerCallResult(SDValue Chain, SDValue InFlag,
                          CallingConv::ID CallConv, bool IsVarArg,
                          const SmallVectorImpl<ISD::InputArg> &Ins, SDLoc DL,
                          SelectionDAG &DAG,
                          SmallVectorImpl<SDValue> &InVals) const;

  // Lower a call into CALLSEQ_START - FalconISD:CALL - CALLSEQ_END chain
  SDValue LowerCall(TargetLowering::CallLoweringInfo &CLI,
                    SmallVectorImpl<SDValue> &InVals) const override;

  // Lower incoming arguments, copy physregs into vregs
  SDValue LowerFormalArguments(SDValue Chain, CallingConv::ID CallConv,
                               bool IsVarArg,
                               const SmallVectorImpl<ISD::InputArg> &Ins,
                               SDLoc DL, SelectionDAG &DAG,
                               SmallVectorImpl<SDValue> &InVals) const override;

  SDValue LowerReturn(SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
                      const SmallVectorImpl<ISD::OutputArg> &Outs,
                      const SmallVectorImpl<SDValue> &OutVals, SDLoc DL,
                      SelectionDAG &DAG) const override;

  EVT getOptimalMemOpType(uint64_t Size, unsigned DstAlign, unsigned SrcAlign,
                          bool IsMemset, bool ZeroMemset, bool MemcpyStrSrc,
                          MachineFunction &MF) const override {
	  // XXX
    return Size >= 8 ? MVT::i64 : MVT::i32;
  }

  bool shouldConvertConstantLoadToIntImm(const APInt &Imm,
                                         Type *Ty) const override {
    return true;
  }

  unsigned getRegisterByName(const char* RegName, EVT VT,
                                     SelectionDAG &DAG) const override;

  std::pair<unsigned, const TargetRegisterClass *>
    getRegForInlineAsmConstraint(const TargetRegisterInfo *TRI,
                                 StringRef Constraint, MVT VT) const override;


  void ReplaceNodeResults(SDNode *N, SmallVectorImpl<SDValue> &Results, SelectionDAG &DAG) const override {
  }

};
}

#endif
