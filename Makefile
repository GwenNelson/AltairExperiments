.DEFAULT_GOAL := all
clean:
	rm -f bin/*.bin
	rm -f bin/*.hex
	rm -f bin/*.lis
	rm -f bin/*.lst
	rm -rf bin/src

ifeq ($(USE_Z80ASM),1)
bin/%.bin: src/%.asm
	z80asm --output=$@ --cpu=8080 --inc-path=include/ --out-dir=bin/ -b -l $<

bin/%.hex: bin/%.bin
	objcopy -v -I binary -O ihex $< $@
else
bin/%.hex: src/%.asm
	asm8080 -Iinclude/ -obin/$* -lbin/$*.lst $<
endif

SOURCES  := $(wildcard src/*.asm)
HEXFILES := $(patsubst src/%.asm, bin/%.hex, $(SOURCES))
BINFILES := $(patsubst src/%.asm, bin/%.bin, $(SOURCES)) 


all: $(HEXFILES) $(BINFILES)
