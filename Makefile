S_SOURCES = $(shell find . -name "*.s")
S_OBJECTS = $(patsubst %.s, %.o, $(S_SOURCES))
C_SOURCES = $(shell find . -name "*.c")
C_OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))

ASM = nasm
CC  = gcc
LD  = ld

ASM_FLAGS = -f elf -g -F stabs
C_FLAGS = -std=c99 -c -m32 -Wall -Wextra -ggdb -gstabs+ -ffreestanding -I. -Iinclude
LD_FLAGS = -T link.ld -nostdlib

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

