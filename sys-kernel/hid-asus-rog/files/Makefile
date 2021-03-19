obj-m	:= src/hid-asus-rog.o
KERNEL_NAME := $(shell basename `readlink -f /usr/src/linux`)
KERNELDIR ?= /lib/modules/$(shell echo $(KERNEL_NAME) | sed 's/linux-//')/build
PWD       := $(shell pwd)

all: default

default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

clean:
	rm -rf src/*.o src/*~ src/.*.cmd src/*.ko src/*.mod.c \
		.tmp_versions modules.order Module.symvers

