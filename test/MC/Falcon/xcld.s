# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: xcld %r0, %r0      # encoding: [0xfa,0x00,0x04]
# CHECK: xcld %r0, %r15     # encoding: [0xfa,0x0f,0x04]
# CHECK: xcld %r15, %r0     # encoding: [0xfa,0xf0,0x04]
xcld %r0, %r0
xcld %r0, %r15
xcld %r15, %r0

# CHECK: xdld %r0, %r0      # encoding: [0xfa,0x00,0x05]
# CHECK: xdld %r0, %r15     # encoding: [0xfa,0x0f,0x05]
# CHECK: xdld %r15, %r0     # encoding: [0xfa,0xf0,0x05]
xdld %r0, %r0
xdld %r0, %r15
xdld %r15, %r0

# CHECK: xdst %r0, %r0      # encoding: [0xfa,0x00,0x06]
# CHECK: xdst %r0, %r15     # encoding: [0xfa,0x0f,0x06]
# CHECK: xdst %r15, %r0     # encoding: [0xfa,0xf0,0x06]
xdst %r0, %r0
xdst %r0, %r15
xdst %r15, %r0
