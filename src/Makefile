### GNU Make definitions: ###
# CURRENT_TARGET	= $@
# FIRST_PREREQUISITE	= $<
# ALL_PREREQUISITES 	= $^

ASM = nasm
ASM_FLAGS = -g -f bin
LD_SCRIPT = linker.ld

OS_BIN = takos.bin
BUILD_DIR = ../build
BOOT_BIN = $(BUILD_DIR)/boot.bin
BOOT_SRC = boot/boot.asm
KERNEL_SRC = src/kernel.asm
KERNEL_BIN = $(BUILD_DIR)/kernel.bin

OBJECT_FILES = $(BUILD_DIR)/kernel.asm.o\
	$(BUILD_DIR)/kernel.o\
	$(BUILD_DIR)/term.o\
	$(BUILD_DIR)/string.o\
	$(BUILD_DIR)/idt.o\
	$(BUILD_DIR)/idt.asm.o\
	$(BUILD_DIR)/mem.o

CROSS_TOOLCHAIN_PATH = /home/us/prj/cross_compiler
CROSS_TARGET = $(CROSS_TOOLCHAIN_PATH)/bin/i686-elf
CROSS_LINKER = $(CROSS_TARGET)-ld
CROSS_GCC = $(CROSS_TARGET)-gcc
CROSS_GCC_FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer
CROSS_GCC_FLAGS += -finline-functions -Wno-unused-function -fno-builtin
CROSS_GCC_FLAGS += -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0
CROSS_GCC_FLAGS += -Iinc

all: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin
	dd if=$(BUILD_DIR)/boot.bin		> $(BUILD_DIR)/kernel.img
	dd if=$(BUILD_DIR)/kernel.bin		>> $(BUILD_DIR)/kernel.img
	dd if=/dev/zero bs=1048576 count=16	>> $(BUILD_DIR)/kernel.img

$(BUILD_DIR)/kernel.bin: $(OBJECT_FILES)
	$(CROSS_LINKER) -g -relocatable $(OBJECT_FILES) -o $(BUILD_DIR)/kernelfull.o
	$(CROSS_GCC) $(CROSS_GCC_FLAGS) -T $(LD_SCRIPT) -ffreestanding -O0 -nostdlib $(BUILD_DIR)/kernelfull.o -o $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/boot.bin: boot/boot.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

#$(BUILD_DIR)/kernel.asm.o: kernel.asm
#	$(ASM) -f elf -g $< -o $@

#$(BUILD_DIR)/idt.asm.o: idt.asm
#	$(ASM) -f elf -g $< -o $@

$(BUILD_DIR)/%.asm.o: %.asm
	$(ASM) -f elf -g $< -o $@

$(BUILD_DIR)/%.o:	%.c
	$(CROSS_GCC) $(CROSS_GCC_FLAGS) -std=gnu99 -c $< -o $@

run: $(BOOT_BIN)
	@qemu-system-x86_64 -hda $(BUILD_DIR)/kernel.img

debug:
	@gdb -x script.gdb

clean:
	rm -rf $(BUILD_DIR)
