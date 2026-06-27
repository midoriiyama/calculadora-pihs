.section .text
.global verifica_divisao 
.global ler_operando1, ler_operador, ler_operando2, mostrar_resultado
.global soma, subtracao, multiplicacao, divisao, exponenciacao, combinacao, arranjo, logaritmo, fatorial, inverso, raiz, primo

.section .data
    # Mensagens para entrada e saída
    msg_in_op1: .asciz "Digite o primeiro operando: "
    msg_in_operador: .asciz "Digite o operador: " 
    msg_in_op2: .asciz "Digite o segundo operando: "
    msg_resultado: .asciz "O resultado é: %lld\n"

    # Mensagens de erro
    msg_erro_zero: .asciz "Erro: Não é possível realizar a operação para 0.\n"
    msg_erro_int: .asciz "Erro: Operando precisa ser um inteiro não negativo.\n"
    msg_erro_ac: .asciz "Erro: O valor do primeiro operando deve ser maior ou igual ao segundo.\n"
    msg_erro_op_invalido: .asciz "Erro: Operador inválido.\n"
    msg_erro_log1: .asciz "Erro: Logaritmando deve ser maior que 0.\n"
    msg_erro_log2: .asciz "Erro: A base deve ser um número diferente de 1.\n"

    fmt_in:	.asciz "%lld"
    fmt_op: .asciz " %c"
    fmt_out: .asciz "%lld\n"

.section .bss
    .comm buffer_temp, 8
    
.section .text



ler_operando1:
    push %rbp
    mov %rsp, %rbp

    # --- LER OPERANDO 1 ---
    xor %rax, %rax
    lea msg_in_op1(%rip), %rdi
	call printf

    xor %rax, %rax
    lea fmt_in(%rip), %rdi
    lea operando1(%rip), %rsi
	call scanf

    mov %rbp, %rsp
    pop %rbp
    ret

ler_operador:
    push %rbp
    mov %rsp, %rbp

    # --- LER OPERADOR ---
    xor %rax, %rax
    lea msg_in_operador(%rip), %rdi
	call printf

    xor %rax, %rax
    lea fmt_op(%rip), %rdi
    lea operador(%rip), %rsi
    call scanf

    mov %rbp, %rsp
    pop %rbp
    ret

ler_operando2:
    push %rbp
    mov %rsp, %rbp

    # --- LER OPERANDO 2 ---
    xor %rax, %rax
    lea msg_in_op2(%rip), %rdi
	call printf
    
    xor %rax, %rax
    lea fmt_in(%rip), %rdi
    lea operando2(%rip), %rsi
	call scanf

    mov %rbp, %rsp
    pop %rbp
    ret

mostrar_resultado:
    push %rbp
    mov %rsp, %rbp

    xor %rax, %rax
    lea msg_resultado(%rip), %rdi
    movq resultado(%rip), %rsi
    call printf

    mov %rbp, %rsp
    pop %rbp
    ret

soma:
    push %rbp
    mov %rsp, %rbp

    xor %rax, %rax
    movq operando1(%rip), %rax
    addq operando2(%rip), %rax

    movq %rax, resultado(%rip)

    mov %rbp, %rsp
    pop %rbp
    ret

subtracao:
    push %rbp
    mov %rsp, %rbp

    xor %rax, %rax
    movq operando1(%rip), %rax
    subq operando2(%rip), %rax

    movq %rax, resultado(%rip)

    mov %rbp, %rsp
    pop %rbp
    ret

multiplicacao:
    push %rbp
    mov %rsp, %rbp

    xor %rax, %rax
    movq operando1(%rip), %rax
    mulq operando2(%rip)
    
    movq %rax, resultado(%rip)
    
    mov %rbp, %rsp
    pop %rbp
    ret
    
verifica_divisao:
    push %rbp
    mov %rsp, %rbp

    cmp $0, operando2

    xor %rax, %rax
    lea msg_erro_zero(%rip), %rdi
    call printf

    xor %rax, %rax

    mov %rbp, %rsp
    pop %rbp
    ret

divisao:
    push %rbp
    mov %rsp, %rbp

    movq operando1(%rip), %rax
    divq operando2(%rip)

    movq %rax, resultado(%rip)

    mov %rbp, %rsp
    pop %rbp
    ret

exponenciacao:
    push %rbp
    mov %rsp, %rbp
    
    movq $1, %rax
    movq operando1(%rip), %rbx
    movq operando2(%rip), %rcx

loop_exponenciacao:
    cmp $0, %rcx
    jle fim_exponenciacao
    
    mulq %rbx
    decq %rcx
    jmp loop_exponenciacao

fim_exponenciacao:
    movq %rax, resultado(%rip)

    mov %rbp, %rsp
    pop %rbp
    ret
    
combinacao:
    push %rbp
    mov %rsp, %rbp

    # cmp $0, operando1
    # je

    # cmp $0, operando2
    # je

    # cmp operando1, operando2
    # jl 

    # Faz fatorial de n
    call fatorial 
    movq resultado(%rip), %r8

    movq operando1(%rip), %rbx
    movq operando2(%rip), %rcx
    
    subq %rcx, %rbx # rbx = n-p

    movq %rcx, operando1(%rip)

    # Faz fatorial de p
    call fatorial
    movq resultado(%rip), %rdi

    movq %rbx, operando1(%rip)

    # fatorial de (n-p)
    call fatorial

    movq %rdi, %rax
    mulq resultado(%rip)

    movq %rax, %rbx
    movq %r8, %rax

    xor %rdx, %rdx
    divq %rbx

    movq %rax, resultado(%rip)
    
    mov %rbp, %rsp
    pop %rbp
    ret

arranjo:
    push %rbp
    mov %rsp, %rbp

    mov %rbp, %rsp
    pop %rbp
    ret

logaritmo:
    push %rbp
    mov %rsp, %rbp

    mov %rbp, %rsp
    pop %rbp
    ret

fatorial:
    push %rbp
    mov %rsp, %rbp
    
    xor %rax, %rax
    movq operando1(%rip), %rax
    movq %rax, %rcx

loop_fatorial:
    decq %rcx
    cmpq $1, %rcx
    je fim_fatorial
    
    mulq %rcx
    jmp loop_fatorial

fim_fatorial:
    movq %rax, resultado(%rip)

    mov %rbp, %rsp
    pop %rbp
    ret

inverso:
    push %rbp
    mov %rsp, %rbp

    mov %rbp, %rsp
    pop %rbp
    ret

raiz:
    push %rbp
    mov %rsp, %rbp

    mov %rbp, %rsp
    pop %rbp
    ret
    
primo:
    push %rbp
    mov %rsp, %rbp


    mov %rbp, %rsp
    pop %rbp
    ret
