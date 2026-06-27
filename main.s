.global main
.global operando1, operador, operando2
    
.section .bss
    .comm operando1, 8
    .comm operador, 8
    .comm operando2, 8
    .comm resultado, 8
    .comm resultado_str, 8

.section .text

main:
    # Prólogo da main
    push %rbp
    mov %rsp, %rbp

    call ler_operando1
    call ler_operador

    cmpb $'!', %al
    je chamar_fatorial
    
    call ler_operando2

    mov operador(%rip), %al
    
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

    jmp finalizar


chamar_soma:
    call soma
    jmp mostra_resultado
    
chamar_subtracao:
    call subtracao
    jmp mostra_resultado
    
chamar_multiplicacao:
    call multiplicacao
    jmp mostra_resultado
    
chamar_divisao:
    call verifica_divisao

    cmp $0, %rax
    je finalizar
    
    call divisao
    jmp mostra_resultado

chamar_fatorial:
    call fatorial
    jmp mostra_resultado
    
chamar_exponenciacao:
    call exponenciacao
    jmp mostra_resultado

chamar_combinacao:
    call combinacao
    jmp mostra_resultado

mostra_resultado:
    call mostrar_resultado
    jmp finalizar

finalizar:    
    mov %rbp, %rsp
    pop %rbp
    
    mov $60, %rax     # syscall exit
    xor %rdi, %rdi      # código de retorno 0
    syscall
    