;;

SYMBOL		equ 'K'
BIOS_INTERRUPT	equ 0x10

ORG	0
BITS	16		; use 16-bit arch

_start:
	jmp short start
	nop

times 33 db 0

start:
	jmp 0x7c0:next
next:
	cli		; disable (clear) interrupts to prevent CPU from handling interrupts
	mov ax, 0x7c0
	mov ds, ax
	mov es, ax
	xor ax, ax
	mov ss, ax
	mov sp, 0x7c00
	sti		; enable interrupts

	mov ah, 0x0E	; teletype output (convention)
	mov al, SYMBOL
	xor bx, bx	; zero bl and bh registers

	int BIOS_INTERRUPT

	jmp $

times 510 - ($ - $$) db 0

; BIOS checks bootable devices for a boot signature with byte sequence 0x55 and 0xAA
; at byte offsets 510 and 511 respectively: 
db 0x55
db 0xAA
