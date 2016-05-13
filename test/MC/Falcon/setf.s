# RUN: llvm-mc -triple=falcon0 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: setf %p0              # encoding: [0xf4,0x31,0x00]
# CHECK: setf %p7              # encoding: [0xf4,0x31,0x07]
# CHECK: setf %ccc             # encoding: [0xf4,0x31,0x08]
# CHECK: setf %ie0             # encoding: [0xf4,0x31,0x10]
setf %p0
setf %p7
setf %ccc
setf %ie0

# CHECK: setf %r0              # encoding: [0xf9,0x09]
# CHECK: setf %r15             # encoding: [0xf9,0xf9]
setf %r0
setf %r15


# CHECK: clrf %p0              # encoding: [0xf4,0x32,0x00]
# CHECK: clrf %p7              # encoding: [0xf4,0x32,0x07]
# CHECK: clrf %ccc             # encoding: [0xf4,0x32,0x08]
# CHECK: clrf %ie0             # encoding: [0xf4,0x32,0x10]
clrf %p0
clrf %p7
clrf %ccc
clrf %ie0

# CHECK: clrf %r0              # encoding: [0xf9,0x0a]
# CHECK: clrf %r15             # encoding: [0xf9,0xfa]
clrf %r0
clrf %r15


# CHECK: tglf %p0              # encoding: [0xf4,0x33,0x00]
# CHECK: tglf %p7              # encoding: [0xf4,0x33,0x07]
# CHECK: tglf %ccc             # encoding: [0xf4,0x33,0x08]
# CHECK: tglf %ie0             # encoding: [0xf4,0x33,0x10]
tglf %p0
tglf %p7
tglf %ccc
tglf %ie0

# CHECK: tglf %r0              # encoding: [0xf9,0x0b]
# CHECK: tglf %r15             # encoding: [0xf9,0xfb]
tglf %r0
tglf %r15


# CHECK: wait %p0              # encoding: [0xf4,0x28,0x00]
# CHECK: wait %p7              # encoding: [0xf4,0x28,0x07]
# CHECK: wait %ccc             # encoding: [0xf4,0x28,0x08]
# CHECK: wait %ie0             # encoding: [0xf4,0x28,0x10]
wait %p0
wait %p7
wait %ccc
wait %ie0
