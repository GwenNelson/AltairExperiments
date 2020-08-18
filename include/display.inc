; this routine takes as input the following:
;       DE: the display value
;       BC: the delay value for display timer - the bigger the value the less time the display is lit up for
; the following registers are clobbered:
;       A
;       BC
;       HL
	jmp disp_inc_end
display_out:
        lxi  h,0000h  ; init h:l for timer
        ; we display the contents of the output register by repeating this in a loop
disp_out_loop:
        ldax d
        ldax d
        ldax d
        ldax d
        dad  b
        jnc  disp_out_loop
        ret

disp_inc_end:
