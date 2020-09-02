.DEFAULT_GOAL := all
clean:
	rm -f bin/*.bin
	rm -f bin/*.hex
	rm -f bin/*.lis
	rm -f bin/*.lst
	rm -f bin/*.o
	rm -f bin/*.asm
	rm -f bin/*.def
	rm -f bin/*.map
	rm -f bin/*.lib
	rm -f src/*.o
	rm -rf bin/src
	rm -f src/*.lis
	rm -f zcc_opt.def

bin/start.o: src/start.asm
	z80asm --cpu=8080 --output=$@ -l  $<

bin/printf.o: src/printf.asm
	z80asm --cpu=8080 --output=$@ -l  $<

bin/stdio.lib: bin/printf.o
	z80asm --cpu=8080 -x$@ $^

bin/main.o: bin/main.asm
	z80asm --cpu=8080 --output=$@ -l  $<

bin/main.asm: src/main.c
	sccz80 -m8080 $< -o $@

bin/ctest.bin: bin/start.o bin/stdio.lib bin/main.o
	z80asm -m8080 -v -b -s -l -m -g -o$@ -lbin/stdio.lib bin/start.o bin/main.o

bin/ctest.hex: bin/ctest.bin
	objcopy -v -I binary -O ihex $< $@

all: bin/ctest.hex
