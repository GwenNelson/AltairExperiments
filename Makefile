.DEFAULT_GOAL := all
clean:
	rm -f bin/*.bin
	rm -f bin/*.hex
	rm -f bin/*.lis
	rm -f bin/*.lst
	rm -rf bin/src

ifeq ($(USE_Z80ASM),1)
bin/%.bin: src/%.asm
	z80asm --output=$@ --cpu=8080 --out-dir=bin/ -b -l $<

bin/%.hex: bin/%.bin
	objcopy -v -I binary -O ihex $< $@
else
bin/%.hex: src/%.asm
	asm8080 -obin/$* -lbin/$*.lst $<
endif

all: bin/cylon.hex bin/cylon.bin
