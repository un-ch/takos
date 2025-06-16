ASM                = nasm
CROSS_TOOLCHAIN    = /home/us/prj/cross_compiler/bin/i686-elf
CROSS_GCC          = $(CROSS_TOOLCHAIN)-gcc
CROSS_LD           = $(CROSS_TOOLCHAIN)-ld

ASM_FLAGS         = -g
ASM_BIN_FLAGS     = $(ASM_FLAGS) -f bin
ASM_ELF_FLAGS     = $(ASM_FLAGS) -f elf

CFLAGS            = -g -ffreestanding -falign-jumps -falign-functions \
                    -falign-labels -falign-loops -fstrength-reduce \
                    -fomit-frame-pointer -finline-functions -Wno-unused-function \
                    -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles \
                    -nodefaultlibs -Wall -O0 -Iinc

LDFLAGS          = -g -relocatable

BUILD_DIR         = ../build
BOOT_SRC          = boot/boot.asm
KERNEL_SOURCES    = src/kernel.asm
LD_SCRIPT         = linker.ld

OS_BIN            = takos.bin
BOOT_BIN          = $(BUILD_DIR)/boot.bin
KERNEL_BIN        = $(BUILD_DIR)/kernel.bin
KERNEL_IMG        = $(BUILD_DIR)/kernel.img
KERNEL_OBJ        = $(BUILD_DIR)/kernelfull.o

OBJECTS = \
    $(BUILD_DIR)/kernel.asm.o \
    $(BUILD_DIR)/kernel.o \
    $(BUILD_DIR)/term.o \
    $(BUILD_DIR)/string.o \
    $(BUILD_DIR)/idt.o \
    $(BUILD_DIR)/idt.asm.o \
    $(BUILD_DIR)/mem.o

all: $(BOOT_BIN) $(KERNEL_BIN)
	dd if=$(BOOT_BIN)             of=$(KERNEL_IMG)
	dd if=$(KERNEL_BIN)          of=$(KERNEL_IMG) bs=512 seek=1
	dd if=/dev/zero bs=1048576 count=16 >> $(KERNEL_IMG)

$(BOOT_BIN): $(BOOT_SRC) | $(BUILD_DIR)
	$(ASM) $(ASM_BIN_FLAGS) $< -o $@

$(KERNEL_BIN): $(OBJECTS)
	$(CROSS_LD) $(LDFLAGS) $(OBJECTS) -o $(KERNEL_OBJ)
	$(CROSS_GCC) $(CFLAGS) -T $(LD_SCRIPT) -nostdlib $(KERNEL_OBJ) -o $(KERNEL_BIN)

$(BUILD_DIR)/%.asm.o: %.asm | $(BUILD_DIR)
	$(ASM) $(ASM_ELF_FLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CROSS_GCC) $(CFLAGS) -std=gnu99 -c $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

run: all
	@qemu-system-x86_64 -hda $(KERNEL_IMG)

debug:
	@gdb -x script.gdb

clean:
	rm -rf $(BUILD_DIR)

