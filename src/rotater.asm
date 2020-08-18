; Front panel rotater
;
; Reads sense switches at startup and then rotates them around
; To run, load into memory in the halt state and before hitting run set A8-A14 to a pattern
;
; Note that A15 has a special meaning, allowing to update the stored pattern
; To use this feature, set the other sense switches from A8-A14 to update the pattern
; Then raise A15, the rotation will halt temporarily, when lowered, the new pattern will be switched to

        lxi  b,0003h  ; init timer delay value for timer, we set this quite high because fast feedback is important

	INCLUDE "display.inc"

	in 0ffh       ; read the sense switches
	sta input_var ; store it into input_var
main_loop:
	lda input_var
	call rotate_it
	sta input_var

	mov d,a
	call display_out

	; allow to update the pattern by setting a new one and then raising A15
	in 0ffh
	ani 080h
	cnz update_it
	jmp main_loop

rotate_it:
	rlc      ; rotate everything left
	ret

update_it:
	in 0ffh
	ani 07fh  ; lose the A15 bit
	sta input_var
	ret

input_var:
	db 0
