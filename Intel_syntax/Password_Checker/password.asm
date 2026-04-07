; Simple password system, just loops through your input and sees if
; it matches the set code

global _start

section .bss
    input_buffer resb 4

section .data
    denied_msg db "Wrong code", 10
    accepted_msg db "Correct code", 10
    start_msg db "Enter code: "
    entered_msg db "You entered: "
    code db "5836"

section .text
_start:

    ; Print start text
    mov rax, 1
    mov rdi, 1
    mov rsi, start_msg
    mov rdx, 12
    syscall

    ; Get input
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 4
    syscall

    ; Save the input and code to  safe registers
    mov r12, rsi
    mov r13, code

    ; Print First part of text
    mov rax, 1                 
    mov rdi, 1                 
    mov rsi, entered_msg   
    mov rdx, 13               
    syscall

    ; Print entered num
    mov rax, 1                 
    mov rdi, 1 
    mov rsi, input_buffer
    mov rdx, 4
    syscall

    ; Newline
    push 10
    mov rax, 1                 
    mov rdi, 1 
    mov rsi, rsp
    mov rdx, 2
    syscall

    pop rcx

    ; Start loop
    mov rcx, 4
    jmp check_loop
    
check_loop:
    mov al, byte [r12]
    mov bl, byte [r13]

    cmp al, bl
    jne code_denied

    inc r12
    inc r13

    dec rcx
    jnz check_loop

    jmp code_accepted

code_accepted:
    mov rax, 1                 
    mov rdi, 1                 
    mov rsi, accepted_msg   
    mov rdx, 13  
    syscall
    jmp exit 

code_denied:
    mov rax, 1                 
    mov rdi, 1                 
    mov rsi, denied_msg
    mov rdx, 13  
    syscall
    jmp exit

exit:
    ; Exit the program cleanly
    mov rax, 60         
    mov rdi, 0          
    syscall

