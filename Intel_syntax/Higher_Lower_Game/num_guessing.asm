; A game where you need to guess a num 0-225, after each
; try youl be told if the number you are trying to guess
; was lower or higher than your guess

global _start

section .bss
    num_buffer resb 1
    guess_buffer resb 4
    guess_num resb 1

section .data
    ; No newline on this message as it takes input on same line
    guess_msg db "Enter guess 0-255: "
    correct_msg db "Correct!", 10
    lower_msg db "Wrong, the number is lower.", 10
    higher_msg db "Wrong, the number is higher.", 10

section .text
_start:

    ; Put a rand 32bit int in rax, then take the lowest byte
    rdrand rax
    ; Only take 1 byte of it
    mov [num_buffer], al

    jmp ask_for_guess

ask_for_guess:

    ; Print guess msg
    mov rax, 1
    mov rdi, 1
    mov rsi, guess_msg
    mov rdx, 19
    syscall

    ; Input user guess
    mov rax, 0
    mov rdi, 0
    mov rsi, guess_buffer
    mov rdx, 4
    syscall

    ; Set up the registers for the loop
    mov r12, 0
    mov rcx, guess_buffer
    mov r13, 10

    jmp num_reader_loop
    

num_reader_loop:

    ; Pull a byte into r14, see if its the end of the input
    ; If so then go to comparing 
    ; Else convert it to a number, then add the 100's or 10's place and add to total
    mov r14, 0
    mov r14b, byte [rcx]
    cmp r14b, 10
    je compare_guess
    sub r14b, 48
    imul r12, 10
    add r12, r14
    inc rcx
    jmp num_reader_loop

compare_guess:

    ; Put the rand num and the first byte of the guess into regs
    mov al, [num_buffer]
    mov bl, r12b

    ; Compare the regs we just set up to see if he guess is right
    cmp al, bl
    je correct_guess
    jb wrong_guess_lower
    ja wrong_guess_higher


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

wrong_guess_lower:

    ; Print wrong guess msg lower
    mov rax, 1
    mov rdi, 1
    mov rsi, lower_msg
    mov rdx, 28
    syscall

    jmp ask_for_guess

wrong_guess_higher:

    ; Print wrong guess msg higher
    mov rax, 1
    mov rdi, 1
    mov rsi, higher_msg
    mov rdx, 29
    syscall

    jmp ask_for_guess

exit:
    ; Exit
    mov rax, 60
    mov rdi, 0
    syscall
