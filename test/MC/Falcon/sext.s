# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: sext %r0, %r0          # encoding: [0xfd,0x00,0x02]
# CHECK: sext %r15, %r0         # encoding: [0xfd,0xf0,0x02]
# CHECK: sext %r0, %r15         # encoding: [0xfd,0x0f,0x02]
sext %r0, %r0
sext %r15, %r0
sext %r0, %r15

# CHECK: sext %r0, %r0, %r0     # encoding: [0xff,0x00,0x02]
# CHECK: sext %r0, %r15, %r0    # encoding: [0xff,0xf0,0x02]
# CHECK: sext %r0, %r0, %r15    # encoding: [0xff,0x0f,0x02]
# CHECK: sext %r15, %r0, %r0    # encoding: [0xff,0x00,0xf2]
sext %r0, %r0, %r0
sext %r0, %r15, %r0
sext %r0, %r0, %r15
sext %r15, %r0, %r0

# CHECK: sext %r0, 0            # encoding: [0xf0,0x02,0x00]
# CHECK: sext %r15, 0           # encoding: [0xf0,0xf2,0x00]
# CHECK: sext %r0, 255          # encoding: [0xf0,0x02,0xff]
sext %r0, 0
sext %r15, 0
sext %r0, 255

# CHECK: sext %r0, %r0, 0       # encoding: [0xc2,0x00,0x00]
# CHECK: sext %r0, %r15, 0      # encoding: [0xc2,0xf0,0x00]
# CHECK: sext %r15, %r0, 0      # encoding: [0xc2,0x0f,0x00]
# CHECK: sext %r0, %r0, 255     # encoding: [0xc2,0x00,0xff]
sext %r0, %r0, 0
sext %r0, %r15, 0
sext %r15, %r0, 0
sext %r0, %r0, 255
