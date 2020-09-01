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
	rm -f src/*.o
	rm -rf bin/src
	rm -f src/*.lis

bin/start.o: src/start.asm
	z80asm --cpu=8080 --output=$@ -l  $<

bin/printf.o: src/printf.asm
	z80asm --cpu=8080 --output=$@ -l  $<

bin/main.o: bin/main.asm
	z80asm --cpu=8080 --output=$@ -l  $<

bin/main.asm: src/main.c
	sccz80 -m8080 $< -o $@

bin/ctest.bin: bin/start.o bin/printf.o bin/main.o
	z80asm --cpu=8080 -v -b -s -l -m -g -o$@ $^

bin/ctest.hex: bin/ctest.bin
	objcopy -v -I binary -O ihex $< $@

all: bin/ctest.hex
