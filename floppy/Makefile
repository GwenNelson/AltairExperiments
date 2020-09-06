all: mkimg DISKFF.DSK

hello.bin: hello.asm
	asm8080 $^

DISKFF.DSK: mkimg hello.bin
	./mkimg hello.bin > $@

mkimg: src/mkimg.c
	gcc -o $@ $^
