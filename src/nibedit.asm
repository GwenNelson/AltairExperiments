; Front panel nibble editor
;
; Reads sense switches to input 2 nibbles to form one byte in the display register
; When A15 is low, A8-A11 is the low nibble, when A15 is high A8-11 is the high nibble
;
        lxi  b,0003h  ; init timer delay value for timer, we set this quite high because fast feedback is important

	INCLUDE "display.inc"

main_loop:
	lda input_var
	mov d,a
	call display_out

	in 0ffh
	ani 080h

	jz update_lower_nibble
	jnz update_higher_nibble

main_loop_ret:
	; update display register
	lda input_var
	mov d,a
	call display_out

	jmp main_loop


update_lower_nibble:
	in 0ffh ; read input
	ani 0fh ; mask the lower nibble
	mov b,a ; store the result in b

	lda input_var ; load the current variable from RAM
	ani 0f0h      ; mask the higher nibble to preserve the old higher nibble
	ora b         ; or the lower nibble into A
	mov d,a
	lxi b,0003h   ; restore b
	sta input_var ; save the new value
	
	jmp main_loop_ret

update_higher_nibble:
	in 0ffh  ; read input
	ani 0fh  ; mask the lower nibble
        rlc	 ; rotate it into the left 
	rlc
	rlc
	rlc
	mov b,a  ; store the result in b

	lda input_var ; load current variable
	ani 0fh       ; mask the lower nibble to preserve it
	ora b         ; or in the higher nibble

	mov d,a
	lxi b,0003h   ; restore b for the display timer
	sta input_var ; save the new value

	jmp main_loop_ret

input_var:
	db 0
	db 0
