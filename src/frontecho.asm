; Front panel echo
;
; This program echos the input from the sense switches into the left 8 memory bus LEDs

        lxi  b,000fh  ; init timer delay value for timer, we set this quite high because fast feedback is important

	INCLUDE "display.inc"

main_loop:
	in 0ffh	; read the sense switches
	mov d,a ; load the read value into display register
	call display_out
	jmp main_loop

