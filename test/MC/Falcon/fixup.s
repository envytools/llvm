# RUN: llvm-mc -triple falcon3 --show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple falcon3 -filetype=obj %s | \
# RUN: llvm-readobj -r | FileCheck %s -check-prefix=CHECK-REL

# .align won't work otherwise.
.data

# CHECK: mov %r0, target          # encoding: [0xf0,0x07,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S8R
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S16 target 0x0
.align 16
mov %r0, target

# CHECK: mov %r0, %s8(target)     # encoding: [0xf0,0x07,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S8 target 0x0
.align 16
mov %r0, %s8(target)

# CHECK: mov %r0, %s16(target)    # encoding: [0xf1,0x07,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S16 target 0x0
.align 16
mov %r0, %s16(target)

# CHECK: mov %r0, %lo16(target)   # encoding: [0xf1,0x07,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_LO16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_LO16 target 0x0
.align 16
mov %r0, %lo16(target)

# CHECK: sethi %r0, target        # encoding: [0xf0,0x03,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8R
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_16 target 0x0
.align 16
sethi %r0, target

# CHECK: sethi %r0, %u8(target)   # encoding: [0xf0,0x03,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8 target 0x0
.align 16
sethi %r0, %u8(target)

# CHECK: sethi %r0, %u16(target)  # encoding: [0xf1,0x03,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_16 target 0x0
.align 16
sethi %r0, %u16(target)

# CHECK: sethi %r0, %hi8(target)  # encoding: [0xf0,0x03,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_HI8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_HI8 target 0x0
.align 16
sethi %r0, %hi8(target)

# CHECK: sethi %r0, %hi16(target) # encoding: [0xf1,0x03,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_HI16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_HI16 target 0x0
.align 16
sethi %r0, %hi16(target)

# CHECK: ld %r0b, target(%r0)     # encoding: [0x18,0x00,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8 target 0x0
.align 16
ld %r0b, target(%r0)

# CHECK: ld %r0h, target(%r0)     # encoding: [0x58,0x00,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8S1
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8S1 target 0x0
.align 16
ld %r0h, target(%r0)

# CHECK: ld %r0, target(%r0)      # encoding: [0x98,0x00,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8S2
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8S2 target 0x0
.align 16
ld %r0, target(%r0)

# CHECK: cmps %r0b, target        # encoding: [0x30,0x05,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S8 target 0x0
.align 16
cmps %r0b, target

# CHECK: cmps %r0b, %s8(target)   # encoding: [0x30,0x05,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S8 target 0x0
.align 16
cmps %r0b, %s8(target)

# CHECK: cmps %r0b, %s16(target)  # encoding: [0x31,0x05,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S16 target 0x0
.align 16
cmps %r0b, %s16(target)

# CHECK: cmps %r0h, target        # encoding: [0x70,0x05,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S8R
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S16 target 0x0
.align 16
cmps %r0h, target

# CHECK: cmps %r0h, %s8(target)   # encoding: [0x70,0x05,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S8 target 0x0
.align 16
cmps %r0h, %s8(target)

# CHECK: cmps %r0h, %s16(target)  # encoding: [0x71,0x05,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S16 target 0x0
.align 16
cmps %r0h, %s16(target)

# CHECK: cmps %r0, target         # encoding: [0xb0,0x05,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S8R
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S16 target 0x0
.align 16
cmps %r0, target

# CHECK: cmps %r0, %s8(target)    # encoding: [0xb0,0x05,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S8 target 0x0
.align 16
cmps %r0, %s8(target)

# CHECK: cmps %r0, %s16(target)   # encoding: [0xb1,0x05,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_S16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_S16 target 0x0
.align 16
cmps %r0, %s16(target)

# CHECK: cmpu %r0b, target        # encoding: [0x30,0x04,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8 target 0x0
.align 16
cmpu %r0b, target

# CHECK: cmpu %r0b, %u8(target)   # encoding: [0x30,0x04,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8 target 0x0
.align 16
cmpu %r0b, %u8(target)

# CHECK: cmpu %r0b, %u16(target)  # encoding: [0x31,0x04,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_16 target 0x0
.align 16
cmpu %r0b, %u16(target)

# CHECK: cmpu %r0h, target        # encoding: [0x70,0x04,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8R
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_16 target 0x0
.align 16
cmpu %r0h, target

# CHECK: cmpu %r0h, %u8(target)   # encoding: [0x70,0x04,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8 target 0x0
.align 16
cmpu %r0h, %u8(target)

# CHECK: cmpu %r0h, %u16(target)  # encoding: [0x71,0x04,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_16 target 0x0
.align 16
cmpu %r0h, %u16(target)

# CHECK: cmpu %r0, target         # encoding: [0xb0,0x04,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8R
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_16 target 0x0
.align 16
cmpu %r0, target

# CHECK: cmpu %r0, %u8(target)    # encoding: [0xb0,0x04,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8 target 0x0
.align 16
cmpu %r0, %u8(target)

# CHECK: cmpu %r0, %u16(target)   # encoding: [0xb1,0x04,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_16 target 0x0
.align 16
cmpu %r0, %u16(target)

# CHECK: shl %r0, target          # encoding: [0xb6,0x04,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8 target 0x0
.align 16
shl %r0, target

# CHECK: shl %r0, %u8(target)     # encoding: [0xb6,0x04,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target, kind: FK_FALCON_U8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_8 target 0x0
.align 16
shl %r0, %u8(target)

# CHECK: bra target               # encoding: [0xf4,0x0e,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target+2, kind: FK_FALCON_PC8R
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_PC16 target 0x2
.align 16
bra target

# CHECK: bra %pc8(target)         # encoding: [0xf4,0x0e,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target+2, kind: FK_FALCON_PC8
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_PC8 target 0x2
.align 16
bra %pc8(target)

# CHECK: bra %pc16(target)        # encoding: [0xf5,0x0e,A,A]
# CHECK-NEXT:                     # fixup A - offset: 2, value: target+2, kind: FK_FALCON_PC16
# CHECK-REL:                      0x{{[0-9A-F]*2}} R_FALCON_PC16 target 0x2
.align 16
bra %pc16(target)
