# RUN: not llvm-mc -filetype obj -triple=falcon3 %s -o /dev/null 2>&1 | FileCheck %s

# CHECK: unexpected token in argument list
# CHECK: mov %r0 %r0
mov %r0 %r0

# CHECK: register expected
# CHECK: ld %r0, %r0(
ld %r0, %r0(

# CHECK: register expected
# CHECK: ld %r0, 0(
ld %r0, 0(

# CHECK: register expected
# CHECK: ld %r0, (
ld %r0, (

# CHECK: closing ) expected
# CHECK: ld %r0, (%r0
ld %r0, (%r0

# CHECK: closing ) expected
# CHECK: ld %r0, (%r0,%r0)
ld %r0, (%r0,%r0)

# CHECK: unknown token in expression
# CHECK: ld %r0, %lo16(%r0)
ld %r0, %lo16(%r0)

# CHECK: opening ( expected
# CHECK: mov %pc, %lo16
mov %pc, %lo16

# CHECK: closing ) expected
# CHECK: mov %pc, %lo16(0
mov %pc, %lo16(0

# CHECK: invalid register
# CHECK: ld %r0, %r16(%r0)
ld %r0, %r16(%r0)

# CHECK: invalid operand for instruction
# CHECK: ld %r0, %r0b(%r0)
ld %r0, %r0b(%r0)

# CHECK: invalid register
# CHECK: ld %r0, %r0(%r16)
ld %r0, %r0(%r16)

# CHECK: invalid instruction
# CHECK: xewait
xewait

# CHECK: invalid operand for instruction
# CHECK: xdwait %r0
xdwait %r0

# CHECK: too few operands for instruction
# CHECK: add %r0
add %r0

# CHECK: invalid operand for instruction
# CHECK: mov %pc, %r0
mov %pc, %r0

# CHECK: invalid register
# CHECK: mov %r0, %
mov %r0, %
