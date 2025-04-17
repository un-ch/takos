
BOOT_BIN = boot.bin
BUILD_DIR = build

all:
	@cd src/boot && $(MAKE) --no-print-directory

run:
	@qemu-system-x86_64 -hda $(BUILD_DIR)/$(BOOT_BIN)

clean:
	rm -rf $(BUILD_DIR)
