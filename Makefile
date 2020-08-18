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

HEXFILES:=bin/cylon.hex\
	  bin/frontecho.hex\
	  bin/rotater.hex\
	  bin/nibedit.hex

BINFILES:=bin/cylon.bin\
	  bin/frontecho.bin\
	  bin/rotater.bin\
	  bin/nibedit.hex

all: $(HEXFILES) $(BINFILES)
