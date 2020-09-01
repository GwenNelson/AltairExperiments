	GLOBAL _printf

	XLIB _printf

._printf
	pop h  ; pop return address
	pop b  ; pop string param
	writeStr:
                ldax b ; load a character from address in b:c

                cpi 0  ; if end of string, return
                jz ret_printf

		cpi '%'
		jz nested
                
                out 11h ; write the character
                
                inx b   ; increment and loop
                jmp writeStr
	
	nested:
		inx b ; increment to the next char
		inx b
		pop d ; pop the nested param
		push b ; preserve b
		push h ; preserve h
		push d
		call _printf
		pop h ; restore h
		pop b ; restore b
		jmp writeStr

	ret_printf:
		push h
		ret
