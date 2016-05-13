//===-- FalconDisassembler.cpp - Disassembler for Falcon --------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Falcon.h"
#include "llvm/MC/MCDisassembler/MCDisassembler.h"
#include "llvm/MC/MCFixedLenDisassembler.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "systemz-disassembler"

typedef MCDisassembler::DecodeStatus DecodeStatus;

namespace {
class FalconDisassembler : public MCDisassembler {
public:
  FalconDisassembler(const MCSubtargetInfo &STI, MCContext &Ctx)
    : MCDisassembler(STI, Ctx) {}
  ~FalconDisassembler() override {}

  DecodeStatus getInstruction(MCInst &instr, uint64_t &Size,
                              ArrayRef<uint8_t> Bytes, uint64_t Address,
                              raw_ostream &VStream,
                              raw_ostream &CStream) const override;
};
} // end anonymous namespace

static MCDisassembler *createFalconDisassembler(const Target &T,
                                                 const MCSubtargetInfo &STI,
                                                 MCContext &Ctx) {
  return new FalconDisassembler(STI, Ctx);
}

extern "C" void LLVMInitializeFalconDisassembler() {
  // Register the disassembler.
  TargetRegistry::RegisterMCDisassembler(TheFalconTarget,
                                         createFalconDisassembler);
}

#if 0
/// tryAddingSymbolicOperand - trys to add a symbolic operand in place of the
/// immediate Value in the MCInst.
///
/// @param Value      - The immediate Value, has had any PC adjustment made by
///                     the caller.
/// @param isBranch   - If the instruction is a branch instruction
/// @param Address    - The starting address of the instruction
/// @param Offset     - The byte offset to this immediate in the instruction
/// @param Width      - The byte width of this immediate in the instruction
///
/// If the getOpInfo() function was set when setupForSymbolicDisassembly() was
/// called then that function is called to get any symbolic information for the
/// immediate in the instruction using the Address, Offset and Width.  If that
/// returns non-zero then the symbolic information it returns is used to create
/// an MCExpr and that is added as an operand to the MCInst.  If getOpInfo()
/// returns zero and isBranch is true then a symbol look up for immediate Value
/// is done and if a symbol is found an MCExpr is created with that, else
/// an MCExpr with the immediate Value is created.  This function returns true
/// if it adds an operand to the MCInst and false otherwise.
static bool tryAddingSymbolicOperand(int64_t Value, bool isBranch,
                                     uint64_t Address, uint64_t Offset,
                                     uint64_t Width, MCInst &MI,
                                     const void *Decoder) {
  const MCDisassembler *Dis = static_cast<const MCDisassembler*>(Decoder);
  return Dis->tryAddingSymbolicOperand(MI, Value, Address, isBranch,
                                       Offset, Width);
}
#endif

static DecodeStatus decodeRegisterClass(MCInst &Inst, uint64_t RegNo,
                                        const unsigned *Regs, unsigned Size) {
  assert(RegNo < Size && "Invalid register");
  RegNo = Regs[RegNo];
  if (RegNo == 0)
    return MCDisassembler::Fail;
  Inst.addOperand(MCOperand::createReg(RegNo));
  return MCDisassembler::Success;
}

static DecodeStatus DecodeFLAGRegisterClass(MCInst &Inst, uint64_t RegNo,
                                             uint64_t Address,
                                             const void *Decoder) {
  return decodeRegisterClass(Inst, RegNo, FalconMC::FLAGRegs, 32);
}

static DecodeStatus DecodeGPR8RegisterClass(MCInst &Inst, uint64_t RegNo,
                                             uint64_t Address,
                                             const void *Decoder) {
  return decodeRegisterClass(Inst, RegNo, FalconMC::GPR8Regs, 16);
}

static DecodeStatus DecodeGPR16RegisterClass(MCInst &Inst, uint64_t RegNo,
                                             uint64_t Address,
                                             const void *Decoder) {
  return decodeRegisterClass(Inst, RegNo, FalconMC::GPR16Regs, 16);
}

static DecodeStatus DecodeGPR32RegisterClass(MCInst &Inst, uint64_t RegNo,
                                             uint64_t Address,
                                             const void *Decoder) {
  return decodeRegisterClass(Inst, RegNo, FalconMC::GPR32Regs, 16);
}

static DecodeStatus DecodeSRRegisterClass(MCInst &Inst, uint64_t RegNo,
                                          uint64_t Address,
                                          const void *Decoder) {
  return decodeRegisterClass(Inst, RegNo, FalconMC::SRRegs, 16);
}

static DecodeStatus DecodePREDRegisterClass(MCInst &Inst, uint64_t RegNo,
                                             uint64_t Address,
                                             const void *Decoder) {
  if (RegNo >= 8)
    return MCDisassembler::Fail;
  return decodeRegisterClass(Inst, RegNo, FalconMC::FLAGRegs, 8);
}

template<unsigned N>
static DecodeStatus decodeUImmOperand(MCInst &Inst, uint64_t Imm) {
  if (!isUInt<N>(Imm))
    return MCDisassembler::Fail;
  Inst.addOperand(MCOperand::createImm(Imm));
  return MCDisassembler::Success;
}

template<unsigned N>
static DecodeStatus decodeSImmOperand(MCInst &Inst, uint64_t Imm) {
  if (!isUInt<N>(Imm))
    return MCDisassembler::Fail;
  Inst.addOperand(MCOperand::createImm(SignExtend64<N>(Imm)));
  return MCDisassembler::Success;
}


static DecodeStatus decodeU8ImmOperand(MCInst &Inst, uint64_t Imm,
                                       uint64_t Address, const void *Decoder) {
  return decodeUImmOperand<8>(Inst, Imm);
}

static DecodeStatus decodeU8XImmOperand(MCInst &Inst, uint64_t Imm,
                                       uint64_t Address, const void *Decoder) {
  return decodeUImmOperand<8>(Inst, Imm);
}

static DecodeStatus decodeU16ImmOperand(MCInst &Inst, uint64_t Imm,
                                        uint64_t Address, const void *Decoder) {
  return decodeUImmOperand<16>(Inst, Imm);
}

static DecodeStatus decodeU16XImmOperand(MCInst &Inst, uint64_t Imm,
                                        uint64_t Address, const void *Decoder) {
  return decodeUImmOperand<16>(Inst, Imm);
}

static DecodeStatus decodeS8ImmOperand(MCInst &Inst, uint64_t Imm,
                                       uint64_t Address, const void *Decoder) {
  return decodeSImmOperand<8>(Inst, Imm);
}

static DecodeStatus decodeS8XImmOperand(MCInst &Inst, uint64_t Imm,
                                       uint64_t Address, const void *Decoder) {
  return decodeSImmOperand<8>(Inst, Imm);
}

static DecodeStatus decodeS16ImmOperand(MCInst &Inst, uint64_t Imm,
                                        uint64_t Address, const void *Decoder) {
  return decodeSImmOperand<16>(Inst, Imm);
}

static DecodeStatus decodeS16XImmOperand(MCInst &Inst, uint64_t Imm,
                                       uint64_t Address, const void *Decoder) {
  return decodeSImmOperand<16>(Inst, Imm);
}

template<unsigned N>
static DecodeStatus decodePCOperand(MCInst &Inst, uint64_t Imm,
                                    uint64_t Address,
                                    const void *Decoder) {
  assert(isUInt<N>(Imm) && "Invalid PC-relative offset");
  uint64_t Value = SignExtend64<N>(Imm) + Address;

#if 0
  if (!tryAddingSymbolicOperand(Value, isBranch, Address, 2, N / 8,
                                Inst, Decoder))
#endif
    Inst.addOperand(MCOperand::createImm(Value));

  return MCDisassembler::Success;
}

static DecodeStatus decodeMemRegOperands(MCInst &Inst, uint64_t Field,
                                         uint64_t Address,
                                         const void *Decoder) {
  uint64_t RegEnc = Field & 0xf;
  assert(Field < 16 && "Invalid MemReg");
  Inst.addOperand(MCOperand::createReg(FalconMC::GPR32Regs[RegEnc]));
  return MCDisassembler::Success;
}

static DecodeStatus decodeMemRegRegOperands(MCInst &Inst, uint64_t Field,
                                            uint64_t Address,
                                            const void *Decoder) {
  uint64_t RegEnc = Field & 0xf;
  uint64_t IdxEnc = Field >> 4 & 0xf;
  assert(Field < 256 && "Invalid MemRegReg");
  Inst.addOperand(MCOperand::createReg(FalconMC::GPR32Regs[RegEnc]));
  Inst.addOperand(MCOperand::createReg(FalconMC::GPR32Regs[IdxEnc]));
  return MCDisassembler::Success;
}

template<unsigned shift>
static DecodeStatus decodeMemRegImmOperands(MCInst &Inst, uint64_t Field,
                                            uint64_t Address,
                                            const void *Decoder) {
  uint64_t RegEnc = Field & 0xf;
  uint64_t IdxEnc = Field >> 4 & 0xff;
  assert(Field < 4096 && "Invalid MemRegImm");
  Inst.addOperand(MCOperand::createReg(FalconMC::GPR32Regs[RegEnc]));
  Inst.addOperand(MCOperand::createImm(IdxEnc << shift));
  return MCDisassembler::Success;
}

template<unsigned shift>
static DecodeStatus decodeMemImmOperands(MCInst &Inst, uint64_t Field,
                                         uint64_t Address,
                                         const void *Decoder) {
  uint64_t IdxEnc = Field & 0xff;
  assert(Field < 256 && "Invalid MemImm");
  Inst.addOperand(MCOperand::createImm(IdxEnc << shift));
  return MCDisassembler::Success;
}

#include "FalconGenDisassemblerTables.inc"

DecodeStatus FalconDisassembler::getInstruction(MCInst &MI, uint64_t &Size,
                                                 ArrayRef<uint8_t> Bytes,
                                                 uint64_t Address,
                                                 raw_ostream &OS,
                                                 raw_ostream &CS) const {
  // Get the first two bytes of the instruction.
  Size = 0;
  const uint8_t *Table;
  if (Bytes.size() < 2)
    return MCDisassembler::Fail;

  // XXX: no v5 support here

  // The first byte usually determines the size.
  if (Bytes[0] < 0xc0) {
    // Sized...
    uint8_t Op = Bytes[0] & 0x3f;
    if (Op < 0x20) {
      Size = 3;
      Table = DecoderTableFalcon24;
    } else if (Op < 0x30) {
      Size = 4;
      Table = DecoderTableFalcon32;
    } else switch (Op) {
      case 0x3d:
        Size = 2;
        Table = DecoderTableFalcon16;
        break;
      case 0x30:
      case 0x34:
      case 0x36:
      case 0x38:
      case 0x39:
      case 0x3a:
      case 0x3b:
      case 0x3c:
        Size = 3;
        Table = DecoderTableFalcon24;
        break;
      case 0x31:
      case 0x37:
      case 0x3e: // v4+; not sized, but that's not important here
        Size = 4;
        Table = DecoderTableFalcon32;
        break;
      // 0x32, 0x33, 0x35, 0x3f invalid
      default:
        return MCDisassembler::Fail;
    }
  } else {
    // Unsized...
    if (Bytes[0] < 0xe0) {
      Size = 3;
      Table = DecoderTableFalcon24;
    } else if (Bytes[0] < 0xf0) {
      Size = 4;
      Table = DecoderTableFalcon32;
    } else switch (Bytes[0]) {
      case 0xf8:
      case 0xf9:
      case 0xfc:
        Size = 2;
        Table = DecoderTableFalcon16;
        break;
      case 0xf0:
      case 0xf2:
      case 0xf4:
      case 0xfa:
      case 0xfd:
      case 0xfe:
      case 0xff:
        Size = 3;
        Table = DecoderTableFalcon24;
        break;
      case 0xf1:
      case 0xf5:
        Size = 4;
        Table = DecoderTableFalcon32;
        break;
      // 0xf3, 0xf6, 0xf7, 0xfb invalid
      default:
        return MCDisassembler::Fail;
    }
  }

  // Read any remaining bytes.
  if (Bytes.size() < Size) {
    Size = 0;
    return MCDisassembler::Fail;
  }

  // Construct the instruction.
  uint64_t Inst = 0;
  for (uint64_t I = 0; I < Size; ++I)
    Inst |= uint64_t(Bytes[I]) << 8 * I;

  return decodeInstruction(Table, MI, Inst, Address, this, STI);
}
