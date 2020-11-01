# Small makefile currently server

main:
	nasm -f elf -I ./src -o ./main.o src/main.asm
	ld -m elf_i386 main.o -o main

debug:
	nasm -f elf -g -I ./src -F dwarf -o ./main.o ./src/main.asm
	ld -m elf_i386 main.o -o main

clean:
	rm -rf main.o main

