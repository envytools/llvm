# RUN: llvm-mc -triple=falcon3s -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4s -show-encoding %s | FileCheck %s

# CHECK: braf %p0, a                   # encoding: [0xf4,0x00,A]
# CHECK: fixup A - offset: 2, value: a+2, kind: FK_FALCON_PC8R
# CHECK: braf %p1, a                   # encoding: [0xf4,0x01,A]
# CHECK: braf %p2, a                   # encoding: [0xf4,0x02,A]
# CHECK: braf %p3, a                   # encoding: [0xf4,0x03,A]
# CHECK: braf %p4, a                   # encoding: [0xf4,0x04,A]
# CHECK: braf %p5, a                   # encoding: [0xf4,0x05,A]
# CHECK: braf %p6, a                   # encoding: [0xf4,0x06,A]
# CHECK: braf %p7, a                   # encoding: [0xf4,0x07,A]
# CHECK: brac a                        # encoding: [0xf4,0x08,A]
# CHECK: fixup A - offset: 2, value: a+2, kind: FK_FALCON_PC8R
# CHECK: brao a                        # encoding: [0xf4,0x09,A]
# CHECK: bras a                        # encoding: [0xf4,0x0a,A]
# CHECK: braz a                        # encoding: [0xf4,0x0b,A]
# CHECK: braa a                        # encoding: [0xf4,0x0c,A]
# CHECK: brana a                       # encoding: [0xf4,0x0d,A]
# CHECK: bra a                         # encoding: [0xf4,0x0e,A]
# CHECK: branf %p0, a                  # encoding: [0xf4,0x10,A]
# CHECK: branf %p1, a                  # encoding: [0xf4,0x11,A]
# CHECK: branf %p2, a                  # encoding: [0xf4,0x12,A]
# CHECK: branf %p3, a                  # encoding: [0xf4,0x13,A]
# CHECK: branf %p4, a                  # encoding: [0xf4,0x14,A]
# CHECK: branf %p5, a                  # encoding: [0xf4,0x15,A]
# CHECK: branf %p6, a                  # encoding: [0xf4,0x16,A]
# CHECK: branf %p7, a                  # encoding: [0xf4,0x17,A]
# CHECK: branc a                       # encoding: [0xf4,0x18,A]
# CHECK: brano a                       # encoding: [0xf4,0x19,A]
# CHECK: brans a                       # encoding: [0xf4,0x1a,A]
# CHECK: branz a                       # encoding: [0xf4,0x1b,A]
# CHECK: brag a                        # encoding: [0xf4,0x1c,A]
# CHECK: brale a                       # encoding: [0xf4,0x1d,A]
# CHECK: bral a                        # encoding: [0xf4,0x1e,A]
# CHECK: brage a                       # encoding: [0xf4,0x1f,A]
braf %p0, a
braf %p1, a
braf %p2, a
braf %p3, a
braf %p4, a
braf %p5, a
braf %p6, a
braf %p7, a
brac a
brao a
bras a
braz a
braa a
brana a
bra a
branf %p0, a
branf %p1, a
branf %p2, a
branf %p3, a
branf %p4, a
branf %p5, a
branf %p6, a
branf %p7, a
branc a
brano a
brans a
branz a
brag a
brale a
bral a
brage a

# CHECK: braf %p0, %pc16(a)            # encoding: [0xf5,0x00,A,A]
# CHECK: fixup A - offset: 2, value: a+2, kind: FK_FALCON_PC16
# CHECK: braf %p1, %pc16(a)            # encoding: [0xf5,0x01,A,A]
# CHECK: braf %p2, %pc16(a)            # encoding: [0xf5,0x02,A,A]
# CHECK: braf %p3, %pc16(a)            # encoding: [0xf5,0x03,A,A]
# CHECK: braf %p4, %pc16(a)            # encoding: [0xf5,0x04,A,A]
# CHECK: braf %p5, %pc16(a)            # encoding: [0xf5,0x05,A,A]
# CHECK: braf %p6, %pc16(a)            # encoding: [0xf5,0x06,A,A]
# CHECK: braf %p7, %pc16(a)            # encoding: [0xf5,0x07,A,A]
# CHECK: brac %pc16(a)                 # encoding: [0xf5,0x08,A,A]
# CHECK: fixup A - offset: 2, value: a+2, kind: FK_FALCON_PC16
# CHECK: brao %pc16(a)                 # encoding: [0xf5,0x09,A,A]
# CHECK: bras %pc16(a)                 # encoding: [0xf5,0x0a,A,A]
# CHECK: braz %pc16(a)                 # encoding: [0xf5,0x0b,A,A]
# CHECK: braa %pc16(a)                 # encoding: [0xf5,0x0c,A,A]
# CHECK: brana %pc16(a)                # encoding: [0xf5,0x0d,A,A]
# CHECK: bra %pc16(a)                  # encoding: [0xf5,0x0e,A,A]
# CHECK: branf %p0, %pc16(a)           # encoding: [0xf5,0x10,A,A]
# CHECK: branf %p1, %pc16(a)           # encoding: [0xf5,0x11,A,A]
# CHECK: branf %p2, %pc16(a)           # encoding: [0xf5,0x12,A,A]
# CHECK: branf %p3, %pc16(a)           # encoding: [0xf5,0x13,A,A]
# CHECK: branf %p4, %pc16(a)           # encoding: [0xf5,0x14,A,A]
# CHECK: branf %p5, %pc16(a)           # encoding: [0xf5,0x15,A,A]
# CHECK: branf %p6, %pc16(a)           # encoding: [0xf5,0x16,A,A]
# CHECK: branf %p7, %pc16(a)           # encoding: [0xf5,0x17,A,A]
# CHECK: branc %pc16(a)                # encoding: [0xf5,0x18,A,A]
# CHECK: brano %pc16(a)                # encoding: [0xf5,0x19,A,A]
# CHECK: brans %pc16(a)                # encoding: [0xf5,0x1a,A,A]
# CHECK: branz %pc16(a)                # encoding: [0xf5,0x1b,A,A]
# CHECK: brag %pc16(a)                 # encoding: [0xf5,0x1c,A,A]
# CHECK: brale %pc16(a)                # encoding: [0xf5,0x1d,A,A]
# CHECK: bral %pc16(a)                 # encoding: [0xf5,0x1e,A,A]
# CHECK: brage %pc16(a)                # encoding: [0xf5,0x1f,A,A]
braf %p0, %pc16(a)
braf %p1, %pc16(a)
braf %p2, %pc16(a)
braf %p3, %pc16(a)
braf %p4, %pc16(a)
braf %p5, %pc16(a)
braf %p6, %pc16(a)
braf %p7, %pc16(a)
brac %pc16(a)
brao %pc16(a)
bras %pc16(a)
braz %pc16(a)
braa %pc16(a)
brana %pc16(a)
bra %pc16(a)
branf %p0, %pc16(a)
branf %p1, %pc16(a)
branf %p2, %pc16(a)
branf %p3, %pc16(a)
branf %p4, %pc16(a)
branf %p5, %pc16(a)
branf %p6, %pc16(a)
branf %p7, %pc16(a)
branc %pc16(a)
brano %pc16(a)
brans %pc16(a)
branz %pc16(a)
brag %pc16(a)
brale %pc16(a)
bral %pc16(a)
brage %pc16(a)

# CHECK: bra %pc8(a)                   # encoding: [0xf4,0x0e,A]
# CHECK: fixup A - offset: 2, value: a+2, kind: FK_FALCON_PC8
bra %pc8(a)
