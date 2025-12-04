	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 4
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function nativeSieve
lCPI0_0:
	.quad	0x412e848000000000              ; double 1.0E+6
lCPI0_1:
	.quad	0x408f400000000000              ; double 1000
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_nativeSieve
	.p2align	2
_nativeSieve:                           ; @nativeSieve
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	add	w9, w8, #1
                                        ; implicit-def: $x8
	mov	x8, x9
	sxtw	x8, w8
	lsr	x0, x8, #0
	bl	_malloc
	stur	x0, [x29, #-16]
	ldur	x8, [x29, #-16]
	subs	x8, x8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB0_2
	b	LBB0_1
LBB0_1:
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	b	LBB0_23
LBB0_2:
	stur	wzr, [x29, #-20]
	b	LBB0_3
LBB0_3:                                 ; =>This Inner Loop Header: Depth=1
	ldur	w8, [x29, #-20]
	ldur	w9, [x29, #-4]
	subs	w8, w8, w9
	cset	w8, gt
	tbnz	w8, #0, LBB0_6
	b	LBB0_4
LBB0_4:                                 ;   in Loop: Header=BB0_3 Depth=1
	ldur	x8, [x29, #-16]
	ldursw	x9, [x29, #-20]
	add	x9, x8, x9
	mov	w8, #1
	strb	w8, [x9]
	b	LBB0_5
LBB0_5:                                 ;   in Loop: Header=BB0_3 Depth=1
	ldur	w8, [x29, #-20]
	add	w8, w8, #1
	stur	w8, [x29, #-20]
	b	LBB0_3
LBB0_6:
	ldur	x8, [x29, #-16]
	strb	wzr, [x8, #1]
	ldur	x8, [x29, #-16]
	strb	wzr, [x8]
	bl	_clock
	stur	x0, [x29, #-32]
	mov	w8, #2
	stur	w8, [x29, #-36]
	b	LBB0_7
LBB0_7:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_10 Depth 2
	ldur	w8, [x29, #-36]
	ldur	w9, [x29, #-36]
	mul	w8, w8, w9
	ldur	w9, [x29, #-4]
	subs	w8, w8, w9
	cset	w8, gt
	tbnz	w8, #0, LBB0_16
	b	LBB0_8
LBB0_8:                                 ;   in Loop: Header=BB0_7 Depth=1
	ldur	x8, [x29, #-16]
	ldursw	x9, [x29, #-36]
	add	x8, x8, x9
	ldrb	w8, [x8]
	tbz	w8, #0, LBB0_14
	b	LBB0_9
LBB0_9:                                 ;   in Loop: Header=BB0_7 Depth=1
	ldur	w8, [x29, #-36]
	ldur	w9, [x29, #-36]
	mul	w8, w8, w9
	str	w8, [sp, #40]
	b	LBB0_10
LBB0_10:                                ;   Parent Loop BB0_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	w8, [sp, #40]
	ldur	w9, [x29, #-4]
	subs	w8, w8, w9
	cset	w8, gt
	tbnz	w8, #0, LBB0_13
	b	LBB0_11
LBB0_11:                                ;   in Loop: Header=BB0_10 Depth=2
	ldur	x8, [x29, #-16]
	ldrsw	x9, [sp, #40]
	add	x8, x8, x9
	strb	wzr, [x8]
	b	LBB0_12
LBB0_12:                                ;   in Loop: Header=BB0_10 Depth=2
	ldur	w9, [x29, #-36]
	ldr	w8, [sp, #40]
	add	w8, w8, w9
	str	w8, [sp, #40]
	b	LBB0_10
LBB0_13:                                ;   in Loop: Header=BB0_7 Depth=1
	b	LBB0_14
LBB0_14:                                ;   in Loop: Header=BB0_7 Depth=1
	b	LBB0_15
LBB0_15:                                ;   in Loop: Header=BB0_7 Depth=1
	ldur	w8, [x29, #-36]
	add	w8, w8, #1
	stur	w8, [x29, #-36]
	b	LBB0_7
LBB0_16:
	bl	_clock
	str	x0, [sp, #32]
	ldr	x8, [sp, #32]
	ldur	x9, [x29, #-32]
	subs	x8, x8, x9
	ucvtf	d0, x8
	adrp	x8, lCPI0_1@PAGE
	ldr	d1, [x8, lCPI0_1@PAGEOFF]
	fmul	d0, d0, d1
	adrp	x8, lCPI0_0@PAGE
	ldr	d1, [x8, lCPI0_0@PAGEOFF]
	fdiv	d0, d0, d1
	mov	x8, sp
	str	d0, [x8]
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	str	wzr, [sp, #28]
	mov	w8, #2
	str	w8, [sp, #24]
	b	LBB0_17
LBB0_17:                                ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #24]
	ldur	w9, [x29, #-4]
	subs	w8, w8, w9
	cset	w8, gt
	tbnz	w8, #0, LBB0_22
	b	LBB0_18
LBB0_18:                                ;   in Loop: Header=BB0_17 Depth=1
	ldur	x8, [x29, #-16]
	ldrsw	x9, [sp, #24]
	add	x8, x8, x9
	ldrb	w8, [x8]
	tbz	w8, #0, LBB0_20
	b	LBB0_19
LBB0_19:                                ;   in Loop: Header=BB0_17 Depth=1
	ldr	w8, [sp, #28]
	add	w8, w8, #1
	str	w8, [sp, #28]
	b	LBB0_20
LBB0_20:                                ;   in Loop: Header=BB0_17 Depth=1
	b	LBB0_21
LBB0_21:                                ;   in Loop: Header=BB0_17 Depth=1
	ldr	w8, [sp, #24]
	add	w8, w8, #1
	str	w8, [sp, #24]
	b	LBB0_17
LBB0_22:
	ldur	x0, [x29, #-16]
	bl	_free
	ldr	w8, [sp, #28]
                                        ; implicit-def: $x10
	mov	x10, x8
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	mov	x9, sp
	str	x10, [x9]
	str	x8, [x9, #8]
	adrp	x0, l_.str.2@PAGE
	add	x0, x0, l_.str.2@PAGEOFF
	bl	_printf
	b	LBB0_23
LBB0_23:
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"Memory allocation failed\n"

l_.str.1:                               ; @.str.1
	.asciz	"C Sieve function time: %.f ms\n"

l_.str.2:                               ; @.str.2
	.asciz	"There are %d prime numbers up to %d.\n"

.subsections_via_symbols
