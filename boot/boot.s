;See https://wikipedia.org/wiki/Multiboot_Specification
MBOOT_HEADER_MAGIC      equ     0x1BADB002
MBOOT_PAGE_ALIGN        equ     1 << 0
MBOOT_MEM_INFO          equ     1 << 1
MBOOT_HEADER_FLAGS      equ     MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM          equ     -(MBOOT_HEADER_MAGIC+MBOOT_HEADER_FLAGS)

[BITS 32]

section .text
    dd      MBOOT_HEADER_MAGIC
    dd      MBOOT_HEADER_FLAGS
    dd      MBOOT_CHECKSUM

[GLOBAL start]
[GLOBAL g_mboot]
[EXTERN fk_entry]

start:
    cli
    mov     [g_mboot],  ebx
    mov     esp,        STACK_TOP
    and     esp,        0FFFFFFF0H
    mov     ebp,        0
    call    fk_entry
stop:
    hlt
    jmp     stop

section .data

stack:
    times 1024 db 0
g_mboot:
    db      0
STACK_TOP   equ         $-stack-1

