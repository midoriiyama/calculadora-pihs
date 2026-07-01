.global main
.global operando1, operador, operando2

.section .bss
    .comm operando1, 8      # double
    .comm operador, 8
    .comm operando2, 8      # double
    .comm resultado, 8      # inteiro (usado por fatorial, primo, combinacao, arranjo)
    .comm resultado_str, 8

.section .text

main:
    push %rbp
    mov %rsp, %rbp

loop:
    
    call ler_numero

    cmp $0, %rax
    je finalizar
    
    movsd %xmm0, operando1(%rip)

    call ler_operador
    movb %al, operador(%rip)

    mov operador(%rip), %al

    movsd operando1(%rip), %xmm0

    cmpb $'!', %al
    je chamar_fatorial

    cmpb $'r', %al
    je chamar_raiz

    cmpb $'p', %al
    je chamar_primo

    cmpb $'i', %al
    je chamar_inverso

    call ler_numero
    cmp $0, %rax
    je finalizar

    movsd %xmm0, operando2(%rip)

    movb operador(%rip), %al
    movsd operando1(%rip), %xmm0
    movsd operando2(%rip), %xmm1

    # Compara o operador e chama a função correspondente
    cmpb $'+', %al
    je chamar_soma

    cmpb $'-', %al
    je chamar_subtracao

    cmpb $'*', %al
    je chamar_multiplicacao

    cmpb $'/', %al
    je chamar_divisao

    cmpb $'^', %al
    je chamar_exponenciacao

    cmpb $'c', %al
    je chamar_combinacao

    cmpb $'a', %al
    je chamar_arranjo

    cmpb $'l', %al
    je chamar_logaritmo

    call erro_operador
    
    jmp finalizar


chamar_soma:
    call soma
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_subtracao:
    call subtracao
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_multiplicacao:
    call multiplicacao
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_divisao:
    # divisor (operando2) precisa estar em xmm1 para a verificação
    call verifica_divisao

    cmp $0, %rax
    je finalizar

    call divisao
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_fatorial:
    cvttsd2si operando1(%rip), %rdi   # trunca operando1 (double) para inteiro

    call verifica_fatorial

    cmp $0, %rax
    je finalizar

    call fatorial
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_exponenciacao:
    # base em xmm0 (double), expoente truncado para inteiro em rdi
    cvttsd2si operando2(%rip), %rdi

    call exponenciacao
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_combinacao:
    cvttsd2si operando1(%rip), %rdi   # n
    cvttsd2si operando2(%rip), %rsi   # p

    call verifica_ac

    cmp $0, %rax
    je finalizar

    cvttsd2si operando1(%rip), %rdi
    cvttsd2si operando2(%rip), %rsi

    call combinacao
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_arranjo:
    cvttsd2si operando1(%rip), %rdi   # n
    cvttsd2si operando2(%rip), %rsi   # k

    call verifica_ac

    cmp $0, %rax
    je finalizar

    cvttsd2si operando1(%rip), %rdi
    cvttsd2si operando2(%rip), %rsi

    call arranjo
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_raiz:
    call verifica_raiz

    cmp $0, %rax
    je finalizar

    call raiz
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_primo:
    cvttsd2si operando1(%rip), %rdi   # trunca operando1 para inteiro

    call primo
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_logaritmo:
    # xmm0 = logaritmando (operando1), xmm1 = base (operando2)
    call verifica_logaritmo

    cmp $0, %rax
    je finalizar

    movsd operando1(%rip), %xmm0
    movsd operando2(%rip), %xmm1

    call logaritmo
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_inverso:
    call verifica_inverso

    cmp $0, %rax
    je finalizar

    call inverso
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

mostra_resultado:
    call mostrar_resultado
    jmp finalizar

mostra_resultado_float:
    call mostrar_resultado_float
    jmp finalizar

finalizar:

    jmp loop

    mov %rbp, %rsp
    pop %rbp

    mov $60, %rax     # syscall exit
    xor %rdi, %rdi      # código de retorno 0
    syscall
