; Bath Hack 2023
; PaperMachine

.nolist
.include "m328Pdef.inc"
.list

.dseg
	.def	rRES0	= r0
	.def	rRES1	= r1

	.def	rR0		= r2
	.def	rR1		= r3
	.def	rR2		= r4
	.def	rR3		= r5
	.def	rR_SREG = r6
	.def	rR_PC	= r7
	.def	rR_SC	= r8
	.def	rR_SD	= r9
	.def	rR_SR 	= r10

	.def	rSM_DIR = r18
	.def	rSM_STA = r19
	.def	rSS_STA = r20
	.def	rSB_CNT = r21
	.def	rBT_CNT = r22
	.def	rBT0	= r24
	.def	rBT1	= r25

	.def	rTEMP	= r27

	.equ	_R0		= 17
	.equ	_R1		= 18
	.equ	_R2		= 19
	.equ	_R3		= 20

	.equ	_SREG_C = 0
	.equ	_SREG_Z = 1
	.equ	_SREG_N = 2
	.equ	_SREG_V = 3
	.equ	_SREG_S = 4
	.equ	_SREG_H = 5
	.equ	_SREG_T = 6
	.equ	_SREG_I = 7

	;PORTB PINS
	.equ	SEG_B	= 0
	.equ	SEG_C	= 1
	.equ	SEG_D	= 2
	.equ	SEG_E	= 3
	.equ	SEG_F	= 4
	.equ	SEG_G	= 5	

	;PORTC PINS
	.equ	SS_D0	= 0
	.equ	SS_D1	= 1
	.equ	SS_D2	= 2
	.equ	SS_D3	= 3
	.equ	SS_STA	= 4

	;PORTD PINS
	.equ	ST_RUN	= 1
	.equ	SM_DIR_ = 2
	.equ	SM_DIR	= 3	
	.equ	SM_STP	= 4
	.equ	SS_STAO = 5
	.equ	ST_RST	= 6
	.equ	SEG_A	= 7

	;OPCODES
	.equ	_HLT	= 0b0000
	.equ	_LD 	= 0b0001
	.equ 	_ADD	= 0b0010
	.equ 	_ADDI	= 0b0011
	.equ	_SUB	= 0b0100
	.equ	_SUBI	= 0b0101
	.equ	_CPI	= 0b0110
	.equ	_BRLO	= 0b0111
	.equ	_BREQ	= 0b1000
	.equ	_BRSH	= 0b1001
	.equ	_JMP	= 0b1010
	.equ	_MOV	= 0b1011
	.equ	_LDI	= 0b1100
	.equ	_OUT	= 0b1101
	.equ	_CP		= 0b1110

.cseg
	clr		rR0
	clr		rR1
	clr		rR2
	clr		rR3
	clr		rR_SREG
	clr		rR_PC
	clr		rR_SC
	clr		rR_SD

	clr		rSM_DIR
	clr		rSM_STA
	clr		rSS_STA
	clr		rSB_CNT
	clr		rBT_CNT
	clr		rBT0
	clr		rBT1
	ser		rTEMP
	out		DDRB, rTEMP						;set 7-seg pins to output
	
	ldi		rTEMP, (1<<SM_DIR | 1<<SM_DIR_ | 1<<SM_STP | 1<<SS_STAO | 1<<SEG_A)
	out		DDRD, rTEMP						;set step motor pins and 7-seg A to output
	jmp		loop
	
putc:
	cbi		PORTD, SEG_A
	mov 	rRES0, rTEMP
	clr		rTEMP
	out 	PORTB, rTEMP
	mov 	rTEMP, rRES0
	
	cpi 	rTEMP, 'A'
	breq	putc_a
	cpi		rTEMP, 'E'
	breq	putc_e
	cpi		rTEMP, 'H'
	breq	putc_h
	cpi		rTEMP, 'L'
	breq	putc_l
	cpi		rTEMP, 'O'
	breq	putc_o
	cpi		rTEMP, 0
	breq	putc_space
	jmp		putc_err
putc_a:
	sbi 	PORTD, SEG_A
	ldi 	rTEMP, (1<<SEG_B|1<<SEG_C|1<<SEG_E|1<<SEG_F|1<<SEG_G)
	out 	PORTB, rTEMP	
	jmp		loop
putc_e:
	sbi 	PORTD, SEG_A
	ldi		rTEMP, (1<<SEG_D|1<<SEG_E|1<<SEG_F|1<<SEG_G)
	out 	PORTB, rTEMP
	jmp		loop
putc_h:
	ldi		rTEMP, (1<<SEG_B|1<<SEG_C|1<<SEG_E|1<<SEG_F|1<<SEG_G)
	out 	PORTB, rTEMP
	jmp 	loop
putc_l:
	ldi		rTEMP, (1<<SEG_D|1<<SEG_E|1<<SEG_F)
	out 	PORTB, rTEMP
	jmp		loop
putc_o:
	sbi 	PORTD, SEG_A
	ldi		rTEMP, (1<<SEG_B|1<<SEG_C|1<<SEG_D|1<<SEG_E|1<<SEG_F)
	out 	PORTB, rTEMP
	jmp		loop
putc_space:
	cbi		PORTD, SEG_A
	clr		rTEMP
	out 	PORTB, rTEMP
putc_err:
	sbi 	PORTB, SEG_G
	jmp		loop

__hlt:
	jmp		__hlt

__ld:
	cpi		rBT0, _R0
	breq	__ld_r0
	cpi		rBT0, _R1
	breq	__ld_r1
	cpi		rBT0, _R2
	breq	__ld_r2
	cpi		rBT0, _R3
	breq	__ld_r3_i
	jmp 	loop
__ld_r0:
	cpi		rBT1, _R1
	breq	__ld_r0_r1
	cpi		rBT1, _R2
	breq	__ld_r0_r2
	cpi		rBT1, _R3
	breq	__ld_r0_r3
	jmp 	loop
__ld_r0_r1:
	mov 	rR_SD, rR1
	ldi		rTEMP, _R0
	mov 	rR_SR, rTEMP
	jmp		loop
__ld_r0_r2:
	mov 	rR_SD, rR2
	ldi		rTEMP, _R0
	mov 	rR_SR, rTEMP
	jmp		loop	
__ld_r0_r3:
	mov 	rR_SD, rR3
	ldi		rTEMP, _R0
	mov 	rR_SR, rTEMP
	jmp		loop
__ld_r1:
	cpi		rBT1, _R0
	breq	__ld_r1_r0
	cpi		rBT1, _R2
	breq	__ld_r1_r2
	cpi		rBT1, _R3
	breq	__ld_r1_r3
	jmp 	loop
__ld_r1_r0:
	mov 	rR_SD, rR0
	ldi		rTEMP, _R1
	mov 	rR_SR, rTEMP
	jmp		loop
__ld_r1_r2:
	mov 	rR_SD, rR2
	ldi		rTEMP, _R1
	mov 	rR_SR, rTEMP
	jmp		loop	
__ld_r1_r3:
	mov 	rR_SD, rR3
	ldi		rTEMP, _R1
	mov 	rR_SR, rTEMP
	jmp		loop
__ld_r3_i:
	rjmp	__ld_r3
__ld_r2:
	cpi		rBT1, _R0
	breq	__ld_r2_r0
	cpi		rBT1, _R1
	breq	__ld_r2_r1
	cpi		rBT1, _R3
	breq	__ld_r2_r3
	jmp 	loop
__ld_r2_r0:
	mov 	rR_SD, rR0
	ldi		rTEMP, _R2
	mov 	rR_SR, rTEMP
	jmp		loop
__ld_r2_r1:
	mov 	rR_SD, rR1
	ldi		rTEMP, _R2
	mov 	rR_SR, rTEMP
	jmp		loop	
__ld_r2_r3:
	mov 	rR_SD, rR3
	ldi		rTEMP, _R2
	mov 	rR_SR, rTEMP
	jmp		loop
__ld_r3:
	cpi		rBT1, _R0
	breq	__ld_r3_r0
	cpi		rBT1, _R1
	breq	__ld_r3_r1
	cpi		rBT1, _R2
	breq	__ld_r3_r2
	jmp 	loop
__ld_r3_r0:
	mov 	rR_SD, rR0
	ldi		rTEMP, _R3
	mov 	rR_SR, rTEMP
	jmp		loop
__ld_r3_r1:
	mov 	rR_SD, rR1
	ldi		rTEMP, _R3
	mov 	rR_SR, rTEMP
	jmp		loop	
__ld_r3_r2:
	mov 	rR_SD, rR2
	ldi		rTEMP, _R3
	mov 	rR_SR, rTEMP
	jmp		loop
	
__add:
	cpi		rBT0, _R0
	breq	__add_r0
	cpi		rBT0, _R1
	breq	__add_r1
	cpi		rBT0, _R2
	breq	__add_r2
	cpi		rBT0, _R3
	breq	__add_r3
	jmp 	loop
__add_r0:
	cpi		rBT1, _R1
	breq	__add_r0_r1
	cpi		rBT1, _R2
	breq	__add_r0_r2
	cpi		rBT1, _R3
	breq	__add_r0_r3
	jmp 	loop
__add_r0_r1:
	add 	rR0, rR1
	jmp		loop
__add_r0_r2:
	add		rR0, rR2
	jmp		loop	
__add_r0_r3:
	add		rR0, rR3
	jmp		loop
__add_r1:
	cpi		rBT1, _R0
	breq	__add_r1_r0
	cpi		rBT1, _R2
	breq	__add_r1_r2
	cpi		rBT1, _R3
	breq	__add_r1_r3
	jmp 	loop
__add_r1_r0:
	add 	rR1, rR0
	jmp		loop
__add_r1_r2:
	add		rR1, rR2
	jmp		loop	
__add_r1_r3:
	add		rR1, rR3
	jmp		loop
__add_r2:
	cpi		rBT1, _R0
	breq	__add_r2_r0
	cpi		rBT1, _R1
	breq	__add_r2_r1
	cpi		rBT1, _R3
	breq	__add_r2_r3
	jmp 	loop
__add_r2_r0:
	add 	rR2, rR0
	jmp		loop
__add_r2_r1:
	add		rR2, rR1
	jmp		loop	
__add_r2_r3:
	add		rR2, rR3
	jmp		loop
__add_r3:
	cpi		rBT1, _R0
	breq	__add_r3_r0
	cpi		rBT1, _R1
	breq	__add_r3_r1
	cpi		rBT1, _R2
	breq	__add_r3_r2
	jmp 	loop
__add_r3_r0:
	add 	rR3, rR0
	jmp		loop
__add_r3_r1:
	add		rR3, rR1
	jmp		loop	
__add_r3_r2:
	add		rR3, rR2
	jmp		loop

__addi:
	cpi		rBT0, _R0
	breq	__addi_r0
	cpi		rBT0, _R1
	breq	__addi_r1
	cpi		rBT0, _R2
	breq	__addi_r2
	cpi		rBT0, _R3
	breq	__addi_r3
	jmp 	loop
__addi_r0:
	add		rR0, rBT1
__addi_r1:
	add		rR1, rBT1
__addi_r2:
	add		rR2, rBT1
__addi_r3:
	add		rR3, rBT1

__sub:
	cpi		rBT0, _R0
	breq	__sub_r0
	cpi		rBT0, _R1
	breq	__sub_r1
	cpi		rBT0, _R2
	breq	__sub_r2
	cpi		rBT0, _R3
	breq	__sub_r2
	jmp 	loop
__sub_r0:
	cpi		rBT1, _R1
	breq	__sub_r0_r1
	cpi		rBT1, _R2
	breq	__sub_r0_r2
	cpi		rBT1, _R3
	breq	__sub_r0_r3
	jmp 	loop
__sub_r0_r1:
	sub 	rR0, rR1
	jmp		loop
__sub_r0_r2:
	sub		rR0, rR2
	jmp		loop	
__sub_r0_r3:
	sub		rR0, rR3
	jmp		loop
__sub_r1:
	cpi		rBT1, _R0
	breq	__sub_r1_r0
	cpi		rBT1, _R2
	breq	__sub_r1_r2
	cpi		rBT1, _R3
	breq	__sub_r1_r3
	jmp 	loop
__sub_r1_r0:
	sub 	rR1, rR0
	jmp		loop
__sub_r1_r2:
	sub		rR1, rR2
	jmp		loop	
__sub_r1_r3:
	sub		rR1, rR3
	jmp		loop
__sub_r2:
	cpi		rBT1, _R0
	breq	__sub_r2_r0
	cpi		rBT1, _R1
	breq	__sub_r2_r1
	cpi		rBT1, _R3
	breq	__sub_r2_r3
	jmp 	loop
__sub_r2_r0:
	sub 	rR2, rR0
	jmp		loop
__sub_r2_r1:
	sub		rR2, rR1
	jmp		loop	
__sub_r2_r3:
	sub		rR2, rR3
	jmp		loop
__sub_r3:
	cpi		rBT1, _R0
	breq	__sub_r3_r0
	cpi		rBT1, _R1
	breq	__sub_r3_r1
	cpi		rBT1, _R2
	breq	__sub_r3_r2
	jmp 	loop
__sub_r3_r0:
	sub 	rR3, rR0
	jmp		loop
__sub_r3_r1:
	sub		rR3, rR1
	jmp		loop	
__sub_r3_r2:
	sub		rR3, rR2
	jmp		loop

__subi:
	cpi		rBT0, _R0
	breq	__subi_r0
	cpi		rBT0, _R1
	breq	__subi_r1
	cpi		rBT0, _R2
	breq	__subi_r2
	cpi		rBT0, _R3
	breq	__subi_r3
	jmp 	loop
__subi_r0:
	sub		rR0, rBT1
__subi_r1:
	sub		rR1, rBT1
__subi_r2:
	sub		rR2, rBT1
__subi_r3:
	sub		rR3, rBT1

__cpi:
	cpi		rBT0, _R0
	breq	__cpi_r0
	cpi		rBT0, _R1
	breq	__cpi_r1
	cpi		rBT0, _R2
	breq	__cpi_r2
	cpi		rBT0, _R3
	breq	__cpi_r3
	jmp 	loop
__cpi_r0:
	cp		rR0, rBT1
	rjmp	__cpi_sreg
__cpi_r1:
	cp		rR1, rBT1
	rjmp	__cpi_sreg
__cpi_r2:
	cp		rR2, rBT1
	rjmp	__cpi_sreg
__cpi_r3:
	cp		rR3, rBT1
__cpi_sreg:
	mov 	rTEMP, rR_SREG
	brbs	_SREG_C, __cpi_sreg_c
	andi	rTEMP, ~_SREG_C
	rjmp	__cpi_sreg_2
__cpi_sreg_c:
	ori		rTEMP, _SREG_C
__cpi_sreg_2:
	brbs	_SREG_Z, __cpi_sreg_z
	andi	rTEMP, ~_SREG_Z
	rjmp	__cpi_sreg_end
__cpi_sreg_z:
	ori		rTEMP, _SREG_Z
__cpi_sreg_end:
	mov 	rR_SREG, rTEMP
	jmp		loop

__brlo:
	bst		rR_SREG, _SREG_C
	bld		rTEMP, 0
	tst		rTEMP
	brne	__jmp
	jmp		loop

__breq:
	bst		rR_SREG, _SREG_Z
	bld		rTEMP, 0
	tst		rTEMP
	brne	__jmp
	jmp		loop
	
__brsh:
	bst		rR_SREG, _SREG_C
	bld		rTEMP, 0
	tst		rTEMP
	breq	__jmp
	jmp		loop
	
__jmp:
	mov 	rR_PC, rBT0
	mov 	rR_SD, rBT0
	;clr		rSB_CNT
	;ldi		rTEMP, 4
	;mov 	rR_PC, rTEMP
	;mov 	rR_SD, rTEMP
	jmp		loop

__mov:
	cpi		rBT0, _R0
	breq	__mov_r0
	cpi		rBT0, _R1
	breq	__mov_r1
	cpi		rBT0, _R2
	breq	__mov_r2
	cpi		rBT0, _R3
	breq	__mov_r2
	jmp 	loop
__mov_r0:
	cpi		rBT1, _R1
	breq	__mov_r0_r1
	cpi		rBT1, _R2
	breq	__mov_r0_r2
	cpi		rBT1, _R3
	breq	__mov_r0_r3
	jmp 	loop
__mov_r0_r1:
	mov 	rR0, rR1
	jmp		loop
__mov_r0_r2:
	mov		rR0, rR2
	jmp		loop	
__mov_r0_r3:
	mov		rR0, rR3
	jmp		loop
__mov_r1:
	cpi		rBT1, _R0
	breq	__mov_r1_r0
	cpi		rBT1, _R2
	breq	__mov_r1_r2
	cpi		rBT1, _R3
	breq	__mov_r1_r3
	jmp 	loop
__mov_r1_r0:
	mov 	rR1, rR0
	jmp		loop
__mov_r1_r2:
	mov		rR1, rR2
	jmp		loop	
__mov_r1_r3:
	mov		rR1, rR3
	jmp		loop
__mov_r2:
	cpi		rBT1, _R0
	breq	__mov_r2_r0
	cpi		rBT1, _R1
	breq	__mov_r2_r1
	cpi		rBT1, _R3
	breq	__mov_r2_r3
	jmp 	loop
__mov_r2_r0:
	mov 	rR2, rR0
	jmp		loop
__mov_r2_r1:
	mov		rR2, rR1
	jmp		loop	
__mov_r2_r3:
	mov		rR2, rR3
	jmp		loop
__mov_r3:
	cpi		rBT1, _R0
	breq	__mov_r3_r0
	cpi		rBT1, _R1
	breq	__mov_r3_r1
	cpi		rBT1, _R2
	breq	__mov_r3_r2
	jmp 	loop
__mov_r3_r0:
	mov 	rR3, rR0
	jmp		loop
__mov_r3_r1:
	mov		rR3, rR1
	jmp		loop	
__mov_r3_r2:
	mov		rR3, rR2
	jmp		loop

__ldi:
	cpi		rBT0, _R0
	breq	__ldi_r0
	cpi		rBT0, _R1
	breq	__ldi_r1
	cpi		rBT0, _R2
	breq	__ldi_r2
	cpi		rBT0, _R3
	breq	__ldi_r2
	jmp 	loop
__ldi_r0:
	mov 	rR0, rBT1
	jmp		loop
__ldi_r1:
	mov 	rR1, rBT1
	jmp		loop
__ldi_r2:
	mov 	rR2, rBT1
	jmp		loop
__ldi_r3:
	mov 	rR3, rBT1
	jmp		loop

__out:
	cpi		rBT0, _R0
	breq	__out_r0
	cpi		rBT0, _R1
	breq	__out_r0
	cpi		rBT0, _R2
	breq	__out_r0
	cpi		rBT0, _R3
	breq	__out_r0
	jmp		loop
__out_r0:
	mov 	rTEMP, rR0
	jmp		putc
__out_r1:
	mov 	rTEMP, rR1
	jmp		putc
__out_r2:
	mov 	rTEMP, rR2
	jmp		putc
__out_r3:
	mov  	rTEMP, rR3
	jmp		putc

__cp:

sleep:
	ldi		rTEMP, 1						;initialise sleep counters
	mov		rRES0, rTEMP
	ldi		rTEMP, 1
	mov 	rRES1, rTEMP
	ldi 	rTEMP, 2
sleep_l:
	dec		rRES0
	brne	sleep_l
	dec		rRES1
	brne	sleep_l
	dec		rTEMP
	brne	sleep_l

	tst		rSM_STA
	brne	loop_s1 						;return to loop, depending on step status
	jmp		loop_s2

loop:
	sbis	PIND, ST_RUN 					;if the run pin isn't high
	rjmp	loop 							;wait

	tst		rSM_DIR							;test step direction
	breq	loop_dir0
	cbi 	PORTD, SM_DIR
	sbi 	PORTD, SM_DIR_
	rjmp	loop_dir1
loop_dir0:
	sbi 	PORTD, SM_DIR
	cbi		PORTD, SM_DIR_
loop_dir1:
	ser		rSM_STA 						;set step status
	sbi		PORTD, SM_STP 
	jmp		sleep 							;first delay
loop_s1:
	clr		rSM_STA 						;clear step status
	cbi		PORTD, SM_STP 
	jmp		sleep 							;second delay
loop_s2:
	in 		rTEMP, PINC
	bst		rTEMP, SS_STA 					;retrieve sensor status bit
	clr		rTEMP
	bld		rTEMP, 0

	cbi		PORTD, SS_STAO
	cpi		rTEMP, 0
	cbi		PORTD, SS_STAO					;otherwise clear it
	brbs	6,loop_staoff 					;^ if status bit is clear
	sbi 	PORTD, SS_STAO					;set sensor status output
loop_staoff:
	tst		rSS_STA							;if last status was on
	mov		rSS_STA, rTEMP					;then we're still on a step marker
	breq	loop 							;keep moving to prevent multiple triggers
	tst		rSS_STA							;else if it was off, but is now on
	breq	symbol							;handle symbol
	rjmp	loop 							;else still off, keep moving

symbol:
	in 		rTEMP, PINC						;load in symbol
	com		rTEMP
	andi	rTEMP, 0x0F						;keep symbol only

	cpi		rSB_CNT, 1 						;if we've read the first symbol
	brsh	symbol_msn

	swap	rTEMP
	mov 	rBT1, rTEMP						;set MSN of byte, store in byte 1 temporarily
	inc 	rSB_CNT							;increment symbol counter
	rjmp	loop
symbol_msn:
	or		rBT1, rTEMP						;set LSN of byte
	clr		rSB_CNT							;reset symbol counter
byte:
	cp		rR_SD, rR_PC
	breq	byte_ld_done_i
	brlo	byte_ld_r

	clr		rSM_DIR
	cp		rR_SD, rR_SC
	brne	byte_ld_f_cont
	mov 	rTEMP, rR_SR
	cpi		rTEMP, _R0
	breq	byte_ld_f_r0
	cpi		rTEMP, _R1
	breq	byte_ld_f_r1
	cpi		rTEMP, _R2
	breq	byte_ld_f_r2
	cpi		rTEMP, _R3
	breq	byte_ld_f_r3	
	jmp		loop
byte_ld_f_r0:
	mov 	rR0, rBT1
	dec		rR_SC
	jmp		loop
byte_ld_f_r1:
	mov 	rR1, rBT1
	dec		rR_SC
	jmp		loop
byte_ld_f_r2:
	mov 	rR2, rBT1
	dec		rR_SC
	jmp		loop
byte_ld_f_r3:
	mov 	rR3, rBT1
	dec		rR_SC
	jmp		loop
byte_ld_f_cont:
	inc 	rR_SC
	jmp		loop
byte_ld_done_i:
	rjmp	byte_ld_done
byte_ld_r:
	ser		rSM_DIR
	cp		rR_SD, rR_SC
	brne	byte_ld_r_cont
	mov 	rTEMP, rR_SR
	cpi		rTEMP, _R0
	breq	byte_ld_r_r0
	cpi		rTEMP, _R1
	breq	byte_ld_r_r1
	cpi		rTEMP, _R2
	breq	byte_ld_r_r2
	cpi		rTEMP, _R3
	breq	byte_ld_r_r3	
	jmp		loop
byte_ld_r_r0:
	mov 	rR0, rBT1
	inc		rR_SC
	jmp		loop
byte_ld_r_r1:
	mov 	rR1, rBT1
	inc		rR_SC
	jmp		loop
byte_ld_r_r2:
	mov 	rR2, rBT1
	inc		rR_SC
	jmp		loop
byte_ld_r_r3:
	mov 	rR3, rBT1
	inc		rR_SC
	jmp		loop
byte_ld_r_cont:
	dec 	rR_SC
	jmp		loop

byte_ld_done:
	cp		rR_SC, rR_PC
	breq	byte_norm
	brlo	byte_jmp_f

	ser		rSM_DIR
	dec		rR_SC
	jmp		loop
byte_jmp_f:
	clr		rSM_DIR
	inc 	rR_SC
	jmp		loop
byte_norm:
	clr		rSM_DIR
	inc 	rR_PC
	inc 	rR_SC
	inc 	rR_SD
	
	cpi		rBT_CNT, 1						;if we've read the second byte
	breq	byte_msb 						;handle word

	inc 	rBT_CNT 						;increment byte counter
	mov 	rBT0, rBT1 						;load LSB into MSB
	clr		rBT1							;clear LSB
	rjmp	loop 							
byte_msb:
	clr 	rBT_CNT

;;;;; INSTRUCTIONS ;;;
; 16-bit
;   rRES0     rRES1
; 0000 1111 1122 2222
; 0: opcode
; 1: operand 0
; 2: operand 1
	
word:
	mov		rRES0, rBT0						;save opcode temporarily
	andi	rBT0, 0x0F						;save bottom nibble for operand 0

	mov 	rTEMP, rBT1
	andi	rTEMP, 0xC0						;keep top two bits
	lsr		rTEMP							;shift into place
	lsr		rTEMP
	or		rBT0, rTEMP						;add to operand 0

	andi	rBT1, 0x3F						;clear top two bits for operand 1

	mov 	rTEMP, rRES0					;restore opcode
	swap	rTEMP
	andi	rTEMP, 0x0F						;save bottom nibble for opcode

	cpi		rTEMP, _HLT
	breq	__hlt_i
	cpi		rTEMP, _LD
	breq	__ld_i
	cpi		rTEMP, _ADD
	breq	__add_i
	cpi		rTEMP, _ADDI
	breq	__addi_i
	cpi		rTEMP, _SUB
	breq	__sub_i
	cpi		rTEMP, _SUBI
	breq	__subi_i
	cpi		rTEMP, _CPI
	breq	__cpi_i
	cpi		rTEMP, _BRLO
	breq	__brlo_i
	cpi		rTEMP, _BREQ
	breq	__breq_i
	cpi		rTEMP, _BRSH
	breq	__brsh_i
	cpi		rTEMP, _JMP
	breq	__jmp_i
	cpi		rTEMP, _MOV
	breq	__mov_i
	cpi		rTEMP, _LDI
	breq	__ldi_i
	cpi		rTEMP, _OUT
	breq	__out_i
	cpi		rTEMP, _CP
	breq	__cp_i
	jmp		__hlt

__hlt_i:
	jmp		__hlt
__ld_i:
	jmp		__ld
__add_i:
	jmp		__add
__addi_i:
	jmp		__addi
__sub_i:
	jmp		__sub
__subi_i:
	jmp		__subi
__cpi_i:
	jmp		__cpi
__brlo_i:
	jmp		__brlo
__breq_i:
	jmp		__breq
__brsh_i:
	jmp		__brsh
__jmp_i:
	jmp		__jmp
__mov_i:
	jmp		__mov
__ldi_i:
	jmp		__ldi
__out_i:
	jmp		__out
__cp_i:
	jmp		__cp
