# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: div %r0, %r0, %r0     # encoding: [0xff,0x00,0x0c]
# CHECK: div %r0, %r15, %r0    # encoding: [0xff,0xf0,0x0c]
# CHECK: div %r0, %r0, %r15    # encoding: [0xff,0x0f,0x0c]
# CHECK: div %r15, %r0, %r0    # encoding: [0xff,0x00,0xfc]
div %r0, %r0, %r0
div %r0, %r15, %r0
div %r0, %r0, %r15
div %r15, %r0, %r0

# CHECK: div %r0, %r0, 0       # encoding: [0xcc,0x00,0x00]
# CHECK: div %r0, %r15, 0      # encoding: [0xcc,0xf0,0x00]
# CHECK: div %r15, %r0, 0      # encoding: [0xcc,0x0f,0x00]
# CHECK: div %r0, %r0, 255     # encoding: [0xcc,0x00,0xff]
# CHECK: div %r0, %r0, 256     # encoding: [0xec,0x00,0x00,0x01]
# CHECK: div %r0, %r15, 256    # encoding: [0xec,0xf0,0x00,0x01]
# CHECK: div %r15, %r0, 256    # encoding: [0xec,0x0f,0x00,0x01]
# CHECK: div %r0, %r0, 65535   # encoding: [0xec,0x00,0xff,0xff]
div %r0, %r0, 0
div %r0, %r15, 0
div %r15, %r0, 0
div %r0, %r0, 255
div %r0, %r0, 256
div %r0, %r15, 256
div %r15, %r0, 256
div %r0, %r0, 65535


# CHECK: mod %r0, %r0, %r0     # encoding: [0xff,0x00,0x0d]
# CHECK: mod %r0, %r15, %r0    # encoding: [0xff,0xf0,0x0d]
# CHECK: mod %r0, %r0, %r15    # encoding: [0xff,0x0f,0x0d]
# CHECK: mod %r15, %r0, %r0    # encoding: [0xff,0x00,0xfd]
mod %r0, %r0, %r0
mod %r0, %r15, %r0
mod %r0, %r0, %r15
mod %r15, %r0, %r0

# CHECK: mod %r0, %r0, 0       # encoding: [0xcd,0x00,0x00]
# CHECK: mod %r0, %r15, 0      # encoding: [0xcd,0xf0,0x00]
# CHECK: mod %r15, %r0, 0      # encoding: [0xcd,0x0f,0x00]
# CHECK: mod %r0, %r0, 255     # encoding: [0xcd,0x00,0xff]
# CHECK: mod %r0, %r0, 256     # encoding: [0xed,0x00,0x00,0x01]
# CHECK: mod %r0, %r15, 256    # encoding: [0xed,0xf0,0x00,0x01]
# CHECK: mod %r15, %r0, 256    # encoding: [0xed,0x0f,0x00,0x01]
# CHECK: mod %r0, %r0, 65535   # encoding: [0xed,0x00,0xff,0xff]
mod %r0, %r0, 0
mod %r0, %r15, 0
mod %r15, %r0, 0
mod %r0, %r0, 255
mod %r0, %r0, 256
mod %r0, %r15, 256
mod %r15, %r0, 256
mod %r0, %r0, 65535
