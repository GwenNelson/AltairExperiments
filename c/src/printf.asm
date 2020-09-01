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
		jnz continue_write	; if not, go back to main loop
		inx b			; skip over the 's' character

		pop d ; pop the nested param
		push b ; preserve b
		push h ; preserve h
		push d ; push the nested param back to the stack
		call _puts
		pop h ; restore h
		pop b ; restore b
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
	
