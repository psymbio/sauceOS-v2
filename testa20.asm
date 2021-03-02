; 8086 couldn't access the 20 bits at once as it was 16 bits
; therefore they used segmenting

; 0x0000 to 0xffff: offset address range
; 0x0000 to 0xf000: segment range

; segment:offset
; final addr was calc as: addr = segment * 16 + offset
; for example 0xf000:0xfffd
; 0xf000 * 16 = 0xf0000
; 0xf0000 + 0xfffd = 0xffffd 20 bit

; 0xf800:0x8000 = 0xf8000 + 0x8000 = 0x10000 which was truncted in the 8086 to 0x0000 -> taking us back to the starting address
; to not truncate such addresses we need to enable the A20 line
testa20:
	pusha

	mov ax, [0x7dfe]  ; 7dfe = 7c00+510 (memory location of magic number)
                  ; create a reference to check for wrapping
	; set es:SEGMENT REG to zero
	push bx
	mov bx, 0xffff
	mov es, bx
	pop bx

	mov bx, 0x7e0e    ; set offset to 0x7e0e

	mov dx, [es:bx]   ; print the contents located in the segment
	; call printh
	cmp ax, dx        ; compare the segment to the reference
	je .cont          ; if (ax == dx) {jmp to .cont}

	popa              ; else { popa
	mov ax, 1         ; set ax to 1 as a return value
	ret               ; return }


; for this section, do the same as what was done above
; except shift the reference (and thus the offset) location
; one byte for confirmation

.cont:
	mov ax, [0x7dff]

	push bx
	mov bx, 0xffff
	mov es, bx
	pop bx
	; call printh
	
	mov bx, 0x7e0f
	mov dx, [es:bx]
	; call printh

	cmp ax, dx      ; if (ax == dx) {exit}
	je .exit

	popa
	mov ax, 1       ; else {...}
	ret

.exit:
	popa
	xor ax, ax      ; set ax to 0 as return value
	ret

; this is the process used to figure out the offset for the magic
; number given the segment is 0xffff
;0xffff0 + offset = 0x107dfe
;offset = 0x107dfe - 0xffff0
;offset = 0x7e0e
