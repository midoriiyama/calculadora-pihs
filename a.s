.section .text
.global preencher_lista

preencher_lista:
    # Vamos usar o %rcx como o nosso índice (0, 1, 2...)
    movq $0, %rcx

    # Inserir o valor 10 na posição 0
    movq $10, %rax
    movq %rax, minha_lista(,%rcx,8)   # minha_lista[0] = 10

    # Inserir o valor 20 na posição 1
    incq %rcx                         # %rcx agora é 1
    movq $20, %rax
    movq %rax, minha_lista(,%rcx,8)   # minha_lista[1] = 20

    # Inserir o valor 30 na posição 2
    incq %rcx                         # %rcx agora é 2
    movq $30, %rax
    movq %rax, minha_lista(,%rcx,8)   # minha_lista[2] = 30

    ret