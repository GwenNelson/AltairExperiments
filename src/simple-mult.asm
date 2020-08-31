; Simple multiplication routine
;
; This demo shows how to perform a simple multplication
;

                org 0

                ; reset UART
                mvi a,03h
                out 10h

                mvi a,15h
                out 10h

		lxi b,multAstr
		call writeStr

		lhld multA
		mov a,h
		call writeHexByte
		mov a,l
		call writeHexByte

		lxi b,nlStr
		call writeStr

		lxi b,multBstr
		call writeStr

		lhld multB
		mov a,h
		call writeHexByte
		mov a,l
		call writeHexByte

		lxi b,nlStr
		call writeStr

		call mult

		lxi b,multResultstr
		call writeStr

		lhld multResult
		mov a,h
		call writeHexByte
		mov a,l
		call writeHexByte

		lxi b,nlStr
		call writeStr

loop:		jmp loop



mult:		lhld multA
		sphl
		lhld multB
		xchg
		lxi h,0000H
		lxi b,0000H
multNZ:		dad sp
		jnc multNC
		inx b
multNC:		dcx d
		mov a,e
		ora d
		jnz multNZ
		shld multResult
		mov l,c
		mov h,b
		shld multResult+2
		ret

; =============================================================================
;  writeHexNibble
;   writes a nibble from A to the UART
; =============================================================================
writeHexNibble:
	cpi 10			; compare with 10
	jc writeHexNibbleDigit	; if <10, write the digit

	sui 10			; otherwise, subtract 10 and add 'A'
	adi 65			; add 'A'
	out 11h			; write to the UART
	ret
	
writeHexNibbleDigit:
	adi 48			; add 48 to get ASCII character code 
	out 11h			; write to the UART
	ret

; =============================================================================


; =============================================================================
;  writeHexByte
;   writes a byte from A to the UART
; =============================================================================
writeHexByte:
	mov b,a 		; store A in b
	rrc			; rotate right 4 times to get high nibble
	rrc
	rrc
	rrc
	ani 15			; mask it so we only have the rightmost 4 bits
	call writeHexNibble	; write the high nibble

	mov a,b			; restore A
	ani 15			; mask it
	call writeHexNibble	; write the low nibble
	ret
; =============================================================================



; =============================================================================
;  writeStr routine
;   takes address of string ending in 0 in B:C pair
; =============================================================================
writeStr:
                ldax b ; load a character from address in b:c

                cpi 0  ; if end of string, return
                rz
                
                out 11h ; write the character
                
                inx b   ; increment and loop
                jmp writeStr
; =============================================================================


multAstr:	db "Param A: 0x",0
multBstr:	db "Param B: 0x",0
nlStr:		db 13,10,0
multResultstr:	db "Result: 0x",0

; 2 16-bit params
multA:		dw 4
multB:  	dw 4

; 32-bit result
multResult: 	dw 0
		dw 0
