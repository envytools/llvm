# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: and %r0, %r0          # encoding: [0xfd,0x00,0x04]
# CHECK: and %r15, %r0         # encoding: [0xfd,0xf0,0x04]
# CHECK: and %r0, %r15         # encoding: [0xfd,0x0f,0x04]
and %r0, %r0
and %r15, %r0
and %r0, %r15

# CHECK: and %r0, %r0, %r0     # encoding: [0xff,0x00,0x04]
# CHECK: and %r0, %r15, %r0    # encoding: [0xff,0xf0,0x04]
# CHECK: and %r0, %r0, %r15    # encoding: [0xff,0x0f,0x04]
# CHECK: and %r15, %r0, %r0    # encoding: [0xff,0x00,0xf4]
and %r0, %r0, %r0
and %r0, %r15, %r0
and %r0, %r0, %r15
and %r15, %r0, %r0

# CHECK: and %r0, 0            # encoding: [0xf0,0x04,0x00]
# CHECK: and %r15, 0           # encoding: [0xf0,0xf4,0x00]
# CHECK: and %r0, 255          # encoding: [0xf0,0x04,0xff]
# CHECK: and %r0, 256          # encoding: [0xf1,0x04,0x00,0x01]
# CHECK: and %r15, 256         # encoding: [0xf1,0xf4,0x00,0x01]
# CHECK: and %r0, 65535        # encoding: [0xf1,0x04,0xff,0xff]
and %r0, 0
and %r15, 0
and %r0, 255
and %r0, 256
and %r15, 256
and %r0, 65535

# CHECK: and %r0, %r0, 0       # encoding: [0xc4,0x00,0x00]
# CHECK: and %r0, %r15, 0      # encoding: [0xc4,0xf0,0x00]
# CHECK: and %r15, %r0, 0      # encoding: [0xc4,0x0f,0x00]
# CHECK: and %r0, %r0, 255     # encoding: [0xc4,0x00,0xff]
# CHECK: and %r0, %r0, 256     # encoding: [0xe4,0x00,0x00,0x01]
# CHECK: and %r0, %r15, 256    # encoding: [0xe4,0xf0,0x00,0x01]
# CHECK: and %r15, %r0, 256    # encoding: [0xe4,0x0f,0x00,0x01]
# CHECK: and %r0, %r0, 65535   # encoding: [0xe4,0x00,0xff,0xff]
and %r0, %r0, 0
and %r0, %r15, 0
and %r15, %r0, 0
and %r0, %r0, 255
and %r0, %r0, 256
and %r0, %r15, 256
and %r15, %r0, 256
and %r0, %r0, 65535


# CHECK: or %r0, %r0          # encoding: [0xfd,0x00,0x05]
# CHECK: or %r15, %r0         # encoding: [0xfd,0xf0,0x05]
# CHECK: or %r0, %r15         # encoding: [0xfd,0x0f,0x05]
or %r0, %r0
or %r15, %r0
or %r0, %r15

# CHECK: or %r0, %r0, %r0     # encoding: [0xff,0x00,0x05]
# CHECK: or %r0, %r15, %r0    # encoding: [0xff,0xf0,0x05]
# CHECK: or %r0, %r0, %r15    # encoding: [0xff,0x0f,0x05]
# CHECK: or %r15, %r0, %r0    # encoding: [0xff,0x00,0xf5]
or %r0, %r0, %r0
or %r0, %r15, %r0
or %r0, %r0, %r15
or %r15, %r0, %r0

# CHECK: or %r0, 0            # encoding: [0xf0,0x05,0x00]
# CHECK: or %r15, 0           # encoding: [0xf0,0xf5,0x00]
# CHECK: or %r0, 255          # encoding: [0xf0,0x05,0xff]
# CHECK: or %r0, 256          # encoding: [0xf1,0x05,0x00,0x01]
# CHECK: or %r15, 256         # encoding: [0xf1,0xf5,0x00,0x01]
# CHECK: or %r0, 65535        # encoding: [0xf1,0x05,0xff,0xff]
or %r0, 0
or %r15, 0
or %r0, 255
or %r0, 256
or %r15, 256
or %r0, 65535

# CHECK: or %r0, %r0, 0       # encoding: [0xc5,0x00,0x00]
# CHECK: or %r0, %r15, 0      # encoding: [0xc5,0xf0,0x00]
# CHECK: or %r15, %r0, 0      # encoding: [0xc5,0x0f,0x00]
# CHECK: or %r0, %r0, 255     # encoding: [0xc5,0x00,0xff]
# CHECK: or %r0, %r0, 256     # encoding: [0xe5,0x00,0x00,0x01]
# CHECK: or %r0, %r15, 256    # encoding: [0xe5,0xf0,0x00,0x01]
# CHECK: or %r15, %r0, 256    # encoding: [0xe5,0x0f,0x00,0x01]
# CHECK: or %r0, %r0, 65535   # encoding: [0xe5,0x00,0xff,0xff]
or %r0, %r0, 0
or %r0, %r15, 0
or %r15, %r0, 0
or %r0, %r0, 255
or %r0, %r0, 256
or %r0, %r15, 256
or %r15, %r0, 256
or %r0, %r0, 65535


# CHECK: xor %r0, %r0          # encoding: [0xfd,0x00,0x06]
# CHECK: xor %r15, %r0         # encoding: [0xfd,0xf0,0x06]
# CHECK: xor %r0, %r15         # encoding: [0xfd,0x0f,0x06]
xor %r0, %r0
xor %r15, %r0
xor %r0, %r15

# CHECK: xor %r0, %r0, %r0     # encoding: [0xff,0x00,0x06]
# CHECK: xor %r0, %r15, %r0    # encoding: [0xff,0xf0,0x06]
# CHECK: xor %r0, %r0, %r15    # encoding: [0xff,0x0f,0x06]
# CHECK: xor %r15, %r0, %r0    # encoding: [0xff,0x00,0xf6]
xor %r0, %r0, %r0
xor %r0, %r15, %r0
xor %r0, %r0, %r15
xor %r15, %r0, %r0

# CHECK: xor %r0, 0            # encoding: [0xf0,0x06,0x00]
# CHECK: xor %r15, 0           # encoding: [0xf0,0xf6,0x00]
# CHECK: xor %r0, 255          # encoding: [0xf0,0x06,0xff]
# CHECK: xor %r0, 256          # encoding: [0xf1,0x06,0x00,0x01]
# CHECK: xor %r15, 256         # encoding: [0xf1,0xf6,0x00,0x01]
# CHECK: xor %r0, 65535        # encoding: [0xf1,0x06,0xff,0xff]
xor %r0, 0
xor %r15, 0
xor %r0, 255
xor %r0, 256
xor %r15, 256
xor %r0, 65535

# CHECK: xor %r0, %r0, 0       # encoding: [0xc6,0x00,0x00]
# CHECK: xor %r0, %r15, 0      # encoding: [0xc6,0xf0,0x00]
# CHECK: xor %r15, %r0, 0      # encoding: [0xc6,0x0f,0x00]
# CHECK: xor %r0, %r0, 255     # encoding: [0xc6,0x00,0xff]
# CHECK: xor %r0, %r0, 256     # encoding: [0xe6,0x00,0x00,0x01]
# CHECK: xor %r0, %r15, 256    # encoding: [0xe6,0xf0,0x00,0x01]
# CHECK: xor %r15, %r0, 256    # encoding: [0xe6,0x0f,0x00,0x01]
# CHECK: xor %r0, %r0, 65535   # encoding: [0xe6,0x00,0xff,0xff]
xor %r0, %r0, 0
xor %r0, %r15, 0
xor %r15, %r0, 0
xor %r0, %r0, 255
xor %r0, %r0, 256
xor %r0, %r15, 256
xor %r15, %r0, 256
xor %r0, %r0, 65535
