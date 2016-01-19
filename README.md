# Linux Kernl ROP demo

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
