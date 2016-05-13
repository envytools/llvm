# RUN: llvm-mc -triple=falcon0s -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3s -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4s -show-encoding %s | FileCheck %s

# CHECK: cc 0                  # encoding: [0xf4,0x3c,0x00]
# CHECK: cc 255                # encoding: [0xf4,0x3c,0xff]
# CHECK: cc 256                # encoding: [0xf5,0x3c,0x00,0x01]
# CHECK: cc 65535              # encoding: [0xf5,0x3c,0xff,0xff]
cc 0
cc 0xff
cc 0x100
cc 0xffff

# CHECK: cc 0, %r0             # encoding: [0xf2,0x0c,0x00]
# CHECK: cc 0, %r15            # encoding: [0xf2,0xfc,0x00]
# CHECK: cc 255, %r0           # encoding: [0xf2,0x0c,0xff]
cc 0, %r0
cc 0, %r15
cc 255, %r0
