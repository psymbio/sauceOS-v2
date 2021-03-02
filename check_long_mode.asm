check_long_mode:
	pusha
	pushfd ; pushing eflags to the stack
	pop eax ; pop eflags from stack to EAX
	mov ecx, eax ; back up eax in ecx
	; how can we be using 32 bit registers in real mode?
	; to use 32 bit registers we need prefixes 
	; for 32 bit regsiters is 0x66
	; for 32 bit addresses the prefix is 0x67

	; nasm compiler does this prefixx adding for us provided that the 
	; operand and addressing size are equal

	; ecx and eax are of equal sizes
	; ecx and [eax] are of equal sizes

	xor eax, 1 << 21
	; if the 21st bit of eax is not 1 flip it to one

	push eax
	popfd
	; if eflags retained that 1 in the 21st bit then cpuid is supported otherwise not
	pushfd ; push flags back to stack
	pop eax
	xor eax, ecx ; rets true when they are different
	jz .exit ; if cpuid doesn't exist we go to done

	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .exit ; if eax is less than 0x80000001 then we can't go into long mode
	; if it isn't then we can access extended information through cpuid and we can continue
	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .exit
	mov si, YES_LM
	call printf
	popa
	ret
.exit:
	popa
	mov si, NO_LM
	call printf
	jmp $
