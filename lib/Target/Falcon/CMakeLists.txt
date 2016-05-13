set(LLVM_TARGET_DEFINITIONS Falcon.td)

tablegen(LLVM FalconGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM FalconGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM FalconGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM FalconGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM FalconGenDisassemblerTables.inc -gen-disassembler)
tablegen(LLVM FalconGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM FalconGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM FalconGenCallingConv.inc -gen-callingconv)
tablegen(LLVM FalconGenSubtargetInfo.inc -gen-subtarget)
add_public_tablegen_target(FalconCommonTableGen)

add_llvm_target(FalconCodeGen
  FalconAsmPrinter.cpp
  FalconFrameLowering.cpp
  FalconInstrInfo.cpp
  FalconISelDAGToDAG.cpp
  FalconISelLowering.cpp
  FalconMCInstLower.cpp
  FalconRegisterInfo.cpp
  FalconSubtarget.cpp
  FalconTargetMachine.cpp
  )

add_subdirectory(AsmParser)
add_subdirectory(Disassembler)
add_subdirectory(InstPrinter)
add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)
