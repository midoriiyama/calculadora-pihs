.section .text
.global soma
.global subtracao
.global multiplicacao
.global divisao
.global exponenciacao
.global combinacao
.global arranjo
.global logaritmo
.global fatorial
.global inverso
.global raiz
.global primo

soma:
    movq operando1, %rax
    addq %rax, operando2
    ret

subtracao:
    movq operando1, %rax
    subq %rax, operando2
    ret

multiplicacao:
    mul %rbx

    # 1. Preparando a divisão por 10
    movq $0, %rdx      # A instrução div exige que o rdx seja zerado antes de começar
    movq $10, %rcx     # Colocamos o divisor (10) no rcx
    
    # 2. Executando a divisão
    div %rcx           # O processador divide %rax por %rcx.
                       # O quociente (dezena) vai para o %rax [2].
                       # O resto (unidade) vai para o %rdx [2].

    # 3. Convertendo de volta para ASCII (Número -> Texto)
    addq $48, %rax     # Transforma a dezena em caractere
    addq $48, %rdx     # Transforma a unidade em caractere

    # 4. Movendo os caracteres para a memória (byte a byte)
    movb %al, resultado_str(%rip)       # Salva o 1º dígito (dezena) na posição 0
    movb %dl, resultado_str+1(%rip)     # Salva o 2º dígito (unidade) na posição 1
    movb $10, resultado_str+2(%rip)     # Salva o 'Enter' (código ASCII 10) na posição 2
    
    ret
    
divisao:
    movq operando1, %rax
    divq operando2
    ret

exponenciacao:
    # 
combinacao:
arranjo:
logaritmo:

fatorial:
    # movq operando1, %rax
    # movq $1, %rcx

loop_fatorial:
    # cmpq %rcx, %rax
    # je fim_fatorial
    # mulq %rcx, %rax
    # incq %rcx
    # jmp loop_fatorial

fim_fatorial:
    ret

inverso:
raiz:
primo:


