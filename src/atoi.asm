; atoi implementation
;
; simple implementation of atoi with output shown on front panel

	lxi b,numStr
	call atoi
loop:	jmp loop

; ================================================================
;  atoi routine
;   takes address of null-terminated string in B:C pair
; ================================================================
atoi:

atoiloop:	ldax b ; load first character
		cpi 0  ; compare with 0, and return if so
		rz
		
		lxi d,0
		lhld numResult
		xchg

		sui 48

		; now we multiply D:E by 10
		dad d ; H=H*1
		dad d ; H=H*2
		dad d ; H=H*3
		dad d ; H=H*4
		dad d ; H=H*5
		dad d ; H=H*6
		dad d ; H=H*7
		dad d ; H=H*8
		dad d ; H=H*9
		dad d ; H=H*10
	
		; set d:e to A
		lxi d,0
		mov e,a
		; add the digit to H:L
		dad d ; now H:L is updated

		; store current result
		shld numResult

		inx b
		jmp atoiloop
	
; ================================================================

numStr:	db "69",0 ; heh
numResult: dw 0
