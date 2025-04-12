section .bss
    buffer      resb 100
    output      resb 20 ; our output buffer

section .data
    input_msg   db "Enter a number: ", 0xA
    input_msg_len equ $ - input_msg

    output_msg  db "Converted to integer", 0xA
    output_msg_len equ $ - output_msg

section .text
    global _start

_start:

    ; print input message
    mov rax, 1
    mov rdi, 1
    mov rsi, input_msg
    mov rdx, input_msg_len
    syscall

    ; read number input into buffer
    mov rax, 0
    mov rdi, 0 
    mov rsi, buffer
    mov rdx, 100
    syscall


    
    mov r10, 0 ; total
    mov rsi, buffer 

parse_loop:
    ; gets 1 byte value from the memory address in rsi and stores it in al
    mov al, byte[rsi] ; al is an 8-bit register

    cmp al, 0xa ; compare al register to a value (0xa) and sets flag
    je parse_done ; jumps if equal (to parse_done)

    sub al, '0' ; to turn our ascii value of our string integer, into an actual integer. we subtract '0' 

    imul r10, r10, 10 ; r10 = r10 * 10

    movzx rax,al ; moves al (8-bit) into rax and zero extends to fit 64-bit
    add r10, rax ; adds r10 and rax


    inc rsi ; increments rsi by one byte, is our buffer memory address
    jmp parse_loop ; takes us back to beginning of our loop


parse_done:


    ; print output msg
    mov rax, 1
    mov rdi, 1
    mov rsi, output_msg
    mov rdx, output_msg_len
    syscall


    mov r11, output

itoa_loop:

    
    cmp r10,0 ; no more numbers to process 
    je itoa_done ; jump out of our loop
    
    
    mov rax, r10  ; move r10 our string into rax
    xor rdx, rdx ; must be cleared to zero each division
    mov rcx, 10 ; move integer 10 into rcx
    div rcx ; divide rax by 10

    ; rax = quotient, rdx = remainder

    ; dl is the bottom 8 bits of rdx, our remainder
    
    add dl, '0' ; add ascii 0 to change int to ascii
    
    mov [r11], dl ; storing each character into our output buffer
    inc r11 ; increment our pointer in our output buffer (stored in r11)
    
    mov r10,rax ; store the quotient back in r10 to do the next number 
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

    
    
    mov rdx, r11 ; to get our length
    
    ; print entered number
    mov rax, 1 
    mov rdi, 1
    mov rsi, output
    sub rdx, output ; (r11 - output )
    
    syscall

    ; exit program
    mov rax, 60
    xor rdi, rdi
    syscall


