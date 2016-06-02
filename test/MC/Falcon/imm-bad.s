# RUN: not llvm-mc -filetype obj -triple=falcon3 %s -o /dev/null 2>&1 | FileCheck %s

# CHECK: invalid operand for instruction
# CHECK: mov %r0, 0x8000
# CHECK: invalid operand for instruction
# CHECK: mov %r0, -0x8001
mov %r0, 0x8000
mov %r0, -0x8001

# CHECK: invalid operand for instruction
# CHECK: add %r0, 0x10000
# CHECK: invalid operand for instruction
# CHECK: add %r0, -1
add %r0, 0x10000
add %r0, -1

# CHECK: invalid operand for instruction
# CHECK: shl %r0, 0x100
# CHECK: invalid operand for instruction
# CHECK: shl %r0, -1
shl %r0, 0x100
shl %r0, -1

# CHECK: invalid operand for instruction
# CHECK: mov %r0, %u8(0)
# CHECK: invalid operand for instruction
# CHECK: mov %r0, %u16(0)
# CHECK: invalid operand for instruction
# CHECK: mov %r0, %hi8(0)
# CHECK: invalid operand for instruction
# CHECK: mov %r0, %hi16(0)
mov %r0, %u8(0)
mov %r0, %u16(0)
mov %r0, %hi8(0)
mov %r0, %hi16(0)

# CHECK: invalid operand for instruction
# CHECK: sethi %r0, %s8(0)
# CHECK: invalid operand for instruction
# CHECK: sethi %r0, %s16(0)
# CHECK: invalid operand for instruction
# CHECK: sethi %r0, %lo16(0)
sethi %r0, %s8(0)
sethi %r0, %s16(0)
sethi %r0, %lo16(0)

# CHECK: invalid operand for instruction
# CHECK: shl %r0, %u16(0)
shl %r0, %u16(0)

# CHECK: invalid operand for instruction
# CHECK: ld %r0b, -1(%r0)
ld %r0b, -1(%r0)

# CHECK: invalid operand for instruction
# CHECK: ld %r0b, 0x100(%r0)
ld %r0b, 0x100(%r0)

# CHECK: invalid operand for instruction
# CHECK: ld %r0h, 0x200(%r0)
ld %r0h, 0x200(%r0)

# CHECK: invalid operand for instruction
# CHECK: ld %r0, 0x400(%r0)
ld %r0, 0x400(%r0)

# CHECK: invalid operand for instruction
# CHECK: ld %r0h, 1(%r0)
ld %r0h, 1(%r0)

# CHECK: invalid operand for instruction
# CHECK: ld %r0, 2(%r0)
ld %r0, 2(%r0)
