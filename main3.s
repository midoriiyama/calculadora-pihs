.global main
.global operando1, operador, operando2

.section .bss
    .comm operando1, 8
    .comm operador, 8
    .comm operando2, 8
    .comm resultado, 8
    .comm buffer_linha, 256

.section .text

main:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp

    .loop_principal:

    call ler_buffer

    call salvar_funcao
    cmp $1, %rax
    je .foi_salvo_como_funcao

    call salvar_variavel
    cmp $1, %rax
    je .foi_salvo_como_variavel

    call salvar_variavel
    cmp $1, %rax
    je .foi_salvo_como_variavel

    # %r12 vai ser o nosso "dedo" apontando e percorrendo o texto
    lea buffer_linha(%rip), %r12 

    
     

    call avaliar_expressao

    # Quando retornar do 'call', a conta toda foi resolvida e está no %xmm0!
    movsd %xmm0, resultado(%rip)
    call mostrar_resultado_float
    jmp .verifica_loop

# ====================================================================
# AVALIADOR RECURSIVO DE EXPRESSÕES (O "CÉREBRO" DA CALCULADORA)
# ====================================================================
avaliar_expressao:
    push %rbp
    mov %rsp, %rbp

    # --- O INTERCEPTADOR: É UMA CHAMADA DE FUNÇÃO? (Ex: f(3)) ---
    movzbl (%r12), %eax            # Lê o 1º caractere
    cmpb $'a', %al
    jl .leitura_normal             # Não é letra, segue a vida
    cmpb $'z', %al
    jg .leitura_normal             # Não é letra, segue a vida

    movzbl 1(%r12), %ecx           # Olha o 2º caractere (sem avançar %r12)
    cmpb $'(', %cl
    jne .leitura_normal            # Se não for '(', é conta normal (ex: a+5)

    # --- É UMA FUNÇÃO! VAMOS USAR A PILHA (STACK) ---
    
    # 1. Encontra a string salva da fórmula (ex: "x+3") no lista_fun
    subb $97, %al
    movzbq %al, %rax
    shlq $5, %rax                  # Multiplica índice por 32 (tamanho da string)
    lea lista_fun(%rip), %r13
    addq %rax, %r13                # %r13 agora aponta para a fórmula na memória

    # 2. Lê o número de dentro do parêntese
    addq $2, %r12                  # Pula o "f("
    xor %rax, %rax
    call ler_numero                # Nosso sscanf otimizado lê o número e deixa no %xmm0

    # 3. Faz o Backup do 'x' antigo na pilha
    lea lista_var(%rip), %rdi
    movq 184(%rdi), %r14           # Pega os 8 bytes da gaveta do 'x' (deslocamento 184)
    push %r14                      # Guarda em segurança no topo da pilha

    # 4. Injeta o novo valor (do %xmm0) na variável 'x'
    movsd %xmm0, 184(%rdi)

    # 5. Backup do ponteiro da string principal
    push %r12                      # Empilha onde paramos de ler na string principal

    # 6. Aponta o %r12 para a fórmula e resolve!
    mov %r13, %r12                 # Muda o ponteiro para o texto "x+3"
    call avaliar_expressao         # RECURSÃO! Chama a si mesma para resolver a função!

    # 7. Restaura o estado original (Desempilha na ordem inversa)
    pop %r12                       # Recupera o ponteiro da string original
    addq $1, %r12                  # Pula o caractere de fechamento ')'

    pop %r14                       # Recupera o valor do 'x' antigo
    lea lista_var(%rip), %rdi
    movq %r14, 184(%rdi)           # Devolve pra gaveta silenciosamente

    jmp .fim_avaliar            # Terminou a função! Vai embora com o resultado em %xmm0!

# ====================================================================
# FLUXO DA CALCULADORA NORMAL
# ====================================================================
.leitura_normal:

.ler_primeiro_operando:
    movzbl (%r12), %eax            # Lê o 1º caractere
    cmpb $'a', %al
    jl .primeiro_e_numero
    cmpb $'z', %al
    jg .primeiro_e_numero

    # --- É VARIÁVEL (Ex: "a") ---
    subb $97, %al
    movzbq %al, %rax
    shlq $3, %rax                  # Multiplica índice por 8

    lea lista_var(%rip), %rdi
    addq %rax, %rdi                # Acha a gaveta da variável
    movsd (%rdi), %xmm0

    movsd %xmm0, operando1(%rip)   # Salva o valor em operando1

    inc %r12                       # PULA a letra!
    jmp .ler_o_operador

.primeiro_e_numero:
    xor %rax, %rax
    call ler_numero                # Chama a nova função com sscanf
    movsd %xmm0, operando1(%rip)

.ler_o_operador:
    movzbl (%r12), %eax            # Lê o Operador (+, -, *, !)
    movb %al, operador(%rip)
    inc %r12                       # CRUCIAL: Pula o operador!

    # Se for fatorial (!), não existe 2º operando, pula direto pra conta!
    cmpb $'!', %al
    je .chamar_fatorial

    cmpb $'r', %al
    je .chamar_raiz

    cmpb $'p', %al
    je .chamar_primo

    cmpb $'i', %al
    je .chamar_inverso

.ler_segundo_operando:
    movzbl (%r12), %eax            # Lê o 1º caractere após o operador
    cmpb $'a', %al
    jl .segundo_e_numero
    cmpb $'z', %al
    jg .segundo_e_numero

    # --- É VARIÁVEL (Ex: "a") ---
    subb $97, %al
    movzbq %al, %rax
    shlq $3, %rax
    lea lista_var(%rip), %rdi
    addq %rax, %rdi
    movsd (%rdi), %xmm0
    movsd %xmm0, operando2(%rip)   # Salva o valor em operando2
    jmp .fazer_a_conta             # Tudo lido, vai pra matemática!

.segundo_e_numero:
    xor %rax, %rax
    call ler_numero
    movsd %xmm0, operando2(%rip)

.fazer_a_conta:
    mov operador(%rip), %al
    movsd operando1(%rip), %xmm0
    movsd operando2(%rip), %xmm1
    
    # ==============================================================
    # AQUI VOCÊ VERIFICA O SINAL E CHAMA A MATEMÁTICA
    # ==============================================================
    cmpb $'+', %al
    je .chamar_soma

    cmpb $'-', %al
    je .chamar_subtracao

    cmpb $'*', %al
    je .chamar_multiplicacao

    cmpb $'/', %al
    je .chamar_divisao

    cmpb $'^', %al
    je .chamar_exponenciacao

    cmpb $'c', %al
    je .chamar_combinacao

    cmpb $'a', %al
    je .chamar_arranjo

    cmpb $'l', %al
    je .chamar_logaritmo
    
    call erro_operador
    jmp .verifica_loop


    .foi_salvo_como_funcao:
    xor %rax, %rax
    lea msg_out_funcao(%rip), %rdi
    call printf
    jmp .loop_principal

    .foi_salvo_como_variavel:
    xor %rax, %rax
    lea msg_out_variavel(%rip), %rdi
    call printf
    jmp .loop_principal

    .chamar_soma:
    call soma
    movsd %xmm0, resultado_float(%rip)
    jmp .mostra_resultado_float

    .chamar_subtracao:
    call subtracao
    movsd %xmm0, resultado_float(%rip)
    jmp .mostra_resultado_float

    .chamar_multiplicacao:
    call multiplicacao
    movsd %xmm0, resultado_float(%rip)
    jmp .mostra_resultado_float

    .chamar_divisao:
    call verifica_zero
    cmp $0, %rax
    je .verifica_loop

    movsd operando1(%rip), %xmm0
    movsd operando2(%rip), %xmm1
    
    call divisao
    movsd %xmm0, resultado_float(%rip)
    jmp .mostra_resultado_float

    .chamar_fatorial:
    # o valor para verificar precisa estar em %xmm0
    call verifica_int_nao_negativo
    cmp $0, %rax
    je .verifica_loop

    cvttsd2si operando1(%rip), %rdi
    
    call fatorial
    movq %rax, resultado(%rip)
    jmp .mostra_resultado
    
    .chamar_exponenciacao:
    # o valor para verificar precisa estar em %xmm0
    movsd operando2(%rip), %xmm0
    call verifica_int_nao_negativo
    cmp $0, %rax
    je .verifica_loop
    
    movsd operando1(%rip), %xmm0
    cvttsd2si operando2(%rip), %rdi
    call exponenciacao
    
    movsd %xmm0, resultado_float(%rip)
    jmp .mostra_resultado_float
    
    .chamar_combinacao:
    call verifica_ac
    cmp $0, %rax
    je .verifica_loop

    cvttsd2si operando1(%rip), %rdi
    cvttsd2si operando2(%rip), %rsi

    call combinacao
    movq %rax, resultado(%rip)
    jmp .mostra_resultado

    .chamar_arranjo:
    call verifica_ac
    cmp $0, %rax
    je .verifica_loop

    cvttsd2si operando1(%rip), %rdi
    cvttsd2si operando2(%rip), %rsi

    call arranjo
    movq %rax, resultado(%rip)
    jmp .mostra_resultado

    .chamar_raiz:
    call verifica_raiz
    cmp $0, %rax
    je .verifica_loop

    call raiz
    movsd %xmm0, resultado_float(%rip)
    jmp .mostra_resultado_float

    .chamar_primo:
    roundsd $2, %xmm0, %xmm0
    cvttsd2si %xmm0, %rdi

    call primo
    movq %rax, resultado(%rip)
    jmp .mostra_resultado

    .chamar_logaritmo:
    call verifica_logaritmo
    cmp $0, %rax
    je .verifica_loop
    
    movsd operando1(%rip), %xmm0
    movsd operando2(%rip), %xmm1

    call logaritmo
    movsd %xmm0, resultado_float(%rip)
    jmp .mostra_resultado_float

    .chamar_inverso:
    # pra verificar tem que estar no xmm1
    movsd operando1(%rip), %xmm1
    call verifica_zero
    cmp $0, %rax
    je .verifica_loop

    movsd operando1(%rip), %xmm0
    call inverso
    movsd %xmm0, resultado_float(%rip)
    jmp .mostra_resultado_float
    
    .mostra_resultado:
    call mostrar_resultado
    jmp .verifica_loop

    .mostra_resultado_float:
    call mostrar_resultado_float
    jmp .verifica_loop

    .verifica_loop:
    call continuar
    cmp $1, %rax
    je .loop_principal
    jmp .finalizar

    # --- FINALIZADOR DO AVALIADOR ---
    .fim_avaliar:
        mov %rbp, %rsp                 # Restaura a pilha
        pop %rbp                       
        ret 

    .finalizar:
    mov %rbp, %rsp
    pop %rbp

    mov $60, %rax
    xor %rdi, %rdi
    syscall
