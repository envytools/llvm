# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: ret              # encoding: [0xf8,0x00]
ret
# CHECK: iret             # encoding: [0xf8,0x01]
iret
# CHECK: hlt              # encoding: [0xf8,0x02]
hlt
# CHECK: xdwait           # encoding: [0xf8,0x03]
xdwait
# CHECK: xdbar            # encoding: [0xf8,0x06]
xdbar
# CHECK: xcwait           # encoding: [0xf8,0x07]
xcwait

# XXX
# C-HECK: trap 0           # encoding: [0xf8,0x08]
#trap 0
# C-HECK: trap 1           # encoding: [0xf8,0x09]
#trap 1
# C-HECK: trap 2           # encoding: [0xf8,0x0a]
#trap 2
# C-HECK: trap 3           # encoding: [0xf8,0x0b]
#trap 3
