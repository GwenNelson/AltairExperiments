; Cylon-like lights
;
; This program displays on the leftmost half of the memory bus LEDs a cylon-like sweeping effect
; Inspired by kill-the-bit and battlestar galactica


        lxi  d,8000h  ; init display register
        lxi  h,0000h  ; init h:l for timer
        lxi  b,0003h  ; init timer delay value for timer

right_loop:
	call display_out ; display current display register
	mov a,d		 ; move into a and rotate right
	rrc
	mov d,a
	cpi 1            ; check if the display register is equal to 1
	jnz right_loop   ; if not, repeat the loop
	jmp left_loop    ; if we hit 1, start moving left

left_loop:
	call display_out ; same as above
	mov a,d
	rlc              ; rotate left
	mov d,a
	cpi 128          ; if we hit 128, start moving right
	jnz left_loop
	jmp right_loop

display_out:
	ldax d ; display contents of display register on output LEDs by loading
	ldax d ; this sets the memory bus to the contents of the register, the high byte is seen on the leftmost LEDs
	ldax d ; we repeat this 4 times and use the delay loop below to ensure that most of the time, the LEDs show the display register
	ldax d ; otherwise the memory bus shows the rest of the code running constantly and human eyes never see the leftmost LEDs change, just a blur

	dad  b ; add timer delay value to h:l with carry
	jnc display_out ; if we didn't carry, keep on showing output and adding timer delay value
	ret             ; if we did carry, return to caller

