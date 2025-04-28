[ORG 0x7C00]
[BITS 16]

BIOS_INT		equ 0x10
SYMBOL			equ '!'

CODE_SEG		equ (gdt_code_seg - gdt_start)
DATA_SEG		equ (gdt_data_seg - gdt_start)
REAL_MODE_STACK		equ (0x2000 - 0x10)

jmp short start
nop

start:
	jmp 0:step2

step2:
	cli

	xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	mov sp, 0x7C00

	;call print_symb_bios

	jmp real_to_protected

real_to_protected:

	cli				; ?once again

	xor ax, ax
	mov ds, ax

	lgdt [gdt_desc]

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
	db 0xCF				; flags and limit (bits 16-19)
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

	; enable the A20 line:
	in al, 0x92
	or al, 2
	out 0x92, al

	;call print_symb_not_bios

	mov eax, 1
	mov ecx, 100
	mov edi, 0x0100000

	call ata_lba_read

	jmp CODE_SEG:0x0100000

ata_lba_read:
	mov ebx, eax
	shr eax, 24
	or eax, 0xE0
	mov dx, 0x1F6
	out dx, al

	mov eax, ecx
	mov dx, 0x1F2
	out dx, al

	mov eax, ebx
	mov dx, 0x1F3
	out dx, al

	mov dx, 0x1F4
	mov eax, ebx
	shr eax, 8
	out dx, al

	mov dx, 0x1F5
	mov eax, ebx
	shr eax, 16
	out dx, al

	mov dx, 0x1f7
	mov al, 0x20
	out dx, al

.next_sector:
	push ecx

.try_again:
	mov dx, 0x1f7
	in al, dx
	test al, 8
	jz .try_again

	mov ecx, 256
	mov dx, 0x1F0
	rep insw
	pop ecx
	loop .next_sector
	ret

;print_symb_bios:
;	mov ah, 0x0E			; BIOS teletype mode
;	mov al, SYMBOL
;	xor bx, bx
;	int BIOS_INT
;	ret
;
;print_symb_not_bios:
;	mov al, 'P'
;	mov ah, 0x04			; specify the color
;	mov [0xB80A0], ax		; specify symbol screen place
;	ret
;
times 510 - ($ - $$) db 0
dw 0xAA55
