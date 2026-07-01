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