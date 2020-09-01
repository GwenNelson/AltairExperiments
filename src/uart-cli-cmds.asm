;
; CLI demo with commands
;
; This program runs a CLI on bare metal
; Based on the uart-cli-simple.asm demo, but adds commands
;


		org 0

		; reset UART
		mvi a,03h
		out 10h

		mvi a,15h
		out 10h

prompt:		lxi b, promptStr	; output prompt character
		call writeStr

		call getStr		; read in string into inputBuf

		; check for commands
		lxi b,inputBuf		; help command first
		lxi d,helpCmdStr
		call strcmp
		jz helpCmd

		lxi b,inputBuf		; then greet command
		lxi d,greetCmdStr
		call strcmp
		jz greetCmd

		jmp invalidCmd		; if we get here, invalid command


; =============================================================================
;  getstr routine
;   reads a string from the user into inputBuf
; =============================================================================
getStr:	
		; reset inputBufCurPos
		lxi h,inputBuf
		shld inputBufCurPos
getStrLoop:
		in 10h		; poll for received character
		rrc		; received character flag in LSB
		jnc getStrLoop	; if not carried, keep polling
		in 11h		; read character in

		cpi 0Dh		; check if the character is enter
		jz getStrEnter	; if it is, call enter handler

		; if not a special character, store it at inputBufCurPos
		lhld inputBufCurPos 	; load indirect into H:L
		xchg			; D:E now has address
		stax d			; store indirect, A stored at address

		; increment buffer pointer
		lxi h,inputBufCurPos	; set H:L to inputBufCurPos
		inr m			; increment buffer position

		out 11h			; echo the character
		jmp getStrLoop		; repeat polling loop
getStrEnter:
		; terminate the string
		lhld inputBufCurPos 	; load H:L indirect with inputBufCurPos
		xchg			; D:E is now the actual address
		xra a			; XOR A with A, sets it to 0
		stax d			; store A into address at D:E

		lxi b,nlStr		; write a newline
		call writeStr

		; return to caller
		ret
; ===============================================================================



; ======================================================================
;  command routines
;  these all jump back to prompt when done
; ======================================================================

invalidCmd:
		lxi b,invalidCmdStr
		call writeStr
		jmp prompt

helpCmd:
		lxi b,helpStr
		call writeStr
		jmp prompt

greetCmd:
		lxi b,greetPromptStr 	; ask for name
		call writeStr

		call getStr    		; read name

		lxi b,greetStr		; greet the user
		call writeStr
		lxi b,inputBuf
		call writeStr
		lxi b,nlStr
		call writeStr

		jmp prompt
; ======================================================================




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




; ======================================================================
;  strcmp routine
;   takes addresses of 2 strings in b:c and d:e and compares them
;   if they match, zero flag will be set
;   if they don't match, zero flag will not be set
;
;  CAUTION:
;   this will loop forever if the strings are not terminated correctly
; ======================================================================
strcmp:
	ldax b 	; load a character from address in b:c into A
	xchg   	; load D:E into H:L, M is now a character from D:E
	cmp m  	; compare A and M
	rnz	; if not equal, return

	cpi 0	; check for end of string
	rz	; if end of string, return

	inx b		; increment b:c
	xchg		; swap H:L and D:E back
	inx d		; increment d:e
	jmp strcmp	; loop

; ======================================================================



promptStr:	db "> ",0
nlStr:		db 0Dh,0Ah,0

helpCmdStr:	db "help",0
greetCmdStr:	db "greet",0

invalidCmdStr:	db "Invalid command!",0Dh,0Ah,0

greetPromptStr:	db "Please enter your name: ",0
greetStr:	db "Hello ",0
helpStr:	db "Valid commands are ",0Dh,0AH
		db "  [help]  - display this list",0Dh,0Ah
		db "  [greet] - runs a simple greeting demo",0Dh,0Ah,0


inputBufCurPos: dw inputBuf
		; we reserve a buffer here and allow to expand to fill up RAM
inputBuf:	ds 1024

