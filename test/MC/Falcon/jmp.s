# RUN: llvm-mc -triple=falcon0s -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3s -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4s -show-encoding %s | FileCheck %s

# CHECK: jmp 0x0                # encoding: [0xf4,0x20,0x00]
# CHECK: jmp 0xff               # encoding: [0xf4,0x20,0xff]
# CHECK: jmp 0x100              # encoding: [0xf5,0x20,0x00,0x01]
# CHECK: jmp 0xffff             # encoding: [0xf5,0x20,0xff,0xff]
jmp 0
jmp 0xff
jmp 0x100
jmp 0xffff

# CHECK: jmp %r0                # encoding: [0xf9,0x04]
# CHECK: jmp %r15               # encoding: [0xf9,0xf4]
jmp %r0
jmp %r15


# CHECK: call 0x0               # encoding: [0xf4,0x21,0x00]
# CHECK: call 0xff              # encoding: [0xf4,0x21,0xff]
# CHECK: call 0x100             # encoding: [0xf5,0x21,0x00,0x01]
# CHECK: call 0xffff            # encoding: [0xf5,0x21,0xff,0xff]
call 0
call 0xff
call 0x100
call 0xffff

# CHECK: call %r0               # encoding: [0xf9,0x05]
# CHECK: call %r15              # encoding: [0xf9,0xf5]
call %r0
call %r15
