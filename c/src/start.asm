	GLOBAL _start
	EXTERN _main


	ORG 0
_start:
        ; reset UART
	mvi a,03h
	out 10h

	mvi a,15h
	out 10h

	; setup SP
	lxi h,_stack_top
	sphl

	call _main
_loop:	nop
	jmp _loop
	ret

SECTION bss
	_stack_bottom:	ds 128
	_stack_top:
