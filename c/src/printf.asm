	GLOBAL _printf

	XLIB _printf

; uses __stdc __z88dk_callee convention

_printf:
	pop h  ; pop return address
	pop b  ; pop string param
	writeStr:
                ldax b ; load a character from address in b:c

                cpi 0  ; if end of string, return
                jz ret_printf

		cpi '%' ; handle % characters
		jz nested

	continue_write:                
                out 11h ; write the character
                
                inx b   ; increment and loop
                jmp writeStr
	
	nested: ; this is used to display a string via a nested call
		inx b   		; increment to the next char
		ldax b  		; load it

		cpi 's' 		; check if it's a string
		jz nested_str		; if yes, start handling string

		cpi 'x'			; check if it's a hex value
		jz nested_hex		; if yes, start handling hex

		jmp continue_write	; else, go back to main loop

	nested_str:
		inx b			; skip over the 's' character

		pop d ; pop the nested param
		push b ; preserve b
		push h ; preserve h
		push d ; push the nested param back to the stack
		call _puts
		pop h ; restore h
		pop b ; restore b
		jmp writeStr

	nested_hex:
		inx b	; skip over the 'x' character
		
		pop d   ; pop nested param
		push b  ; preserve b
		push h  ; preserve h
		push d  ; push nested param back to the stack
		call _puts_hex
		pop h
		pop b
		jmp writeStr

	ret_printf:
		push h ; restore return address
		ret

_puts:
	pop h
	pop b
	puts_loop:
		ldax b
		cpi 0
		jz ret_putf
		out 11h
		inx b
		jmp puts_loop
	ret_putf:
		push h
		ret

_puts_hex:
	pop b
	pop h	
	mov a,h
        call writeHexByte
        mov a,l
        call writeHexByte
	push b
	ret



; =============================================================================
;  writeHexNibble
;   writes a nibble from A to the UART
; =============================================================================
writeHexNibble:
        cpi 10                  ; compare with 10
        jc writeHexNibbleDigit  ; if <10, write the digit

        sui 10                  ; otherwise, subtract 10 and add 'A'
        adi 65                  ; add 'A'
        out 11h                 ; write to the UART
        ret
        
writeHexNibbleDigit:
        adi 48                  ; add 48 to get ASCII character code 
        out 11h                 ; write to the UART
        ret

; =============================================================================


; =============================================================================
;  writeHexByte
;   writes a byte from A to the UART
; =============================================================================
writeHexByte:
	push b
        mov b,a                 ; store A in b
        rrc                     ; rotate right 4 times to get high nibble
        rrc
        rrc
        rrc
        ani 15                  ; mask it so we only have the rightmost 4 bits
        call writeHexNibble     ; write the high nibble

        mov a,b                 ; restore A
        ani 15                  ; mask it
        call writeHexNibble     ; write the low nibble
	pop b
        ret
; =============================================================================

