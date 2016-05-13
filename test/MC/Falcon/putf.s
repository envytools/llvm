# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: putf %p0, %r0         # encoding: [0xf2,0x08,0x00]
# CHECK: putf %p1, %r0         # encoding: [0xf2,0x08,0x01]
# CHECK: putf %p2, %r0         # encoding: [0xf2,0x08,0x02]
# CHECK: putf %p3, %r0         # encoding: [0xf2,0x08,0x03]
# CHECK: putf %p4, %r0         # encoding: [0xf2,0x08,0x04]
# CHECK: putf %p5, %r0         # encoding: [0xf2,0x08,0x05]
# CHECK: putf %p6, %r0         # encoding: [0xf2,0x08,0x06]
# CHECK: putf %p7, %r0         # encoding: [0xf2,0x08,0x07]
# CHECK: putf %ccc, %r0        # encoding: [0xf2,0x08,0x08]
# CHECK: putf %cco, %r0        # encoding: [0xf2,0x08,0x09]
# CHECK: putf %ccs, %r0        # encoding: [0xf2,0x08,0x0a]
# CHECK: putf %ccz, %r0        # encoding: [0xf2,0x08,0x0b]
# CHECK: putf %ie0, %r0        # encoding: [0xf2,0x08,0x10]
# CHECK: putf %ie1, %r0        # encoding: [0xf2,0x08,0x11]
# CHECK: putf %sie0, %r0       # encoding: [0xf2,0x08,0x14]
# CHECK: putf %sie1, %r0       # encoding: [0xf2,0x08,0x15]
# CHECK: putf %ta, %r0         # encoding: [0xf2,0x08,0x18]
# CHECK: putf %p0, %r15        # encoding: [0xf2,0xf8,0x00]
putf %p0, %r0
putf %p1, %r0
putf %p2, %r0
putf %p3, %r0
putf %p4, %r0
putf %p5, %r0
putf %p6, %r0
putf %p7, %r0
putf %ccc, %r0
putf %cco, %r0
putf %ccs, %r0
putf %ccz, %r0
putf %ie0, %r0
putf %ie1, %r0
putf %sie0, %r0
putf %sie1, %r0
putf %ta, %r0
putf %p0, %r15

# CHECK: putf %r0, %r0         # encoding: [0xfa,0x00,0x08]
# CHECK: putf %r0, %r15        # encoding: [0xfa,0xf0,0x08]
# CHECK: putf %r15, %r0        # encoding: [0xfa,0x0f,0x08]
putf %r0, %r0
putf %r0, %r15
putf %r15, %r0
