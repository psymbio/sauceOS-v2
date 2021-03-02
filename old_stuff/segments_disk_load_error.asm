; Tell the assembler where this code will be loaded
; https://stackoverflow.com/questions/2058690/what-is-significance-of-memory-at-00007c00-to-booting-sequence
[org 0x7c00]
mov si, STR
call printf

call read_disk

jmp $

printf:
        pusha
        str_loop:
                mov al, [si]
                cmp al, 0
                jne print_char
                popa
                ret

print_char:
        mov ah, 0x0e
        int 0x10
        add si, 1
        jmp str_loop

; reading sectors from the drive
; https://en.wikipedia.org/wiki/INT_13H
read_disk:
	pusha
	mov ah, 0x02
	; selecting drive
	; qemu emulates a hard disk to dl so it is 0x80
	; 0x80 is if you're booting from a hard disk (which is not a flash drive or a floppy)
	mov dl, 0x80
	; 0x00 is for selecting the first head
	; if you're working with a virtual machine, set it to 0x00

	; selecting the starting cylinder
	mov ch, 0
	; decide the number of sectors you want to 
	mov dh, 0
	; read the next sector
	mov al, 1
	; choose which sector to read as the 2nd sector
	mov cl, 2

	; address buffer pointer
	; ex bx in wikipedia article
	; where we want the disk information in memory
	; right now we're at 0x7c00 which is the default space of the boot sector
	; we need to load the address buffer pointer 512 bytes after 0x7c00
	; so we to load it to memory 512 bytes after that
	; move the segment register to 0 for no offsets
	; tell the bx register where we want it to be located in memory
	push bx
	mov bx, 0
	mov es, bx
	pop bx
	; to load us into our location memory
	mov bx, 0x7c00 + 512

	; Now issue the BIOS interrupt to do the actual read.
	int 0x13
	; to look at error
	; look if carry flag has been flipped
	jc disk_error
	popa
	ret

disk_error:
	mov si, DISK_ERR_MSG
	call printf
	jmp $
	
; 0x0a is \n new line
; 0x0d is \r carriage return
STR: db 'Welcome to sauceOS...', 0x0a, 0x0d, 0
DISK_ERR_MSG: db 'There was an error loading the disk.', 0x0a, 0x0d, 0
; padding and the magic number
times 510-($-$$) db 0
dw 0xaa55
