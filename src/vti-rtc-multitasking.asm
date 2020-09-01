; VTI/RTC multitasking
;
; this program uses the VTI/RTC board for multitasking between two threads
;
	ORG 0

	jmp start


	ORG 08h ; VT1, change as appropriate
	jmp isr ; jump to the ISR when VT1 is triggered

	ORG 100h



start:	
                mvi a,03h
                out 10h

                mvi a,15h
        out 10h

	di

	mvi a,360q ; configure the VTI/RTC board to 1 1 1 1 0 000
	out 254    ;                                ^ ^ ^ ^ ^ ^^^
                   ;                                | | | | |  |
	           ;                                | | | | |  +--------- current interrupt level register
                   ;                                | | | | +------------ disable current interrupt level register
                   ;                                | | | +-------------- reset RTC interrupt
                   ;                                | | +---------------- clear RTC counters
                   ;                                | +------------------ enable RTC interrupt
                   ;                                +-------------------- enable 88-VI


	; setup stack for task A
	lxi h, thread_a_stack_top
	sphl

	; setup stack for task B
	lxi h, thread_b_stack_top
	sphl

	lxi d,loopB
	push d
	push b
	push d
	push h
	push psw

	lxi h,0
	dad sp
	shld thread_b_stack_pointer

	; switch stack back to task A
	lxi h, thread_a_stack_top
	sphl

	ei          ; finally, enable interrupts


; run an infinite loop, this will be disrupted by the interrupt
loopA:	
	di
	mvi a,65
	out 11h
	ei
;	call isr
	jmp loopA


loopB:
	di
	mvi a,66
	out 11h
	ei
;	call isr
	jmp loopB

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
	mvi a,'!'
	out 11h
	; task switch happens here
	
	lxi h,cur_task_id
	mov a,m
	cpi 0
	jz switch_to_b
	jnz switch_to_a

switch_to_a:
	mvi m,0
	lxi h,0
	dad sp
	shld thread_b_stack_pointer

	mvi a,'!'
	out 11h

	lhld thread_a_stack_pointer
	sphl
	jmp end_isr

switch_to_b:
	mvi m,1
	lxi h,0
	dad sp
	shld thread_a_stack_pointer

	mvi a,'.'
	out 11h

	lhld thread_b_stack_pointer
	sphl
	jmp end_isr

	; =======================================================
end_isr:

	pop psw ; restore the registers
	pop h
	pop d
	pop b

	ei      ; restore interrupts
	ret

cur_task_id:
	db 0

thread_a_stack_pointer: dw 0
thread_b_stack_pointer: dw 0

thread_a_stack_bottom:
	ds 128
thread_a_stack_top:

thread_b_stack_bottom:
	ds 128
thread_b_stack_top:
