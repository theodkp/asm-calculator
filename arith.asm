section .bss
    buffer resb 100
    output resb 20

section .data
    input_msg db "Enter a mathematical expression (e.g. 12+4):", 0xA
    input_msg_len equ $ - input_msg

    result_msg db "Result:", 0xA
    result_msg_len equ $ - result_msg

section .text
    global _start

_start:
    ; 1. Print input_msg
    mov rax, 1
    mov rdi, 1
    mov rsi, input_msg
    mov rdx, input_msg_len
    syscall

    ; 2. Read into buffer
    mov rax, 0 
    mov rdi, 0 
    mov rsi, buffer
    mov rdx, 100
    syscall

; 3. Parse first number into r10

    mov rsi, buffer
    mov r10, 0
first_atoi_loop:

    mov al, byte[rsi]

    ; operator check
    cmp al, '+'
    je get_operator

    cmp al, '-'
    je get_operator

    cmp al, '*'
    je get_operator

    cmp al, '/'
    je get_operator


    sub al, '0'
    imul r10, r10,10
    movzx rax,al
    add r10,rax

    inc rsi
    jmp first_atoi_loop



; 4. Detect operator 

get_operator:
    mov bl, al
    inc rsi
    mov r11, 0



; 5. Parse second number into r11

second_atoi_loop:


second_atoi_done:

; 6. Compare operator, jump to + / - / * / /

    cmp bl, '+'
    add r10, r11

    cmp bl, '-'
    sub r10, r11

    
; 8. Use your Day 4 logic to convert and print r10



    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall
