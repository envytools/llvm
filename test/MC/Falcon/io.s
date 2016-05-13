# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: iowr 0(%r0), %r0      # encoding: [0xd0,0x00,0x00]
# CHECK: iowr 1020(%r0), %r0   # encoding: [0xd0,0x00,0xff]
# CHECK: iowr 0(%r15), %r0     # encoding: [0xd0,0xf0,0x00]
# CHECK: iowr 0(%r0), %r15     # encoding: [0xd0,0x0f,0x00]
iowr 0(%r0), %r0
iowr 1020(%r0), %r0
iowr 0(%r15), %r0
iowr 0(%r0), %r15

# CHECK: iowr (%r0), %r0       # encoding: [0xfa,0x00,0x00]
# CHECK: iowr (%r15), %r0      # encoding: [0xfa,0xf0,0x00]
# CHECK: iowr (%r0), %r15      # encoding: [0xfa,0x0f,0x00]
iowr (%r0), %r0
iowr (%r15), %r0
iowr (%r0), %r15

# CHECK: iowrb 0(%r0), %r0      # encoding: [0xd1,0x00,0x00]
# CHECK: iowrb 1020(%r0), %r0   # encoding: [0xd1,0x00,0xff]
# CHECK: iowrb 0(%r15), %r0     # encoding: [0xd1,0xf0,0x00]
# CHECK: iowrb 0(%r0), %r15     # encoding: [0xd1,0x0f,0x00]
iowrb 0(%r0), %r0
iowrb 1020(%r0), %r0
iowrb 0(%r15), %r0
iowrb 0(%r0), %r15

# CHECK: iowrb (%r0), %r0       # encoding: [0xfa,0x00,0x01]
# CHECK: iowrb (%r15), %r0      # encoding: [0xfa,0xf0,0x01]
# CHECK: iowrb (%r0), %r15      # encoding: [0xfa,0x0f,0x01]
iowrb (%r0), %r0
iowrb (%r15), %r0
iowrb (%r0), %r15


# CHECK: iord %r0, 0(%r0)         # encoding: [0xcf,0x00,0x00]
# CHECK: iord %r0, 0(%r15)        # encoding: [0xcf,0xf0,0x00]
# CHECK: iord %r15, 0(%r0)        # encoding: [0xcf,0x0f,0x00]
# CHECK: iord %r0, 1020(%r0)      # encoding: [0xcf,0x00,0xff]
iord %r0, 0(%r0)
iord %r0, 0(%r15)
iord %r15, 0(%r0)
iord %r0, 1020(%r0)

# CHECK: iord %r0, %r0(%r0)       # encoding: [0xff,0x00,0x0f]
# CHECK: iord %r0, %r0(%r15)      # encoding: [0xff,0xf0,0x0f]
# CHECK: iord %r0, %r15(%r0)      # encoding: [0xff,0x0f,0x0f]
# CHECK: iord %r15, %r0(%r0)      # encoding: [0xff,0x00,0xff]
iord %r0, %r0(%r0)
iord %r0, %r0(%r15)
iord %r0, %r15(%r0)
iord %r15, %r0(%r0)

# CHECK: iordb %r0, 0(%r0)         # encoding: [0xce,0x00,0x00]
# CHECK: iordb %r0, 0(%r15)        # encoding: [0xce,0xf0,0x00]
# CHECK: iordb %r15, 0(%r0)        # encoding: [0xce,0x0f,0x00]
# CHECK: iordb %r0, 1020(%r0)      # encoding: [0xce,0x00,0xff]
iordb %r0, 0(%r0)
iordb %r0, 0(%r15)
iordb %r15, 0(%r0)
iordb %r0, 1020(%r0)

# CHECK: iordb %r0, %r0(%r0)       # encoding: [0xff,0x00,0x0e]
# CHECK: iordb %r0, %r0(%r15)      # encoding: [0xff,0xf0,0x0e]
# CHECK: iordb %r0, %r15(%r0)      # encoding: [0xff,0x0f,0x0e]
# CHECK: iordb %r15, %r0(%r0)      # encoding: [0xff,0x00,0xfe]
iordb %r0, %r0(%r0)
iordb %r0, %r0(%r15)
iordb %r0, %r15(%r0)
iordb %r15, %r0(%r0)
