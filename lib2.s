.global ler_numero, ler_operador, erro_operador, limpar_buffer
.global mostrar_resultado, mostrar_resultado_float, continuar, msg_in
.global soma, subtracao, multiplicacao, divisao, exponenciacao
.global combinacao, arranjo, logaritmo, fatorial, inverso, raiz, primo
.global verifica_zero, verifica_int_nao_negativo, verifica_menor_ac
.global verifica_ac, verifica_logaritmo, verifica_raiz
.global salvar_funcao, ler_buffer, salvar_variavel
.global msg_out_funcao, msg_out_variavel
.section .data
    msg_in: .asciz "Digite a expressão:\n"
    
    msg_resultado: .asciz "O resultado é: %lld\n"
    msg_resultado_float: .asciz "O resultado é: %lf\n"

    msg_operando_invalido: .asciz "O operando é inválido.\n"
    msg_operador_invalido: .asciz "O operador é inválido.\n"

    msg_continuar: .asciz "Deseja continuar? (s/n): "

    msg_erro_zero: .asciz "Erro: Não é possível realizar a operação para 0.\n"
    msg_erro_int: .asciz "Erro: Operando precisa ser um inteiro não negativo.\n"
    msg_erro_neg: .asciz "Erro: Não é possível realizar a operação para valor negativo.\n"
    msg_erro_ac: .asciz "Erro: O valor do primeiro operando deve ser maior ou igual ao segundo.\n"
    msg_erro_op_invalido: .asciz "Erro: Operador inválido.\n"
    msg_erro_log1: .asciz "Erro: Logaritmando deve ser maior que 0.\n"
    msg_erro_log2: .asciz "Erro: A base deve ser um número diferente de 1.\n"
    msg_erro_continuar: .asciz "Erro: Entrada inválida.\n"

    msg_out_funcao: .asciz "Função salva com sucesso!\n"
    msg_out_variavel: .asciz "Variável salva com sucesso!\n"

    fmt_in:	.asciz "%lld"
    fmt_op: .asciz " %c"
    fmt_out_int: .asciz "%lld\n"
    fmt_double: .asciz "%lf"
    fmt_string: .asciz "%s"


.section .bss
    .comm resultado_float, 8
    .comm continuar_char, 8
    .comm lista_var, 208 # Cada tupla da variável ocupa 8 bytes
    .comm lista_fun, 832 # Cada tupla de função ocupa 32 bytes
    
.section .text

ler_buffer:
    xor %rax, %rax
    lea msg_in(%rip), %rdi
    call printf

    xor %rax, %rax
    lea fmt_string(%rip), %rdi
    lea buffer_linha(%rip), %rsi
    xor %rax, %rax
    call scanf

ler_numero:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp

    lea fmt_double(%rip), %rdi
    lea buffer_linha(%rip), %rsi
    xor %rax, %rax
    call scanf

    cmp $1, %rax
    jne erro_ler_numero

    movsd (%rsp), %xmm0
    jmp finalizar_ler_numero

erro_ler_numero:
    call limpar_buffer  

    lea msg_operando_invalido(%rip), %rdi
    xor %rax, %rax
    call printf

    xor %rax, %rax        

finalizar_ler_numero:
    mov %rbp, %rsp
    pop %rbp
    ret

ler_operador:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp
    sub $16, %rsp

    xor %rax, %rax
    lea fmt_op(%rip), %rdi
    mov %rsp, %rsi
    call scanf

    movq (%rsp), %rax

    mov %rbp, %rsp
    pop %rbp
    ret


erro_operador:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp

    xor %rax, %rax
    lea msg_operador_invalido(%rip), %rdi
    call printf

    mov %rbp, %rsp
    pop %rbp
    ret

limpar_buffer:
    push %rbp
    mov %rsp, %rbp
    
    and $-16, %rsp  

loop_limpar_buffer:
    xor %rax, %rax
    call getchar # le o char q ta no buffer esperando ser armazenado e descarta

    cmp $10, %eax # ASCII(10) = ('\n' / Enter)
    je fim_limpar_buffer

    cmp $-1, %eax # ASCII(-1) = EOF    
    je fim_limpar_buffer

    jmp loop_limpar_buffer 

fim_limpar_buffer:
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


continuar:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp
    sub $16, %rsp

loop_continuar:
    xor %rax, %rax
    lea msg_continuar(%rip), %rdi
    call printf

    xor %rax, %rax
    lea fmt_op(%rip), %rdi
    lea (%rsp), %rsi
    call scanf

    movq (%rsp), %rbx

    cmpb $'n', %bl
    je retorna_zero

    cmpb $'s', %bl
    jne erro_continua

    movq $1, %rax
    jmp finaliza_continuar

retorna_zero:
    xor %rax, %rax
    jmp finaliza_continuar

erro_continua:
    xor %rax, %rax
    lea msg_erro_continuar(%rip), %rdi
    call printf
    jmp loop_continuar

finaliza_continuar:
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


logaritmo:
    push %rbp
    mov %rsp, %rbp

    # xmm0 = x (logaritmando), xmm1 = b (base), ambos double
    sub $16, %rsp
    movsd %xmm0, (%rsp)         # guarda x na pilha
    movsd %xmm1, 8(%rsp)        # guarda b na pilha

    # Calcula o log2(x)
    fld1
    fldl (%rsp) # st(0) = x
    fyl2x # st(0) = log2(x)

    # Calcula o log2(b)
    fld1                   
    fldl 8(%rsp) # st(0) = b e st(1) = log2(x)
    fyl2x # st(0) = log2(b) e st(1) = log2(x)

    # Mudança de base
    fxch # Troca: st(0) = log2(x) e st(1) = log2(b)
    fdiv %st(1), %st(0) # st(0) = log2(x) / log2(b)

    fstpl (%rsp)
    movsd (%rsp), %xmm0

    add $16, %rsp
    mov %rbp, %rsp
    pop %rbp
    ret


fatorial:
    push %rbp
    mov %rsp, %rbp
    
    cmpq $0, %rdi
    je caso_zero_fatorial
    
    xor %rax, %rax
    movq %rdi, %rax
    movq %rax, %rcx

loop_fatorial:
    decq %rcx
    cmpq $1, %rcx
    jle fim_fatorial
    
    mulq %rcx
    jmp loop_fatorial

caso_zero_fatorial:
    movq $1, %rax

fim_fatorial:
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

    cmp $2, %rdi
    jge iniciar_primo
    movq $2, %rdi

iniciar_primo:
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

verifica_zero: # serve para divisao, e inverso (lembrar de trocar para o xmm1)
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp

    xor %rax, %rax
    cvtsi2sd %rax, %xmm2
    comisd %xmm2, %xmm1
    je eh_zero
    movq $1, %rax 

finaliza:
    mov %rbp, %rsp
    pop %rbp
    ret

eh_zero:
    xor %rax, %rax
    lea msg_erro_zero(%rip), %rdi
    call printf
    xor %rax, %rax
    jmp finaliza


verifica_int_nao_negativo:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp
    
    cvttsd2si %xmm0, %rax
    cvtsi2sd %rax, %xmm1
    comisd %xmm0, %xmm1
    jne nao_e_inteiro_nao_negativo

    pxor %xmm1, %xmm1
    comisd %xmm1, %xmm0        # xmm0 CMP xmm1(=0): testa se xmm0 >= 0
    jb nao_e_inteiro_nao_negativo   # se xmm0 < 0 → erro

    movq $1, %rax              # ← sucesso
    jmp fim_verifica_int_nao_negativo

nao_e_inteiro_nao_negativo:
    xor %rax, %rax
    lea msg_erro_int(%rip), %rdi
    call printf
    xor %rax, %rax

fim_verifica_int_nao_negativo:
    mov %rbp, %rsp
    pop %rbp
    ret


verifica_menor_ac:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp

    cmpq %rsi, %rdi # compara n e p
    jl nao_pode_menor_ac

    movq $1, %rax
    jmp fim_verifica_menor_ac

nao_pode_menor_ac:
    xor %rax, %rax
    lea msg_erro_ac(%rip), %rdi
    call printf
    xor %rax, %rax

fim_verifica_menor_ac:
    mov %rbp, %rsp
    pop %rbp
    ret


verifica_ac:
    push %rbp
    mov %rsp, %rbp

    # verifica se n (xmm0) é inteiro não negativo
    call verifica_int_nao_negativo
    cmp $0, %rax
    je fim_verifica_ac

    # verifica se p (xmm1) é inteiro não negativo
    movsd %xmm1, %xmm0
    call verifica_int_nao_negativo
    cmp $0, %rax
    je fim_verifica_ac

    # verifica se n >= p
    cvttsd2si operando1(%rip), %rdi
    cvttsd2si operando2(%rip), %rsi
    call verifica_menor_ac

fim_verifica_ac:
    mov %rbp, %rsp
    pop %rbp
    ret
    
verifica_logaritmo:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp

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


verifica_raiz:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp

    pxor %xmm1, %xmm1
    comisd %xmm1, %xmm0     # xmm0 = operando
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




salvar_funcao:
    # Prólogo oficial da função [4]
    push %rbp
    mov %rsp, %rbp

    # Carrega o endereço da linha digitada pelo usuário no registrador %r12
    lea buffer_linha(%rip), %r12

    # --- PASSO 1: VERIFICAR SE O FORMATO É f(x)= ---
    # Compara o caractere na posição 1: deve ser '('
    movzbl 1(%r12), %eax
    cmpb $'(', %al
    jne nao_e_funcao        # Se não for '(', salta (não é definição de função) [3]

    # Compara o caractere na posição 3: deve ser ')'
    movzbl 3(%r12), %eax
    cmpb $')', %al
    jne nao_e_funcao

    # Compara o caractere na posição 4: deve ser '='
    movzbl 4(%r12), %eax
    cmpb $'=', %al
    jne nao_e_funcao

    # --- PASSO 2: CALCULAR O ENDEREÇO DA GAVETA (OTIMIZADO) ---
    # Se chegou aqui, temos certeza que o usuário digitou f(x)=
    movzbl 0(%r12), %eax    # Pega o nome da função (ex: 'g' = código ASCII 103)
    subb $97, %al           # Subtrai 97 para achar o índice (103 - 97 = 6)
    
    movzbq %al, %rax        # Estende para 64 bits para fazer a conta
    
    # MÁGICA DA OTIMIZAÇÃO: Deslocamento lógico para a esquerda [2, 5]
    # Deslocar 5 bits para a esquerda multiplica o valor por 32 (2^5) rapidamente!
    shlq $5, %rax           

    lea lista_fun(%rip), %rdi
    addq %rax, %rdi         # %rdi agora aponta exatamente para o início da gaveta de 32 bytes!

    # --- PASSO 3: GUARDAR O PARÂMETRO E A EXPRESSÃO ---
    # Salva o parâmetro ('x') no primeiro byte da gaveta
    movzbl 2(%r12), %eax
    movb %al, 0(%rdi)

    # Prepara os ponteiros para copiar a expressão (sem espaços)
    lea 5(%r12), %rsi       # %rsi aponta para o caractere 5 do buffer (início do "7*9")
    lea 1(%rdi), %rdx       # %rdx aponta para o byte 1 da gaveta (logo após o 'x')

copiar_expressao:
    movzbl (%rsi), %eax     # Lê 1 byte da expressão
    movb %al, (%rdx)        # Escreve na gaveta

    # Condições de parada
    cmpb $10, %al           # É o Enter (ASCII 10 - quebra de linha)?
    je fim_copiar           # Salta para o fim se for o enter [3]
    cmpb $0, %al            # É o fim da string (NULL)?
    je fim_copiar           

    inc %rsi                # Avança o ponteiro de leitura
    inc %rdx                # Avança o ponteiro de escrita
    jmp copiar_expressao    # Repete o laço

fim_copiar:
    # Força o caractere NULL (\0) no final da string salva para segurança das chamadas futuras
    movb $0, (%rdx)         
    
    # Retorna 1 (Sucesso) no %rax, de acordo com a convenção de funções [6]
    mov $1, %rax
    jmp sair_salvar_funcao

nao_e_funcao:
    # Retorna 0 (Não era uma função)
    mov $0, %rax

sair_salvar_funcao:
    # Epílogo: Restaura os ponteiros da pilha e encerra [4]
    mov %rbp, %rsp
    pop %rbp
    ret


salvar_variavel:
    push %rbp
    mov %rsp, %rbp

    # r12 tem o endereço do buffer_linha (contém o que o usuário digitou)
    lea buffer_linha(%rip), %r12
    
    # Verifica se o formato digitado é de variável
    # %eax tem o byte na posicao 1 de %r12 ('=')
    movzbl 1(%r12), %eax
    cmpb $'=', %al
    jne nao_e_variavel

    # Calcula posição da variável
    # %eax vai receber o nome da variavel
    # %al vai receber o indice pela tabela ASCII
    movzbl 0(%r12), %eax    
    subb $97, %al         
    
    # transforma em 64 bytes
    movzbq %al, %rax   
    
    # %rax tem o indice onde a variavel vai ser salva
    shlq $3, %rax           

    # rdi aponta pro início da posição da variável
    lea lista_var(%rip), %rdi

    # %rdi possui o endereco pra ser salvo o valor da variavel
    addq %rax, %rdi       

    # Guarda o valor da variável na posição que o rdi aponta
    # 2(%r12) é a posicao do numero que ta no buffer

    # %rdi <- valor do buffer 2(%r12)
    # %rsi <- fmt_double
    # %rdx <- %rdi

    mov %rdi, %rdx
    lea fmt_double(%rip), %rsi
    mov 2(%r12), %rdi

    xor %rax, %rax
    call sscanf

    mov $1, %rax
    jmp sair_salvar_variavel

nao_e_variavel:
    xor %rax, %rax


sair_salvar_variavel:
    mov %rbp, %rsp
    pop %rbp
    ret



