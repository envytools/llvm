# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: st 0(%r0), %r0b     # encoding: [0x00,0x00,0x00]
# CHECK: st 255(%r0), %r0b   # encoding: [0x00,0x00,0xff]
# CHECK: st 0(%r15), %r0b    # encoding: [0x00,0xf0,0x00]
# CHECK: st 0(%r0), %r15b    # encoding: [0x00,0x0f,0x00]
st 0(%r0), %r0b
st 255(%r0), %r0b
st 0(%r15), %r0b
st 0(%r0), %r15b

# CHECK: st 0(%r0), %r0h     # encoding: [0x40,0x00,0x00]
# CHECK: st 510(%r0), %r0h   # encoding: [0x40,0x00,0xff]
# CHECK: st 0(%r15), %r0h    # encoding: [0x40,0xf0,0x00]
# CHECK: st 0(%r0), %r15h    # encoding: [0x40,0x0f,0x00]
st 0(%r0), %r0h
st 510(%r0), %r0h
st 0(%r15), %r0h
st 0(%r0), %r15h

# CHECK: st 0(%r0), %r0      # encoding: [0x80,0x00,0x00]
# CHECK: st 1020(%r0), %r0   # encoding: [0x80,0x00,0xff]
# CHECK: st 0(%r15), %r0     # encoding: [0x80,0xf0,0x00]
# CHECK: st 0(%r0), %r15     # encoding: [0x80,0x0f,0x00]
st 0(%r0), %r0
st 1020(%r0), %r0
st 0(%r15), %r0
st 0(%r0), %r15


# CHECK: st 0(%sp), %r0b     # encoding: [0x30,0x01,0x00]
# CHECK: st 0(%sp), %r15b    # encoding: [0x30,0xf1,0x00]
# CHECK: st 255(%sp), %r0b   # encoding: [0x30,0x01,0xff]
st 0(%sp), %r0b
st 0(%sp), %r15b
st 255(%sp), %r0b

# CHECK: st 0(%sp), %r0h     # encoding: [0x70,0x01,0x00]
# CHECK: st 0(%sp), %r15h    # encoding: [0x70,0xf1,0x00]
# CHECK: st 510(%sp), %r0h   # encoding: [0x70,0x01,0xff]
st 0(%sp), %r0h
st 0(%sp), %r15h
st 510(%sp), %r0h

# CHECK: st 0(%sp), %r0      # encoding: [0xb0,0x01,0x00]
# CHECK: st 0(%sp), %r15     # encoding: [0xb0,0xf1,0x00]
# CHECK: st 1020(%sp), %r0   # encoding: [0xb0,0x01,0xff]
st 0(%sp), %r0
st 0(%sp), %r15
st 1020(%sp), %r0


# CHECK: st (%r0), %r0b      # encoding: [0x38,0x00,0x00]
# CHECK: st (%r15), %r0b     # encoding: [0x38,0xf0,0x00]
# CHECK: st (%r0), %r15b     # encoding: [0x38,0x0f,0x00]
st (%r0), %r0b
st (%r15), %r0b
st (%r0), %r15b

# CHECK: st (%r0), %r0h      # encoding: [0x78,0x00,0x00]
# CHECK: st (%r15), %r0h     # encoding: [0x78,0xf0,0x00]
# CHECK: st (%r0), %r15h     # encoding: [0x78,0x0f,0x00]
st (%r0), %r0h
st (%r15), %r0h
st (%r0), %r15h

# CHECK: st (%r0), %r0       # encoding: [0xb8,0x00,0x00]
# CHECK: st (%r15), %r0      # encoding: [0xb8,0xf0,0x00]
# CHECK: st (%r0), %r15      # encoding: [0xb8,0x0f,0x00]
st (%r0), %r0
st (%r15), %r0
st (%r0), %r15


# CHECK: st %r0(%sp), %r0b      # encoding: [0x38,0x00,0x01]
# CHECK: st %r15(%sp), %r0b     # encoding: [0x38,0x0f,0x01]
# CHECK: st %r0(%sp), %r15b     # encoding: [0x38,0xf0,0x01]
st %r0(%sp), %r0b
st %r15(%sp), %r0b
st %r0(%sp), %r15b

# CHECK: st %r0(%sp), %r0h      # encoding: [0x78,0x00,0x01]
# CHECK: st %r15(%sp), %r0h     # encoding: [0x78,0x0f,0x01]
# CHECK: st %r0(%sp), %r15h     # encoding: [0x78,0xf0,0x01]
st %r0(%sp), %r0h
st %r15(%sp), %r0h
st %r0(%sp), %r15h

# CHECK: st %r0(%sp), %r0       # encoding: [0xb8,0x00,0x01]
# CHECK: st %r15(%sp), %r0      # encoding: [0xb8,0x0f,0x01]
# CHECK: st %r0(%sp), %r15      # encoding: [0xb8,0xf0,0x01]
st %r0(%sp), %r0
st %r15(%sp), %r0
st %r0(%sp), %r15


# CHECK: ld %r0b, 0(%r0)        # encoding: [0x18,0x00,0x00]
# CHECK: ld %r0b, 0(%r15)       # encoding: [0x18,0xf0,0x00]
# CHECK: ld %r15b, 0(%r0)       # encoding: [0x18,0x0f,0x00]
# CHECK: ld %r0b, 255(%r0)      # encoding: [0x18,0x00,0xff]
ld %r0b, 0(%r0)
ld %r0b, 0(%r15)
ld %r15b, 0(%r0)
ld %r0b, 255(%r0)

# CHECK: ld %r0h, 0(%r0)        # encoding: [0x58,0x00,0x00]
# CHECK: ld %r0h, 0(%r15)       # encoding: [0x58,0xf0,0x00]
# CHECK: ld %r15h, 0(%r0)       # encoding: [0x58,0x0f,0x00]
# CHECK: ld %r0h, 510(%r0)      # encoding: [0x58,0x00,0xff]
ld %r0h, 0(%r0)
ld %r0h, 0(%r15)
ld %r15h, 0(%r0)
ld %r0h, 510(%r0)

# CHECK: ld %r0, 0(%r0)         # encoding: [0x98,0x00,0x00]
# CHECK: ld %r0, 0(%r15)        # encoding: [0x98,0xf0,0x00]
# CHECK: ld %r15, 0(%r0)        # encoding: [0x98,0x0f,0x00]
# CHECK: ld %r0, 1020(%r0)      # encoding: [0x98,0x00,0xff]
ld %r0, 0(%r0)
ld %r0, 0(%r15)
ld %r15, 0(%r0)
ld %r0, 1020(%r0)


# CHECK: ld %r0b, 0(%sp)        # encoding: [0x34,0x00,0x00]
# CHECK: ld %r15b, 0(%sp)       # encoding: [0x34,0xf0,0x00]
# CHECK: ld %r0b, 255(%sp)      # encoding: [0x34,0x00,0xff]
ld %r0b, 0(%sp)
ld %r15b, 0(%sp)
ld %r0b, 255(%sp)

# CHECK: ld %r0h, 0(%sp)        # encoding: [0x74,0x00,0x00]
# CHECK: ld %r15h, 0(%sp)       # encoding: [0x74,0xf0,0x00]
# CHECK: ld %r0h, 510(%sp)      # encoding: [0x74,0x00,0xff]
ld %r0h, 0(%sp)
ld %r15h, 0(%sp)
ld %r0h, 510(%sp)

# CHECK: ld %r0, 0(%sp)         # encoding: [0xb4,0x00,0x00]
# CHECK: ld %r15, 0(%sp)        # encoding: [0xb4,0xf0,0x00]
# CHECK: ld %r0, 1020(%sp)      # encoding: [0xb4,0x00,0xff]
ld %r0, 0(%sp)
ld %r15, 0(%sp)
ld %r0, 1020(%sp)


# CHECK: ld %r0b, %r0(%r0)      # encoding: [0x3c,0x00,0x08]
# CHECK: ld %r0b, %r0(%r15)     # encoding: [0x3c,0xf0,0x08]
# CHECK: ld %r0b, %r15(%r0)     # encoding: [0x3c,0x0f,0x08]
# CHECK: ld %r15b, %r0(%r0)     # encoding: [0x3c,0x00,0xf8]
ld %r0b, %r0(%r0)
ld %r0b, %r0(%r15)
ld %r0b, %r15(%r0)
ld %r15b, %r0(%r0)

# CHECK: ld %r0h, %r0(%r0)      # encoding: [0x7c,0x00,0x08]
# CHECK: ld %r0h, %r0(%r15)     # encoding: [0x7c,0xf0,0x08]
# CHECK: ld %r0h, %r15(%r0)     # encoding: [0x7c,0x0f,0x08]
# CHECK: ld %r15h, %r0(%r0)     # encoding: [0x7c,0x00,0xf8]
ld %r0h, %r0(%r0)
ld %r0h, %r0(%r15)
ld %r0h, %r15(%r0)
ld %r15h, %r0(%r0)

# CHECK: ld %r0, %r0(%r0)       # encoding: [0xbc,0x00,0x08]
# CHECK: ld %r0, %r0(%r15)      # encoding: [0xbc,0xf0,0x08]
# CHECK: ld %r0, %r15(%r0)      # encoding: [0xbc,0x0f,0x08]
# CHECK: ld %r15, %r0(%r0)      # encoding: [0xbc,0x00,0xf8]
ld %r0, %r0(%r0)
ld %r0, %r0(%r15)
ld %r0, %r15(%r0)
ld %r15, %r0(%r0)


# CHECK: ld %r0b, %r0(%sp)      # encoding: [0x3a,0x00,0x00]
# CHECK: ld %r0b, %r15(%sp)     # encoding: [0x3a,0x0f,0x00]
# CHECK: ld %r15b, %r0(%sp)     # encoding: [0x3a,0xf0,0x00]
ld %r0b, %r0(%sp)
ld %r0b, %r15(%sp)
ld %r15b, %r0(%sp)

# CHECK: ld %r0h, %r0(%sp)      # encoding: [0x7a,0x00,0x00]
# CHECK: ld %r0h, %r15(%sp)     # encoding: [0x7a,0x0f,0x00]
# CHECK: ld %r15h, %r0(%sp)     # encoding: [0x7a,0xf0,0x00]
ld %r0h, %r0(%sp)
ld %r0h, %r15(%sp)
ld %r15h, %r0(%sp)

# CHECK: ld %r0, %r0(%sp)       # encoding: [0xba,0x00,0x00]
# CHECK: ld %r0, %r15(%sp)      # encoding: [0xba,0x0f,0x00]
# CHECK: ld %r15, %r0(%sp)      # encoding: [0xba,0xf0,0x00]
ld %r0, %r0(%sp)
ld %r0, %r15(%sp)
ld %r15, %r0(%sp)
