	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 4
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function navtiveLoopCounterHelper
lCPI0_0:
	.quad	0x412e848000000000              ; double 1.0E+6
lCPI0_1:
	.quad	0x408f400000000000              ; double 1000
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_navtiveLoopCounterHelper
	.p2align	2
_navtiveLoopCounterHelper:              ; @navtiveLoopCounterHelper
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	stur	wzr, [x29, #-8]
	bl	_clock
	stur	x0, [x29, #-16]
	stur	wzr, [x29, #-20]
	b	LBB0_1
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	ldur	w8, [x29, #-20]
	ldur	w9, [x29, #-4]
	subs	w8, w8, w9
	cset	w8, ge
	tbnz	w8, #0, LBB0_4
	b	LBB0_2
LBB0_2:                                 ;   in Loop: Header=BB0_1 Depth=1
	ldur	w8, [x29, #-8]
	add	w8, w8, #1
	stur	w8, [x29, #-8]
	b	LBB0_3
LBB0_3:                                 ;   in Loop: Header=BB0_1 Depth=1
	ldur	w8, [x29, #-20]
	add	w8, w8, #1
	stur	w8, [x29, #-20]
	b	LBB0_1
LBB0_4:
	bl	_clock
	str	x0, [sp, #16]
	ldr	x8, [sp, #16]
	ldur	x9, [x29, #-16]
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
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"C function time: %.f ms\n"

.subsections_via_symbols
