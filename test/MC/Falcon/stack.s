# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: push %r0              # encoding: [0xf9,0x00]
# CHECK: push %r15             # encoding: [0xf9,0xf0]
push %r0
push %r15

# CHECK: pop %r0               # encoding: [0xfc,0x00]
# CHECK: pop %r15              # encoding: [0xfc,0xf0]
pop %r0
pop %r15

# CHECK: addsp %r0             # encoding: [0xf9,0x01]
# CHECK: addsp %r15            # encoding: [0xf9,0xf1]
addsp %r0
addsp %r15

# CHECK: addsp 0               # encoding: [0xf4,0x30,0x00]
# CHECK: addsp -1              # encoding: [0xf4,0x30,0xff]
# CHECK: addsp -128            # encoding: [0xf4,0x30,0x80]
# CHECK: addsp 127             # encoding: [0xf4,0x30,0x7f]
# CHECK: addsp 128             # encoding: [0xf5,0x30,0x80,0x00]
# CHECK: addsp -129            # encoding: [0xf5,0x30,0x7f,0xff]
# CHECK: addsp -32768          # encoding: [0xf5,0x30,0x00,0x80]
# CHECK: addsp 32767           # encoding: [0xf5,0x30,0xff,0x7f]
addsp 0
addsp -1
addsp -128
addsp 127
addsp 128
addsp -129
addsp -32768
addsp 32767
