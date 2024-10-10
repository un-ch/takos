
ORG     0x7C00              ; BIOS loads the bootloader into RAM at absolute address 0x7C00
BITS    16                  ; use 16-bit arch

SYMBOL          equ 'K'
BIOS_INTERRUPT  equ 0x10

start:
    mov ah, 0x0E            ; teletype output (convention)
    mov al, SYMBOL
    xor bx, bx              ; zero bl and bh registers

    int BIOS_INTERRUPT

    jmp $

times 510 - ($ - $$) db 0

; BIOS checks bootable devices for a boot signature with byte sequence 0x55 and 0xAA
; at byte offsets 510 and 511 respectively: 
db 0x55
db 0xAA
