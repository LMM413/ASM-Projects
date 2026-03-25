global _start

section .bss
    num_buffer resb 1
    guess_buffer resb 2

section .data
    guess_msg db "Enter guess 0-9: "
    correct_msg db "Correct!"
    wrong_guess_msg db "Wrong, the number was: "

section .text
_start:

    ; Put a rand 32bit int in rax, put 10 in rcx.
    ; This gives x/10, then we save 1 byte from rdx
    ; This is the remainder and gives a 0-9 int
    rdrand rax
    mov rcx, 10
    mov rdx, 0
    div rcx
    add dl, 48
    mov [num_buffer], dl

    ; Print guess msg
    mov rax, 1
    mov rdi, 1
    mov rsi, guess_msg
    mov rdx, 17
    syscall

    ; Input user guess
    mov rax, 0
    mov rdi, 0
    mov rsi, guess_buffer
    mov rdx, 2
    syscall

    ; Put the rand num and the first byte of the guess into regs
    mov al, [num_buffer]
    mov bl, byte [guess_buffer]

    ; Compare the regs we just set up to see if he guess is right
    cmp al, bl
    je correct_guess
    jne wrong_guess

correct_guess:

    ; Print correct guess msg
    mov rax, 1
    mov rdi, 1
    mov rsi, correct_msg
    mov rdx, 8
    syscall

    ; Newline
    push 10
    mov rax, 1                 
    mov rdi, 1 
    mov rsi, rsp
    mov rdx, 2
    syscall
    pop rcx

    jmp exit

wrong_guess:

    ; Print wrong guess msg
    mov rax, 1
    mov rdi, 1
    mov rsi, wrong_guess_msg
    mov rdx, 23
    syscall

    ; Print rand num 
    mov rax, 1
    mov rdi, 1
    mov rsi, num_buffer
    mov rdx, 1
    syscall

    ; Newline
    push 10
    mov rax, 1                 
    mov rdi, 1 
    mov rsi, rsp
    mov rdx, 2
    syscall
    pop rcx

exit:
    ; Exit
    mov rax, 60
    mov rdi, 0
    syscall
