obj-m += drv.o

CC=gcc
ccflags-y += "-g"
ccflags-y += "-O0"

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	# compile the trigger
	$(CC) trigger.c -O2 -o trigger

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -fr ./trigger
