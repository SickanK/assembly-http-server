# Small makefile for server

main:
	nasm -f elf -o main.o src/main.asm
	ld -m elf_i386 main.o -o main

clean:
	rm -rf main.o main

