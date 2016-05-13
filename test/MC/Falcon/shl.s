# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: shl %r0b, %r0b        # encoding: [0x3b,0x00,0x04]
# CHECK: shl %r15b, %r0b       # encoding: [0x3b,0xf0,0x04]
# CHECK: shl %r0b, %r15b       # encoding: [0x3b,0x0f,0x04]
shl %r0b, %r0b
shl %r15b, %r0b
shl %r0b, %r15b

# CHECK: shl %r0h, %r0h        # encoding: [0x7b,0x00,0x04]
# CHECK: shl %r15h, %r0h       # encoding: [0x7b,0xf0,0x04]
# CHECK: shl %r0h, %r15h       # encoding: [0x7b,0x0f,0x04]
shl %r0h, %r0h
shl %r15h, %r0h
shl %r0h, %r15h

# CHECK: shl %r0, %r0          # encoding: [0xbb,0x00,0x04]
# CHECK: shl %r15, %r0         # encoding: [0xbb,0xf0,0x04]
# CHECK: shl %r0, %r15         # encoding: [0xbb,0x0f,0x04]
shl %r0, %r0
shl %r15, %r0
shl %r0, %r15


# CHECK: shl %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x04]
# CHECK: shl %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x04]
# CHECK: shl %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x04]
# CHECK: shl %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xf4]
shl %r0b, %r0b, %r0b
shl %r0b, %r15b, %r0b
shl %r0b, %r0b, %r15b
shl %r15b, %r0b, %r0b

# CHECK: shl %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x04]
# CHECK: shl %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x04]
# CHECK: shl %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x04]
# CHECK: shl %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xf4]
shl %r0h, %r0h, %r0h
shl %r0h, %r15h, %r0h
shl %r0h, %r0h, %r15h
shl %r15h, %r0h, %r0h

# CHECK: shl %r0, %r0, %r0     # encoding: [0xbc,0x00,0x04]
# CHECK: shl %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x04]
# CHECK: shl %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x04]
# CHECK: shl %r15, %r0, %r0    # encoding: [0xbc,0x00,0xf4]
shl %r0, %r0, %r0
shl %r0, %r15, %r0
shl %r0, %r0, %r15
shl %r15, %r0, %r0


# CHECK: shl %r0b, 0           # encoding: [0x36,0x04,0x00]
# CHECK: shl %r15b, 0          # encoding: [0x36,0xf4,0x00]
# CHECK: shl %r0b, 255         # encoding: [0x36,0x04,0xff]
shl %r0b, 0
shl %r15b, 0
shl %r0b, 255

# CHECK: shl %r0h, 0           # encoding: [0x76,0x04,0x00]
# CHECK: shl %r15h, 0          # encoding: [0x76,0xf4,0x00]
# CHECK: shl %r0h, 255         # encoding: [0x76,0x04,0xff]
shl %r0h, 0
shl %r15h, 0
shl %r0h, 255

# CHECK: shl %r0, 0            # encoding: [0xb6,0x04,0x00]
# CHECK: shl %r15, 0           # encoding: [0xb6,0xf4,0x00]
# CHECK: shl %r0, 255          # encoding: [0xb6,0x04,0xff]
shl %r0, 0
shl %r15, 0
shl %r0, 255


# CHECK: shl %r0b, %r0b, 0     # encoding: [0x14,0x00,0x00]
# CHECK: shl %r0b, %r15b, 0    # encoding: [0x14,0xf0,0x00]
# CHECK: shl %r15b, %r0b, 0    # encoding: [0x14,0x0f,0x00]
# CHECK: shl %r0b, %r0b, 255   # encoding: [0x14,0x00,0xff]
shl %r0b, %r0b, 0
shl %r0b, %r15b, 0
shl %r15b, %r0b, 0
shl %r0b, %r0b, 255

# CHECK: shl %r0h, %r0h, 0     # encoding: [0x54,0x00,0x00]
# CHECK: shl %r0h, %r15h, 0    # encoding: [0x54,0xf0,0x00]
# CHECK: shl %r15h, %r0h, 0    # encoding: [0x54,0x0f,0x00]
# CHECK: shl %r0h, %r0h, 255   # encoding: [0x54,0x00,0xff]
shl %r0h, %r0h, 0
shl %r0h, %r15h, 0
shl %r15h, %r0h, 0
shl %r0h, %r0h, 255

# CHECK: shl %r0, %r0, 0       # encoding: [0x94,0x00,0x00]
# CHECK: shl %r0, %r15, 0      # encoding: [0x94,0xf0,0x00]
# CHECK: shl %r15, %r0, 0      # encoding: [0x94,0x0f,0x00]
# CHECK: shl %r0, %r0, 255     # encoding: [0x94,0x00,0xff]
shl %r0, %r0, 0
shl %r0, %r15, 0
shl %r15, %r0, 0
shl %r0, %r0, 255



# CHECK: shr %r0b, %r0b        # encoding: [0x3b,0x00,0x05]
# CHECK: shr %r15b, %r0b       # encoding: [0x3b,0xf0,0x05]
# CHECK: shr %r0b, %r15b       # encoding: [0x3b,0x0f,0x05]
shr %r0b, %r0b
shr %r15b, %r0b
shr %r0b, %r15b

# CHECK: shr %r0h, %r0h        # encoding: [0x7b,0x00,0x05]
# CHECK: shr %r15h, %r0h       # encoding: [0x7b,0xf0,0x05]
# CHECK: shr %r0h, %r15h       # encoding: [0x7b,0x0f,0x05]
shr %r0h, %r0h
shr %r15h, %r0h
shr %r0h, %r15h

# CHECK: shr %r0, %r0          # encoding: [0xbb,0x00,0x05]
# CHECK: shr %r15, %r0         # encoding: [0xbb,0xf0,0x05]
# CHECK: shr %r0, %r15         # encoding: [0xbb,0x0f,0x05]
shr %r0, %r0
shr %r15, %r0
shr %r0, %r15


# CHECK: shr %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x05]
# CHECK: shr %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x05]
# CHECK: shr %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x05]
# CHECK: shr %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xf5]
shr %r0b, %r0b, %r0b
shr %r0b, %r15b, %r0b
shr %r0b, %r0b, %r15b
shr %r15b, %r0b, %r0b

# CHECK: shr %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x05]
# CHECK: shr %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x05]
# CHECK: shr %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x05]
# CHECK: shr %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xf5]
shr %r0h, %r0h, %r0h
shr %r0h, %r15h, %r0h
shr %r0h, %r0h, %r15h
shr %r15h, %r0h, %r0h

# CHECK: shr %r0, %r0, %r0     # encoding: [0xbc,0x00,0x05]
# CHECK: shr %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x05]
# CHECK: shr %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x05]
# CHECK: shr %r15, %r0, %r0    # encoding: [0xbc,0x00,0xf5]
shr %r0, %r0, %r0
shr %r0, %r15, %r0
shr %r0, %r0, %r15
shr %r15, %r0, %r0


# CHECK: shr %r0b, 0           # encoding: [0x36,0x05,0x00]
# CHECK: shr %r15b, 0          # encoding: [0x36,0xf5,0x00]
# CHECK: shr %r0b, 255         # encoding: [0x36,0x05,0xff]
shr %r0b, 0
shr %r15b, 0
shr %r0b, 255

# CHECK: shr %r0h, 0           # encoding: [0x76,0x05,0x00]
# CHECK: shr %r15h, 0          # encoding: [0x76,0xf5,0x00]
# CHECK: shr %r0h, 255         # encoding: [0x76,0x05,0xff]
shr %r0h, 0
shr %r15h, 0
shr %r0h, 255

# CHECK: shr %r0, 0            # encoding: [0xb6,0x05,0x00]
# CHECK: shr %r15, 0           # encoding: [0xb6,0xf5,0x00]
# CHECK: shr %r0, 255          # encoding: [0xb6,0x05,0xff]
shr %r0, 0
shr %r15, 0
shr %r0, 255


# CHECK: shr %r0b, %r0b, 0     # encoding: [0x15,0x00,0x00]
# CHECK: shr %r0b, %r15b, 0    # encoding: [0x15,0xf0,0x00]
# CHECK: shr %r15b, %r0b, 0    # encoding: [0x15,0x0f,0x00]
# CHECK: shr %r0b, %r0b, 255   # encoding: [0x15,0x00,0xff]
shr %r0b, %r0b, 0
shr %r0b, %r15b, 0
shr %r15b, %r0b, 0
shr %r0b, %r0b, 255

# CHECK: shr %r0h, %r0h, 0     # encoding: [0x55,0x00,0x00]
# CHECK: shr %r0h, %r15h, 0    # encoding: [0x55,0xf0,0x00]
# CHECK: shr %r15h, %r0h, 0    # encoding: [0x55,0x0f,0x00]
# CHECK: shr %r0h, %r0h, 255   # encoding: [0x55,0x00,0xff]
shr %r0h, %r0h, 0
shr %r0h, %r15h, 0
shr %r15h, %r0h, 0
shr %r0h, %r0h, 255

# CHECK: shr %r0, %r0, 0       # encoding: [0x95,0x00,0x00]
# CHECK: shr %r0, %r15, 0      # encoding: [0x95,0xf0,0x00]
# CHECK: shr %r15, %r0, 0      # encoding: [0x95,0x0f,0x00]
# CHECK: shr %r0, %r0, 255     # encoding: [0x95,0x00,0xff]
shr %r0, %r0, 0
shr %r0, %r15, 0
shr %r15, %r0, 0
shr %r0, %r0, 255



# CHECK: sar %r0b, %r0b        # encoding: [0x3b,0x00,0x07]
# CHECK: sar %r15b, %r0b       # encoding: [0x3b,0xf0,0x07]
# CHECK: sar %r0b, %r15b       # encoding: [0x3b,0x0f,0x07]
sar %r0b, %r0b
sar %r15b, %r0b
sar %r0b, %r15b

# CHECK: sar %r0h, %r0h        # encoding: [0x7b,0x00,0x07]
# CHECK: sar %r15h, %r0h       # encoding: [0x7b,0xf0,0x07]
# CHECK: sar %r0h, %r15h       # encoding: [0x7b,0x0f,0x07]
sar %r0h, %r0h
sar %r15h, %r0h
sar %r0h, %r15h

# CHECK: sar %r0, %r0          # encoding: [0xbb,0x00,0x07]
# CHECK: sar %r15, %r0         # encoding: [0xbb,0xf0,0x07]
# CHECK: sar %r0, %r15         # encoding: [0xbb,0x0f,0x07]
sar %r0, %r0
sar %r15, %r0
sar %r0, %r15


# CHECK: sar %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x07]
# CHECK: sar %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x07]
# CHECK: sar %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x07]
# CHECK: sar %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xf7]
sar %r0b, %r0b, %r0b
sar %r0b, %r15b, %r0b
sar %r0b, %r0b, %r15b
sar %r15b, %r0b, %r0b

# CHECK: sar %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x07]
# CHECK: sar %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x07]
# CHECK: sar %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x07]
# CHECK: sar %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xf7]
sar %r0h, %r0h, %r0h
sar %r0h, %r15h, %r0h
sar %r0h, %r0h, %r15h
sar %r15h, %r0h, %r0h

# CHECK: sar %r0, %r0, %r0     # encoding: [0xbc,0x00,0x07]
# CHECK: sar %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x07]
# CHECK: sar %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x07]
# CHECK: sar %r15, %r0, %r0    # encoding: [0xbc,0x00,0xf7]
sar %r0, %r0, %r0
sar %r0, %r15, %r0
sar %r0, %r0, %r15
sar %r15, %r0, %r0


# CHECK: sar %r0b, 0           # encoding: [0x36,0x07,0x00]
# CHECK: sar %r15b, 0          # encoding: [0x36,0xf7,0x00]
# CHECK: sar %r0b, 255         # encoding: [0x36,0x07,0xff]
sar %r0b, 0
sar %r15b, 0
sar %r0b, 255

# CHECK: sar %r0h, 0           # encoding: [0x76,0x07,0x00]
# CHECK: sar %r15h, 0          # encoding: [0x76,0xf7,0x00]
# CHECK: sar %r0h, 255         # encoding: [0x76,0x07,0xff]
sar %r0h, 0
sar %r15h, 0
sar %r0h, 255

# CHECK: sar %r0, 0            # encoding: [0xb6,0x07,0x00]
# CHECK: sar %r15, 0           # encoding: [0xb6,0xf7,0x00]
# CHECK: sar %r0, 255          # encoding: [0xb6,0x07,0xff]
sar %r0, 0
sar %r15, 0
sar %r0, 255


# CHECK: sar %r0b, %r0b, 0     # encoding: [0x17,0x00,0x00]
# CHECK: sar %r0b, %r15b, 0    # encoding: [0x17,0xf0,0x00]
# CHECK: sar %r15b, %r0b, 0    # encoding: [0x17,0x0f,0x00]
# CHECK: sar %r0b, %r0b, 255   # encoding: [0x17,0x00,0xff]
sar %r0b, %r0b, 0
sar %r0b, %r15b, 0
sar %r15b, %r0b, 0
sar %r0b, %r0b, 255

# CHECK: sar %r0h, %r0h, 0     # encoding: [0x57,0x00,0x00]
# CHECK: sar %r0h, %r15h, 0    # encoding: [0x57,0xf0,0x00]
# CHECK: sar %r15h, %r0h, 0    # encoding: [0x57,0x0f,0x00]
# CHECK: sar %r0h, %r0h, 255   # encoding: [0x57,0x00,0xff]
sar %r0h, %r0h, 0
sar %r0h, %r15h, 0
sar %r15h, %r0h, 0
sar %r0h, %r0h, 255

# CHECK: sar %r0, %r0, 0       # encoding: [0x97,0x00,0x00]
# CHECK: sar %r0, %r15, 0      # encoding: [0x97,0xf0,0x00]
# CHECK: sar %r15, %r0, 0      # encoding: [0x97,0x0f,0x00]
# CHECK: sar %r0, %r0, 255     # encoding: [0x97,0x00,0xff]
sar %r0, %r0, 0
sar %r0, %r15, 0
sar %r15, %r0, 0
sar %r0, %r0, 255



# CHECK: shlc %r0b, %r0b        # encoding: [0x3b,0x00,0x0c]
# CHECK: shlc %r15b, %r0b       # encoding: [0x3b,0xf0,0x0c]
# CHECK: shlc %r0b, %r15b       # encoding: [0x3b,0x0f,0x0c]
shlc %r0b, %r0b
shlc %r15b, %r0b
shlc %r0b, %r15b

# CHECK: shlc %r0h, %r0h        # encoding: [0x7b,0x00,0x0c]
# CHECK: shlc %r15h, %r0h       # encoding: [0x7b,0xf0,0x0c]
# CHECK: shlc %r0h, %r15h       # encoding: [0x7b,0x0f,0x0c]
shlc %r0h, %r0h
shlc %r15h, %r0h
shlc %r0h, %r15h

# CHECK: shlc %r0, %r0          # encoding: [0xbb,0x00,0x0c]
# CHECK: shlc %r15, %r0         # encoding: [0xbb,0xf0,0x0c]
# CHECK: shlc %r0, %r15         # encoding: [0xbb,0x0f,0x0c]
shlc %r0, %r0
shlc %r15, %r0
shlc %r0, %r15


# CHECK: shlc %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x0c]
# CHECK: shlc %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x0c]
# CHECK: shlc %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x0c]
# CHECK: shlc %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xfc]
shlc %r0b, %r0b, %r0b
shlc %r0b, %r15b, %r0b
shlc %r0b, %r0b, %r15b
shlc %r15b, %r0b, %r0b

# CHECK: shlc %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x0c]
# CHECK: shlc %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x0c]
# CHECK: shlc %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x0c]
# CHECK: shlc %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xfc]
shlc %r0h, %r0h, %r0h
shlc %r0h, %r15h, %r0h
shlc %r0h, %r0h, %r15h
shlc %r15h, %r0h, %r0h

# CHECK: shlc %r0, %r0, %r0     # encoding: [0xbc,0x00,0x0c]
# CHECK: shlc %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x0c]
# CHECK: shlc %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x0c]
# CHECK: shlc %r15, %r0, %r0    # encoding: [0xbc,0x00,0xfc]
shlc %r0, %r0, %r0
shlc %r0, %r15, %r0
shlc %r0, %r0, %r15
shlc %r15, %r0, %r0


# CHECK: shlc %r0b, 0           # encoding: [0x36,0x0c,0x00]
# CHECK: shlc %r15b, 0          # encoding: [0x36,0xfc,0x00]
# CHECK: shlc %r0b, 255         # encoding: [0x36,0x0c,0xff]
shlc %r0b, 0
shlc %r15b, 0
shlc %r0b, 255

# CHECK: shlc %r0h, 0           # encoding: [0x76,0x0c,0x00]
# CHECK: shlc %r15h, 0          # encoding: [0x76,0xfc,0x00]
# CHECK: shlc %r0h, 255         # encoding: [0x76,0x0c,0xff]
shlc %r0h, 0
shlc %r15h, 0
shlc %r0h, 255

# CHECK: shlc %r0, 0            # encoding: [0xb6,0x0c,0x00]
# CHECK: shlc %r15, 0           # encoding: [0xb6,0xfc,0x00]
# CHECK: shlc %r0, 255          # encoding: [0xb6,0x0c,0xff]
shlc %r0, 0
shlc %r15, 0
shlc %r0, 255


# CHECK: shlc %r0b, %r0b, 0     # encoding: [0x1c,0x00,0x00]
# CHECK: shlc %r0b, %r15b, 0    # encoding: [0x1c,0xf0,0x00]
# CHECK: shlc %r15b, %r0b, 0    # encoding: [0x1c,0x0f,0x00]
# CHECK: shlc %r0b, %r0b, 255   # encoding: [0x1c,0x00,0xff]
shlc %r0b, %r0b, 0
shlc %r0b, %r15b, 0
shlc %r15b, %r0b, 0
shlc %r0b, %r0b, 255

# CHECK: shlc %r0h, %r0h, 0     # encoding: [0x5c,0x00,0x00]
# CHECK: shlc %r0h, %r15h, 0    # encoding: [0x5c,0xf0,0x00]
# CHECK: shlc %r15h, %r0h, 0    # encoding: [0x5c,0x0f,0x00]
# CHECK: shlc %r0h, %r0h, 255   # encoding: [0x5c,0x00,0xff]
shlc %r0h, %r0h, 0
shlc %r0h, %r15h, 0
shlc %r15h, %r0h, 0
shlc %r0h, %r0h, 255

# CHECK: shlc %r0, %r0, 0       # encoding: [0x9c,0x00,0x00]
# CHECK: shlc %r0, %r15, 0      # encoding: [0x9c,0xf0,0x00]
# CHECK: shlc %r15, %r0, 0      # encoding: [0x9c,0x0f,0x00]
# CHECK: shlc %r0, %r0, 255     # encoding: [0x9c,0x00,0xff]
shlc %r0, %r0, 0
shlc %r0, %r15, 0
shlc %r15, %r0, 0
shlc %r0, %r0, 255



# CHECK: shrc %r0b, %r0b        # encoding: [0x3b,0x00,0x0d]
# CHECK: shrc %r15b, %r0b       # encoding: [0x3b,0xf0,0x0d]
# CHECK: shrc %r0b, %r15b       # encoding: [0x3b,0x0f,0x0d]
shrc %r0b, %r0b
shrc %r15b, %r0b
shrc %r0b, %r15b

# CHECK: shrc %r0h, %r0h        # encoding: [0x7b,0x00,0x0d]
# CHECK: shrc %r15h, %r0h       # encoding: [0x7b,0xf0,0x0d]
# CHECK: shrc %r0h, %r15h       # encoding: [0x7b,0x0f,0x0d]
shrc %r0h, %r0h
shrc %r15h, %r0h
shrc %r0h, %r15h

# CHECK: shrc %r0, %r0          # encoding: [0xbb,0x00,0x0d]
# CHECK: shrc %r15, %r0         # encoding: [0xbb,0xf0,0x0d]
# CHECK: shrc %r0, %r15         # encoding: [0xbb,0x0f,0x0d]
shrc %r0, %r0
shrc %r15, %r0
shrc %r0, %r15


# CHECK: shrc %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x0d]
# CHECK: shrc %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x0d]
# CHECK: shrc %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x0d]
# CHECK: shrc %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xfd]
shrc %r0b, %r0b, %r0b
shrc %r0b, %r15b, %r0b
shrc %r0b, %r0b, %r15b
shrc %r15b, %r0b, %r0b

# CHECK: shrc %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x0d]
# CHECK: shrc %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x0d]
# CHECK: shrc %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x0d]
# CHECK: shrc %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xfd]
shrc %r0h, %r0h, %r0h
shrc %r0h, %r15h, %r0h
shrc %r0h, %r0h, %r15h
shrc %r15h, %r0h, %r0h

# CHECK: shrc %r0, %r0, %r0     # encoding: [0xbc,0x00,0x0d]
# CHECK: shrc %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x0d]
# CHECK: shrc %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x0d]
# CHECK: shrc %r15, %r0, %r0    # encoding: [0xbc,0x00,0xfd]
shrc %r0, %r0, %r0
shrc %r0, %r15, %r0
shrc %r0, %r0, %r15
shrc %r15, %r0, %r0


# CHECK: shrc %r0b, 0           # encoding: [0x36,0x0d,0x00]
# CHECK: shrc %r15b, 0          # encoding: [0x36,0xfd,0x00]
# CHECK: shrc %r0b, 255         # encoding: [0x36,0x0d,0xff]
shrc %r0b, 0
shrc %r15b, 0
shrc %r0b, 255

# CHECK: shrc %r0h, 0           # encoding: [0x76,0x0d,0x00]
# CHECK: shrc %r15h, 0          # encoding: [0x76,0xfd,0x00]
# CHECK: shrc %r0h, 255         # encoding: [0x76,0x0d,0xff]
shrc %r0h, 0
shrc %r15h, 0
shrc %r0h, 255

# CHECK: shrc %r0, 0            # encoding: [0xb6,0x0d,0x00]
# CHECK: shrc %r15, 0           # encoding: [0xb6,0xfd,0x00]
# CHECK: shrc %r0, 255          # encoding: [0xb6,0x0d,0xff]
shrc %r0, 0
shrc %r15, 0
shrc %r0, 255


# CHECK: shrc %r0b, %r0b, 0     # encoding: [0x1d,0x00,0x00]
# CHECK: shrc %r0b, %r15b, 0    # encoding: [0x1d,0xf0,0x00]
# CHECK: shrc %r15b, %r0b, 0    # encoding: [0x1d,0x0f,0x00]
# CHECK: shrc %r0b, %r0b, 255   # encoding: [0x1d,0x00,0xff]
shrc %r0b, %r0b, 0
shrc %r0b, %r15b, 0
shrc %r15b, %r0b, 0
shrc %r0b, %r0b, 255

# CHECK: shrc %r0h, %r0h, 0     # encoding: [0x5d,0x00,0x00]
# CHECK: shrc %r0h, %r15h, 0    # encoding: [0x5d,0xf0,0x00]
# CHECK: shrc %r15h, %r0h, 0    # encoding: [0x5d,0x0f,0x00]
# CHECK: shrc %r0h, %r0h, 255   # encoding: [0x5d,0x00,0xff]
shrc %r0h, %r0h, 0
shrc %r0h, %r15h, 0
shrc %r15h, %r0h, 0
shrc %r0h, %r0h, 255

# CHECK: shrc %r0, %r0, 0       # encoding: [0x9d,0x00,0x00]
# CHECK: shrc %r0, %r15, 0      # encoding: [0x9d,0xf0,0x00]
# CHECK: shrc %r15, %r0, 0      # encoding: [0x9d,0x0f,0x00]
# CHECK: shrc %r0, %r0, 255     # encoding: [0x9d,0x00,0xff]
shrc %r0, %r0, 0
shrc %r0, %r15, 0
shrc %r15, %r0, 0
shrc %r0, %r0, 255
