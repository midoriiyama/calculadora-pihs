.global _start
.global operando1, operador, operando2

.section .bss
    .comm operando1, 8      # double
    .comm operador, 8
    .comm operando2, 8      # double
    .comm resultado, 8      # inteiro (usado por fatorial, primo, combinacao, arranjo)
    .comm resultado_str, 8

.section .text

_start:
    push %rbp
    mov %rsp, %rbp

# loop:  
    
    call ler_expressao

    cmp $0, %rax
    je finalizar

    # Print operando1
    movq $1, %rax
    movq $1, %rdi
    leaq operando1(%rip), %rsi
    movq $8, %rdx
    syscall
    # Print operador
    movq $1, %rax
    movq $1, %rdi
    leaq operador(%rip), %rsi
    movq $8, %rdx
    syscall
    # Print operando2
    movq $1, %rax
    movq $1, %rdi
    leaq operando2(%rip), %rsi
    movq $8, %rdx
    syscall


finalizar:

    mov %rbp, %rsp
    pop %rbp

    mov $60, %rax     # syscall exit
    xor %rdi, %rdi      # código de retorno 0
    syscall
