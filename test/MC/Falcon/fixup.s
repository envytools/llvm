# RUN: llvm-mc -filetype=obj -triple=falcon3 %s | llvm-objdump -d - | FileCheck %s

# CHECK: f8 00 ret
ret

# CHECK-NEXT: f1 07 00 c0     mov %r0, -16384
# CHECK-NEXT: f1 07 00 c0     mov %r0, -16384
# CHECK-NEXT: f0 07 c0        mov %r0, -64
# CHECK-NEXT: f1 07 c0 ff     mov %r0, -64
# CHECK-NEXT: f0 07 c0        mov %r0, -64
# CHECK-NEXT: f1 07 78 56     mov %r0,
# CHECK-NEXT: f1 07 ef cd     mov %r0,
# CHECK-NEXT: f1 07 56 00     mov %r0,
mov %r0, s16
mov %r0, %s16(s16)
mov %r0, s8
mov %r0, %s16(s8)
mov %r0, %s8(s8)
mov %r0, %lo16(u32)
mov %r0, %lo16(x32)
mov %r0, %lo16(y32)

# CHECK-NEXT: 31 05 00 c0     cmps %r0b, -16384
# CHECK-NEXT: 30 05 c0        cmps %r0b, -64
# CHECK-NEXT: 31 05 c0 ff     cmps %r0b, -64
# CHECK-NEXT: 30 05 c0        cmps %r0b, -64
cmps %r0b, %s16(s16)
cmps %r0b, s8
cmps %r0b, %s16(s8)
cmps %r0b, %s8(s8)

# CHECK-NEXT: f1 03 00 c0     sethi %r0, 49152
# CHECK-NEXT: f1 03 00 c0     sethi %r0, 49152
# CHECK-NEXT: f0 03 c0        sethi %r0, 192
# CHECK-NEXT: f1 03 c0 00     sethi %r0, 192
# CHECK-NEXT: f0 03 c0        sethi %r0, 192
# CHECK-NEXT: f1 03 34 12     sethi %r0,
# CHECK-NEXT: f1 03 ab 89     sethi %r0,
# CHECK-NEXT: f1 03 34 12     sethi %r0,
# CHECK-NEXT: f0 03 12        sethi %r0,
# CHECK-NEXT: f0 03 ab        sethi %r0,
sethi %r0, u16
sethi %r0, %u16(u16)
sethi %r0, u8
sethi %r0, %u16(u8)
sethi %r0, %u8(u8)
sethi %r0, %hi16(u32)
sethi %r0, %hi16(x32)
sethi %r0, %hi16(y32)
sethi %r0, %hi8(u24)
sethi %r0, %hi8(x24)

# CHECK-NEXT: f4 0e 7f        bra
# CHECK-NEXT: f5 0e 80 00     bra
bra .+0x7f
bra .+0x80

# CHECK-NEXT: 18 00 c0        ld %r0b, 192(%r0)
# CHECK-NEXT: 58 00 60        ld %r0h, 192(%r0)
# CHECK-NEXT: 98 00 30        ld %r0, 192(%r0)
# CHECK-NEXT: 58 00 c0        ld %r0h, 384(%r0)
# CHECK-NEXT: 98 00 c0        ld %r0, 768(%r0)
ld %r0b, u8(%r0)
ld %r0h, u8(%r0)
ld %r0, u8(%r0)
ld %r0h, u8s1(%r0)
ld %r0, u8s2(%r0)

s16 = -0x4000
u16 = 0xc000
u8 = 0xc0
s8 = -0x40
u32 = 0x12345678
x32 = 0x89abcdef
y32 = 0x12340056
u24 = 0x123456
x24 = 0xabcdef
u8s1 = 0x180
u8s2 = 0x300
