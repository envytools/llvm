//=== FalconMachineFunctionInfo.h - Falcon machine function info -*- C++ -*-//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_FALCON_FALCONMACHINEFUNCTIONINFO_H
#define LLVM_LIB_TARGET_FALCON_FALCONMACHINEFUNCTIONINFO_H

#include "llvm/CodeGen/MachineFunction.h"

namespace llvm {

class FalconMachineFunctionInfo : public MachineFunctionInfo {
  virtual void anchor();
  unsigned VarArgsFrameIndex;
  int ReturnAddrFrameIndex;
  int FramePointerSaveIndex;
  bool ManipulatesSP;

public:
  explicit FalconMachineFunctionInfo(MachineFunction &MF)
    : VarArgsFrameIndex(0), ReturnAddrFrameIndex(0), FramePointerSaveIndex(0),
      ManipulatesSP(false) {}

  // Get and set the frame index of the first stack vararg.
  unsigned getVarArgsFrameIndex() const { return VarArgsFrameIndex; }
  void setVarArgsFrameIndex(unsigned FI) { VarArgsFrameIndex = FI; }

  // Get and set the frame index of the return register.
  int getReturnAddrFrameIndex() const { return ReturnAddrFrameIndex; }
  void setReturnAddrFrameIndex(int FI) { ReturnAddrFrameIndex = FI; }

  // Get and set the frame index of where the old frame pointer is stored.
  int getFramePointerSaveIndex() const { return FramePointerSaveIndex; }
  void setFramePointerSaveIndex(int Idx) { FramePointerSaveIndex = Idx; }

  // Get and set whether the function directly manipulates the stack pointer,
  // e.g. through STACKSAVE or STACKRESTORE.
  bool getManipulatesSP() const { return ManipulatesSP; }
  void setManipulatesSP(bool MSP) { ManipulatesSP = MSP; }
};

} // end namespace llvm

#endif
