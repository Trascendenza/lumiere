[org 0x7C00]
bits 16

KERNEL_LOAD_ADDR equ 0x1000
KERNEL_SECTORS   equ 1

start:
    cli
    mov [BOOT_DRIVE], dl   ; save boot drive

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov si, boot_msg
    call print

    mov bx, KERNEL_LOAD_ADDR
    mov dh, KERNEL_SECTORS
    call load_kernel

    jmp 0x0000:KERNEL_LOAD_ADDR


print:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret


load_kernel:
    mov ah, 0x02
    mov al, dh              ; sectors to read
    mov ch, 0               ; cylinder
    mov dh, 0               ; head
    mov cl, 2               ; sector (start after boot sector)
    mov dl, [BOOT_DRIVE]    ; restore correct drive
    int 0x13
    jc disk_error
    ret

disk_error:
    mov si, disk_msg
    call print
    hlt
    jmp $

BOOT_DRIVE db 0

boot_msg db "Bootloader: loading kernel...", 13, 10, 0
disk_msg db "Disk read error!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
