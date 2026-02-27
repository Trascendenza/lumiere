[org 0x1000]
bits 16

start:
    mov si, kernel_msg
    call print

    call scheduler_check

halt:
    cli
    hlt
    jmp halt


scheduler_check:
    mov si, panic_msg
    call print
    ret


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

kernel_msg db "Lumiere Kernel 0.0.1 started.", 13, 10, 0
panic_msg  db "ERR: Kernel panic: no process to run.", 13, 10, 0
;times 512-($-$$) db 0
