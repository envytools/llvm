# RUN: not llvm-mc -filetype obj -triple=falcon3 %s -o /dev/null 2>&1 | FileCheck %s

# CHECK: s8 fixup value out of range
# CHECK-NEXT: s16 fixup value out of range
# CHECK-NEXT: u8 fixup value out of range
# CHECK-NEXT: u16 fixup value out of range
# CHECK-NEXT: hi8 fixup value out of range
mov %r0, %s8(0x80)
mov %r0, %s16(0x8000)
sethi %r0, %u8(0x100)
sethi %r0, %u16(0x10000)
sethi %r0, %hi8(0x1000000)

# CHECK-NEXT: s8 fixup value out of range
# CHECK-NEXT: s16 fixup value out of range
# CHECK-NEXT: u8 fixup value out of range
# CHECK-NEXT: u16 fixup value out of range
# CHECK-NEXT: hi8 fixup value out of range
mov %r0, %s8(-0x81)
mov %r0, %s16(-0x8001)
sethi %r0, %u8(-1)
sethi %r0, %u16(-1)
sethi %r0, %hi8(-1)

# CHECK-NEXT: u8 fixup value out of range
# CHECK-NEXT: u8s1 fixup value out of range
# CHECK-NEXT: u8s2 fixup value out of range
ld %r0b, s_100(%r0)
ld %r0h, s_200(%r0)
ld %r0, s_400(%r0)
# CHECK-NEXT: u8s1 fixup value unaligned
# CHECK-NEXT: u8s2 fixup value unaligned
ld %r0h, s_1(%r0)
ld %r0, s_2(%r0)

s_1 = 1
s_2 = 2
s_100 = 0x100
s_200 = 0x200
s_400 = 0x400

# CHECK-NEXT: s8 fixup value out of range
sa:
bra %pc8(sb)
sb = sa + 0x80

# CHECK-NEXT: s16 fixup value out of range
a:
bra b
b = a + 0x8000

# CHECK-NEXT: s16 fixup value out of range
la:
bra %pc16(lb)
lb = la + 0x8000
