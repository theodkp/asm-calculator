section .bss
    buffer      resb 100

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

    ; TODO: read into buffer
    mov rax, 0
    mov rdi, 0 
    mov rsi, buffer
    mov rdx, 100
    syscall


    ;
    mov r10, 0
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

    ; exit program
    mov rax, 60
    xor rdi, rdi
    syscall


