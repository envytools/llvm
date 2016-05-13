# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: getf %r0, %p0         # encoding: [0xf0,0x0c,0x00]
# CHECK: getf %r0, %p1         # encoding: [0xf0,0x0c,0x01]
# CHECK: getf %r0, %p2         # encoding: [0xf0,0x0c,0x02]
# CHECK: getf %r0, %p3         # encoding: [0xf0,0x0c,0x03]
# CHECK: getf %r0, %p4         # encoding: [0xf0,0x0c,0x04]
# CHECK: getf %r0, %p5         # encoding: [0xf0,0x0c,0x05]
# CHECK: getf %r0, %p6         # encoding: [0xf0,0x0c,0x06]
# CHECK: getf %r0, %p7         # encoding: [0xf0,0x0c,0x07]
# CHECK: getf %r0, %ccc        # encoding: [0xf0,0x0c,0x08]
# CHECK: getf %r0, %cco        # encoding: [0xf0,0x0c,0x09]
# CHECK: getf %r0, %ccs        # encoding: [0xf0,0x0c,0x0a]
# CHECK: getf %r0, %ccz        # encoding: [0xf0,0x0c,0x0b]
# CHECK: getf %r0, %ie0        # encoding: [0xf0,0x0c,0x10]
# CHECK: getf %r0, %ie1        # encoding: [0xf0,0x0c,0x11]
# CHECK: getf %r0, %sie0       # encoding: [0xf0,0x0c,0x14]
# CHECK: getf %r0, %sie1       # encoding: [0xf0,0x0c,0x15]
# CHECK: getf %r0, %ta         # encoding: [0xf0,0x0c,0x18]
# CHECK: getf %r15, %p0        # encoding: [0xf0,0xfc,0x00]
getf %r0, %p0
getf %r0, %p1
getf %r0, %p2
getf %r0, %p3
getf %r0, %p4
getf %r0, %p5
getf %r0, %p6
getf %r0, %p7
getf %r0, %ccc
getf %r0, %cco
getf %r0, %ccs
getf %r0, %ccz
getf %r0, %ie0
getf %r0, %ie1
getf %r0, %sie0
getf %r0, %sie1
getf %r0, %ta
getf %r15, %p0

# CHECK: getf %r0, %r0         # encoding: [0xfe,0x00,0x0c]
# CHECK: getf %r0, %r15        # encoding: [0xfe,0xf0,0x0c]
# CHECK: getf %r15, %r0        # encoding: [0xfe,0x0f,0x0c]
getf %r0, %r0
getf %r0, %r15
getf %r15, %r0
