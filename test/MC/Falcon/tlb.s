# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: itlb %r0           # encoding: [0xf9,0x08]
# CHECK: itlb %r15          # encoding: [0xf9,0xf8]
itlb %r0
itlb %r15

# CHECK: ptlb %r0, %r0      # encoding: [0xfe,0x00,0x02]
# CHECK: ptlb %r0, %r15     # encoding: [0xfe,0xf0,0x02]
# CHECK: ptlb %r15, %r0     # encoding: [0xfe,0x0f,0x02]
ptlb %r0, %r0
ptlb %r0, %r15
ptlb %r15, %r0

# CHECK: vtlb %r0, %r0      # encoding: [0xfe,0x00,0x03]
# CHECK: vtlb %r0, %r15     # encoding: [0xfe,0xf0,0x03]
# CHECK: vtlb %r15, %r0     # encoding: [0xfe,0x0f,0x03]
vtlb %r0, %r0
vtlb %r0, %r15
vtlb %r15, %r0
