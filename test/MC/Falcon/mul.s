# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: mulu %r0, %r0          # encoding: [0xfd,0x00,0x00]
# CHECK: mulu %r15, %r0         # encoding: [0xfd,0xf0,0x00]
# CHECK: mulu %r0, %r15         # encoding: [0xfd,0x0f,0x00]
mulu %r0, %r0
mulu %r15, %r0
mulu %r0, %r15

# CHECK: mulu %r0, %r0, %r0     # encoding: [0xff,0x00,0x00]
# CHECK: mulu %r0, %r15, %r0    # encoding: [0xff,0xf0,0x00]
# CHECK: mulu %r0, %r0, %r15    # encoding: [0xff,0x0f,0x00]
# CHECK: mulu %r15, %r0, %r0    # encoding: [0xff,0x00,0xf0]
mulu %r0, %r0, %r0
mulu %r0, %r15, %r0
mulu %r0, %r0, %r15
mulu %r15, %r0, %r0

# CHECK: mulu %r0, 0            # encoding: [0xf0,0x00,0x00]
# CHECK: mulu %r15, 0           # encoding: [0xf0,0xf0,0x00]
# CHECK: mulu %r0, 255          # encoding: [0xf0,0x00,0xff]
# CHECK: mulu %r0, 256          # encoding: [0xf1,0x00,0x00,0x01]
# CHECK: mulu %r15, 256         # encoding: [0xf1,0xf0,0x00,0x01]
# CHECK: mulu %r0, 65535        # encoding: [0xf1,0x00,0xff,0xff]
mulu %r0, 0
mulu %r15, 0
mulu %r0, 255
mulu %r0, 256
mulu %r15, 256
mulu %r0, 65535

# CHECK: mulu %r0, %r0, 0       # encoding: [0xc0,0x00,0x00]
# CHECK: mulu %r0, %r15, 0      # encoding: [0xc0,0xf0,0x00]
# CHECK: mulu %r15, %r0, 0      # encoding: [0xc0,0x0f,0x00]
# CHECK: mulu %r0, %r0, 255     # encoding: [0xc0,0x00,0xff]
# CHECK: mulu %r0, %r0, 256     # encoding: [0xe0,0x00,0x00,0x01]
# CHECK: mulu %r0, %r15, 256    # encoding: [0xe0,0xf0,0x00,0x01]
# CHECK: mulu %r15, %r0, 256    # encoding: [0xe0,0x0f,0x00,0x01]
# CHECK: mulu %r0, %r0, 65535   # encoding: [0xe0,0x00,0xff,0xff]
mulu %r0, %r0, 0
mulu %r0, %r15, 0
mulu %r15, %r0, 0
mulu %r0, %r0, 255
mulu %r0, %r0, 256
mulu %r0, %r15, 256
mulu %r15, %r0, 256
mulu %r0, %r0, 65535


# CHECK: muls %r0, %r0          # encoding: [0xfd,0x00,0x01]
# CHECK: muls %r15, %r0         # encoding: [0xfd,0xf0,0x01]
# CHECK: muls %r0, %r15         # encoding: [0xfd,0x0f,0x01]
muls %r0, %r0
muls %r15, %r0
muls %r0, %r15

# CHECK: muls %r0, %r0, %r0     # encoding: [0xff,0x00,0x01]
# CHECK: muls %r0, %r15, %r0    # encoding: [0xff,0xf0,0x01]
# CHECK: muls %r0, %r0, %r15    # encoding: [0xff,0x0f,0x01]
# CHECK: muls %r15, %r0, %r0    # encoding: [0xff,0x00,0xf1]
muls %r0, %r0, %r0
muls %r0, %r15, %r0
muls %r0, %r0, %r15
muls %r15, %r0, %r0

# CHECK: muls %r0, 0            # encoding: [0xf0,0x01,0x00]
# CHECK: muls %r15, 0           # encoding: [0xf0,0xf1,0x00]
# CHECK: muls %r0, 127          # encoding: [0xf0,0x01,0x7f]
# CHECK: muls %r0, -128         # encoding: [0xf0,0x01,0x80]
# CHECK: muls %r0, -1           # encoding: [0xf0,0x01,0xff]
# CHECK: muls %r0, 128          # encoding: [0xf1,0x01,0x80,0x00]
# CHECK: muls %r15, 128         # encoding: [0xf1,0xf1,0x80,0x00]
# CHECK: muls %r0, -129         # encoding: [0xf1,0x01,0x7f,0xff]
# CHECK: muls %r0, 32767        # encoding: [0xf1,0x01,0xff,0x7f]
# CHECK: muls %r0, -32768       # encoding: [0xf1,0x01,0x00,0x80]
muls %r0, 0
muls %r15, 0
muls %r0, 127
muls %r0, -128
muls %r0, -1
muls %r0, 128
muls %r15, 128
muls %r0, -129
muls %r0, 32767
muls %r0, -32768

# CHECK: muls %r0, %r0, 0       # encoding: [0xc1,0x00,0x00]
# CHECK: muls %r0, %r15, 0      # encoding: [0xc1,0xf0,0x00]
# CHECK: muls %r15, %r0, 0      # encoding: [0xc1,0x0f,0x00]
# CHECK: muls %r0, %r0, 127     # encoding: [0xc1,0x00,0x7f]
# CHECK: muls %r0, %r0, -128    # encoding: [0xc1,0x00,0x80]
# CHECK: muls %r0, %r0, -1      # encoding: [0xc1,0x00,0xff]
# CHECK: muls %r0, %r0, 128     # encoding: [0xe1,0x00,0x80,0x00]
# CHECK: muls %r0, %r15, 128    # encoding: [0xe1,0xf0,0x80,0x00]
# CHECK: muls %r15, %r0, 128    # encoding: [0xe1,0x0f,0x80,0x00]
# CHECK: muls %r0, %r0, -129    # encoding: [0xe1,0x00,0x7f,0xff]
# CHECK: muls %r0, %r0, 32767   # encoding: [0xe1,0x00,0xff,0x7f]
# CHECK: muls %r0, %r0, -32768  # encoding: [0xe1,0x00,0x00,0x80]
muls %r0, %r0, 0
muls %r0, %r15, 0
muls %r15, %r0, 0
muls %r0, %r0, 127
muls %r0, %r0, -128
muls %r0, %r0, -1
muls %r0, %r0, 128
muls %r0, %r15, 128
muls %r15, %r0, 128
muls %r0, %r0, -129
muls %r0, %r0, 32767
muls %r0, %r0, -32768
