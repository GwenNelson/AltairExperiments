; VTI/RTC test
;
; this program implements a simple usage of the VTI/RTC board, assumed to be on vector VT1
; if your altair is configured with the RTC on a different vector, change the line below

	ORG 0

	jmp start

	ORG 08h ; VT1, change as appropriate
	jmp isr ; jump to the ISR when VT1 is triggered

	ORG 100h

	INCLUDE "display.inc"

start:	mvi a,255 ; configure stack
	mov h,a
	mov l,a
	sphl

	mvi a,360q ; configure the VTI/RTC board to 1 1 1 1 0 000
	out 254    ;                                ^ ^ ^ ^ ^ ^^^
	mvi d,1    ;                                | | | | |  |
	ei         ;                                | | | | |  +--------- current interrupt level register
                   ;                                | | | | +------------ disable current interrupt level register
                   ;                                | | | +-------------- reset RTC interrupt
                   ;                                | | +---------------- clear RTC counters
                   ;                                | +------------------ enable RTC interrupt
                   ;                                +-------------------- enable 88-VI
loop:	
	jmp loop

isr:	di
	mvi a,10q  ; configure the VTI/RTC board same as above, except without clearing the counters and enabling current interrupt level register
	ori 330q
	out 254

	mov a,d
	rlc
	mov d,a
	lxi b,0003h
	call display_out

	ei
	ret
