; print characters in nasm
mov ah, 0x0e
mov al, 'X'
int 0x10

jmp $
; padding
; $ start of instruction
; $$ end of instructions
; 510: magic number
; 510 - instructions are padded with 0
times 510-($-$$) db 0
; and the magic number of bootloader
; tells that this is a bootsector and not harddrive or anything
dw 0xaa55
