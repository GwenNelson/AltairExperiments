# AltairExperiments

This repo contains some bare metal programs for the Altair 8800, tested on the altairduino.

The code is compiled using asm8080 found here: https://github.com/begoon/asm8080

## Programs included
 * cylon.asm     - a simple test of outputting to the front panel LEDs, makes the active LED move left and right like a cylon scanner
 * frontecho.asm - a simple test of echoing front panel input on sense switches to the LEDs
 * rotater.asm   - dynamically updateable rotating pattern on the front panel

There may also be a few library routines used by multiple programs, such as the following:
 * display.asm - the front panel LED display routine
