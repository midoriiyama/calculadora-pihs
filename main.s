.global _start
.global operando1
.global operador
.global operando2

.section .data
    # Mensagens para entrada e saída
    msg_in_op1: .ascii "Digite o primeiro operando: "
    len_msg_in_op1 = . - msg_in_op1

    msg_in_operador: .ascii "Digite o operador: " 
    len_msg_in_operador = . - msg_in_operador

    msg_in_op2: .ascii "Digite o segundo operando: "
    len_msg_in_op2 = . - msg_in_op2

    msg_resultado: .ascii "O resultado é: "
    len_msg_resultado = . - msg_resultado

    # Mensagens de erro
    msg_erro_zero: .ascii "Erro: Não é possível realizar a operação para 0.\n"
    msg_erro_int: .ascii "Erro: Operando precisa ser um inteiro não negativo.\n"
    msg_erro_ac: .ascii "Erro: O valor do primeiro operando deve ser maior ou igual ao segundo.\n"
    msg_erro_op_invalido: .ascii "Erro: Operador inválido.\n"
    msg_erro_log1: .ascii "Erro: Logaritmando deve ser maior que 0.\n"
    msg_erro_log2: .ascii "Erro: A base deve ser um número diferente de 1.\n"

    # write
    
.section .rodata
    
.section .bss
    # Entradas
    # 1 byte = 1 caractere ascii
    # 4 bytes = .long
    .comm operando1, 4
    .comm operador, 2
    .comm operando2, 4
    .comm resultado, 4
    .comm resultado_str, 3

.section .text

_start:

    # Print operando1
    movq $1, %rax
    movq $1, %rdi
    leaq msg_in_op1(%rip), %rsi
    movq $len_msg_in_op1, %rdx
    syscall

    # Read operando 1
    movq $0, %rax                  # sys_read (0)
    movq $1, %rdi                  # stdout
    leaq operando1(%rip), %rsi     # Endereço da variável
    movq $4, %rdx                  # Tamanho máximo a ler
    syscall

    # Print operador
    movq $1, %rax
    movq $1, %rdi
    leaq msg_in_operador(%rip), %rsi
    movq $len_msg_in_operador, %rdx
    syscall

    # Read operador
    movq $0, %rax                  # sys_read (0)
    movq $1, %rdi                  # stdout
    leaq operador(%rip), %rsi     # Endereço da variável
    movq $2, %rdx                  # Tamanho máximo a ler
    syscall

    # Print operando2
    movq $1, %rax
    movq $1, %rdi
    leaq msg_in_op2(%rip), %rsi
    movq $len_msg_in_op2, %rdx
    syscall

    # Read operando 2
    movq $0, %rax                  # sys_read (0)
    movq $1, %rdi                  # stdout
    leaq operando2(%rip), %rsi     # Endereço da variável
    movq $4, %rdx                  # Tamanho máximo a ler
    syscall

    cmpb $'+', operador
    je chamar_soma
    
    cmpb $'-', operador
    je chamar_subtracao

    cmpb $'*', operador
    je chamar_multiplicacao


chamar_soma:
    call soma
    jmp finalizar
    
chamar_subtracao:
    call subtracao
    jmp finalizar
    
chamar_multiplicacao:
    # Exemplo limpando os registradores e convertendo
    xor %rax, %rax
    xor %rbx, %rbx
    
    movb operando1(%rip), %al    # Pega só o primeiro byte do operando 1 (o '3')
    subb $48, %al                # %al agora vale o número 3

    movb operando2(%rip), %bl    # Pega só o primeiro byte do operando 2 (o '4')
    subb $48, %bl                # %bl agora vale o número 4

    call multiplicacao
    jmp finalizar
    
finalizar:    
    # Print msg resultado
    movq $1, %rax
    movq $1, %rdi
    leaq msg_resultado(%rip), %rsi
    movq $len_msg_resultado, %rdx
    syscall

    # Print resultado
    movq $1, %rax
    movq $1, %rdi
    leaq resultado_str(%rip), %rsi
    movq $3, %rdx                     # Imprime os 3 bytes
    syscall

    movq $60, %rax
    xor %rdi, %rdi
    syscall