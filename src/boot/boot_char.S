
[BITS 16]	;directive specifies whether NASM should generate code in 16-bit mode

BOOTSEG		equ 0x7c00
BIOS_INT	equ 0x10
SYMBOL		equ '!'

print_char:
	mov ah, 0x0e		; BIOS teletype mode
	mov al, SYMBOL
	xor bx, bx
	int BIOS_INT

	ret

_start:
	call print_char

times 510 - ($ - $$) db 0	; fill the rest of the sector with zeros

;BIOS looks for the boot signature '0x55AA':
db 0x55
db 0xAA
