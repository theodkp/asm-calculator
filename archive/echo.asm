section .bss
	buffer resb 100

section .data
	input_msg db "please input something", 0xA ;defining a string 
	input_msg_len equ $ - input_msg ; $ = current address,minus input_msg = starting address of our label

	output_msg db "you entered",0xA 
	output_msg_len equ $ - output_msg 
section .text
    global _start

_start:

	; note, prints rdx bytes from rsi which points to our datas memory address

	; print out our input_msg
	mov rax, 1 ; syscall ,write in 
	mov rdi,1 ; stdout
	mov rsi, input_msg ; address of our input_msg
	mov rdx, input_msg_len ; length in bytes of input_msg into rdx
	syscall

	; read in our user input 
	mov rax, 0 ; using syscall 0 we are reading in 
	mov rdi, 0 ; stdin
	mov rsi, buffer ; move buffer pointer into rsi register
	mov rdx, 100 ; buffer set at 100 bytes
	syscall

	mov rbx, rax ; after syscall rax will contain byte count of our user input, save into rbx
	
	; print "you entered" message
	mov rax, 1
	mov rdi, 1 
	mov rsi, output_msg
	mov rdx, output_msg_len
	syscall


	; print out user input
	mov rax, 1 ; write
	mov rdi, 1 ; stdout
	mov rsi, buffer ; rsi points to entire buffer
	mov rdx, rbx ; our previously saved byte count of our user input
	syscall 	
	
	mov rax,60 ; syscall exit
	xor rdi, rdi ; status code 0, meaning success
	syscall ; exit program
