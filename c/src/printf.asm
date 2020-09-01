	GLOBAL _printf

._printf
	pop d  ; pop return address
	pop b  ; pop string param
	push d ; push return address back on stack
	writeStr:
                ldax b ; load a character from address in b:c

                cpi 0  ; if end of string, return
                rz
                
                out 11h ; write the character
                
                inx b   ; increment and loop
                jmp writeStr
	

