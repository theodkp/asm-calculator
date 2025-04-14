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
    ; Print input_msg
    mov rax, 1
    mov rdi, 1
    mov rsi, input_msg
    mov rdx, input_msg_len
    syscall

    ; Read expression into buffer
    mov rax, 0 
    mov rdi, 0 
    mov rsi, buffer
    mov rdx, 100
    syscall

; atoi first number

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


    ; atoi code
    sub al, '0'
    imul r10, r10,10
    movzx rax,al
    add r10,rax

    inc rsi
    jmp first_atoi_loop



; get operator 

get_operator:
    mov bl, al
    inc rsi



; atoi second number

    mov r11,0

second_atoi_loop:


    mov al, byte[rsi]


    cmp al,0xa
    je second_atoi_done

    sub al, '0'
    imul r11, r11,10
    movzx rax,al
    add r11,rax

    inc rsi
    jmp second_atoi_loop




second_atoi_done:

; jump to operation 

    cmp bl, '+'
    je addition

    cmp bl, '-'
    je subtraction

    cmp bl, '*'
    je multiplication

    cmp bl, '/'
    je division

    jmp done_math


; perform operations
addition:
    add r10, r11
    jmp done_math

subtraction:
    sub r10,r11
    jmp done_math


multiplication:
    imul r10,r11
    jmp done_math

division:
    mov rax, r10
    xor rdx,rdx
    div r11
    mov r10, rax
    jmp done_math


done_math:


    mov r14, r10
    mov r11, output 


; converting back into ascii
itoa_loop:

    
    cmp r14,0 ; no more numbers to process 
    je itoa_done ; jump out of our loop
    
    
    mov rax, r14  ; move r14 our string into rax
    xor rdx, rdx ; must be cleared to zero each division
    mov rcx, 10 ; move integer 10 into rcx
    div rcx ; divide rax by 10

    ; rax = quotient, rdx = remainder

    ; dl is the bottom 8 bits of rdx, our remainder
    
    add dl, '0' ; add ascii 0 to change int to ascii
    
    mov [r11], dl ; storing each character into our output buffer
    inc r11 ; increment our pointer in our output buffer (stored in r11)
    
    mov r14,rax ; store the quotient back in r14 to do the next number 
    jmp itoa_loop


itoa_done:

    

    ; reverse init
    mov r12, output ; r12 stores the beginning of our output buffer
    mov r13, r11 ; r13 stores the end of our inputed number + 1
    dec r13 ; decrement so it lines up with end of inputed number



reverse_loop:

    cmp r12, r13 ; we stop swapping if r12 and r13 are equal
    jae reverse_done ; Jump if Above or Equal

    mov al, byte [r12] ; store each byte in temporary registers al and bl

    mov bl, byte [r13]

    mov [r12], bl ; swap

    mov [r13], al


    

    inc r12 ; increment our left pointer
    dec r13 ; decrement our right pointer

    jmp reverse_loop ; while
        


reverse_done:

    ; output answer to our expresssion
    mov rdx, r11        
    sub rdx, output 
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall


    



    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall
