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
    push %rbp
    mov %rsp, %rbp

loop:
    call ler_numero                 
    movsd %xmm0, operando1(%rip)

    call ler_operador      
    movq %rax, operador(%rip)         
    movb %al, operador(%rip)        


    mov operador(%rip), %al

    movq operando1(%rip), %rdi

    cmpb $'!', %al
    je chamar_fatorial

    cmpb $'r', %al
    je chamar_raiz
    
    cmpb $'p', %al
    je chamar_primo

    cmpb $'i', %al
    je chamar_inverso

    call ler_numero    
    movq %rax, operando2(%rip) 

    movb operador(%rip), %al
    movq operando1(%rip), %rdi             
    movq operando2(%rip), %rsi
    

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

    jmp finalizar

chamar_soma:
    call soma
    movq %rax, resultado(%rip)
    jmp mostra_resultado
    
chamar_subtracao:
    call subtracao
    movq %rax, resultado(%rip)
    jmp mostra_resultado
    
chamar_multiplicacao:
    call multiplicacao
    movq %rax, resultado(%rip)
    jmp mostra_resultado
    
chamar_divisao:
    call verifica_divisao

    cmp $0, %rax
    je finalizar
    
    call divisao
    movsd %xmm0, resultado_float(%rip)
    call mostrar_resultado_float
    jmp finalizar

chamar_fatorial:
    call verifica_fatorial

    cmp $0, %rax
    je finalizar

    call fatorial
    movq %rax, resultado(%rip)
    jmp mostra_resultado
    
chamar_exponenciacao:
    call exponenciacao
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_combinacao:
    call verifica_ac

    cmp $0, %rax
    je finalizar

    call combinacao
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_arranjo:
    call verifica_ac

    cmp $0, %rax
    je finalizar

    call arranjo
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_raiz:
    call verifica_raiz

    cmp $0, %rax
    je finalizar
    
    call raiz
    movsd %xmm0, resultado_float(%rip)
    call mostrar_resultado_float
    jmp finalizar

chamar_primo:
    call primo
    movq %rax, resultado(%rip)
    jmp mostra_resultado

chamar_logaritmo:
    call verifica_logaritmo

    cmp $0, %rax
    je finalizar

    movq operando1(%rip), %rdi
    movq operando2(%rip), %rsi

    call logaritmo
    movsd %xmm0, resultado_float(%rip)
    call mostra_resultado_float
    jmp finalizar

chamar_inverso:
    call verifica_inverso

    cmp $0, %rax
    je finalizar

    call inverso
    movsd %xmm0, resultado_float(%rip)
    call mostrar_resultado_float
    jmp finalizar

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
    