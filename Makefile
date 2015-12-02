S_SOURCES = $(shell find . -name "*.s")
S_OBJECTS = $(patsubst %.s, %.o, $(S_SOURCES))
C_SOURCES = $(shell find . -name "*.c")
C_OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
	ASM = nasm
	CC = gcc
	LD = ld

	ASM_FLAGS = -f elf -g -F stabs
	C_FLAGS = -std=c99 -c -m32 -Wall -Wextra -ggdb -gstabs+ -ffreestanding -I. -Iinclude
	LD_FLAGS = -T link.ld -nostdlib
endif

ifeq ($(UNAME_S),Darwin)
	ASM = nasm
	CC = clang
	LD = /usr/local/opt/i386-elf-binutils/bin/i386-elf-ld

	ASM_FLAGS = -f elf -g -F stabs
	C_FLAGS = -std=c99 -c -m32 -Wall -Wextra -ggdb -ffreestanding -target i386-pc-none-elf -I. -Iinclude
	LD_FLAGS = -T link.ld -nostdlib
endif

all: $(S_OBJECTS) $(C_OBJECTS) link

.s.o:
	$(ASM) $(ASM_FLAGS) $<

.c.o:
	$(CC) $(C_FLAGS) $< -o $@

link:
	$(LD) $(LD_FLAGS) $(S_OBJECTS) $(C_OBJECTS) -o fkernel

.PHONY:clean
clean:
	$(RM) $(S_OBJECTS) $(C_OBJECTS) fkernel

.PHONY:qemu
qemu: all
	qemu-system-i386 -kernel fkernel

