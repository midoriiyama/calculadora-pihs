.section .text
.global verifica_divisao, verifica_ac, verifica_logaritmo, verifica_fatorial, verifica_inverso, verifica_raiz, erro_operador
.global ler_numero, ler_operador, mostrar_resultado, mostrar_resultado_float
.global soma, subtracao, multiplicacao, divisao, exponenciacao, combinacao, arranjo, logaritmo, fatorial, inverso, raiz, primo

.section .data
    # Mensagens para entrada e saída
    msg_in_op1: .asciz "\Digite o primeiro operando: "
    msg_in_operador: .asciz "Digite o operador: " 
    msg_in_op2: .asciz "Digite o segundo operando: "
    msg_resultado: .asciz "O resultado é: %lld\n"
    msg_in_numero: .asciz "Digite o numero: "
    msg_resultado_float: .asciz "O resultado é: %lf\n"
    msg_operando_invalido: .asciz "O operando é inválido.\n"
    msg_operador_invalido: .asciz "O operador é inválido.\n"

    # Mensagens de erro
    msg_erro_zero: .asciz "Erro: Não é possível realizar a operação para 0.\n"
    msg_erro_int: .asciz "Erro: Operando precisa ser um inteiro não negativo.\n"
    msg_erro_neg: .asciz "Erro: Não é possível realizar a operação para valor negativo.\n"
    msg_erro_ac: .asciz "Erro: O valor do primeiro operando deve ser maior ou igual ao segundo.\n"
    msg_erro_op_invalido: .asciz "Erro: Operador inválido.\n"
    msg_erro_log1: .asciz "Erro: Logaritmando deve ser maior que 0.\n"
    msg_erro_log2: .asciz "Erro: A base deve ser um número diferente de 1.\n"

    fmt_in:	.asciz "%lld"
    fmt_op: .asciz " %c"
    fmt_out: .asciz "%lld\n"
    fmt_double: .asciz "%lf"

.section .bss
    .comm buffer_temp, 8
    .comm resultado_float, 8

.section .text


#  --- LER E VERIFICA ENTRADA OPERANDO ---

ler_numero:
    push %rbp
    mov %rsp, %rbp

    and $-16, %rsp


    xor %rax, %rax
    lea msg_in_numero(%rip), %rdi
    call printf

    xor %rax, %rax
    lea fmt_double(%rip), %rdi
    lea buffer_temp(%rip), %rsi
    call scanf

    cmp $1, %rax
    jne erro_ler_numero

    movsd buffer_temp(%rip), %xmm0
    jmp finalizar_ler_numero

erro_ler_numero:
    lea msg_operando_invalido(%rip), %rdi
    
    call printf
    
    call limpar_buffer
    
    xor %rax, %rax
    jmp finalizar_ler_numero

finalizar_ler_numero:
    mov %rbp, %rsp
    pop %rbp
    ret


limpar_buffer:
    push %rbp
    mov %rsp, %rbp
    
    and $-16, %rsp      

loop_limpar:

    xor %rax, %rax
    call getchar # le o char q ta no buffer esperando ser armazenado e descarta

    cmp $10, %eax # ASCII(10) = ('\n' / Enter)
    je fim_limpar

    cmp $-1, %eax # ASCII(-1) = EOF    
    je fim_limpar

    jmp loop_limpar     

fim_limpar:
    mov %rbp, %rsp
    pop %rbp
    ret

ler_operador:
    push %rbp
    mov %rsp, %rbp

    xor %rax, %rax
    lea msg_in_operador(%rip), %rdi
    call printf

    xor %rax, %rax
    lea fmt_op(%rip), %rdi
    lea buffer_temp(%rip), %rsi
    call scanf

    movq buffer_temp(%rip), %rax

    mov %rbp, %rsp
    pop %rbp
    ret

erro_operador:
    push %rbp
    mov %rsp, %rbp
    
    xor %rax, %rax
    lea msg_operador_invalido(%rip), %rdi
    call printf

    mov %rbp, %rsp
    pop %rbp
    ret


mostrar_resultado_float:
    push %rbp
    mov %rsp, %rbp
    
    and $-16, %rsp
    
    xor %rax, %rax
    lea msg_resultado_float(%rip), %rdi
    movsd resultado_float(%rip), %xmm0
    
    # Informar quantidade de registradores xmm enviados
    mov $1, %rax
    call printf

    mov %rbp, %rsp
    pop %rbp
    ret

mostrar_resultado:
    push %rbp
    mov %rsp, %rbp

    and $-16, %rsp

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

    # xmm0 = operando1, xmm1 = operando2 (double)
    addsd %xmm1, %xmm0

    mov %rbp, %rsp
    pop %rbp
    ret

subtracao:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = operando1, xmm1 = operando2 (double)
    subsd %xmm1, %xmm0

    mov %rbp, %rsp
    pop %rbp
    ret

multiplicacao:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = operando1, xmm1 = operando2 (double)
    mulsd %xmm1, %xmm0

    mov %rbp, %rsp
    pop %rbp
    ret
    
verifica_divisao:
    push %rbp
    mov %rsp, %rbp

    # xmm1 = operando2 (divisor), double
    pxor %xmm2, %xmm2
    comisd %xmm2, %xmm1
    je nao_pode_dividir

    jmp pode_dividir
    
nao_pode_dividir:
    lea msg_erro_zero(%rip), %rdi
    call printf
    xor %rax, %rax
    jmp fim_verifica_divisao
    
pode_dividir:
    movq $1, %rax

fim_verifica_divisao:
    mov %rbp, %rsp
    pop %rbp
    ret

divisao:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = operando1 (dividendo), xmm1 = operando2 (divisor)
    divsd %xmm1, %xmm0

    mov %rbp, %rsp
    pop %rbp
    ret

exponenciacao:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = base (double), rdi = expoente (inteiro truncado)
    movsd %xmm0, %xmm1          # xmm1 = base
    movq %rdi, %rcx             # rcx = expoente

    # resultado inicial = 1.0
    pxor %xmm0, %xmm0
    movq $1, %rax
    cvtsi2sd %rax, %xmm0

loop_exponenciacao:
    cmp $0, %rcx
    jle fim_exponenciacao

    mulsd %xmm1, %xmm0
    decq %rcx
    jmp loop_exponenciacao

fim_exponenciacao:
    mov %rbp, %rsp
    pop %rbp
    ret

verifica_ac:
    push %rbp
    mov %rsp, %rbp

    cmpq $0, %rdi
    jl nao_pode_ac_int

    cmpq $0, %rsi
    jl nao_pode_ac_int

    cmp %rsi, %rdi
    jl nao_pode_ac_maior

    movq $1, %rax
    jmp fim_verifica_ac
    
nao_pode_ac_int:
    xor %rax, %rax
    lea msg_erro_int(%rip), %rdi
    call printf
    xor %rax, %rax

    jmp fim_verifica_ac

nao_pode_ac_maior:
    xor %rax, %rax
    lea msg_erro_ac(%rip), %rdi
    call printf
    xor %rax, %rax

    jmp fim_verifica_ac
    
fim_verifica_ac:
    mov %rbp, %rsp
    pop %rbp
    ret
    
combinacao:
    push %rbp
    mov %rsp, %rbp

    movq %rsi, %rbx # %rbx = p
    movq %rdi, %rcx 
    subq %rsi, %rcx # %rcx = n - p


    push %rcx # Protege o (n-p)
    push %rbx # Protege o p

    # N!
    call fatorial
    movq %rax, %r8 # r8 = n!
    pop %rbx
    pop %rcx

    movq %rbx, %rdi
    push %rcx
    push %r8

    # P!
    call fatorial
    movq %rax, %rbx # rbx = p!
    pop %r8
    pop %rcx

    # (N-P)!
    movq %rcx, %rdi
    push %r8
    push %rbx
    call fatorial
    
    pop %rbx
    pop %r8

    mulq %rbx
    movq %rax, %rcx # %rcx = (n-p)! * p!

    movq %r8, %rax # %rax = n!
    xor %rdx, %rdx
    divq %rcx

    mov %rbp, %rsp
    pop %rbp
    ret

arranjo:
    push %rbp
    mov %rsp, %rbp

    # rdi = n
    # rsi = k

    movq %rdi, %rbx # rbx = n
    subq %rsi, %rbx # rbx = n-k

    push %rbx
    call fatorial
    movq %rax, %rcx # rcx = n!
    pop %rbx

    movq %rbx, %rdi
    push %rcx
    call fatorial # rax = (n-k)!
    pop %rcx
    
    movq %rax, %rbx
    movq %rcx, %rax
    xor %rdx, %rdx
    divq %rbx

    mov %rbp, %rsp
    pop %rbp
    ret

verifica_logaritmo:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = logaritmando, xmm1 = base (double)
    pxor %xmm2, %xmm2
    comisd %xmm0, %xmm2
    jae nao_pode_logaritmo1     # logaritmando <= 0

    movq $1, %rax
    cvtsi2sd %rax, %xmm2
    comisd %xmm2, %xmm1
    je nao_pode_logaritmo2      # base == 1

    movq $1, %rax
    jmp fim_verifica_logaritmo
    
nao_pode_logaritmo1:
    xor %rax, %rax
    lea msg_erro_log1(%rip), %rdi
    call printf
    xor %rax, %rax
    jmp fim_verifica_logaritmo

nao_pode_logaritmo2:
    xor %rax, %rax
    lea msg_erro_log2(%rip), %rdi
    call printf
    xor %rax, %rax
    jmp fim_verifica_logaritmo

fim_verifica_logaritmo:
    mov %rbp, %rsp
    pop %rbp
    ret

logaritmo:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = x (logaritmando), xmm1 = b (base), ambos double
    sub $16, %rsp
    movsd %xmm0, (%rsp)         # guarda x na pilha
    movsd %xmm1, 8(%rsp)        # guarda b na pilha

    # --- CALCULAR O log2(x) ---
    fld1
    fldl (%rsp) # st(0) = x
    fyl2x # st(0) = log2(x)

    # --- CALCULAR O log2(base) ---
    fld1                   
    fldl 8(%rsp) # st(0) = b e st(1) = log2(x)
    fyl2x # st(0) = log2(b) e st(1) = log2(x)

    # --- MUDANCA DE BASE ---
    fxch # Troca: st(0) = log2(x) e st(1) = log2(b)
    fdiv %st(1), %st(0) # st(0) = log2(x) / log2(b)

    fstpl (%rsp)
    movsd (%rsp), %xmm0

    add $16, %rsp
    mov %rbp, %rsp
    pop %rbp
    ret

verifica_fatorial:
    push %rbp
    mov %rsp, %rbp

    cmpq $0, %rdi
    jl nao_pode_fatorial

    movq $1, %rax
    jmp fim_verifica_fatorial
    
nao_pode_fatorial:
    xor %rax, %rax
    lea msg_erro_int(%rip), %rdi
    call printf
    xor %rax, %rax

fim_verifica_fatorial:
    mov %rbp, %rsp
    pop %rbp
    ret

fatorial:
    push %rbp
    mov %rsp, %rbp
    
    xor %rax, %rax
    movq %rdi, %rax
    movq %rax, %rcx

loop_fatorial:
    decq %rcx
    cmpq $1, %rcx
    jle fim_fatorial
    
    mulq %rcx
    jmp loop_fatorial

fim_fatorial:
    mov %rbp, %rsp
    pop %rbp
    ret

verifica_inverso:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = operando (double)
    pxor %xmm1, %xmm1
    comisd %xmm1, %xmm0
    je nao_pode_inverso

    movq $1, %rax
    jmp fim_verifica_inverso
    
nao_pode_inverso:
    xor %rax, %rax
    lea msg_erro_zero(%rip), %rdi
    call printf
    xor %rax, %rax

fim_verifica_inverso:
    mov %rbp, %rsp
    pop %rbp
    ret

inverso:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = operando (double); calcular 1.0 / operando
    movsd %xmm0, %xmm1          # xmm1 = operando
    movq $1, %rax
    cvtsi2sd %rax, %xmm0        # xmm0 = 1.0
    divsd %xmm1, %xmm0          # xmm0 = 1.0 / operando

    mov %rbp, %rsp
    pop %rbp
    ret

verifica_raiz:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = operando (double)
    pxor %xmm1, %xmm1
    comisd %xmm1, %xmm0
    jb nao_pode_raiz

    movq $1, %rax
    jmp fim_verifica_raiz
    
nao_pode_raiz:
    xor %rax, %rax
    lea msg_erro_neg(%rip), %rdi
    call printf
    xor %rax, %rax

fim_verifica_raiz:
    mov %rbp, %rsp
    pop %rbp
    ret

raiz:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = operando (double)
    sqrtsd %xmm0, %xmm0

    mov %rbp, %rsp
    pop %rbp
    ret
    
primo:
    push %rbp
    mov %rsp, %rbp

    movq %rdi, %rax
    xor %rdx, %rdx
    movq $2, %rbx
    divq %rbx

    movq %rax, %rcx

    
loop_primo:
    movq %rdi, %rax

    cmp $1, %rcx
    jle fim_primo

    xor %rdx, %rdx
    divq %rcx

    decq %rcx
    
    cmp $0, %rdx
    je proximo_numero
    
    jmp loop_primo

proximo_numero:
    incq %rdi

    movq %rdi, %rax
    xor %rdx, %rdx
    movq $2, %rbx
    divq %rbx

    movq %rax, %rcx

    jmp loop_primo

fim_primo:
    movq %rdi, %rax
    
    mov %rbp, %rsp
    pop %rbp
    ret
