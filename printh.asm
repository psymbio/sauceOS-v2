; https://stackoverflow.com/questions/1797765/assembly-invalid-effective-address
printh:
	push cx
	push di
	push bx
        mov si, HEX_PATTERN
	mov cl, 12
	mov di, 2
	jmp print_hex_char

print_hex_char:
	mov bx, dx
	shr bx, cl
	sub cl, 4
	and bx, 0x00f
	mov bx, [bx + HEX_TABLE]
	mov [HEX_PATTERN + di], bl
	add di, 1
	cmp di, 6
	je .exit
	jmp print_hex_char

.exit:
	call printf
	pop bx
	pop di
	pop cx
	ret
HEX_PATTERN: db '0x****', 0x0a, 0x0d, 0
HEX_TABLE: db '0123456789abcdef'
