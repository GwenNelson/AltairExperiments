; VTI/RTC test
;
; this program implements a simple usage of the VTI/RTC board, assumed to be on vector VT1
; if your altair is configured with the RTC on a different vector, change the line below
;
;
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
                   ;                                | | | | |  |
	           ;                                | | | | |  +--------- current interrupt level register
                   ;                                | | | | +------------ disable current interrupt level register
                   ;                                | | | +-------------- reset RTC interrupt
                   ;                                | | +---------------- clear RTC counters
                   ;                                | +------------------ enable RTC interrupt
                   ;                                +-------------------- enable 88-VI


	mvi a,1     ; setup the value to be rotated
	sta cur_val


	ei          ; finally, enable interrupts


; run an infinite loop, this will be disrupted by the interrupt
loop:	
	jmp loop

; this is the ISR for the clock interrupt
isr:	di         ; disable interrupts so we don't get disrupted by a higher level interrupt

	push b     ; push registers so we can later restore
	push d
	push h
	push psw
 
	mvi a,10q  ; configure the VTI/RTC board same as above, except without clearing the counters and enabling current interrupt level register
	ori 330q
	out 254


	; the below chunk of code is the actual service routine

	; =======================================================

	; we do work here - in this demo, simply rotating a bit left and displaying it	
	; in a more serious program, the ISR itself would likely be a stub and we'd call the relevant subroutine to do the real work here
	lda cur_val
	rlc
	sta cur_val
	mov d,a
	lxi b,0003h
	call display_out

	; =======================================================


	pop psw ; restore the registers
	pop h
	pop d
	pop b

	ei      ; restore interrupts
	ret

cur_val:
	db 0 ; the value being rotated
