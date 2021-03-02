[org 0x7c00]
mov bx, 30
cmp bx, 4
jle A

cmp bx, 40
jl B

call C

mov ah, 0x0e
int 0x10

jmp $

A:
	mov ah, 0x0e
	mov al, 'A'
	int 0x10
	ret
B:
	mov ah, 0x0e
	mov al, 'B'
	int 0x10
	ret
C:
	mov ah, 0x0e
	mov al, 'C'
	int 0x10
	ret

times 510-($-$$) db 0
dw 0xaa55
