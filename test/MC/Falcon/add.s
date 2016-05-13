# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: add %r0b, %r0b        # encoding: [0x3b,0x00,0x00]
# CHECK: add %r15b, %r0b       # encoding: [0x3b,0xf0,0x00]
# CHECK: add %r0b, %r15b       # encoding: [0x3b,0x0f,0x00]
add %r0b, %r0b
add %r15b, %r0b
add %r0b, %r15b

# CHECK: add %r0h, %r0h        # encoding: [0x7b,0x00,0x00]
# CHECK: add %r15h, %r0h       # encoding: [0x7b,0xf0,0x00]
# CHECK: add %r0h, %r15h       # encoding: [0x7b,0x0f,0x00]
add %r0h, %r0h
add %r15h, %r0h
add %r0h, %r15h

# CHECK: add %r0, %r0          # encoding: [0xbb,0x00,0x00]
# CHECK: add %r15, %r0         # encoding: [0xbb,0xf0,0x00]
# CHECK: add %r0, %r15         # encoding: [0xbb,0x0f,0x00]
add %r0, %r0
add %r15, %r0
add %r0, %r15


# CHECK: add %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x00]
# CHECK: add %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x00]
# CHECK: add %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x00]
# CHECK: add %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xf0]
add %r0b, %r0b, %r0b
add %r0b, %r15b, %r0b
add %r0b, %r0b, %r15b
add %r15b, %r0b, %r0b

# CHECK: add %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x00]
# CHECK: add %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x00]
# CHECK: add %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x00]
# CHECK: add %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xf0]
add %r0h, %r0h, %r0h
add %r0h, %r15h, %r0h
add %r0h, %r0h, %r15h
add %r15h, %r0h, %r0h

# CHECK: add %r0, %r0, %r0     # encoding: [0xbc,0x00,0x00]
# CHECK: add %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x00]
# CHECK: add %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x00]
# CHECK: add %r15, %r0, %r0    # encoding: [0xbc,0x00,0xf0]
add %r0, %r0, %r0
add %r0, %r15, %r0
add %r0, %r0, %r15
add %r15, %r0, %r0


# CHECK: add %r0b, 0           # encoding: [0x36,0x00,0x00]
# CHECK: add %r15b, 0          # encoding: [0x36,0xf0,0x00]
# CHECK: add %r0b, 255         # encoding: [0x36,0x00,0xff]
add %r0b, 0
add %r15b, 0
add %r0b, 255

# CHECK: add %r0h, 0           # encoding: [0x76,0x00,0x00]
# CHECK: add %r15h, 0          # encoding: [0x76,0xf0,0x00]
# CHECK: add %r0h, 255         # encoding: [0x76,0x00,0xff]
# CHECK: add %r0h, 256         # encoding: [0x77,0x00,0x00,0x01]
# CHECK: add %r15h, 256        # encoding: [0x77,0xf0,0x00,0x01]
# CHECK: add %r0h, 65535       # encoding: [0x77,0x00,0xff,0xff]
add %r0h, 0
add %r15h, 0
add %r0h, 255
add %r0h, 256
add %r15h, 256
add %r0h, 65535

# CHECK: add %r0, 0            # encoding: [0xb6,0x00,0x00]
# CHECK: add %r15, 0           # encoding: [0xb6,0xf0,0x00]
# CHECK: add %r0, 255          # encoding: [0xb6,0x00,0xff]
# CHECK: add %r0, 256          # encoding: [0xb7,0x00,0x00,0x01]
# CHECK: add %r15, 256         # encoding: [0xb7,0xf0,0x00,0x01]
# CHECK: add %r0, 65535        # encoding: [0xb7,0x00,0xff,0xff]
add %r0, 0
add %r15, 0
add %r0, 255
add %r0, 256
add %r15, 256
add %r0, 65535

# CHECK: add %r0b, %r0b, 0     # encoding: [0x10,0x00,0x00]
# CHECK: add %r0b, %r15b, 0    # encoding: [0x10,0xf0,0x00]
# CHECK: add %r15b, %r0b, 0    # encoding: [0x10,0x0f,0x00]
# CHECK: add %r0b, %r0b, 255   # encoding: [0x10,0x00,0xff]
add %r0b, %r0b, 0
add %r0b, %r15b, 0
add %r15b, %r0b, 0
add %r0b, %r0b, 255

# CHECK: add %r0h, %r0h, 0     # encoding: [0x50,0x00,0x00]
# CHECK: add %r0h, %r15h, 0    # encoding: [0x50,0xf0,0x00]
# CHECK: add %r15h, %r0h, 0    # encoding: [0x50,0x0f,0x00]
# CHECK: add %r0h, %r0h, 255   # encoding: [0x50,0x00,0xff]
# CHECK: add %r0h, %r0h, 256   # encoding: [0x60,0x00,0x00,0x01]
# CHECK: add %r0h, %r15h, 256  # encoding: [0x60,0xf0,0x00,0x01]
# CHECK: add %r15h, %r0h, 256  # encoding: [0x60,0x0f,0x00,0x01]
# CHECK: add %r0h, %r0h, 65535 # encoding: [0x60,0x00,0xff,0xff]
add %r0h, %r0h, 0
add %r0h, %r15h, 0
add %r15h, %r0h, 0
add %r0h, %r0h, 255
add %r0h, %r0h, 256
add %r0h, %r15h, 256
add %r15h, %r0h, 256
add %r0h, %r0h, 65535

# CHECK: add %r0, %r0, 0       # encoding: [0x90,0x00,0x00]
# CHECK: add %r0, %r15, 0      # encoding: [0x90,0xf0,0x00]
# CHECK: add %r15, %r0, 0      # encoding: [0x90,0x0f,0x00]
# CHECK: add %r0, %r0, 255     # encoding: [0x90,0x00,0xff]
# CHECK: add %r0, %r0, 256     # encoding: [0xa0,0x00,0x00,0x01]
# CHECK: add %r0, %r15, 256    # encoding: [0xa0,0xf0,0x00,0x01]
# CHECK: add %r15, %r0, 256    # encoding: [0xa0,0x0f,0x00,0x01]
# CHECK: add %r0, %r0, 65535   # encoding: [0xa0,0x00,0xff,0xff]
add %r0, %r0, 0
add %r0, %r15, 0
add %r15, %r0, 0
add %r0, %r0, 255
add %r0, %r0, 256
add %r0, %r15, 256
add %r15, %r0, 256
add %r0, %r0, 65535



# CHECK: adc %r0b, %r0b        # encoding: [0x3b,0x00,0x01]
# CHECK: adc %r15b, %r0b       # encoding: [0x3b,0xf0,0x01]
# CHECK: adc %r0b, %r15b       # encoding: [0x3b,0x0f,0x01]
adc %r0b, %r0b
adc %r15b, %r0b
adc %r0b, %r15b

# CHECK: adc %r0h, %r0h        # encoding: [0x7b,0x00,0x01]
# CHECK: adc %r15h, %r0h       # encoding: [0x7b,0xf0,0x01]
# CHECK: adc %r0h, %r15h       # encoding: [0x7b,0x0f,0x01]
adc %r0h, %r0h
adc %r15h, %r0h
adc %r0h, %r15h

# CHECK: adc %r0, %r0          # encoding: [0xbb,0x00,0x01]
# CHECK: adc %r15, %r0         # encoding: [0xbb,0xf0,0x01]
# CHECK: adc %r0, %r15         # encoding: [0xbb,0x0f,0x01]
adc %r0, %r0
adc %r15, %r0
adc %r0, %r15


# CHECK: adc %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x01]
# CHECK: adc %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x01]
# CHECK: adc %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x01]
# CHECK: adc %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xf1]
adc %r0b, %r0b, %r0b
adc %r0b, %r15b, %r0b
adc %r0b, %r0b, %r15b
adc %r15b, %r0b, %r0b

# CHECK: adc %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x01]
# CHECK: adc %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x01]
# CHECK: adc %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x01]
# CHECK: adc %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xf1]
adc %r0h, %r0h, %r0h
adc %r0h, %r15h, %r0h
adc %r0h, %r0h, %r15h
adc %r15h, %r0h, %r0h

# CHECK: adc %r0, %r0, %r0     # encoding: [0xbc,0x00,0x01]
# CHECK: adc %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x01]
# CHECK: adc %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x01]
# CHECK: adc %r15, %r0, %r0    # encoding: [0xbc,0x00,0xf1]
adc %r0, %r0, %r0
adc %r0, %r15, %r0
adc %r0, %r0, %r15
adc %r15, %r0, %r0


# CHECK: adc %r0b, 0           # encoding: [0x36,0x01,0x00]
# CHECK: adc %r15b, 0          # encoding: [0x36,0xf1,0x00]
# CHECK: adc %r0b, 255         # encoding: [0x36,0x01,0xff]
adc %r0b, 0
adc %r15b, 0
adc %r0b, 255

# CHECK: adc %r0h, 0           # encoding: [0x76,0x01,0x00]
# CHECK: adc %r15h, 0          # encoding: [0x76,0xf1,0x00]
# CHECK: adc %r0h, 255         # encoding: [0x76,0x01,0xff]
# CHECK: adc %r0h, 256         # encoding: [0x77,0x01,0x00,0x01]
# CHECK: adc %r15h, 256        # encoding: [0x77,0xf1,0x00,0x01]
# CHECK: adc %r0h, 65535       # encoding: [0x77,0x01,0xff,0xff]
adc %r0h, 0
adc %r15h, 0
adc %r0h, 255
adc %r0h, 256
adc %r15h, 256
adc %r0h, 65535

# CHECK: adc %r0, 0            # encoding: [0xb6,0x01,0x00]
# CHECK: adc %r15, 0           # encoding: [0xb6,0xf1,0x00]
# CHECK: adc %r0, 255          # encoding: [0xb6,0x01,0xff]
# CHECK: adc %r0, 256          # encoding: [0xb7,0x01,0x00,0x01]
# CHECK: adc %r15, 256         # encoding: [0xb7,0xf1,0x00,0x01]
# CHECK: adc %r0, 65535        # encoding: [0xb7,0x01,0xff,0xff]
adc %r0, 0
adc %r15, 0
adc %r0, 255
adc %r0, 256
adc %r15, 256
adc %r0, 65535


# CHECK: adc %r0b, %r0b, 0     # encoding: [0x11,0x00,0x00]
# CHECK: adc %r0b, %r15b, 0    # encoding: [0x11,0xf0,0x00]
# CHECK: adc %r15b, %r0b, 0    # encoding: [0x11,0x0f,0x00]
# CHECK: adc %r0b, %r0b, 255   # encoding: [0x11,0x00,0xff]
adc %r0b, %r0b, 0
adc %r0b, %r15b, 0
adc %r15b, %r0b, 0
adc %r0b, %r0b, 255

# CHECK: adc %r0h, %r0h, 0     # encoding: [0x51,0x00,0x00]
# CHECK: adc %r0h, %r15h, 0    # encoding: [0x51,0xf0,0x00]
# CHECK: adc %r15h, %r0h, 0    # encoding: [0x51,0x0f,0x00]
# CHECK: adc %r0h, %r0h, 255   # encoding: [0x51,0x00,0xff]
# CHECK: adc %r0h, %r0h, 256   # encoding: [0x61,0x00,0x00,0x01]
# CHECK: adc %r0h, %r15h, 256  # encoding: [0x61,0xf0,0x00,0x01]
# CHECK: adc %r15h, %r0h, 256  # encoding: [0x61,0x0f,0x00,0x01]
# CHECK: adc %r0h, %r0h, 65535 # encoding: [0x61,0x00,0xff,0xff]
adc %r0h, %r0h, 0
adc %r0h, %r15h, 0
adc %r15h, %r0h, 0
adc %r0h, %r0h, 255
adc %r0h, %r0h, 256
adc %r0h, %r15h, 256
adc %r15h, %r0h, 256
adc %r0h, %r0h, 65535

# CHECK: adc %r0, %r0, 0       # encoding: [0x91,0x00,0x00]
# CHECK: adc %r0, %r15, 0      # encoding: [0x91,0xf0,0x00]
# CHECK: adc %r15, %r0, 0      # encoding: [0x91,0x0f,0x00]
# CHECK: adc %r0, %r0, 255     # encoding: [0x91,0x00,0xff]
# CHECK: adc %r0, %r0, 256     # encoding: [0xa1,0x00,0x00,0x01]
# CHECK: adc %r0, %r15, 256    # encoding: [0xa1,0xf0,0x00,0x01]
# CHECK: adc %r15, %r0, 256    # encoding: [0xa1,0x0f,0x00,0x01]
# CHECK: adc %r0, %r0, 65535   # encoding: [0xa1,0x00,0xff,0xff]
adc %r0, %r0, 0
adc %r0, %r15, 0
adc %r15, %r0, 0
adc %r0, %r0, 255
adc %r0, %r0, 256
adc %r0, %r15, 256
adc %r15, %r0, 256
adc %r0, %r0, 65535



# CHECK: sub %r0b, %r0b        # encoding: [0x3b,0x00,0x02]
# CHECK: sub %r15b, %r0b       # encoding: [0x3b,0xf0,0x02]
# CHECK: sub %r0b, %r15b       # encoding: [0x3b,0x0f,0x02]
sub %r0b, %r0b
sub %r15b, %r0b
sub %r0b, %r15b

# CHECK: sub %r0h, %r0h        # encoding: [0x7b,0x00,0x02]
# CHECK: sub %r15h, %r0h       # encoding: [0x7b,0xf0,0x02]
# CHECK: sub %r0h, %r15h       # encoding: [0x7b,0x0f,0x02]
sub %r0h, %r0h
sub %r15h, %r0h
sub %r0h, %r15h

# CHECK: sub %r0, %r0          # encoding: [0xbb,0x00,0x02]
# CHECK: sub %r15, %r0         # encoding: [0xbb,0xf0,0x02]
# CHECK: sub %r0, %r15         # encoding: [0xbb,0x0f,0x02]
sub %r0, %r0
sub %r15, %r0
sub %r0, %r15


# CHECK: sub %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x02]
# CHECK: sub %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x02]
# CHECK: sub %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x02]
# CHECK: sub %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xf2]
sub %r0b, %r0b, %r0b
sub %r0b, %r15b, %r0b
sub %r0b, %r0b, %r15b
sub %r15b, %r0b, %r0b

# CHECK: sub %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x02]
# CHECK: sub %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x02]
# CHECK: sub %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x02]
# CHECK: sub %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xf2]
sub %r0h, %r0h, %r0h
sub %r0h, %r15h, %r0h
sub %r0h, %r0h, %r15h
sub %r15h, %r0h, %r0h

# CHECK: sub %r0, %r0, %r0     # encoding: [0xbc,0x00,0x02]
# CHECK: sub %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x02]
# CHECK: sub %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x02]
# CHECK: sub %r15, %r0, %r0    # encoding: [0xbc,0x00,0xf2]
sub %r0, %r0, %r0
sub %r0, %r15, %r0
sub %r0, %r0, %r15
sub %r15, %r0, %r0


# CHECK: sub %r0b, 0           # encoding: [0x36,0x02,0x00]
# CHECK: sub %r15b, 0          # encoding: [0x36,0xf2,0x00]
# CHECK: sub %r0b, 255         # encoding: [0x36,0x02,0xff]
sub %r0b, 0
sub %r15b, 0
sub %r0b, 255

# CHECK: sub %r0h, 0           # encoding: [0x76,0x02,0x00]
# CHECK: sub %r15h, 0          # encoding: [0x76,0xf2,0x00]
# CHECK: sub %r0h, 255         # encoding: [0x76,0x02,0xff]
# CHECK: sub %r0h, 256         # encoding: [0x77,0x02,0x00,0x01]
# CHECK: sub %r15h, 256        # encoding: [0x77,0xf2,0x00,0x01]
# CHECK: sub %r0h, 65535       # encoding: [0x77,0x02,0xff,0xff]
sub %r0h, 0
sub %r15h, 0
sub %r0h, 255
sub %r0h, 256
sub %r15h, 256
sub %r0h, 65535

# CHECK: sub %r0, 0            # encoding: [0xb6,0x02,0x00]
# CHECK: sub %r15, 0           # encoding: [0xb6,0xf2,0x00]
# CHECK: sub %r0, 255          # encoding: [0xb6,0x02,0xff]
# CHECK: sub %r0, 256          # encoding: [0xb7,0x02,0x00,0x01]
# CHECK: sub %r15, 256         # encoding: [0xb7,0xf2,0x00,0x01]
# CHECK: sub %r0, 65535        # encoding: [0xb7,0x02,0xff,0xff]
sub %r0, 0
sub %r15, 0
sub %r0, 255
sub %r0, 256
sub %r15, 256
sub %r0, 65535


# CHECK: sub %r0b, %r0b, 0     # encoding: [0x12,0x00,0x00]
# CHECK: sub %r0b, %r15b, 0    # encoding: [0x12,0xf0,0x00]
# CHECK: sub %r15b, %r0b, 0    # encoding: [0x12,0x0f,0x00]
# CHECK: sub %r0b, %r0b, 255   # encoding: [0x12,0x00,0xff]
sub %r0b, %r0b, 0
sub %r0b, %r15b, 0
sub %r15b, %r0b, 0
sub %r0b, %r0b, 255

# CHECK: sub %r0h, %r0h, 0     # encoding: [0x52,0x00,0x00]
# CHECK: sub %r0h, %r15h, 0    # encoding: [0x52,0xf0,0x00]
# CHECK: sub %r15h, %r0h, 0    # encoding: [0x52,0x0f,0x00]
# CHECK: sub %r0h, %r0h, 255   # encoding: [0x52,0x00,0xff]
# CHECK: sub %r0h, %r0h, 256   # encoding: [0x62,0x00,0x00,0x01]
# CHECK: sub %r0h, %r15h, 256  # encoding: [0x62,0xf0,0x00,0x01]
# CHECK: sub %r15h, %r0h, 256  # encoding: [0x62,0x0f,0x00,0x01]
# CHECK: sub %r0h, %r0h, 65535 # encoding: [0x62,0x00,0xff,0xff]
sub %r0h, %r0h, 0
sub %r0h, %r15h, 0
sub %r15h, %r0h, 0
sub %r0h, %r0h, 255
sub %r0h, %r0h, 256
sub %r0h, %r15h, 256
sub %r15h, %r0h, 256
sub %r0h, %r0h, 65535

# CHECK: sub %r0, %r0, 0       # encoding: [0x92,0x00,0x00]
# CHECK: sub %r0, %r15, 0      # encoding: [0x92,0xf0,0x00]
# CHECK: sub %r15, %r0, 0      # encoding: [0x92,0x0f,0x00]
# CHECK: sub %r0, %r0, 255     # encoding: [0x92,0x00,0xff]
# CHECK: sub %r0, %r0, 256     # encoding: [0xa2,0x00,0x00,0x01]
# CHECK: sub %r0, %r15, 256    # encoding: [0xa2,0xf0,0x00,0x01]
# CHECK: sub %r15, %r0, 256    # encoding: [0xa2,0x0f,0x00,0x01]
# CHECK: sub %r0, %r0, 65535   # encoding: [0xa2,0x00,0xff,0xff]
sub %r0, %r0, 0
sub %r0, %r15, 0
sub %r15, %r0, 0
sub %r0, %r0, 255
sub %r0, %r0, 256
sub %r0, %r15, 256
sub %r15, %r0, 256
sub %r0, %r0, 65535



# CHECK: sbb %r0b, %r0b        # encoding: [0x3b,0x00,0x03]
# CHECK: sbb %r15b, %r0b       # encoding: [0x3b,0xf0,0x03]
# CHECK: sbb %r0b, %r15b       # encoding: [0x3b,0x0f,0x03]
sbb %r0b, %r0b
sbb %r15b, %r0b
sbb %r0b, %r15b

# CHECK: sbb %r0h, %r0h        # encoding: [0x7b,0x00,0x03]
# CHECK: sbb %r15h, %r0h       # encoding: [0x7b,0xf0,0x03]
# CHECK: sbb %r0h, %r15h       # encoding: [0x7b,0x0f,0x03]
sbb %r0h, %r0h
sbb %r15h, %r0h
sbb %r0h, %r15h

# CHECK: sbb %r0, %r0          # encoding: [0xbb,0x00,0x03]
# CHECK: sbb %r15, %r0         # encoding: [0xbb,0xf0,0x03]
# CHECK: sbb %r0, %r15         # encoding: [0xbb,0x0f,0x03]
sbb %r0, %r0
sbb %r15, %r0
sbb %r0, %r15


# CHECK: sbb %r0b, %r0b, %r0b  # encoding: [0x3c,0x00,0x03]
# CHECK: sbb %r0b, %r15b, %r0b # encoding: [0x3c,0xf0,0x03]
# CHECK: sbb %r0b, %r0b, %r15b # encoding: [0x3c,0x0f,0x03]
# CHECK: sbb %r15b, %r0b, %r0b # encoding: [0x3c,0x00,0xf3]
sbb %r0b, %r0b, %r0b
sbb %r0b, %r15b, %r0b
sbb %r0b, %r0b, %r15b
sbb %r15b, %r0b, %r0b

# CHECK: sbb %r0h, %r0h, %r0h  # encoding: [0x7c,0x00,0x03]
# CHECK: sbb %r0h, %r15h, %r0h # encoding: [0x7c,0xf0,0x03]
# CHECK: sbb %r0h, %r0h, %r15h # encoding: [0x7c,0x0f,0x03]
# CHECK: sbb %r15h, %r0h, %r0h # encoding: [0x7c,0x00,0xf3]
sbb %r0h, %r0h, %r0h
sbb %r0h, %r15h, %r0h
sbb %r0h, %r0h, %r15h
sbb %r15h, %r0h, %r0h

# CHECK: sbb %r0, %r0, %r0     # encoding: [0xbc,0x00,0x03]
# CHECK: sbb %r0, %r15, %r0    # encoding: [0xbc,0xf0,0x03]
# CHECK: sbb %r0, %r0, %r15    # encoding: [0xbc,0x0f,0x03]
# CHECK: sbb %r15, %r0, %r0    # encoding: [0xbc,0x00,0xf3]
sbb %r0, %r0, %r0
sbb %r0, %r15, %r0
sbb %r0, %r0, %r15
sbb %r15, %r0, %r0


# CHECK: sbb %r0b, 0           # encoding: [0x36,0x03,0x00]
# CHECK: sbb %r15b, 0          # encoding: [0x36,0xf3,0x00]
# CHECK: sbb %r0b, 255         # encoding: [0x36,0x03,0xff]
sbb %r0b, 0
sbb %r15b, 0
sbb %r0b, 255

# CHECK: sbb %r0h, 0           # encoding: [0x76,0x03,0x00]
# CHECK: sbb %r15h, 0          # encoding: [0x76,0xf3,0x00]
# CHECK: sbb %r0h, 255         # encoding: [0x76,0x03,0xff]
# CHECK: sbb %r0h, 256         # encoding: [0x77,0x03,0x00,0x01]
# CHECK: sbb %r15h, 256        # encoding: [0x77,0xf3,0x00,0x01]
# CHECK: sbb %r0h, 65535       # encoding: [0x77,0x03,0xff,0xff]
sbb %r0h, 0
sbb %r15h, 0
sbb %r0h, 255
sbb %r0h, 256
sbb %r15h, 256
sbb %r0h, 65535

# CHECK: sbb %r0, 0            # encoding: [0xb6,0x03,0x00]
# CHECK: sbb %r15, 0           # encoding: [0xb6,0xf3,0x00]
# CHECK: sbb %r0, 255          # encoding: [0xb6,0x03,0xff]
# CHECK: sbb %r0, 256          # encoding: [0xb7,0x03,0x00,0x01]
# CHECK: sbb %r15, 256         # encoding: [0xb7,0xf3,0x00,0x01]
# CHECK: sbb %r0, 65535        # encoding: [0xb7,0x03,0xff,0xff]
sbb %r0, 0
sbb %r15, 0
sbb %r0, 255
sbb %r0, 256
sbb %r15, 256
sbb %r0, 65535


# CHECK: sbb %r0b, %r0b, 0     # encoding: [0x13,0x00,0x00]
# CHECK: sbb %r0b, %r15b, 0    # encoding: [0x13,0xf0,0x00]
# CHECK: sbb %r15b, %r0b, 0    # encoding: [0x13,0x0f,0x00]
# CHECK: sbb %r0b, %r0b, 255   # encoding: [0x13,0x00,0xff]
sbb %r0b, %r0b, 0
sbb %r0b, %r15b, 0
sbb %r15b, %r0b, 0
sbb %r0b, %r0b, 255

# CHECK: sbb %r0h, %r0h, 0     # encoding: [0x53,0x00,0x00]
# CHECK: sbb %r0h, %r15h, 0    # encoding: [0x53,0xf0,0x00]
# CHECK: sbb %r15h, %r0h, 0    # encoding: [0x53,0x0f,0x00]
# CHECK: sbb %r0h, %r0h, 255   # encoding: [0x53,0x00,0xff]
# CHECK: sbb %r0h, %r0h, 256   # encoding: [0x63,0x00,0x00,0x01]
# CHECK: sbb %r0h, %r15h, 256  # encoding: [0x63,0xf0,0x00,0x01]
# CHECK: sbb %r15h, %r0h, 256  # encoding: [0x63,0x0f,0x00,0x01]
# CHECK: sbb %r0h, %r0h, 65535 # encoding: [0x63,0x00,0xff,0xff]
sbb %r0h, %r0h, 0
sbb %r0h, %r15h, 0
sbb %r15h, %r0h, 0
sbb %r0h, %r0h, 255
sbb %r0h, %r0h, 256
sbb %r0h, %r15h, 256
sbb %r15h, %r0h, 256
sbb %r0h, %r0h, 65535

# CHECK: sbb %r0, %r0, 0       # encoding: [0x93,0x00,0x00]
# CHECK: sbb %r0, %r15, 0      # encoding: [0x93,0xf0,0x00]
# CHECK: sbb %r15, %r0, 0      # encoding: [0x93,0x0f,0x00]
# CHECK: sbb %r0, %r0, 255     # encoding: [0x93,0x00,0xff]
# CHECK: sbb %r0, %r0, 256     # encoding: [0xa3,0x00,0x00,0x01]
# CHECK: sbb %r0, %r15, 256    # encoding: [0xa3,0xf0,0x00,0x01]
# CHECK: sbb %r15, %r0, 256    # encoding: [0xa3,0x0f,0x00,0x01]
# CHECK: sbb %r0, %r0, 65535   # encoding: [0xa3,0x00,0xff,0xff]
sbb %r0, %r0, 0
sbb %r0, %r15, 0
sbb %r15, %r0, 0
sbb %r0, %r0, 255
sbb %r0, %r0, 256
sbb %r0, %r15, 256
sbb %r15, %r0, 256
sbb %r0, %r0, 65535
