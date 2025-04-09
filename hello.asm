section .data
    msg db "Hello, World from assembly!!!", 0xA     ; 0xA = newline
    len equ $ - msg               ; message length

section .text
    global _start

_start:
    mov rax, 1        ; syscall number for write
    mov rdi, 1        ; file descriptor 1 = stdout
    mov rsi, msg      ; pointer to message
    mov rdx, len      ; length of message
    syscall           ; make the syscall

    mov rax, 60       ; syscall number for exit
    xor rdi, rdi      ; exit code 0
    syscall

