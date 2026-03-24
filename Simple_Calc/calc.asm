global _start

section .bss
    x_buffer resb 2
    y_buffer resb 2
    calc_type_buffer resb 2
    result_buffer1 resb 1
    result_buffer2 resb 1

section .data
    x_msg db "Enter x: "
    y_msg db "Enter y: "
    calc_type db "Enter + - * /: "
    result_msg db "Result: "
    err_msg db "Error, try again.", 10

    const_add db "+"
    const_sub db "-"
    const_mult db "*"
    const_div db "/"

section .text
_start:

    ; Print x msg
    mov rax, 1
    mov rdi, 1
    mov rsi, x_msg
    mov rdx, 9
    syscall

    ; Get x input
    mov rax, 0
    mov rdi, 0
    mov rsi, x_buffer
    mov rdx, 2
    syscall

    ; Save x input
    mov r12, 0
    mov r12b, byte [rsi]

    ; Print y msg
    mov rax, 1
    mov rdi, 1
    mov rsi, y_msg
    mov rdx, 9
    syscall

    ; Get y input
    mov rax, 0
    mov rdi, 0
    mov rsi, y_buffer
    mov rdx, 2
    syscall

    ; Save y input
    mov r13, 0
    mov r13b, byte [rsi]
        
    ;Print calc type msg
    mov rax, 1
    mov rdi, 1
    mov rsi, calc_type
    mov rdx, 15
    syscall

    ; Get calc type input
    mov rax, 0
    mov rdi, 0
    mov rsi, calc_type_buffer
    mov rdx, 2
    syscall

    ; Save calc type input
    mov r15, 0
    mov r15b, byte [rsi]

    ; Convert ascii to ints
    sub r12, 48
    sub r13, 48

    ; Check calc type
    mov al, r15b

    mov bl, byte [const_add]
    cmp al, bl
    je calc_add
    
    mov bl, byte [const_sub]
    cmp al, bl
    je calc_sub

    mov bl, byte [const_mult]
    cmp al, bl
    je calc_mult

    mov bl, byte [const_div]
    cmp al, bl
    je calc_div

    jmp error

calc_add:
    add r12, r13
    jmp results

calc_sub:
    sub r12, r13
    jmp results

calc_mult:
    ; Move x and y to mul registers
    mov rbx, r12
    mov rax, r13

    mul rbx
    mov r12, rax
    jmp results

calc_div:
    ; Move x and y to div registers
    mov rax, r12
    mov rcx, r13
    mov rdx, 0

    div rcx
    mov r12, rax
    jmp results

results:

    ; Div the two numbers and print sep
    mov rax, r12
    mov rbx, 10
    mov rdx, 0
    div rbx

    mov [result_buffer1], rax
    mov [result_buffer2], rdx

    add byte [result_buffer1], 48
    add byte [result_buffer2], 48

    ; Print result msg
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, 8
    syscall

    ; Print 1st result number
    mov rax, 1
    mov rdi, 1
    mov rsi, result_buffer1
    mov rdx, 1
    syscall

    ; Print 2nd result number
    mov rax, 1
    mov rdi, 1
    mov rsi, result_buffer2
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

    jmp exit

error:
    ; Print error msg, then return to start
    mov rax, 1
    mov rdi, 1
    mov rsi, err_msg
    mov rdx, 17
    syscall
    jmp _start

exit:
    ; Exit the program
    mov rax, 60         
    mov rdi, 0          
    syscall

