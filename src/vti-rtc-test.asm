	ORG 0

	jmp start

	ORG 08h

	jmp isr

	ORG 100h

start:	mvi a,255 ; configure stack
	mov h,a
	mov l,a
	sphl

	mvi a,360q
	out 254
	ei

loop:	hlt
	jmp loop

isr:	di
	mvi a,10q
	ori 330q
	out 254
	ei
	ret
