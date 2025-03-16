#!/bin/bash

export PREFIX="/home/us/prj/cross_compiler_for_the_udemy_kernel_course"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

make all
