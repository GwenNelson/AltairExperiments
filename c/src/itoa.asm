	call 5
	lxi h,stack_top
	sphl

        mvi a,03h
        out 10h

        mvi a,15h
        out 10h


lxi h,300
call puthl
hlt

puthl:	mov	a,h	; Get the sign bit of the integer,
	ral		; which is the top bit of the high byte
	sbb	a	; A=00 if positive, FF if negative
	sta	negf	; Store it as the negative flag
	cnz	neghl	; And if HL was negative, make it positive
	lxi	d,num	; Load pointer to end of number string
	push	d	; Onto the stack
	lxi	b,-10	; Divide by ten (by trial subtraction)
digit:	lxi	d,-1	; DE = quotient. There is no 16-bit subtraction,
dgtdiv:	dad	b	; so we just add a negative value,
	inx	d
	jc	dgtdiv	; while that overflows.
	mvi	a,'0'+10	; The loop runs once too much so we're 10 out
	add	l 	; The remainder (minus 10) is in L
	xthl		; Swap HL with top of stack (i.e., the string pointer)
	dcx	h	; Go back one byte
	mov	m,a	; And store the digit
	xthl		; Put the pointer back on the stack
	xchg		; Do all of this again with the quotient
	mov	a,h	; If it is zero, we're done
	ora	l
	jnz	digit	; But if not, there are more digits
	pop	d	; Put the string pointer from the stack in DE
	lda	negf	; See if the number was supposed to be negative
	inr	a
	jnz	bdos	; If not, print the string we have and return
	dcx	d	; But if so, we need to add a minus in front
	mvi	a,'-'
	stax	d
	jmp	bdos	; And only then print the string

bdos:
        writeStr:
                ldax d ; load a character from address in b:c

                cpi 0  ; if end of string, return
                rz

                out 11h ; write the character
                
                inx d   ; increment and loop
                jmp writeStr

neghl:	mov	a,h	; HL = -HL; i.e. HL = (~HL) + 1
	cma		; Get bitwise complement of the high byte,
	mov	h,a
	mov	a,l	; And the low byte
	cma		; We have to do it byte for byte since it is an 8-bit
	mov	l,a	; processor.
	inx	h	; Then add one
	ret		
negf:	db	0	; Space for negative flag
	db	"-00000"
num:	db	'$'	; Space for number

stack_bottom:
	ds 128
stack_top:
