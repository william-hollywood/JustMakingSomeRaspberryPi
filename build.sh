#!/bin/bash -ex

AS=arm-none-eabi-as
CC=arm-none-eabi-gcc
MACH=cortex-m0plus
CFLAGS=("-c" "-mcpu=${MACH}" "-mthumb" "-Wall")
LFLAGS=("-nostdlib" "-T" "baremetal.ld" "-Wl,-Map=final.map")

OBJS=()
FILES=("bs2_default_padded_checksummed" "blinker")
for FILE in "${FILES[@]}"; do
	OBJS+=("${FILE}.o")
	${AS} "${CFLAGS[@]}" -o "${FILE}.o" "${FILE}.S" -a="${FILE}.dis"
done

${CC} "${LFLAGS[@]}" -o "blinker.elf" "${OBJS[@]}"

picotool uf2 convert blinker.elf blinker.uf2
