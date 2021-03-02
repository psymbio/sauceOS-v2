; Tell the assembler where this code will be loaded
[org 0x7c00]
mov si, STR
call printf

; helps to not infinitely run there
; and not crash
; hang
; jump to address of current instruction
; an unconditional jump: which will always jump
; jump forever
jmp $

printf:
	; push everything to stack
	pusha
	str_loop:
		mov al, [si]
		cmp al, 0
		; jump not equal to
		; a jump with some condition
		; if string hasn't still reached zero
		jne print_char
		; popeverything from stack
		popa
		ret

print_char:
	mov ah, 0x0e
	int 0x10
	add si, 1
	jmp str_loop
		
STR: db "Welcome to sauceOS...", 0

; padding and the magic number
times 510-($-$$) db 0
dw 0xaa55
