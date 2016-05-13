# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: ins %r0, %r0, 0       # encoding: [0xcb,0x00,0x00]
# CHECK: ins %r0, %r15, 0      # encoding: [0xcb,0xf0,0x00]
# CHECK: ins %r15, %r0, 0      # encoding: [0xcb,0x0f,0x00]
# CHECK: ins %r0, %r0, 255     # encoding: [0xcb,0x00,0xff]
# CHECK: ins %r0, %r0, 256     # encoding: [0xeb,0x00,0x00,0x01]
# CHECK: ins %r0, %r15, 256    # encoding: [0xeb,0xf0,0x00,0x01]
# CHECK: ins %r15, %r0, 256    # encoding: [0xeb,0x0f,0x00,0x01]
# CHECK: ins %r0, %r0, 65535   # encoding: [0xeb,0x00,0xff,0xff]
ins %r0, %r0, 0
ins %r0, %r15, 0
ins %r15, %r0, 0
ins %r0, %r0, 255
ins %r0, %r0, 256
ins %r0, %r15, 256
ins %r15, %r0, 256
ins %r0, %r0, 65535
