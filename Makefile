
FILES = build/kernel.asm.o

all: bin/boot.bin $(FILES)
	rm -rf bin/os.bin
	dd if=bin/boot.bin >> bin/os.bin	

bin/boot.bin: src/boot/boot.asm
	nasm -f bin src/boot/boot.asm -g -o bin/boot.bin

build/kernel.asm.o: src/kernel.asm
	nasm -f elf -g src/kernel.asm -o build/kernel.asm.o

run:
	@qemu-system-x86_64 -hda bin/os.bin

clean:
	@rm -rf bin/$(FILE).bin
