BIOS_INTERRUPT  equ 0x10
TERMINATED_NULL equ 0
MESSAGE         db  'Yo-ho-ho!', TERMINATED_NULL

ORG 0               ; BIOS loads the bootloader into RAM at absolute address 0x7C00
bits    16              ; use 16-bit arch

start:
    jmp short begin
    nop

times 33 db 0

jmp 0x7C0:start

begin:
    cli                 ; disable interrupts
    mov ax, 0x7C0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7C00
    sti                 ; enable interrupts

print_message:
    mov si, MESSAGE
    xor bx, bx          ; zero bh and bl registers
.loop:
    lodsb               ; loads another byte from si -> al + inc si reg
    test al, al
    je end

    mov ah, 0x0E
    int BIOS_INTERRUPT

    jmp .loop

end:

times 510-($ - $$) db 0
dd 0xAA55               ; BIOS looks for a bootloader with the boot signature '0x55AA'
