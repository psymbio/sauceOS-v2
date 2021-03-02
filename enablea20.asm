enablea20:
	pusha
	; first method comment out 6 lines
	; mov ax, 0x2401
	; int 0x15
	; call testa20
	; cmp ax, 1
	; je .done
	; ret
	
	; second method
	; keyboard
	sti
	call waitC
	mov al, 0xad
	out 0x64, al
	call waitC
	mov al, 0xd0
	out 0x64, al

	call waitD ; wait for the data to be read
	; when it is read
	in al, 0x60
	push ax
	call waitC
	mov al, 0xd1
	out 0x64, al

	; write out the input data which is on stack
	call waitC
	pop ax
	or al, 2
	out 0x60, al

	; re-enable keyboard for other commands
	call waitC
	mov al, 0xae
	out 0x64, al

	; open a backup for commands
	call waitC
	sti
	call testa20
	cmp ax, 1
	je .done

	mov si, NO_A20
	call printf
	jmp $
.done:
	mov si, YES_A20
	call printf
	popa
	mov ax, 1
	ret

; wait controller
waitC:
	in al, 0x64 ; in port
	; test is a bit comparator unlike cmp it's like an and gate
	test al, 2
	jnz waitC ; if it's not zero then it's busy then we have to continue to waitC
	ret

; wait data: loop until data is to be read
waitD:
	in al, 0x64 ; data from port 64
	test al, 1 ; if bit 1 is zero the data has been read
	jz waitD
	ret
