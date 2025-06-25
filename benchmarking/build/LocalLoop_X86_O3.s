	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 4
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ## -- Begin function navtiveLoopCounterHelper
LCPI0_0:
	.long	1127219200                      ## 0x43300000
	.long	1160773632                      ## 0x45300000
	.long	0                               ## 0x0
	.long	0                               ## 0x0
LCPI0_1:
	.quad	0x4330000000000000              ## double 4503599627370496
	.quad	0x4530000000000000              ## double 1.9342813113834067E+25
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0
LCPI0_2:
	.quad	0x408f400000000000              ## double 1000
LCPI0_3:
	.quad	0x412e848000000000              ## double 1.0E+6
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_navtiveLoopCounterHelper
	.p2align	4, 0x90
_navtiveLoopCounterHelper:              ## @navtiveLoopCounterHelper
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
	subq	$16, %rsp
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	movl	%edi, %r14d
	movl	$0, -20(%rbp)
	callq	_clock
	movq	%rax, %rbx
	testl	%r14d, %r14d
	jle	LBB0_6
## %bb.1:
	movl	%r14d, %eax
	andl	$3, %eax
	cmpl	$4, %r14d
	jb	LBB0_4
## %bb.2:
	andl	$-4, %r14d
	.p2align	4, 0x90
LBB0_3:                                 ## =>This Inner Loop Header: Depth=1
	incl	-20(%rbp)
	incl	-20(%rbp)
	incl	-20(%rbp)
	incl	-20(%rbp)
	addl	$-4, %r14d
	jne	LBB0_3
LBB0_4:
	testl	%eax, %eax
	je	LBB0_6
	.p2align	4, 0x90
LBB0_5:                                 ## =>This Inner Loop Header: Depth=1
	incl	-20(%rbp)
	decl	%eax
	jne	LBB0_5
LBB0_6:
	callq	_clock
	subq	%rbx, %rax
	movq	%rax, %xmm1
	punpckldq	LCPI0_0(%rip), %xmm1    ## xmm1 = xmm1[0],mem[0],xmm1[1],mem[1]
	subpd	LCPI0_1(%rip), %xmm1
	movapd	%xmm1, %xmm0
	unpckhpd	%xmm1, %xmm0                    ## xmm0 = xmm0[1],xmm1[1]
	addsd	%xmm1, %xmm0
	mulsd	LCPI0_2(%rip), %xmm0
	divsd	LCPI0_3(%rip), %xmm0
	leaq	L_.str(%rip), %rdi
	movb	$1, %al
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	jmp	_printf                         ## TAILCALL
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"C function time: %.f ms\n"

.subsections_via_symbols
