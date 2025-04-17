SRC = boot
ASM = nasm
ASM_FLAGS = -g -f bin
BOOT_BIN = boot.bin
BUILD_DIR = ../../build

$(BUILD_DIR)/$(BOOT_BIN): $(SRC).asm
	@mkdir -p $(BUILD_DIR)
	@$(ASM) $(ASM_FLAGS) $(SRC).asm -o $@

run: $(BUILD_DIR)/$(BOOT_BIN)
	@qemu-system-x86_64 -hda $(BUILD_DIR)/$(BOOT_BIN)

debug:
	@gdb -x script.gdb

clean:
	rm -rf $(BUILD_DIR)
