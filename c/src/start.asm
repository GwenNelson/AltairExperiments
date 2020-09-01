	GLOBAL _start
	EXTERN _main


	ORG 0
_start:
        ; reset UART
	mvi a,03h
	out 10h

	mvi a,15h
	out 10h


	call _main
_loop:	nop
	jmp _loop
	ret

