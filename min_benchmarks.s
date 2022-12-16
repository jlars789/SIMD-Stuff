	.file	"min_benchmarks.c"
	.text
	.globl	min_C
	.type	min_C, @function
min_C:
.LFB5278:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L4
	movl	$0, %eax
	movl	$32767, %edx
.L3:
	movslq	%eax, %rcx
	movzwl	(%rsi,%rcx,2), %ecx
	cmpw	%cx, %dx
	cmovg	%ecx, %edx
	incl	%eax
	movslq	%eax, %rcx
	cmpq	%rdi, %rcx
	jl	.L3
.L1:
	movl	%edx, %eax
	ret
.L4:
	movl	$32767, %edx
	jmp	.L1
	.cfi_endproc
.LFE5278:
	.size	min_C, .-min_C
	.globl	minAVX
	.type	minAVX, @function
minAVX:
.LFB5279:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	andq	$-32, %rsp
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	cmpq	$15, %rdi
	jle	.L13
	vmovdqa	.LC0(%rip), %ymm0
	movl	$16, %eax
.L8:
	leal	-16(%rax), %edx
	movslq	%edx, %rdx
	vpminsw	(%rsi,%rdx,2), %ymm0, %ymm0
	movl	%eax, %r8d
	addl	$16, %eax
	movslq	%eax, %rdx
	cmpq	%rdi, %rdx
	jle	.L8
.L7:
	vmovdqu	%ymm0, 16(%rsp)
	leaq	16(%rsp), %rdx
	leaq	48(%rsp), %r9
	movl	$32767, %eax
.L9:
	movzwl	(%rdx), %ecx
	cmpw	%cx, %ax
	cmovg	%ecx, %eax
	addq	$2, %rdx
	cmpq	%rdx, %r9
	jne	.L9
	movslq	%r8d, %rdx
	cmpq	%rdx, %rdi
	jle	.L6
.L11:
	movslq	%r8d, %rdx
	movzwl	(%rsi,%rdx,2), %edx
	cmpw	%dx, %ax
	cmovg	%edx, %eax
	incl	%r8d
	movslq	%r8d, %rdx
	cmpq	%rdi, %rdx
	jl	.L11
.L6:
	movq	56(%rsp), %rsi
	xorq	%fs:40, %rsi
	jne	.L18
	leave
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L13:
	.cfi_restore_state
	movl	$0, %r8d
	vmovdqa	.LC0(%rip), %ymm0
	jmp	.L7
.L18:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE5279:
	.size	minAVX, .-minAVX
	.globl	functions
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"C (local)"
.LC2:
	.string	"minAVX (C)"
	.section	.data.rel.local,"aw"
	.align 32
	.type	functions, @object
	.size	functions, 32
functions:
	.quad	min_C
	.quad	.LC1
	.quad	minAVX
	.quad	.LC2
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC0:
	.quad	9223231297218904063
	.quad	9223231297218904063
	.quad	9223231297218904063
	.quad	9223231297218904063
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
