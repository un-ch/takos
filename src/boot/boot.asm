
ORG	0x7c00	; BIOS loads the bootloader into RAM at the absolute address 0x7c00
BITS	16	; use 16-bit arch

BIOS_INTERRUPT	equ 0x10
TERMINATED_NULL	equ 0
MESSAGE		db  'Y', TERMINATED_NULL

CODE_SEG	equ gdt_code - gdt_start
DATA_SEG	equ gdt_data - gdt_start

_start:
	jmp short start
	nop

start:
	jmp 0:step2

step2:
	cli                 ; clear interrupts
	mov ax, 0x00
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00
	sti                 ; enable interrupts

.load_protected:
	cli
	lgdt[gdt_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	;jmp CODE_SEG:load32

gdt_start:
gdt_null:
	dd 0x0
	dd 0x0

;  offseet 0x8
gdt_code:               ; cs should point to this
	dw 0xffff           ; segment  limit first 0-15 bits
	dw 0                ; base first 0-15 bits
	db 0                ; base first 16-23 bits
	db 0x9a             ; access byte
	db 11001111b        ; high 4 bit flags and the low 4 bit flags
	db 0                ; base 24-31 bits

; offset 0x10
gdt_data:			; ds, ss, es, fs, gs
	dw 0xffff           ; segment limit first 0-15 bits
	dw 0                ; base first 0-15 bits
	db 0                ; base first 16-23 bits
	db 0x92             ; access byte
	db 11001111b        ; high 4 bit flags and the low 4 bit flags
	db 0                ; base 24-31 bits

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start-1
	dd gdt_start

times 510-($ - $$) db 0 ; fill the rest of the sector with zeros
dw 0xAA55               ; BIOS looks for a bootloader with the boot signature '0x55AA'
;db 0x55               ; BIOS looks for a bootloader with the boot signature '0x55AA'
;db 0xAA
