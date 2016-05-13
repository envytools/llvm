# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: cmpu %r0b, %r0b       # encoding: [0x38,0x00,0x04]
# CHECK: cmpu %r15b, %r0b      # encoding: [0x38,0xf0,0x04]
# CHECK: cmpu %r0b, %r15b      # encoding: [0x38,0x0f,0x04]
cmpu %r0b, %r0b
cmpu %r15b, %r0b
cmpu %r0b, %r15b

# CHECK: cmpu %r0h, %r0h       # encoding: [0x78,0x00,0x04]
# CHECK: cmpu %r15h, %r0h      # encoding: [0x78,0xf0,0x04]
# CHECK: cmpu %r0h, %r15h      # encoding: [0x78,0x0f,0x04]
cmpu %r0h, %r0h
cmpu %r15h, %r0h
cmpu %r0h, %r15h

# CHECK: cmpu %r0, %r0         # encoding: [0xb8,0x00,0x04]
# CHECK: cmpu %r15, %r0        # encoding: [0xb8,0xf0,0x04]
# CHECK: cmpu %r0, %r15        # encoding: [0xb8,0x0f,0x04]
cmpu %r0, %r0
cmpu %r15, %r0
cmpu %r0, %r15


# CHECK: cmpu %r0b, 0          # encoding: [0x30,0x04,0x00]
# CHECK: cmpu %r15b, 0         # encoding: [0x30,0xf4,0x00]
# CHECK: cmpu %r0b, 255        # encoding: [0x30,0x04,0xff]
cmpu %r0b, 0
cmpu %r15b, 0
cmpu %r0b, 255

# CHECK: cmpu %r0h, 0          # encoding: [0x70,0x04,0x00]
# CHECK: cmpu %r15h, 0         # encoding: [0x70,0xf4,0x00]
# CHECK: cmpu %r0h, 255        # encoding: [0x70,0x04,0xff]
# CHECK: cmpu %r0h, 256        # encoding: [0x71,0x04,0x00,0x01]
# CHECK: cmpu %r15h, 256       # encoding: [0x71,0xf4,0x00,0x01]
# CHECK: cmpu %r0h, 65535      # encoding: [0x71,0x04,0xff,0xff]
cmpu %r0h, 0
cmpu %r15h, 0
cmpu %r0h, 255
cmpu %r0h, 256
cmpu %r15h, 256
cmpu %r0h, 65535

# CHECK: cmpu %r0, 0           # encoding: [0xb0,0x04,0x00]
# CHECK: cmpu %r15, 0          # encoding: [0xb0,0xf4,0x00]
# CHECK: cmpu %r0, 255         # encoding: [0xb0,0x04,0xff]
# CHECK: cmpu %r0, 256         # encoding: [0xb1,0x04,0x00,0x01]
# CHECK: cmpu %r15, 256        # encoding: [0xb1,0xf4,0x00,0x01]
# CHECK: cmpu %r0, 65535       # encoding: [0xb1,0x04,0xff,0xff]
cmpu %r0, 0
cmpu %r15, 0
cmpu %r0, 255
cmpu %r0, 256
cmpu %r15, 256
cmpu %r0, 65535


# CHECK: cmps %r0b, %r0b       # encoding: [0x38,0x00,0x05]
# CHECK: cmps %r15b, %r0b      # encoding: [0x38,0xf0,0x05]
# CHECK: cmps %r0b, %r15b      # encoding: [0x38,0x0f,0x05]
cmps %r0b, %r0b
cmps %r15b, %r0b
cmps %r0b, %r15b

# CHECK: cmps %r0h, %r0h       # encoding: [0x78,0x00,0x05]
# CHECK: cmps %r15h, %r0h      # encoding: [0x78,0xf0,0x05]
# CHECK: cmps %r0h, %r15h      # encoding: [0x78,0x0f,0x05]
cmps %r0h, %r0h
cmps %r15h, %r0h
cmps %r0h, %r15h

# CHECK: cmps %r0, %r0         # encoding: [0xb8,0x00,0x05]
# CHECK: cmps %r15, %r0        # encoding: [0xb8,0xf0,0x05]
# CHECK: cmps %r0, %r15        # encoding: [0xb8,0x0f,0x05]
cmps %r0, %r0
cmps %r15, %r0
cmps %r0, %r15


# CHECK: cmps %r0b, 0          # encoding: [0x30,0x05,0x00]
# CHECK: cmps %r15b, 0         # encoding: [0x30,0xf5,0x00]
# CHECK: cmps %r0b, 127        # encoding: [0x30,0x05,0x7f]
# CHECK: cmps %r0b, -128       # encoding: [0x30,0x05,0x80]
# CHECK: cmps %r0b, -1         # encoding: [0x30,0x05,0xff]
cmps %r0b, 0
cmps %r15b, 0
cmps %r0b, 127
cmps %r0b, -128
cmps %r0b, -1

# CHECK: cmps %r0h, 0          # encoding: [0x70,0x05,0x00]
# CHECK: cmps %r15h, 0         # encoding: [0x70,0xf5,0x00]
# CHECK: cmps %r0h, 127        # encoding: [0x70,0x05,0x7f]
# CHECK: cmps %r0h, -128       # encoding: [0x70,0x05,0x80]
# CHECK: cmps %r0h, -1         # encoding: [0x70,0x05,0xff]
# CHECK: cmps %r0h, 128        # encoding: [0x71,0x05,0x80,0x00]
# CHECK: cmps %r15h, 128       # encoding: [0x71,0xf5,0x80,0x00]
# CHECK: cmps %r0h, -129       # encoding: [0x71,0x05,0x7f,0xff]
# CHECK: cmps %r0h, 32767      # encoding: [0x71,0x05,0xff,0x7f]
# CHECK: cmps %r0h, -32768     # encoding: [0x71,0x05,0x00,0x80]
cmps %r0h, 0
cmps %r15h, 0
cmps %r0h, 127
cmps %r0h, -128
cmps %r0h, -1
cmps %r0h, 128
cmps %r15h, 128
cmps %r0h, -129
cmps %r0h, 32767
cmps %r0h, -32768

# CHECK: cmps %r0, 0           # encoding: [0xb0,0x05,0x00]
# CHECK: cmps %r15, 0          # encoding: [0xb0,0xf5,0x00]
# CHECK: cmps %r0, 127         # encoding: [0xb0,0x05,0x7f]
# CHECK: cmps %r0, -128        # encoding: [0xb0,0x05,0x80]
# CHECK: cmps %r0, -1          # encoding: [0xb0,0x05,0xff]
# CHECK: cmps %r0, 128         # encoding: [0xb1,0x05,0x80,0x00]
# CHECK: cmps %r15, 128        # encoding: [0xb1,0xf5,0x80,0x00]
# CHECK: cmps %r0, -129        # encoding: [0xb1,0x05,0x7f,0xff]
# CHECK: cmps %r0, 32767       # encoding: [0xb1,0x05,0xff,0x7f]
# CHECK: cmps %r0, -32768      # encoding: [0xb1,0x05,0x00,0x80]
cmps %r0, 0
cmps %r15, 0
cmps %r0, 127
cmps %r0, -128
cmps %r0, -1
cmps %r0, 128
cmps %r15, 128
cmps %r0, -129
cmps %r0, 32767
cmps %r0, -32768


# CHECK: cmp %r0b, %r0b       # encoding: [0x38,0x00,0x06]
# CHECK: cmp %r15b, %r0b      # encoding: [0x38,0xf0,0x06]
# CHECK: cmp %r0b, %r15b      # encoding: [0x38,0x0f,0x06]
cmp %r0b, %r0b
cmp %r15b, %r0b
cmp %r0b, %r15b

# CHECK: cmp %r0h, %r0h       # encoding: [0x78,0x00,0x06]
# CHECK: cmp %r15h, %r0h      # encoding: [0x78,0xf0,0x06]
# CHECK: cmp %r0h, %r15h      # encoding: [0x78,0x0f,0x06]
cmp %r0h, %r0h
cmp %r15h, %r0h
cmp %r0h, %r15h

# CHECK: cmp %r0, %r0         # encoding: [0xb8,0x00,0x06]
# CHECK: cmp %r15, %r0        # encoding: [0xb8,0xf0,0x06]
# CHECK: cmp %r0, %r15        # encoding: [0xb8,0x0f,0x06]
cmp %r0, %r0
cmp %r15, %r0
cmp %r0, %r15


# CHECK: cmp %r0b, 0          # encoding: [0x30,0x06,0x00]
# CHECK: cmp %r15b, 0         # encoding: [0x30,0xf6,0x00]
# CHECK: cmp %r0b, 127        # encoding: [0x30,0x06,0x7f]
# CHECK: cmp %r0b, -128       # encoding: [0x30,0x06,0x80]
# CHECK: cmp %r0b, -1         # encoding: [0x30,0x06,0xff]
cmp %r0b, 0
cmp %r15b, 0
cmp %r0b, 127
cmp %r0b, -128
cmp %r0b, -1

# CHECK: cmp %r0h, 0          # encoding: [0x70,0x06,0x00]
# CHECK: cmp %r15h, 0         # encoding: [0x70,0xf6,0x00]
# CHECK: cmp %r0h, 127        # encoding: [0x70,0x06,0x7f]
# CHECK: cmp %r0h, -128       # encoding: [0x70,0x06,0x80]
# CHECK: cmp %r0h, -1         # encoding: [0x70,0x06,0xff]
# CHECK: cmp %r0h, 128        # encoding: [0x71,0x06,0x80,0x00]
# CHECK: cmp %r15h, 128       # encoding: [0x71,0xf6,0x80,0x00]
# CHECK: cmp %r0h, -129       # encoding: [0x71,0x06,0x7f,0xff]
# CHECK: cmp %r0h, 32767      # encoding: [0x71,0x06,0xff,0x7f]
# CHECK: cmp %r0h, -32768     # encoding: [0x71,0x06,0x00,0x80]
cmp %r0h, 0
cmp %r15h, 0
cmp %r0h, 127
cmp %r0h, -128
cmp %r0h, -1
cmp %r0h, 128
cmp %r15h, 128
cmp %r0h, -129
cmp %r0h, 32767
cmp %r0h, -32768

# CHECK: cmp %r0, 0           # encoding: [0xb0,0x06,0x00]
# CHECK: cmp %r15, 0          # encoding: [0xb0,0xf6,0x00]
# CHECK: cmp %r0, 127         # encoding: [0xb0,0x06,0x7f]
# CHECK: cmp %r0, -128        # encoding: [0xb0,0x06,0x80]
# CHECK: cmp %r0, -1          # encoding: [0xb0,0x06,0xff]
# CHECK: cmp %r0, 128         # encoding: [0xb1,0x06,0x80,0x00]
# CHECK: cmp %r15, 128        # encoding: [0xb1,0xf6,0x80,0x00]
# CHECK: cmp %r0, -129        # encoding: [0xb1,0x06,0x7f,0xff]
# CHECK: cmp %r0, 32767       # encoding: [0xb1,0x06,0xff,0x7f]
# CHECK: cmp %r0, -32768      # encoding: [0xb1,0x06,0x00,0x80]
cmp %r0, 0
cmp %r15, 0
cmp %r0, 127
cmp %r0, -128
cmp %r0, -1
cmp %r0, 128
cmp %r15, 128
cmp %r0, -129
cmp %r0, 32767
cmp %r0, -32768
