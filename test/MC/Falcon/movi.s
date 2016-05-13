# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: mov %r0, 0            # encoding: [0xf0,0x07,0x00]
# CHECK: mov %r15, 0           # encoding: [0xf0,0xf7,0x00]
# CHECK: mov %r0, -1           # encoding: [0xf0,0x07,0xff]
# CHECK: mov %r0, 127          # encoding: [0xf0,0x07,0x7f]
# CHECK: mov %r0, -128         # encoding: [0xf0,0x07,0x80]
# CHECK: mov %r0, 256          # encoding: [0xf1,0x07,0x00,0x01]
# CHECK: mov %r15, 256         # encoding: [0xf1,0xf7,0x00,0x01]
# CHECK: mov %r0, 32767        # encoding: [0xf1,0x07,0xff,0x7f]
# CHECK: mov %r0, -32768       # encoding: [0xf1,0x07,0x00,0x80]
# CHECK: mov %r0, -129         # encoding: [0xf1,0x07,0x7f,0xff]
# CHECK: mov %r0, 128          # encoding: [0xf1,0x07,0x80,0x00]
mov %r0, 0
mov %r15, 0
mov %r0, -1
mov %r0, 127
mov %r0, -128
mov %r0, 256
mov %r15, 256
mov %r0, 32767
mov %r0, -32768
mov %r0, -129
mov %r0, 128

# CHECK: sethi %r0, 0          # encoding: [0xf0,0x03,0x00]
# CHECK: sethi %r15, 0         # encoding: [0xf0,0xf3,0x00]
# CHECK: sethi %r0, 255        # encoding: [0xf0,0x03,0xff]
# CHECK: sethi %r0, 256        # encoding: [0xf1,0x03,0x00,0x01]
# CHECK: sethi %r15, 256       # encoding: [0xf1,0xf3,0x00,0x01]
# CHECK: sethi %r0, 65535      # encoding: [0xf1,0x03,0xff,0xff]
sethi %r0, 0
sethi %r15, 0
sethi %r0, 255
sethi %r0, 256
sethi %r15, 256
sethi %r0, 65535
