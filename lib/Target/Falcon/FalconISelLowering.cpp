//===-- FalconISelLowering.cpp - Falcon DAG Lowering Implementation  ------===//
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

#include "FalconISelLowering.h"
#include "Falcon.h"
#include "FalconSubtarget.h"
#include "FalconTargetMachine.h"
#include "MCTargetDesc/FalconMCExpr.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/IR/DiagnosticPrinter.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "bpf-lower"

static void fail(SDLoc DL, SelectionDAG &DAG, const char *Msg) {
  MachineFunction &MF = DAG.getMachineFunction();
  DAG.getContext()->diagnose(
      DiagnosticInfoUnsupported(*MF.getFunction(), Msg, DL.getDebugLoc()));
}

static void fail(SDLoc DL, SelectionDAG &DAG, const char *Msg, SDValue Val) {
  MachineFunction &MF = DAG.getMachineFunction();
  std::string Str;
  raw_string_ostream OS(Str);
  OS << Msg;
  Val->print(OS);
  OS.flush();
  DAG.getContext()->diagnose(
      DiagnosticInfoUnsupported(*MF.getFunction(), Str, DL.getDebugLoc()));
}

FalconTargetLowering::FalconTargetLowering(const TargetMachine &TM,
                                     const FalconSubtarget &STI)
    : TargetLowering(TM) {

  // Set up the register classes.
  addRegisterClass(MVT::i1, &Falcon::FLAGRegClass);
  addRegisterClass(MVT::i8, &Falcon::GPR8RegClass);
  addRegisterClass(MVT::i16, &Falcon::GPR16RegClass);
  addRegisterClass(MVT::i32, &Falcon::GPR32RegClass);

  // Compute derived properties from the register classes
  computeRegisterProperties(STI.getRegisterInfo());

  // Set up combiners.
  setTargetDAGCombine(ISD::SRA);

  // XXX?
  setStackPointerRegisterToSaveRestore(Falcon::SP);

  // XXX BasicBlock?
  // XXX FrameIndex
  // XXX ExternalSymbol [?]

  // XXX FRAMEADDR, RETURNADDR

  // XXX WRITE_REGISTER [cx]

  /* XXX */
  setOperationAction(ISD::BR_CC, MVT::i1, Custom);
  setOperationAction(ISD::BR_CC, MVT::i8, Custom);
  setOperationAction(ISD::BR_CC, MVT::i16, Custom);
  setOperationAction(ISD::BR_CC, MVT::i32, Custom);
  setOperationAction(ISD::BR_JT, MVT::Other, Expand);
  setOperationAction(ISD::BRIND, MVT::Other, Expand);
  setOperationAction(ISD::BRCOND, MVT::Other, Expand);
  setOperationAction(ISD::SETCC, MVT::i1, Expand);
  setOperationAction(ISD::SETCC, MVT::i8, Expand);
  setOperationAction(ISD::SETCC, MVT::i16, Expand);
  setOperationAction(ISD::SETCC, MVT::i32, Expand);
  setOperationAction(ISD::SELECT, MVT::i1, Expand);
  setOperationAction(ISD::SELECT, MVT::i8, Expand);
  setOperationAction(ISD::SELECT, MVT::i16, Expand);
  setOperationAction(ISD::SELECT, MVT::i32, Expand);
  setOperationAction(ISD::SELECT_CC, MVT::i1, Expand);
  setOperationAction(ISD::SELECT_CC, MVT::i8, Expand);
  setOperationAction(ISD::SELECT_CC, MVT::i16, Expand);
  setOperationAction(ISD::SELECT_CC, MVT::i32, Expand);

  setOperationAction(ISD::GlobalAddress, MVT::i32, Custom);
  setOperationAction(ISD::JumpTable, MVT::i32, Custom);
  setOperationAction(ISD::ConstantPool, MVT::i32, Custom);
  setOperationAction(ISD::BlockAddress, MVT::i32, Custom);

  setOperationAction(ISD::DYNAMIC_STACKALLOC, MVT::i64, Custom);
  setOperationAction(ISD::STACKSAVE, MVT::Other, Expand);
  setOperationAction(ISD::STACKRESTORE, MVT::Other, Expand);

  // XXX MUL, *MUL_LOHI
  setOperationAction(ISD::MUL, MVT::i8, Promote);

  // XXX UDIV, UREM
  setOperationAction(ISD::MUL, MVT::i8, Promote);

  // XXX ADDC, ADDE, SUBC, SUBE, CARRY_FALSE?

  // XXX [SU]ADDO, [SU]SUBO

  // XXX Expand MULO?

  setOperationAction(ISD::MULHU, MVT::i64, Expand);
  setOperationAction(ISD::MULHS, MVT::i64, Expand);
  setOperationAction(ISD::UMUL_LOHI, MVT::i64, Expand);
  setOperationAction(ISD::SMUL_LOHI, MVT::i64, Expand);

  setOperationAction(ISD::ADDC, MVT::i64, Expand);
  setOperationAction(ISD::ADDE, MVT::i64, Expand);
  setOperationAction(ISD::SUBC, MVT::i64, Expand);
  setOperationAction(ISD::SUBE, MVT::i64, Expand);

  setOperationAction(ISD::AND, MVT::i1, Promote);
  setOperationAction(ISD::AND, MVT::i8, Promote);
  setOperationAction(ISD::AND, MVT::i16, Promote);
  setOperationAction(ISD::OR, MVT::i1, Promote);
  setOperationAction(ISD::OR, MVT::i8, Promote);
  setOperationAction(ISD::OR, MVT::i16, Promote);
  setOperationAction(ISD::XOR, MVT::i1, Promote);
  setOperationAction(ISD::XOR, MVT::i8, Promote);
  setOperationAction(ISD::XOR, MVT::i16, Promote);
  setOperationAction(ISD::UDIV, MVT::i8, Promote);
  setOperationAction(ISD::UDIV, MVT::i16, Promote);
  setOperationAction(ISD::UREM, MVT::i8, Promote);
  setOperationAction(ISD::UREM, MVT::i16, Promote);

  // XXX: getShiftAmountTy

  // XXX: ROTL/ROTR can be hswap?

  // XXX: SELECT, SELECT_CC
  // XXX: SETCC, SETCCE

  // XXX: SIGN_EXTEND, ZERO_EXTEND, ANY_EXTEND
  // XXX: TRUNCATE
  // XXX: *_EXTEND_INREG

  setOperationAction(ISD::ROTR, MVT::i64, Expand);
  setOperationAction(ISD::ROTL, MVT::i64, Expand);
  setOperationAction(ISD::SHL_PARTS, MVT::i64, Expand);
  setOperationAction(ISD::SRL_PARTS, MVT::i64, Expand);
  setOperationAction(ISD::SRA_PARTS, MVT::i64, Expand);

  setOperationAction(ISD::CTTZ, MVT::i64, Expand);
  setOperationAction(ISD::CTLZ, MVT::i64, Expand);
  setOperationAction(ISD::CTTZ_ZERO_UNDEF, MVT::i64, Expand);
  setOperationAction(ISD::CTLZ_ZERO_UNDEF, MVT::i64, Expand);
  setOperationAction(ISD::CTPOP, MVT::i64, Expand);

  // Extended load operations for i1 types must be promoted
  for (MVT VT : MVT::integer_valuetypes()) {
	  // XXX
    setOperationAction(ISD::UDIVREM, VT, Expand);
    setOperationAction(ISD::SDIVREM, VT, Expand);
    setOperationAction(ISD::SDIV, VT, Expand);
    setOperationAction(ISD::SREM, VT, Expand);

    setOperationAction(ISD::SIGN_EXTEND, VT, Custom);
    setOperationAction(ISD::ZERO_EXTEND, VT, Custom);

    // We actually do support signext of arbitrary <32-bit integer type
    // (like i17), but it's easier for us to match the expanded form.
    setOperationAction(ISD::SIGN_EXTEND_INREG, VT, Expand);

    setLoadExtAction(ISD::EXTLOAD, VT, MVT::i1, Promote);
    setLoadExtAction(ISD::ZEXTLOAD, VT, MVT::i1, Promote);
    setLoadExtAction(ISD::SEXTLOAD, VT, MVT::i1, Promote);

    setLoadExtAction(ISD::EXTLOAD, VT, MVT::i8, Expand);
    setLoadExtAction(ISD::EXTLOAD, VT, MVT::i16, Expand);
    setLoadExtAction(ISD::EXTLOAD, VT, MVT::i32, Expand);

    setLoadExtAction(ISD::SEXTLOAD, VT, MVT::i8, Expand);
    setLoadExtAction(ISD::SEXTLOAD, VT, MVT::i16, Expand);
    setLoadExtAction(ISD::SEXTLOAD, VT, MVT::i32, Expand);

    setLoadExtAction(ISD::ZEXTLOAD, VT, MVT::i8, Expand);
    setLoadExtAction(ISD::ZEXTLOAD, VT, MVT::i16, Expand);
    setLoadExtAction(ISD::ZEXTLOAD, VT, MVT::i32, Expand);

    setTruncStoreAction(VT, MVT::i8, Expand);
    setTruncStoreAction(VT, MVT::i16, Expand);
    setTruncStoreAction(VT, MVT::i32, Expand);
  }

  setBooleanContents(ZeroOrOneBooleanContent);

  // Function alignments (log2)
  setMinFunctionAlignment(0);
  setPrefFunctionAlignment(0);
}

SDValue FalconTargetLowering::LowerOperation(SDValue Op, SelectionDAG &DAG) const {
  SDLoc DL(Op);
  switch (Op.getOpcode()) {
  case ISD::ZERO_EXTEND: {
    MVT VT = Op.getSimpleValueType();
    SDValue In = Op.getOperand(0);
    MVT SVT = In.getSimpleValueType();
    if (SVT != MVT::i1) {
      SDValue XIn = DAG.getNode(ISD::ANY_EXTEND, DL, VT, In);
      return DAG.getZeroExtendInReg(XIn, DL, SVT);
    }
    break;
  }
  case ISD::SIGN_EXTEND: {
    MVT VT = Op.getSimpleValueType();
    SDValue In = Op.getOperand(0);
    MVT SVT = In.getSimpleValueType();
    SDValue XIn = DAG.getNode(ISD::ANY_EXTEND, DL, VT, In);
    return DAG.getNode(ISD::SIGN_EXTEND_INREG, DL, VT, XIn, DAG.getValueType(SVT));
  }
  case ISD::GlobalAddress: {
    // XXX nuke offsets
    const GlobalAddressSDNode *GN = cast<GlobalAddressSDNode>(Op);
    const GlobalValue *GV = GN->getGlobal();
    const uint64_t Offset = GN->getOffset();
    SDValue HiGA = DAG.getTargetGlobalAddress(GV, DL, MVT::i32, Offset, FalconMCExpr::VK_Falcon_HI8);
    SDValue LoGA = DAG.getTargetGlobalAddress(GV, DL, MVT::i32, Offset, FalconMCExpr::VK_Falcon_LO16);
    SDValue Hi = DAG.getNode(FalconISD::Hi8, DL, MVT::i32, HiGA);
    SDValue Lo = DAG.getNode(FalconISD::Lo16, DL, MVT::i32, LoGA);
    return DAG.getNode(FalconISD::SETHI, DL, MVT::i32, Lo, Hi);
    /* XXX code models? */
  }
  /*case ISD::JumpTable:
  case ISD::ConstantPool: */
  case ISD::BlockAddress: {
    const BlockAddressSDNode *BN = cast<BlockAddressSDNode>(Op);
    const BlockAddress *BA = BN->getBlockAddress();
    const uint64_t Offset = BN->getOffset();
    SDValue HiGA = DAG.getTargetBlockAddress(BA, MVT::i32, Offset, FalconMCExpr::VK_Falcon_HI8);
    SDValue LoGA = DAG.getTargetBlockAddress(BA, MVT::i32, Offset, FalconMCExpr::VK_Falcon_LO16);
    SDValue Hi = DAG.getNode(FalconISD::Hi8, DL, MVT::i32, HiGA);
    SDValue Lo = DAG.getNode(FalconISD::Lo16, DL, MVT::i32, LoGA);
    return DAG.getNode(FalconISD::SETHI, DL, MVT::i32, Lo, Hi);
  }
  case ISD::BR_CC: {
    ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(1))->get();
    SDValue CmpOp0 = Op.getOperand(2);
    SDValue CmpOp1 = Op.getOperand(3);
    auto ConstOp1 = dyn_cast<ConstantSDNode>(CmpOp1.getNode());
    SDValue Dest = Op.getOperand(4);
    SDLoc DL(Op);
    MVT VT = CmpOp0.getSimpleValueType();

    if (VT == MVT::i1 && ConstOp1) {
      if ((CC == ISD::CondCode::SETNE && ConstOp1->getSExtValue() == -1) ||
          (CC == ISD::CondCode::SETEQ && ConstOp1->getSExtValue() == 0))
        return DAG.getNode(FalconISD::BRANF, DL, Op.getValueType(),
                       Op.getOperand(0), CmpOp0, Dest);
      if ((CC == ISD::CondCode::SETNE && ConstOp1->getSExtValue() == 0) ||
          (CC == ISD::CondCode::SETEQ && ConstOp1->getSExtValue() == -1))
        return DAG.getNode(FalconISD::BRAF, DL, Op.getValueType(),
                       Op.getOperand(0), CmpOp0, Dest);
    } else if (ConstOp1 && ConstOp1->getSExtValue() == 0) {
      SDValue Glue = DAG.getNode(FalconISD::TST_OSZ, DL, MVT::Glue, CmpOp0);
      int BrOp;
      switch (CC) {
      case ISD::CondCode::SETEQ:
        BrOp = FalconISD::BRAZ;
        break;
      case ISD::CondCode::SETNE:
        BrOp = FalconISD::BRANZ;
        break;
      case ISD::CondCode::SETGT:
        BrOp = FalconISD::BRAG;
        break;
      case ISD::CondCode::SETGE:
        BrOp = FalconISD::BRAGE;
        break;
      case ISD::CondCode::SETLT:
        BrOp = FalconISD::BRAL;
        break;
      case ISD::CondCode::SETLE:
        BrOp = FalconISD::BRALE;
        break;
      // XXX
      default:
        llvm_unreachable("unimplemented cc");
      }
      return DAG.getNode(BrOp, DL, Op.getValueType(), Op.getOperand(0), Dest, Glue);
    } else {
      SDValue Glue = DAG.getNode(FalconISD::CMP_COSZ, DL, MVT::Glue, CmpOp0, CmpOp1);
      int BrOp;
      switch (CC) {
      case ISD::CondCode::SETEQ:
        BrOp = FalconISD::BRAZ;
        break;
      case ISD::CondCode::SETNE:
        BrOp = FalconISD::BRANZ;
        break;
      case ISD::CondCode::SETGT:
        BrOp = FalconISD::BRAG;
        break;
      case ISD::CondCode::SETGE:
        BrOp = FalconISD::BRAGE;
        break;
      case ISD::CondCode::SETLT:
        BrOp = FalconISD::BRAL;
        break;
      case ISD::CondCode::SETLE:
        BrOp = FalconISD::BRALE;
        break;
      case ISD::CondCode::SETUGT:
        BrOp = FalconISD::BRAA;
        break;
      case ISD::CondCode::SETUGE:
        BrOp = FalconISD::BRANC;
        break;
      case ISD::CondCode::SETULT:
        BrOp = FalconISD::BRAC;
        break;
      case ISD::CondCode::SETULE:
        BrOp = FalconISD::BRANA;
        break;
      default:
        llvm_unreachable("unimplemented cc");
      }
      return DAG.getNode(BrOp, DL, Op.getValueType(), Op.getOperand(0), Dest, Glue);
    }
    break;
  }
  default:
    llvm_unreachable("unimplemented operand");
  }
  return SDValue();
}

// Calling Convention Implementation
#include "FalconGenCallingConv.inc"

SDValue FalconTargetLowering::LowerFormalArguments(
    SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, SDLoc DL, SelectionDAG &DAG,
    SmallVectorImpl<SDValue> &InVals) const {
  switch (CallConv) {
  default:
    llvm_unreachable("Unsupported calling convention");
  case CallingConv::C:
  case CallingConv::Fast:
    break;
  }

  MachineFunction &MF = DAG.getMachineFunction();
  MachineRegisterInfo &RegInfo = MF.getRegInfo();

  // Assign locations to all of the incoming arguments.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());
  CCInfo.AnalyzeFormalArguments(Ins, CC_Falcon);
  // XXX

  for (auto &VA : ArgLocs) {
    if (VA.isRegLoc()) {
      // Arguments passed in registers
      EVT RegVT = VA.getLocVT();
      switch (RegVT.getSimpleVT().SimpleTy) {
      default: {
        errs() << "LowerFormalArguments Unhandled argument type: "
               << RegVT.getEVTString() << '\n';
        llvm_unreachable(0);
      }
	       // XXX
      case MVT::i1: {
        unsigned VReg = RegInfo.createVirtualRegister(&Falcon::PREDRegClass);
        RegInfo.addLiveIn(VA.getLocReg(), VReg);
        SDValue ArgValue = DAG.getCopyFromReg(Chain, DL, VReg, RegVT);
        InVals.push_back(ArgValue);
        break;
      }
      case MVT::i8: {
        unsigned VReg = RegInfo.createVirtualRegister(&Falcon::GPR8RegClass);
        RegInfo.addLiveIn(VA.getLocReg(), VReg);
        SDValue ArgValue = DAG.getCopyFromReg(Chain, DL, VReg, RegVT);
        InVals.push_back(ArgValue);
        break;
      }
      case MVT::i16: {
        unsigned VReg = RegInfo.createVirtualRegister(&Falcon::GPR16RegClass);
        RegInfo.addLiveIn(VA.getLocReg(), VReg);
        SDValue ArgValue = DAG.getCopyFromReg(Chain, DL, VReg, RegVT);
        InVals.push_back(ArgValue);
        break;
      }
      case MVT::i32: {
        unsigned VReg = RegInfo.createVirtualRegister(&Falcon::GPR32RegClass);
        RegInfo.addLiveIn(VA.getLocReg(), VReg);
        SDValue ArgValue = DAG.getCopyFromReg(Chain, DL, VReg, RegVT);
        InVals.push_back(ArgValue);
        break;
      }
      }
    } else {
      fail(DL, DAG, "defined with too many args");
    }
  }

  if (IsVarArg || MF.getFunction()->hasStructRetAttr()) {
    fail(DL, DAG, "functions with VarArgs or StructRet are not supported");
  }

  return Chain;
}

SDValue FalconTargetLowering::LowerCall(TargetLowering::CallLoweringInfo &CLI,
                                     SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG = CLI.DAG;
  auto &Outs = CLI.Outs;
  auto &OutVals = CLI.OutVals;
  auto &Ins = CLI.Ins;
  SDValue Chain = CLI.Chain;
  SDValue Callee = CLI.Callee;
  bool &IsTailCall = CLI.IsTailCall;
  CallingConv::ID CallConv = CLI.CallConv;
  bool IsVarArg = CLI.IsVarArg;
  MachineFunction &MF = DAG.getMachineFunction();

  // Falcon target does not support tail call optimization.
  IsTailCall = false;

  switch (CallConv) {
  default:
    report_fatal_error("Unsupported calling convention");
  case CallingConv::Fast:
  case CallingConv::C:
    break;
  }
  // XXX

  // Analyze operands of the call, assigning locations to each operand.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());

  CCInfo.AnalyzeCallOperands(Outs, CC_Falcon);

  unsigned NumBytes = CCInfo.getNextStackOffset();

  if (Outs.size() >= 6) {
    fail(CLI.DL, DAG, "too many args to ", Callee);
  }

  for (auto &Arg : Outs) {
    ISD::ArgFlagsTy Flags = Arg.Flags;
    if (!Flags.isByVal())
      continue;

    fail(CLI.DL, DAG, "pass by value not supported ", Callee);
  }

  auto PtrVT = getPointerTy(MF.getDataLayout());
  Chain = DAG.getCALLSEQ_START(
      Chain, DAG.getConstant(NumBytes, CLI.DL, PtrVT, true), CLI.DL);

  SmallVector<std::pair<unsigned, SDValue>, 5> RegsToPass;

  // Walk arg assignments
  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    SDValue Arg = OutVals[i];

    // Push arguments into RegsToPass vector
    if (VA.isRegLoc())
      RegsToPass.push_back(std::make_pair(VA.getLocReg(), Arg));
    else
      llvm_unreachable("call arg pass bug");
  }

  SDValue InFlag;

  // Build a sequence of copy-to-reg nodes chained together with token chain and
  // flag operands which copy the outgoing args into registers.  The InFlag in
  // necessary since all emitted instructions must be stuck together.
  for (auto &Reg : RegsToPass) {
    Chain = DAG.getCopyToReg(Chain, CLI.DL, Reg.first, Reg.second, InFlag);
    InFlag = Chain.getValue(1);
  }

#if 0
  // If the callee is a GlobalAddress node (quite common, every direct call is)
  // turn it into a TargetGlobalAddress node so that legalize doesn't hack it.
  // Likewise ExternalSymbol -> TargetExternalSymbol.
  if (GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(Callee))
    Callee = DAG.getTargetGlobalAddress(G->getGlobal(), CLI.DL, PtrVT,
                                        G->getOffset(), 0);
  else if (ExternalSymbolSDNode *E = dyn_cast<ExternalSymbolSDNode>(Callee))
    Callee = DAG.getTargetExternalSymbol(E->getSymbol(), PtrVT, 0);
#endif

  // Returns a chain & a flag for retval copy to use.
  SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);
  SmallVector<SDValue, 8> Ops;
  Ops.push_back(Chain);
  Ops.push_back(Callee);

  // Add argument registers to the end of the list so that they are
  // known live into the call.
  for (auto &Reg : RegsToPass)
    Ops.push_back(DAG.getRegister(Reg.first, Reg.second.getValueType()));

  if (InFlag.getNode())
    Ops.push_back(InFlag);

  Chain = DAG.getNode(FalconISD::CALL, CLI.DL, NodeTys, Ops);
  InFlag = Chain.getValue(1);

  // Create the CALLSEQ_END node.
  Chain = DAG.getCALLSEQ_END(
      Chain, DAG.getConstant(NumBytes, CLI.DL, PtrVT, true),
      DAG.getConstant(0, CLI.DL, PtrVT, true), InFlag, CLI.DL);
  InFlag = Chain.getValue(1);

  // Handle result values, copying them out of physregs into vregs that we
  // return.
  return LowerCallResult(Chain, InFlag, CallConv, IsVarArg, Ins, CLI.DL, DAG,
                         InVals);
}

SDValue
FalconTargetLowering::LowerReturn(SDValue Chain, CallingConv::ID CallConv,
                               bool IsVarArg,
                               const SmallVectorImpl<ISD::OutputArg> &Outs,
                               const SmallVectorImpl<SDValue> &OutVals,
                               SDLoc DL, SelectionDAG &DAG) const {

  // CCValAssign - represent the assignment of the return value to a location
  SmallVector<CCValAssign, 16> RVLocs;
  MachineFunction &MF = DAG.getMachineFunction();
  // XXX

  // CCState - Info about the registers and stack slot.
  CCState CCInfo(CallConv, IsVarArg, MF, RVLocs, *DAG.getContext());

  if (MF.getFunction()->getReturnType()->isAggregateType()) {
    fail(DL, DAG, "only integer returns supported");
  }

  // Analize return values.
  CCInfo.AnalyzeReturn(Outs, RetCC_Falcon);

  SDValue Flag;
  SmallVector<SDValue, 4> RetOps(1, Chain);

  // Copy the result values into the output registers.
  for (unsigned i = 0; i != RVLocs.size(); ++i) {
    CCValAssign &VA = RVLocs[i];
    assert(VA.isRegLoc() && "Can only return in registers!");

    Chain = DAG.getCopyToReg(Chain, DL, VA.getLocReg(), OutVals[i], Flag);

    // Guarantee that all emitted copies are stuck together,
    // avoiding something bad.
    Flag = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
  }

  unsigned Opc = FalconISD::RET_FLAG;
  RetOps[0] = Chain; // Update chain.

  // Add the flag if we have it.
  if (Flag.getNode())
    RetOps.push_back(Flag);

  return DAG.getNode(Opc, DL, MVT::Other, RetOps);
}

SDValue FalconTargetLowering::LowerCallResult(
    SDValue Chain, SDValue InFlag, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, SDLoc DL, SelectionDAG &DAG,
    SmallVectorImpl<SDValue> &InVals) const {
	// XXX

  MachineFunction &MF = DAG.getMachineFunction();
  // Assign locations to each value returned by this call.
  SmallVector<CCValAssign, 16> RVLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, RVLocs, *DAG.getContext());

  if (Ins.size() >= 2) {
    fail(DL, DAG, "only small returns supported");
  }

  CCInfo.AnalyzeCallResult(Ins, RetCC_Falcon);

  // Copy all of the result registers out of their specified physreg.
  for (auto &Val : RVLocs) {
    Chain = DAG.getCopyFromReg(Chain, DL, Val.getLocReg(),
                               Val.getValVT(), InFlag).getValue(1);
    InFlag = Chain.getValue(2);
    InVals.push_back(Chain.getValue(0));
  }

  return Chain;
}

const char *FalconTargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch ((FalconISD::NodeType)Opcode) {
  case FalconISD::FIRST_NUMBER:
    break;
  case FalconISD::RET_FLAG:
    return "FalconISD::RET_FLAG";
  case FalconISD::CALL:
    return "FalconISD::CALL";
  case FalconISD::IRET:
    return "FalconISD::IRET";
  case FalconISD::SETHI:
    return "FalconISD::SETHI";
  case FalconISD::ADD_COSZ:
    return "FalconISD::ADD_COSZ";
  case FalconISD::ADC_COSZ:
    return "FalconISD::ADC_COSZ";
  case FalconISD::SUB_COSZ:
    return "FalconISD::SUB_COSZ";
  case FalconISD::SBB_COSZ:
    return "FalconISD::SBB_COSZ";
  case FalconISD::SHL_COSZ:
    return "FalconISD::SHL_COSZ";
  case FalconISD::SHR_COSZ:
    return "FalconISD::SHR_COSZ";
  case FalconISD::SAR_COSZ:
    return "FalconISD::SAR_COSZ";
  case FalconISD::SHLC_COSZ:
    return "FalconISD::SHLC_COSZ";
  case FalconISD::SHRC_COSZ:
    return "FalconISD::SHRC_COSZ";
  case FalconISD::NOT_OSZ:
    return "FalconISD::NOT_OSZ";
  case FalconISD::NEG_OSZ:
    return "FalconISD::NEG_OSZ";
  case FalconISD::HSWAP_OSZ:
    return "FalconISD::HSWAP_OSZ";
  case FalconISD::TST_OSZ:
    return "FalconISD::TST_OSZ";
  case FalconISD::CMP_COSZ:
    return "FalconISD::CMP_COSZ";
  case FalconISD::CMPS_CZ:
    return "FalconISD::CMPS_CZ";
  case FalconISD::CMPU_CZ:
    return "FalconISD::CMPU_CZ";
  case FalconISD::AND_COSZ:
    return "FalconISD::AND_COSZ";
  case FalconISD::OR_COSZ:
    return "FalconISD::OR_COSZ";
  case FalconISD::XOR_COSZ:
    return "FalconISD::XOR_COSZ";
  case FalconISD::SEXT_SZ:
    return "FalconISD::SEXT_SZ";
  case FalconISD::EXTR_SZ:
    return "FalconISD::EXTR_SZ";
  case FalconISD::EXTRS_SZ:
    return "FalconISD::EXTRS_SZ";
  case FalconISD::GETB_SZ:
    return "FalconISD::GETB_SZ";
  case FalconISD::INS:
    return "FalconISD::INS";
  case FalconISD::CLRB:
    return "FalconISD::CLRB";
  case FalconISD::SETB:
    return "FalconISD::SETB";
  case FalconISD::TGLB:
    return "FalconISD::TGLB";
  case FalconISD::MULU:
    return "FalconISD::MULU";
  case FalconISD::MULS:
    return "FalconISD::MULS";
  case FalconISD::BRAF:
    return "FalconISD::BRAF";
  case FalconISD::BRANF:
    return "FalconISD::BRANF";
  case FalconISD::BRAC:
    return "FalconISD::BRAC";
  case FalconISD::BRANC:
    return "FalconISD::BRANC";
  case FalconISD::BRAO:
    return "FalconISD::BRAO";
  case FalconISD::BRANO:
    return "FalconISD::BRANO";
  case FalconISD::BRAS:
    return "FalconISD::BRAS";
  case FalconISD::BRANS:
    return "FalconISD::BRANS";
  case FalconISD::BRAZ:
    return "FalconISD::BRAZ";
  case FalconISD::BRANZ:
    return "FalconISD::BRANZ";
  case FalconISD::BRAA:
    return "FalconISD::BRAA";
  case FalconISD::BRANA:
    return "FalconISD::BRANA";
  case FalconISD::BRAL:
    return "FalconISD::BRAL";
  case FalconISD::BRAG:
    return "FalconISD::BRAG";
  case FalconISD::BRALE:
    return "FalconISD::BRALE";
  case FalconISD::BRAGE:
    return "FalconISD::BRAGE";
  case FalconISD::Hi8:
    return "FalconISD::Hi8";
  case FalconISD::Lo16:
    return "FalconISD::Lo16";
  }
  return nullptr;
}

MachineBasicBlock *
FalconTargetLowering::EmitInstrWithCustomInserter(MachineInstr *MI,
                                               MachineBasicBlock *BB) const {
  const TargetInstrInfo &TII = *BB->getParent()->getSubtarget().getInstrInfo();
  DebugLoc DL = MI->getDebugLoc();

  // XXX
#if 0
  assert(MI->getOpcode() == Falcon::Select && "Unexpected instr type to insert");

  // To "insert" a SELECT instruction, we actually have to insert the diamond
  // control-flow pattern.  The incoming instruction knows the destination vreg
  // to set, the condition code register to branch on, the true/false values to
  // select between, and a branch opcode to use.
  const BasicBlock *LLVM_BB = BB->getBasicBlock();
  MachineFunction::iterator I = ++BB->getIterator();

  // ThisMBB:
  // ...
  //  TrueVal = ...
  //  jmp_XX r1, r2 goto Copy1MBB
  //  fallthrough --> Copy0MBB
  MachineBasicBlock *ThisMBB = BB;
  MachineFunction *F = BB->getParent();
  MachineBasicBlock *Copy0MBB = F->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *Copy1MBB = F->CreateMachineBasicBlock(LLVM_BB);

  F->insert(I, Copy0MBB);
  F->insert(I, Copy1MBB);
  // Update machine-CFG edges by transferring all successors of the current
  // block to the new block which will contain the Phi node for the select.
  Copy1MBB->splice(Copy1MBB->begin(), BB,
                   std::next(MachineBasicBlock::iterator(MI)), BB->end());
  Copy1MBB->transferSuccessorsAndUpdatePHIs(BB);
  // Next, add the true and fallthrough blocks as its successors.
  BB->addSuccessor(Copy0MBB);
  BB->addSuccessor(Copy1MBB);

  // Insert Branch if Flag
  unsigned LHS = MI->getOperand(1).getReg();
  unsigned RHS = MI->getOperand(2).getReg();
  int CC = MI->getOperand(3).getImm();
  switch (CC) {
  case ISD::SETGT:
    BuildMI(BB, DL, TII.get(Falcon::JSGT_rr))
        .addReg(LHS)
        .addReg(RHS)
        .addMBB(Copy1MBB);
    break;
  case ISD::SETUGT:
    BuildMI(BB, DL, TII.get(Falcon::JUGT_rr))
        .addReg(LHS)
        .addReg(RHS)
        .addMBB(Copy1MBB);
    break;
  case ISD::SETGE:
    BuildMI(BB, DL, TII.get(Falcon::JSGE_rr))
        .addReg(LHS)
        .addReg(RHS)
        .addMBB(Copy1MBB);
    break;
  case ISD::SETUGE:
    BuildMI(BB, DL, TII.get(Falcon::JUGE_rr))
        .addReg(LHS)
        .addReg(RHS)
        .addMBB(Copy1MBB);
    break;
  case ISD::SETEQ:
    BuildMI(BB, DL, TII.get(Falcon::JEQ_rr))
        .addReg(LHS)
        .addReg(RHS)
        .addMBB(Copy1MBB);
    break;
  case ISD::SETNE:
    BuildMI(BB, DL, TII.get(Falcon::JNE_rr))
        .addReg(LHS)
        .addReg(RHS)
        .addMBB(Copy1MBB);
    break;
  default:
    report_fatal_error("unimplemented select CondCode " + Twine(CC));
  }

  // Copy0MBB:
  //  %FalseValue = ...
  //  # fallthrough to Copy1MBB
  BB = Copy0MBB;

  // Update machine-CFG edges
  BB->addSuccessor(Copy1MBB);

  // Copy1MBB:
  //  %Result = phi [ %FalseValue, Copy0MBB ], [ %TrueValue, ThisMBB ]
  // ...
  BB = Copy1MBB;
  BuildMI(*BB, BB->begin(), DL, TII.get(Falcon::PHI), MI->getOperand(0).getReg())
      .addReg(MI->getOperand(5).getReg())
      .addMBB(Copy0MBB)
      .addReg(MI->getOperand(4).getReg())
      .addMBB(ThisMBB);

#endif
  MI->eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

unsigned FalconTargetLowering::getRegisterByName(const char *RegName, EVT VT,
                                                SelectionDAG &DAG) const {
  // Only unallocatable registers should be matched here.
// XXX: allow some GPRs to be used as global vars?
  unsigned Reg = 0;
  if (VT == MVT::i32) {
    Reg = StringSwitch<unsigned>(RegName)
                     .Case("iv0", Falcon::IV0)
                     .Case("iv1", Falcon::IV1)
                     .Case("tv", Falcon::TV)
                     .Case("xcbase", Falcon::XCBASE)
                     .Case("xdbase", Falcon::XDBASE)
                     .Case("xports", Falcon::XPORTS)
                     .Case("cx", Falcon::CX)
                     .Case("cauth", Falcon::CAUTH)
                     .Case("tstat", Falcon::TSTAT)
                     .Default(0);
  } else if (VT == MVT::i1) {
// XXX: allow PREDs to be used as global vars?
    Reg = StringSwitch<unsigned>(RegName)
                     .Case("ie0", Falcon::IE0)
                     .Case("ie1", Falcon::IE1)
                     .Case("sie0", Falcon::SIE0)
                     .Case("sie1", Falcon::SIE1)
                     .Case("ta", Falcon::TA)
                     .Default(0);
  }

  if (Reg)
    return Reg;
  report_fatal_error("Invalid register name global variable");
}

std::pair<unsigned, const TargetRegisterClass *>
FalconTargetLowering::getRegForInlineAsmConstraint(const TargetRegisterInfo *TRI,
                                                  StringRef Constraint,
                                                  MVT VT) const {
  if (Constraint.size() == 1)
    // GCC Constraint Letters
    switch (Constraint[0]) {
    case 'r': // GENERAL_REGS
      switch (VT.SimpleTy) {
      case MVT::i8:
        return std::make_pair(0U, &Falcon::GPR8RegClass);
      case MVT::i16:
        return std::make_pair(0U, &Falcon::GPR16RegClass);
      case MVT::i32:
        return std::make_pair(0U, &Falcon::GPR32RegClass);
      default:
        break;
      }
    default:
      break;
    }

  return TargetLowering::getRegForInlineAsmConstraint(TRI, Constraint, VT);
}

