# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: extrs %r0, %r0, %r0     # encoding: [0xff,0x00,0x03]
# CHECK: extrs %r0, %r15, %r0    # encoding: [0xff,0xf0,0x03]
# CHECK: extrs %r0, %r0, %r15    # encoding: [0xff,0x0f,0x03]
# CHECK: extrs %r15, %r0, %r0    # encoding: [0xff,0x00,0xf3]
extrs %r0, %r0, %r0
extrs %r0, %r15, %r0
extrs %r0, %r0, %r15
extrs %r15, %r0, %r0

# CHECK: extrs %r0, %r0, 0       # encoding: [0xc3,0x00,0x00]
# CHECK: extrs %r0, %r15, 0      # encoding: [0xc3,0xf0,0x00]
# CHECK: extrs %r15, %r0, 0      # encoding: [0xc3,0x0f,0x00]
# CHECK: extrs %r0, %r0, 255     # encoding: [0xc3,0x00,0xff]
# CHECK: extrs %r0, %r0, 256     # encoding: [0xe3,0x00,0x00,0x01]
# CHECK: extrs %r0, %r15, 256    # encoding: [0xe3,0xf0,0x00,0x01]
# CHECK: extrs %r15, %r0, 256    # encoding: [0xe3,0x0f,0x00,0x01]
# CHECK: extrs %r0, %r0, 65535   # encoding: [0xe3,0x00,0xff,0xff]
extrs %r0, %r0, 0
extrs %r0, %r15, 0
extrs %r15, %r0, 0
extrs %r0, %r0, 255
extrs %r0, %r0, 256
extrs %r0, %r15, 256
extrs %r15, %r0, 256
extrs %r0, %r0, 65535


# CHECK: extr %r0, %r0, %r0     # encoding: [0xff,0x00,0x07]
# CHECK: extr %r0, %r15, %r0    # encoding: [0xff,0xf0,0x07]
# CHECK: extr %r0, %r0, %r15    # encoding: [0xff,0x0f,0x07]
# CHECK: extr %r15, %r0, %r0    # encoding: [0xff,0x00,0xf7]
extr %r0, %r0, %r0
extr %r0, %r15, %r0
extr %r0, %r0, %r15
extr %r15, %r0, %r0

# CHECK: extr %r0, %r0, 0       # encoding: [0xc7,0x00,0x00]
# CHECK: extr %r0, %r15, 0      # encoding: [0xc7,0xf0,0x00]
# CHECK: extr %r15, %r0, 0      # encoding: [0xc7,0x0f,0x00]
# CHECK: extr %r0, %r0, 255     # encoding: [0xc7,0x00,0xff]
# CHECK: extr %r0, %r0, 256     # encoding: [0xe7,0x00,0x00,0x01]
# CHECK: extr %r0, %r15, 256    # encoding: [0xe7,0xf0,0x00,0x01]
# CHECK: extr %r15, %r0, 256    # encoding: [0xe7,0x0f,0x00,0x01]
# CHECK: extr %r0, %r0, 65535   # encoding: [0xe7,0x00,0xff,0xff]
extr %r0, %r0, 0
extr %r0, %r15, 0
extr %r15, %r0, 0
extr %r0, %r0, 255
extr %r0, %r0, 256
extr %r0, %r15, 256
extr %r15, %r0, 256
extr %r0, %r0, 65535
