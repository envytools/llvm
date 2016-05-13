# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: not %r0b              # encoding: [0x3d,0x00]
# CHECK: not %r1b              # encoding: [0x3d,0x10]
# CHECK: not %r2b              # encoding: [0x3d,0x20]
# CHECK: not %r3b              # encoding: [0x3d,0x30]
# CHECK: not %r4b              # encoding: [0x3d,0x40]
# CHECK: not %r5b              # encoding: [0x3d,0x50]
# CHECK: not %r6b              # encoding: [0x3d,0x60]
# CHECK: not %r7b              # encoding: [0x3d,0x70]
# CHECK: not %r8b              # encoding: [0x3d,0x80]
# CHECK: not %r9b              # encoding: [0x3d,0x90]
# CHECK: not %r10b             # encoding: [0x3d,0xa0]
# CHECK: not %r11b             # encoding: [0x3d,0xb0]
# CHECK: not %r12b             # encoding: [0x3d,0xc0]
# CHECK: not %r13b             # encoding: [0x3d,0xd0]
# CHECK: not %r14b             # encoding: [0x3d,0xe0]
# CHECK: not %r15b             # encoding: [0x3d,0xf0]
not %r0b
not %r1b
not %r2b
not %r3b
not %r4b
not %r5b
not %r6b
not %r7b
not %r8b
not %r9b
not %r10b
not %r11b
not %r12b
not %r13b
not %r14b
not %r15b

# CHECK: not %r0h              # encoding: [0x7d,0x00]
# CHECK: not %r1h              # encoding: [0x7d,0x10]
# CHECK: not %r2h              # encoding: [0x7d,0x20]
# CHECK: not %r3h              # encoding: [0x7d,0x30]
# CHECK: not %r4h              # encoding: [0x7d,0x40]
# CHECK: not %r5h              # encoding: [0x7d,0x50]
# CHECK: not %r6h              # encoding: [0x7d,0x60]
# CHECK: not %r7h              # encoding: [0x7d,0x70]
# CHECK: not %r8h              # encoding: [0x7d,0x80]
# CHECK: not %r9h              # encoding: [0x7d,0x90]
# CHECK: not %r10h             # encoding: [0x7d,0xa0]
# CHECK: not %r11h             # encoding: [0x7d,0xb0]
# CHECK: not %r12h             # encoding: [0x7d,0xc0]
# CHECK: not %r13h             # encoding: [0x7d,0xd0]
# CHECK: not %r14h             # encoding: [0x7d,0xe0]
# CHECK: not %r15h             # encoding: [0x7d,0xf0]
not %r0h
not %r1h
not %r2h
not %r3h
not %r4h
not %r5h
not %r6h
not %r7h
not %r8h
not %r9h
not %r10h
not %r11h
not %r12h
not %r13h
not %r14h
not %r15h

# CHECK: not %r0               # encoding: [0xbd,0x00]
# CHECK: not %r1               # encoding: [0xbd,0x10]
# CHECK: not %r2               # encoding: [0xbd,0x20]
# CHECK: not %r3               # encoding: [0xbd,0x30]
# CHECK: not %r4               # encoding: [0xbd,0x40]
# CHECK: not %r5               # encoding: [0xbd,0x50]
# CHECK: not %r6               # encoding: [0xbd,0x60]
# CHECK: not %r7               # encoding: [0xbd,0x70]
# CHECK: not %r8               # encoding: [0xbd,0x80]
# CHECK: not %r9               # encoding: [0xbd,0x90]
# CHECK: not %r10              # encoding: [0xbd,0xa0]
# CHECK: not %r11              # encoding: [0xbd,0xb0]
# CHECK: not %r12              # encoding: [0xbd,0xc0]
# CHECK: not %r13              # encoding: [0xbd,0xd0]
# CHECK: not %r14              # encoding: [0xbd,0xe0]
# CHECK: not %r15              # encoding: [0xbd,0xf0]
not %r0
not %r1
not %r2
not %r3
not %r4
not %r5
not %r6
not %r7
not %r8
not %r9
not %r10
not %r11
not %r12
not %r13
not %r14
not %r15
