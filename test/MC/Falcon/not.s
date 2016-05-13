# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: not %r0b, %r0b    # encoding: [0x39,0x00,0x00]
# CHECK: not %r0b, %r15b   # encoding: [0x39,0xf0,0x00]
# CHECK: not %r15b, %r0b   # encoding: [0x39,0x0f,0x00]
	not	%r0b, %r0b
	not	%r0b, %r15b
	not	%r15b, %r0b
# CHECK: not %r0h, %r0h    # encoding: [0x79,0x00,0x00]
# CHECK: not %r0h, %r15h   # encoding: [0x79,0xf0,0x00]
# CHECK: not %r15h, %r0h   # encoding: [0x79,0x0f,0x00]
	not	%r0h, %r0h
	not	%r0h, %r15h
	not	%r15h, %r0h
# CHECK: not %r0, %r0      # encoding: [0xb9,0x00,0x00]
# CHECK: not %r0, %r15     # encoding: [0xb9,0xf0,0x00]
# CHECK: not %r15, %r0     # encoding: [0xb9,0x0f,0x00]
	not	%r0, %r0
	not	%r0, %r15
	not	%r15, %r0

# CHECK: not %r0b    # encoding: [0x3d,0x00]
# CHECK: not %r15b   # encoding: [0x3d,0xf0]
	not	%r0b
	not	%r15b
# CHECK: not %r0h    # encoding: [0x7d,0x00]
# CHECK: not %r15h   # encoding: [0x7d,0xf0]
	not	%r0h
	not	%r15h
# CHECK: not %r0      # encoding: [0xbd,0x00]
# CHECK: not %r15     # encoding: [0xbd,0xf0]
	not	%r0
	not	%r15

# CHECK: neg %r0b, %r0b    # encoding: [0x39,0x00,0x01]
# CHECK: neg %r0b, %r15b   # encoding: [0x39,0xf0,0x01]
# CHECK: neg %r15b, %r0b   # encoding: [0x39,0x0f,0x01]
	neg	%r0b, %r0b
	neg	%r0b, %r15b
	neg	%r15b, %r0b
# CHECK: neg %r0h, %r0h    # encoding: [0x79,0x00,0x01]
# CHECK: neg %r0h, %r15h   # encoding: [0x79,0xf0,0x01]
# CHECK: neg %r15h, %r0h   # encoding: [0x79,0x0f,0x01]
	neg	%r0h, %r0h
	neg	%r0h, %r15h
	neg	%r15h, %r0h
# CHECK: neg %r0, %r0      # encoding: [0xb9,0x00,0x01]
# CHECK: neg %r0, %r15     # encoding: [0xb9,0xf0,0x01]
# CHECK: neg %r15, %r0     # encoding: [0xb9,0x0f,0x01]
	neg	%r0, %r0
	neg	%r0, %r15
	neg	%r15, %r0

# CHECK: neg %r0b    # encoding: [0x3d,0x01]
# CHECK: neg %r15b   # encoding: [0x3d,0xf1]
	neg	%r0b
	neg	%r15b
# CHECK: neg %r0h    # encoding: [0x7d,0x01]
# CHECK: neg %r15h   # encoding: [0x7d,0xf1]
	neg	%r0h
	neg	%r15h
# CHECK: neg %r0      # encoding: [0xbd,0x01]
# CHECK: neg %r15     # encoding: [0xbd,0xf1]
	neg	%r0
	neg	%r15

# CHECK: mov %r0b, %r0b    # encoding: [0x39,0x00,0x02]
# CHECK: mov %r0b, %r15b   # encoding: [0x39,0xf0,0x02]
# CHECK: mov %r15b, %r0b   # encoding: [0x39,0x0f,0x02]
	mov	%r0b, %r0b
	mov	%r0b, %r15b
	mov	%r15b, %r0b
# CHECK: mov %r0h, %r0h    # encoding: [0x79,0x00,0x02]
# CHECK: mov %r0h, %r15h   # encoding: [0x79,0xf0,0x02]
# CHECK: mov %r15h, %r0h   # encoding: [0x79,0x0f,0x02]
	mov	%r0h, %r0h
	mov	%r0h, %r15h
	mov	%r15h, %r0h
# CHECK: mov %r0, %r0      # encoding: [0xb9,0x00,0x02]
# CHECK: mov %r0, %r15     # encoding: [0xb9,0xf0,0x02]
# CHECK: mov %r15, %r0     # encoding: [0xb9,0x0f,0x02]
	mov	%r0, %r0
	mov	%r0, %r15
	mov	%r15, %r0

# CHECK: mov %r0b    # encoding: [0x3d,0x02]
# CHECK: mov %r15b   # encoding: [0x3d,0xf2]
	mov	%r0b
	mov	%r15b
# CHECK: mov %r0h    # encoding: [0x7d,0x02]
# CHECK: mov %r15h   # encoding: [0x7d,0xf2]
	mov	%r0h
	mov	%r15h
# CHECK: mov %r0      # encoding: [0xbd,0x02]
# CHECK: mov %r15     # encoding: [0xbd,0xf2]
	mov	%r0
	mov	%r15

# CHECK: hswap %r0b, %r0b    # encoding: [0x39,0x00,0x03]
# CHECK: hswap %r0b, %r15b   # encoding: [0x39,0xf0,0x03]
# CHECK: hswap %r15b, %r0b   # encoding: [0x39,0x0f,0x03]
	hswap	%r0b, %r0b
	hswap	%r0b, %r15b
	hswap	%r15b, %r0b
# CHECK: hswap %r0h, %r0h    # encoding: [0x79,0x00,0x03]
# CHECK: hswap %r0h, %r15h   # encoding: [0x79,0xf0,0x03]
# CHECK: hswap %r15h, %r0h   # encoding: [0x79,0x0f,0x03]
	hswap	%r0h, %r0h
	hswap	%r0h, %r15h
	hswap	%r15h, %r0h
# CHECK: hswap %r0, %r0      # encoding: [0xb9,0x00,0x03]
# CHECK: hswap %r0, %r15     # encoding: [0xb9,0xf0,0x03]
# CHECK: hswap %r15, %r0     # encoding: [0xb9,0x0f,0x03]
	hswap	%r0, %r0
	hswap	%r0, %r15
	hswap	%r15, %r0

# CHECK: hswap %r0b    # encoding: [0x3d,0x03]
# CHECK: hswap %r15b   # encoding: [0x3d,0xf3]
	hswap	%r0b
	hswap	%r15b
# CHECK: hswap %r0h    # encoding: [0x7d,0x03]
# CHECK: hswap %r15h   # encoding: [0x7d,0xf3]
	hswap	%r0h
	hswap	%r15h
# CHECK: hswap %r0      # encoding: [0xbd,0x03]
# CHECK: hswap %r15     # encoding: [0xbd,0xf3]
	hswap	%r0
	hswap	%r15

# CHECK: clr %r0b    # encoding: [0x3d,0x04]
# CHECK: clr %r15b   # encoding: [0x3d,0xf4]
	clr	%r0b
	clr	%r15b
# CHECK: clr %r0h    # encoding: [0x7d,0x04]
# CHECK: clr %r15h   # encoding: [0x7d,0xf4]
	clr	%r0h
	clr	%r15h
# CHECK: clr %r0      # encoding: [0xbd,0x04]
# CHECK: clr %r15     # encoding: [0xbd,0xf4]
	clr	%r0
	clr	%r15

# CHECK: tst %r0b    # encoding: [0x3d,0x05]
# CHECK: tst %r15b   # encoding: [0x3d,0xf5]
	tst	%r0b
	tst	%r15b
# CHECK: tst %r0h    # encoding: [0x7d,0x05]
# CHECK: tst %r15h   # encoding: [0x7d,0xf5]
	tst	%r0h
	tst	%r15h
# CHECK: tst %r0      # encoding: [0xbd,0x05]
# CHECK: tst %r15     # encoding: [0xbd,0xf5]
	tst	%r0
	tst	%r15
