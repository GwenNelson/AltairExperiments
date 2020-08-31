;
; Simple CLI demo
;
; This program runs a CLI on bare metal
; When the user hits enter, it repeats back what they entered
;
; Can be used as the basis for a more advanced CLI
;

		org 0

		; reset UART
		mvi a,03h
		out 10h

		mvi a,15h
		out 10h

; see https://deramp.com/downloads/altair/software/utilities/other/ECHO.ASM
prompt:		lxi b, promptStr	; output prompt character
		call writeStr

pollRcv:	in 10h		; poll for received character 
		rrc		; received character flag in LSB
		jnc pollRcv	; if not carried, keep polling
		in 11h		; read character in

		cpi 1Bh		; check if the character is an escape code
		jz  escHandle	; if it is, call the escape character handler
	
		cpi 0Dh		; check if the character is enter
		jz entHandle	; if it is, call the enter character handler

		; if not a special character, store it at inputBufCurPos
		lhld inputBufCurPos ; load indirect, H:L now stores address pointed at by inputBufCurPos
		xchg                ; swap H:L and D:E, D:E now has the address
		stax d              ; store indirect, A is stored at the address

		; increment buffer pointer
		lxi h,inputBufCurPos	; set H:L to inputBufCurPos
		inr m			; increment current cursor position by incrementing that memory location

		out 11h		; finally, echo the character
		jmp pollRcv	; and repeat the polling loop


escHandle:
		jmp pollRcv ; placeholder for now

; =======================================================================
;  entHandle routine
;   handles pressing enter - for now simply outputs "You entered:" and
;   resets inputBuf
; =======================================================================

entHandle:
		; first terminate the string
		lhld inputBufCurPos 	; load H:L indirect with inputBufCurPos
		xchg			; D:E is now the actual address pointed to by inputBufCurPos
		xra a			; XOR A with A, sets it to 0
		stax d			; store A into address at D:E

		lxi b,nlStr		; write a newline
		call writeStr

		lxi b,youEnteredStr	; write "you entered: "
		call writeStr

		lxi b,inputBuf		; write contents of input buffer
		call writeStr

		lxi b,nlStr		; write a newline again
		call writeStr

		; now reset inputBufCurPos
		lxi h, inputBuf		; load H:L with address of inputBuf
		shld inputBufCurPos	; store H:L into inputBufCurPos

		jmp prompt ; jump back to main loop


; ======================================================================
;  writeStr routine
;   takes address of string ending in 0 in B:C pair
; ======================================================================
writeStr:
		ldax b ; load a character from address in b:c

		cpi 0  ; if end of string, return
		rz
		
		out 11h ; write the character
		
		inx b   ; increment and loop
		jmp writeStr
; ======================================================================

promptStr:	db "> ",0
nlStr:		db 0Dh,0Ah,0
youEnteredStr:	db "You entered: ",0

inputBufCurPos: dw inputBuf
inputBuf:	ds 1024

