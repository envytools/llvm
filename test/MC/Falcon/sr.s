# RUN: llvm-mc -triple=falcon3 -show-encoding %s | FileCheck %s
# RUN: llvm-mc -triple=falcon4 -show-encoding %s | FileCheck %s

# CHECK: mov %iv0, %r0         # encoding: [0xfe,0x00,0x00]
# CHECK: mov %iv1, %r0         # encoding: [0xfe,0x01,0x00]
# CHECK: mov %tv, %r0          # encoding: [0xfe,0x03,0x00]
# CHECK: mov %sp, %r0          # encoding: [0xfe,0x04,0x00]
# CHECK: mov %xcbase, %r0      # encoding: [0xfe,0x06,0x00]
# CHECK: mov %xdbase, %r0      # encoding: [0xfe,0x07,0x00]
# CHECK: mov %flags, %r0       # encoding: [0xfe,0x08,0x00]
# CHECK: mov %cauth, %r0       # encoding: [0xfe,0x0a,0x00]
# CHECK: mov %xports, %r0      # encoding: [0xfe,0x0b,0x00]
# CHECK: mov %tstat, %r0       # encoding: [0xfe,0x0c,0x00]
# CHECK: mov %iv0, %r15        # encoding: [0xfe,0xf0,0x00]
mov %iv0, %r0
mov %iv1, %r0
mov %tv, %r0
mov %sp, %r0
mov %xcbase, %r0
mov %xdbase, %r0
mov %flags, %r0
mov %cauth, %r0
mov %xports, %r0
mov %tstat, %r0
mov %iv0, %r15

# CHECK: mov %r0, %iv0         # encoding: [0xfe,0x00,0x01]
# CHECK: mov %r0, %iv1         # encoding: [0xfe,0x10,0x01]
# CHECK: mov %r0, %tv          # encoding: [0xfe,0x30,0x01]
# CHECK: mov %r0, %sp          # encoding: [0xfe,0x40,0x01]
# CHECK: mov %r0, %pc          # encoding: [0xfe,0x50,0x01]
# CHECK: mov %r0, %xcbase      # encoding: [0xfe,0x60,0x01]
# CHECK: mov %r0, %xdbase      # encoding: [0xfe,0x70,0x01]
# CHECK: mov %r0, %flags       # encoding: [0xfe,0x80,0x01]
# CHECK: mov %r0, %cx          # encoding: [0xfe,0x90,0x01]
# CHECK: mov %r0, %cauth       # encoding: [0xfe,0xa0,0x01]
# CHECK: mov %r0, %xports      # encoding: [0xfe,0xb0,0x01]
# CHECK: mov %r0, %tstat       # encoding: [0xfe,0xc0,0x01]
# CHECK: mov %r15, %iv0        # encoding: [0xfe,0x0f,0x01]
mov %r0, %iv0
mov %r0, %iv1
mov %r0, %tv
mov %r0, %sp
mov %r0, %pc
mov %r0, %xcbase
mov %r0, %xdbase
mov %r0, %flags
mov %r0, %cx
mov %r0, %cauth
mov %r0, %xports
mov %r0, %tstat
mov %r15, %iv0
