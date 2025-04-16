[BITS 16]
[ORG 0x7C00]

BIOS_INT		equ 0x10
SYMBOL			equ '!'
CODE_SEG		equ (gdt_code_seg - gdt_start)
DATA_SEG		equ (gdt_data_seg - gdt_start)
REAL_MODE_STACK		equ (0x2000 - 0x10)

_start:
	cli

	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax

	mov sp, $REAL_MODE_STACK

	call print_symb_bios

	jmp real_to_protected

real_to_protected:

	cli				; ?once again

	xor ax, ax
	mov ds, ax

	lgdt [gdt_desc]

	; turn on protected mode:
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	jmp CODE_SEG:protected_mode

gdt_start:
	; null descriptor:
	dw 0, 0
	db 0, 0, 0, 0

; code segment descriptor:
gdt_code_seg:
	dw 0xFFFF			; limit (bits 0-15)
	dw 0x0				; base (bits 0-15)
	db 0x0				; base (bits 16-23)
	db 0x9A				; access byte: present, dpl, type (code, execute/read)
	db 0xCF				; flags and linmit (bits 16-19)
	db 0x00				; base (24-31)

; data segment descriptor:
gdt_data_seg:
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 0x92
	db 0xCF
	db 0x00

gdt_end:

gdt_desc:
	dw gdt_end - gdt_start - 1	; sizeof(gdt) - 1
	dd gdt_start			; adress gdt

[BITS 32]
protected_mode:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov ebp, 0x00200000
	mov esp, ebp

	call print_symb_not_bios

	jmp $

print_symb_bios:
	mov ah, 0x0E			; BIOS teletype mode
	mov al, SYMBOL
	xor bx, bx
	int BIOS_INT
	ret

print_symb_not_bios:
	mov al, 'P'
	mov ah, 0x04			; specify the color
	mov [0xB80A0], ax		; specify symbol screen place
	ret

times 510 - ($ - $$) db 0
dw 0xAA55
