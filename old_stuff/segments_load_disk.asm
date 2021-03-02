; use BIOS to read sectors into memory
[org 0x7c00]
mov si, STR
call printf

mov al, 1
mov cl, 2
call read_disk
jmp test

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

read_disk:
    pusha
    mov ah, 0x02

    mov dl, 0x80
    mov ch, 0
    mov dh, 0
    ; mov al, 1
    ; mov cl, 2

    push bx
    mov bx, 0
    mov es, bx
    pop bx
    mov bx, 0x7c00 + 512

    int 0x13
    jc disk_error
    popa
    ret

disk_error:
    mov si, DISK_ERR_MSG
    call printf
    jmp $

STR: db 'Welcome to sauceOS:)', 0x0a, 0x0d, 0
DISK_ERR_MSG: db 'There was an error loading the disk.', 0x0a, 0x0d, 0
SCND_SCTR: db 'The second sector has been loaded.', 0x0a, 0x0d, 0
; padding and the magic number
times 510-($-$$) db 0
dw 0xaa55

; checking if we can access the second sector now
test:
	mov si, SCND_SCTR
	call printf


; solve disk error pad out the second sector
times 512 db 0
