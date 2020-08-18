# AltairExperiments

This repo contains some bare metal programs for the Altair 8800, tested on the altairduino.

The code is compiled using asm8080 found here: https://github.com/begoon/asm8080.

A lot of the code will also compile using z88dk's z80asm, for example:
```sh
$ z80asm --cpu=8080 -b -l frontecho.asm 
$ objcopy -v -I binary -O ihex frontecho.bin frontecho.ihex
```

This will produce frontecho.bin, frontecho.ihex and frontecho.lis.

A makefile is provided that defaults to building using asm8080, to use z80asm instead pass ```USE_Z80ASM=1```:

```sh
 $ make USE_Z80ASM=1
```

The output files will be placed in the bin/ directory, please note that some of the list files may be in bin/src/ when using z80asm.

## Programs included
 * cylon.asm     - a simple test of outputting to the front panel LEDs, makes the active LED move left and right like a cylon scanner
 * frontecho.asm - a simple test of echoing front panel input on sense switches to the LEDs
 * rotater.asm   - dynamically updateable rotating pattern on the front panel
 * nibedit.asm   - editing a byte using the front panel sense switches in 2 nibbles

There may also be a few library routines used by multiple programs, such as the following:
 * display.inc - the front panel LED display routine

## Running the programs

A quick hacky solution for running .hex files is included in runit.sh. To use it, make sure your user has access to the serial group and then do the following:
```sh
 $ ./runit.sh bin/cylon.hex
```

The script will tell you to hit stop on the Altair and hit enter. Do so, the program will then be uploaded using the debugger on altairduino.

For this to work you need serial input enabled on your altairduino.

