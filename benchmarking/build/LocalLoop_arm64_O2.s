	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 4
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function nativeSieve
lCPI0_0:
	.byte	12                              ; 0xc
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	13                              ; 0xd
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	14                              ; 0xe
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	15                              ; 0xf
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI0_1:
	.byte	0                               ; 0x0
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	1                               ; 0x1
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	2                               ; 0x2
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	3                               ; 0x3
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI0_2:
	.byte	4                               ; 0x4
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	5                               ; 0x5
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	6                               ; 0x6
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	7                               ; 0x7
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI0_3:
	.byte	8                               ; 0x8
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	9                               ; 0x9
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	10                              ; 0xa
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	11                              ; 0xb
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_nativeSieve
	.p2align	2
_nativeSieve:                           ; @nativeSieve
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x22, x21, [sp, #16]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #32]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x0
	add	w22, w0, #1
	sxtw	x0, w22
	bl	_malloc
	cbz	x0, LBB0_6
; %bb.1:
	mov	x20, x0
	tbnz	w19, #31, LBB0_3
; %bb.2:
	mov	w8, w19
	add	x2, x8, #1
	mov	x0, x20
	mov	w1, #1
	bl	_memset
LBB0_3:
	strb	wzr, [x20, #1]
	bl	_clock
	mov	x21, x0
	cmp	w19, #4
	b.ge	LBB0_7
LBB0_4:
	bl	_clock
	sub	x8, x0, x21
	ucvtf	d0, x8
	mov	x8, #70368744177664
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fmul	d0, d0, d1
	mov	x8, #145685290680320
	movk	x8, #16686, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	str	d0, [sp]
Lloh0:
	adrp	x0, l_.str.1@PAGE
Lloh1:
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	cmp	w19, #2
	b.ge	LBB0_12
; %bb.5:
	mov	w21, #0
	b	LBB0_26
LBB0_6:
Lloh2:
	adrp	x0, l_str@PAGE
Lloh3:
	add	x0, x0, l_str@PAGEOFF
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	b	_puts
LBB0_7:
	mov	w9, #4
	mov	w8, #2
	b	LBB0_9
LBB0_8:                                 ;   in Loop: Header=BB0_9 Depth=1
	add	x8, x8, #1
	mul	w9, w8, w8
	cmp	w9, w19
	b.gt	LBB0_4
LBB0_9:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_11 Depth 2
	ldrb	w10, [x20, x8]
	cmp	w10, #0
	ccmp	w9, w19, #0, ne
	b.gt	LBB0_8
; %bb.10:                               ;   in Loop: Header=BB0_9 Depth=1
	mov	w9, w9
LBB0_11:                                ;   Parent Loop BB0_9 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	strb	wzr, [x20, x9]
	add	x9, x9, x8
	cmp	w9, w19
	b.le	LBB0_11
	b	LBB0_8
LBB0_12:
	sub	x8, x22, #2
	cmp	x8, #8
	b.hs	LBB0_14
; %bb.13:
	mov	w21, #0
	mov	w12, #2
	b	LBB0_24
LBB0_14:
	adrp	x9, lCPI0_1@PAGE
	adrp	x10, lCPI0_2@PAGE
	cmp	x8, #32
	b.hs	LBB0_16
; %bb.15:
	mov	w21, #0
	mov	x11, #0
	b	LBB0_20
LBB0_16:
	and	x11, x8, #0xffffffffffffffe0
	add	x12, x20, #18
	movi.2d	v0, #0000000000000000
Lloh4:
	adrp	x13, lCPI0_0@PAGE
Lloh5:
	ldr	q1, [x13, lCPI0_0@PAGEOFF]
	ldr	q2, [x9, lCPI0_1@PAGEOFF]
	ldr	q3, [x10, lCPI0_2@PAGEOFF]
	movi.2d	v5, #0000000000000000
Lloh6:
	adrp	x13, lCPI0_3@PAGE
Lloh7:
	ldr	q17, [x13, lCPI0_3@PAGEOFF]
	mov	x13, x11
	movi.2d	v4, #0000000000000000
	movi.2d	v7, #0000000000000000
	movi.2d	v6, #0000000000000000
	movi.2d	v18, #0000000000000000
	movi.2d	v16, #0000000000000000
	movi.2d	v19, #0000000000000000
LBB0_17:                                ; =>This Inner Loop Header: Depth=1
	ldp	q20, q24, [x12, #-16]
	tbl.16b	v21, { v20 }, v1
	tbl.16b	v22, { v20 }, v2
	tbl.16b	v23, { v20 }, v3
	tbl.16b	v20, { v20 }, v17
	tbl.16b	v25, { v24 }, v1
	tbl.16b	v26, { v24 }, v2
	tbl.16b	v27, { v24 }, v3
	tbl.16b	v24, { v24 }, v17
	add.4s	v4, v4, v20
	add.4s	v5, v5, v23
	add.4s	v0, v0, v22
	add.4s	v7, v7, v21
	add.4s	v16, v16, v24
	add.4s	v18, v18, v27
	add.4s	v6, v6, v26
	add.4s	v19, v19, v25
	add	x12, x12, #32
	subs	x13, x13, #32
	b.ne	LBB0_17
; %bb.18:
	add.4s	v1, v18, v5
	add.4s	v2, v19, v7
	add.4s	v0, v6, v0
	add.4s	v3, v16, v4
	add.4s	v0, v0, v3
	add.4s	v1, v1, v2
	add.4s	v0, v0, v1
	addv.4s	s0, v0
	fmov	w21, s0
	cmp	x8, x11
	b.eq	LBB0_26
; %bb.19:
	tst	x8, #0x18
	b.eq	LBB0_23
LBB0_20:
	and	x13, x8, #0xfffffffffffffff8
	orr	x12, x13, #0x2
	movi.2d	v0, #0000000000000000
	mov.s	v0[0], w21
	movi.2d	v1, #0000000000000000
	add	x14, x11, x20
	add	x14, x14, #2
	sub	x11, x11, x13
	ldr	q2, [x9, lCPI0_1@PAGEOFF]
	ldr	q3, [x10, lCPI0_2@PAGEOFF]
LBB0_21:                                ; =>This Inner Loop Header: Depth=1
	ldr	d4, [x14], #8
	tbl.16b	v5, { v4 }, v2
	tbl.16b	v4, { v4 }, v3
	add.4s	v1, v1, v4
	add.4s	v0, v0, v5
	adds	x11, x11, #8
	b.ne	LBB0_21
; %bb.22:
	add.4s	v0, v0, v1
	addv.4s	s0, v0
	fmov	w21, s0
	cmp	x8, x13
	b.ne	LBB0_24
	b	LBB0_26
LBB0_23:
	orr	x12, x11, #0x2
LBB0_24:
	add	x8, x20, x12
	sub	x9, x22, x12
LBB0_25:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w10, [x8], #1
	add	w21, w21, w10
	subs	x9, x9, #1
	b.ne	LBB0_25
LBB0_26:
	mov	x0, x20
	bl	_free
	stp	x21, x19, [sp]
Lloh8:
	adrp	x0, l_.str.2@PAGE
Lloh9:
	add	x0, x0, l_.str.2@PAGEOFF
	bl	_printf
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpLdr	Lloh6, Lloh7
	.loh AdrpAdrp	Lloh4, Lloh6
	.loh AdrpLdr	Lloh4, Lloh5
	.loh AdrpAdd	Lloh8, Lloh9
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str.1:                               ; @.str.1
	.asciz	"C Sieve function time: %.f ms\n"

l_.str.2:                               ; @.str.2
	.asciz	"There are %d prime numbers up to %d.\n"

l_str:                                  ; @str
	.asciz	"Memory allocation failed"

.subsections_via_symbols
