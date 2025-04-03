SRC = boot_char
ASM = nasm
FLAGS = -f
FORMAT = bin

all: build

build:
	$(ASM) $(FLAGS) $(FORMAT) $(SRC).S -o $(SRC).bin
run:
	@qemu-system-x86_64 -hda $(SRC).bin

debug:
	gdb -x script.gdb

clean:
	rm -rf *.bin
