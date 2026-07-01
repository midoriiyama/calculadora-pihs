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

loop_principal:

    call ler_buffer

    call salvar_funcao
    cmp $1, %rax
    je foi_salvo_como_funcao

    call salvar_variavel
    cmp $1, %rax
    je foi_salvo_como_variavel

    xor %rax, %rax
    call ler_numero

    cmp $0, %rax
    je verifica_loop
    movsd %xmm0, operando1(%rip)

    call ler_operador
    movb %al, operador(%rip)
    movsd operando1(%rip), %xmm0
    jmp verifica_operador1

dois_operando:

    call ler_numero
    cmp $0, %rax
    je verifica_loop
    movsd %xmm0, operando2(%rip)

    movb operador(%rip), %al
    movsd operando1(%rip), %xmm0
    movsd operando2(%rip), %xmm1
    jmp verifica_operador2
    
verifica_operador1:
    cmpb $'!', %al
    je chamar_fatorial

    cmpb $'r', %al
    je chamar_raiz

    cmpb $'p', %al
    je chamar_primo

    cmpb $'i', %al
    je chamar_inverso

    jmp dois_operando

verifica_operador2:
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
    jmp verifica_loop

foi_salvo_como_funcao:
    xor %rax, %rax
    movq msg_out_funcao(%rip), %rdi
    call printf
    jmp loop_principal

foi_salvo_como_variavel:
    xor %rax, %rax
    movq msg_out_variavel(%rip), %rdi
    call printf
    jmp loop_principal

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
    call verifica_zero
    cmp $0, %rax
    je verifica_loop

    movsd operando1(%rip), %xmm0
    movsd operando2(%rip), %xmm1
    
    call divisao
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_fatorial:
    # o valor para verificar precisa estar em %xmm0
    call verifica_int_nao_negativo
    cmp $0, %rax
    je verifica_loop

    cvttsd2si operando1(%rip), %rdi
    
    call fatorial
    movq %rax, resultado(%rip)
    jmp mostra_resultado
    
chamar_exponenciacao:
    # o valor para verificar precisa estar em %xmm0
    movsd operando2(%rip), %xmm0
    call verifica_int_nao_negativo
    cmp $0, %rax
    je verifica_loop
    
    movsd operando1(%rip), %xmm0
    cvttsd2si operando2(%rip), %rdi
    call exponenciacao
    
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float
    
chamar_combinacao:
    call verifica_ac
    cmp $0, %rax
    je verifica_loop

    cvttsd2si operando1(%rip), %rdi
    cvttsd2si operando2(%rip), %rsi

    call combinacao
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_arranjo:
    call verifica_ac
    cmp $0, %rax
    je verifica_loop

    cvttsd2si operando1(%rip), %rdi
    cvttsd2si operando2(%rip), %rsi

    call arranjo
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_raiz:
    call verifica_raiz
    cmp $0, %rax
    je verifica_loop

    call raiz
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_primo:
    roundsd $2, %xmm0, %xmm0
    cvttsd2si %xmm0, %rdi

    call primo
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_logaritmo:
    call verifica_logaritmo
    cmp $0, %rax
    je verifica_loop
    
    movsd operando1(%rip), %xmm0
    movsd operando2(%rip), %xmm1

    call logaritmo
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float

chamar_inverso:
    # pra verificar tem que estar no xmm1
    movsd operando1(%rip), %xmm1
    call verifica_zero
    cmp $0, %rax
    je verifica_loop

    movsd operando1(%rip), %xmm0
    call inverso
    movsd %xmm0, resultado_float(%rip)
    jmp mostra_resultado_float
    
mostra_resultado:
    call mostrar_resultado
    jmp verifica_loop

mostra_resultado_float:
    call mostrar_resultado_float
    jmp verifica_loop

verifica_loop:
    call continuar
    cmp $1, %rax
    je loop_principal
    jmp finalizar

finalizar:
    mov %rbp, %rsp
    pop %rbp

    mov $60, %rax
    xor %rdi, %rdi
    syscall
