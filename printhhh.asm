printh:
	mov si, HEX_PATTERN
	; make a copy of bx in dx so original copy stays
	mov bx, dx
	; 0x1234
	shr bx, 12
	; add bx, 48: doesn't work all the time
	; making ascii to text
	mov bx, [bx + HEX_TABLE]
	; each character is 4 bits we need to shift 3 times: 4 bit x 3 times = 12
	mov [HEX_PATTERN + 2], bl

	mov bx, dx
        shr bx, 8
	and bx, 0x000f
        mov bx, [bx + HEX_TABLE]
        mov [HEX_PATTERN + 3], bl

	mov bx, dx
        shr bx, 4
        and bx, 0x000f
        mov bx, [bx + HEX_TABLE]
        mov [HEX_PATTERN + 4], bl

	mov bx, dx
        shr bx, 0 
        and bx, 0x000f
        mov bx, [bx + HEX_TABLE]
        mov [HEX_PATTERN + 5], bl

	call printf
	ret

; HEX_PATTERN: db '0x****', 0x0a, 0x0d, 0
; HEX_TABLE: db '0123456789abcdef'
