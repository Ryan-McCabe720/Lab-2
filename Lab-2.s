.extern print_output

.section .data
msg1: .ascii "Enter first string (Max 255 Char):\n"
msg1Len = . - msg1
msg2: .ascii "Enter second string:\n"
msg2Len = . - msg2

.section .bss
string1: .space 32
string2: .space 32
len1: .space 8
len2: .space 8

.section .text
.global main

main:

    # prompt for first string
    mov $1, %rax # sys_write
    mov $1, %rdi #stdout
    mov $msg1, %rsi
    mov $msg1Len, %rdx
    syscall

    ### Read first string
    mov $0, %rax    # sys_read
    mov $0, %rdi    #stdin
    mov $string1, %rsi   # store in string1 buffer
    mov $255, %rdx
    syscall
    sub $1, %rax
    mov %rax, len1   # max bytes to be Read

    # prompt for second string
    mov $1, %rax # sys_write
    mov $1, %rdi #stdout
    mov $msg2, %rsi
    mov $msg2Len, %rdx
    syscall

    ### Read second string
    mov $0, %rax    # sys_read
    mov $0, %rdi    #stdin
    mov $string2, %rsi   
    mov $255, %rdx   
    syscall
    sub $1, %rax
    mov %rax, len2

    ### Find Shorter Length
    mov len1, %rcx      
    cmp len2, %rcx      
    jle start_compare  #if len1 <= len2 jump to start_compare 
    mov len2, %rcx      

start_compare:
    # checks if empty string
    cmp $0, %rcx        
    jle finish

    mov $string1, %rsi   # source index, puts value of first string
    mov $string2, %rdi   # dest index, puts value of second string
    xor %r12, %r12      # stores the hamming distance

char_loop:
    movzb (%rsi), %rax
    movzb (%rdi), %rbx
    xor %rbx, %rax

    mov $8, %rdx

bit_loop:
    test $1, %rax
    jz next_bit
    inc %r12
    
next_bit:
    shr $1, %rax #shifts string in %rax one to the right
    dec %rdx
    jnz bit_loop

    inc %rsi
    inc %rdi
    dec %rcx
    jnz char_loop

finish:
    mov %r12, %rdi
    call print_output
    mov $60, %rax
    mov $0, %rdi
    syscall

    .section .note.GNU-stack,"",@progbits
