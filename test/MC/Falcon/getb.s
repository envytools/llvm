# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: getb %r0, %r0, %r0     # encoding: [0xff,0x00,0x08]
# CHECK: getb %r0, %r15, %r0    # encoding: [0xff,0xf0,0x08]
# CHECK: getb %r0, %r0, %r15    # encoding: [0xff,0x0f,0x08]
# CHECK: getb %r15, %r0, %r0    # encoding: [0xff,0x00,0xf8]
getb %r0, %r0, %r0
getb %r0, %r15, %r0
getb %r0, %r0, %r15
getb %r15, %r0, %r0

# CHECK: getb %r0, %r0, 0       # encoding: [0xc8,0x00,0x00]
# CHECK: getb %r0, %r15, 0      # encoding: [0xc8,0xf0,0x00]
# CHECK: getb %r15, %r0, 0      # encoding: [0xc8,0x0f,0x00]
# CHECK: getb %r0, %r0, 255     # encoding: [0xc8,0x00,0xff]
getb %r0, %r0, 0
getb %r0, %r15, 0
getb %r15, %r0, 0
getb %r0, %r0, 255
