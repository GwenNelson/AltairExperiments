               org 0

                ; reset UART
                mvi a,03h
                out 10h

                mvi a,15h
                out 10h

		; simple test
		lxi b,helloStr
		call writeStr
		jmp $


writeStr:
                ldax b ; load a character from address in b:c

                cpi 0  ; if end of string, return
                rz
                
                out 11h ; write the character
                
                inx b   ; increment and loop
                jmp writeStr

helloStr:	db "Hello, world!",13,10,0
