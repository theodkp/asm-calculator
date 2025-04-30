section .bss 
    buffer resb 100
    output resb 20

section .data
    input_msg db "Enter a mathematical expression (e.g. 12+4):", 0xA
    input_msg_len equ $ - input_msg

    result_msg db "Result:", 0xA
    result_msg_len equ $ - result_msg

    div0_msg db "Error: Division by zero!", 0xA
    div0_msg_len equ $ - div0_msg

section .text
    global _start

_start:
    
    ; Print input message
    mov rax, 1
    mov rdi, 1
    mov rsi, input_msg
    mov rdx, input_msg_len
    syscall

    ; Read expression from user input into buffer
    mov rax, 0 
    mov rdi, 0 
    mov rsi, buffer
    mov rdx, 100
    syscall

    ; Prepare for parsing
    mov rsi, buffer
    mov r10, 0

    mov r8b,0 ; initialise register to store if negative flag

    cmp byte [rsi], '-' ; check if first inputed character is negative
    
    jne first_atoi_loop ; if negative jump to is negative 

    mov r8b,1 ; set flag
    inc rsi ; increment past the negative symbol to our first number


first_atoi_loop:
    
    mov al, byte [rsi]

    ; operator check
    cmp al, '+'
    je get_operator
    cmp al, '-'
    je get_operator
    cmp al, '*'
    je get_operator
    cmp al, '/'
    je get_operator

    ; atoi code
    sub al, '0'
    imul r10, r10, 10
    movzx rax, al
    add r10, rax

    inc rsi
    jmp first_atoi_loop

; Get operator
get_operator:
    mov bl, al
    inc rsi

    ; Prepare for second number parsing
    mov r11, 0

    mov r9b, 0 ; init negative flag

    cmp byte[rsi], '-' ; check if negative
    
    jne second_atoi_loop ; jump to setting negative flag

    mov r9b,1 ; set flag
    inc rsi ; increment past the negative symbol to our first number


second_atoi_loop:
    mov al, byte [rsi]

    cmp al, 0xa
    je check_negate_first

    sub al, '0'
    imul r11, r11, 10
    movzx rax, al
    add r11, rax

    inc rsi
    jmp second_atoi_loop


; check if negative flags are set for either numbers
check_negate_first:
    cmp r8b,1
    jne check_negate_second

    neg r10

check_negate_second:
    cmp r9b,1
    jne second_atoi_done

    neg r11
         
second_atoi_done:

; Jump to operation
    cmp bl, '+'
    je addition
    cmp bl, '-'
    je subtraction
    cmp bl, '*'
    je multiplication
    cmp bl, '/'
    je division

    jmp done_math


; Perform operations
addition:
    add r10, r11
    jmp done_math

subtraction:
    sub r10, r11
    jmp done_math

multiplication:
    imul r10, r11
    jmp done_math

division:
    ; check if r11 == 0
    cmp r11, 0
    je div_by_zero_error

    mov rax, r10
    xor rdx, rdx
    div r11
    mov r10, rax
    jmp done_math

; Error if division by zero
div_by_zero_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, div0_msg
    mov rdx, div0_msg_len
    syscall

    ; exit program
    mov rax, 60
    xor rdi, rdi
    syscall

done_math:
    mov r14, r10
    mov r15, output

    cmp r14, 0
    jns itoa_negative_done ; if positive, skip

    ; adding negative sign to our output
    neg r14
    mov byte [r15], '-'
    inc r15


itoa_negative_done:
    cmp r14, 0
    jne itoa_loop
    
    ; if value is zero, add '0' character
    mov byte [r15], '0'
    inc r15
    jmp itoa_done

; Converting back into ASCII
itoa_loop:
    cmp r14, 0
    je itoa_done

    mov rax, r14
    xor rdx, rdx
    mov rcx, 10
    div rcx

    add dl, '0'
    mov [r15], dl
    inc r15

    mov r14, rax
    jmp itoa_loop

itoa_done:
    ; Reverse init
    mov r12, output
    mov r13, r15
    dec r13

    ; increment past our negative sign if we have one
    cmp byte[r12],'-'
    jne reverse_loop

    inc r12

reverse_loop:
    cmp r12, r13
    jae reverse_done

    mov al, byte [r12]
    mov bl, byte [r13]
    mov [r12], bl
    mov [r13], al

    inc r12
    dec r13
    jmp reverse_loop

reverse_done:
    ; Output final answer
    mov rdx, r15
    sub rdx, output
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall
