FILE = boot

# targets:
$(FILE): $(FILE).asm
	@nasm -f  bin $(FILE).asm -g -o $(FILE).bin

.PHONY: run
run: $(FILE)
	@qemu-system-x86_64 -hda $(FILE).bin

clean: @rm -rf $(FILE).bin
