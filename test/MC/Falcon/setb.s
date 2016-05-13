# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: setb %r0, %r0          # encoding: [0xfd,0x00,0x09]
# CHECK: setb %r15, %r0         # encoding: [0xfd,0xf0,0x09]
# CHECK: setb %r0, %r15         # encoding: [0xfd,0x0f,0x09]
setb %r0, %r0
setb %r15, %r0
setb %r0, %r15

# CHECK: setb %r0, 0            # encoding: [0xf0,0x09,0x00]
# CHECK: setb %r15, 0           # encoding: [0xf0,0xf9,0x00]
# CHECK: setb %r0, 255          # encoding: [0xf0,0x09,0xff]
setb %r0, 0
setb %r15, 0
setb %r0, 255


# CHECK: clrb %r0, %r0          # encoding: [0xfd,0x00,0x0a]
# CHECK: clrb %r15, %r0         # encoding: [0xfd,0xf0,0x0a]
# CHECK: clrb %r0, %r15         # encoding: [0xfd,0x0f,0x0a]
clrb %r0, %r0
clrb %r15, %r0
clrb %r0, %r15

# CHECK: clrb %r0, 0            # encoding: [0xf0,0x0a,0x00]
# CHECK: clrb %r15, 0           # encoding: [0xf0,0xfa,0x00]
# CHECK: clrb %r0, 255          # encoding: [0xf0,0x0a,0xff]
clrb %r0, 0
clrb %r15, 0
clrb %r0, 255


# CHECK: tglb %r0, %r0          # encoding: [0xfd,0x00,0x0b]
# CHECK: tglb %r15, %r0         # encoding: [0xfd,0xf0,0x0b]
# CHECK: tglb %r0, %r15         # encoding: [0xfd,0x0f,0x0b]
tglb %r0, %r0
tglb %r15, %r0
tglb %r0, %r15

# CHECK: tglb %r0, 0            # encoding: [0xf0,0x0b,0x00]
# CHECK: tglb %r15, 0           # encoding: [0xf0,0xfb,0x00]
# CHECK: tglb %r0, 255          # encoding: [0xf0,0x0b,0xff]
tglb %r0, 0
tglb %r15, 0
tglb %r0, 255
