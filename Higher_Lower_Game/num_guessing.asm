global _start

section .bss
    number resb 1

section .data
    denied_msg db "Wrong code", 10

section .text
_start:

    ; make rand num
    mov rax, 318
    mov rdi, number
    mov rsi, 1
    mov rdx, 0
    syscall

    ; Print 
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


exit:
    ; Exit the program cleanly
    mov rax, 60         
    mov rdi, 0          
    syscall

