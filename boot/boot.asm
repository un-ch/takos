;;

SYMBOL		equ 'K'
BIOS_INTERRUPT	equ 0x10

ORG	0
BITS	16		; use 16-bit arch

; BIOS Parameter  Block (BPB) stuff:
_start:
	jmp short start
	nop

times 33 db 0

start:
	jmp 0x7c0:next

handle_zero:
	mov ah, 0x0e
	mov al, '0'
	xor bx, bx
	int 0x10
	iret

handle_int_one:
	mov ah, 0x0e
	mov al, '1'
	xor bx, bx
	int 0x10
	iret

next:
	cli		; disable (clear) interrupts to prevent CPU from handling interrupts
	mov ax, 0x7c0
	mov ds, ax
	mov es, ax
	xor ax, ax
	mov ss, ax
	mov sp, 0x7c00
	sti		; enable interrupts

	mov word[ss:0x00], handle_zero
	mov word[ss:0x02], 0x7c0

	mov word[ss:0x04], handle_int_one
	mov word[ss:0x06], 0x7c0


	int 1
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
