.section .data
    # Mensagens para entrada e saída
    msg_in_op1: .asciz "Digite o primeiro operando: "
    msg_in_operador: .asciz "Digite o operador: " 
    msg_in_op2: .asciz "Digite o segundo operando: "
    msg_resultado: .asciz "O resultado é: "

    # Mensagens de erro
    msg_erro_zero: .asciz "Erro: Não é possível realizar a operação para 0.\n"
    msg_erro_int: .asciz "Erro: Operando precisa ser um inteiro não negativo.\n"
    msg_erro_ac: .asciz "Erro: O valor do primeiro operando deve ser maior ou igual ao segundo.\n"
    msg_erro_op_invalido: .asciz "Erro: Operador inválido.\n"
    msg_erro_log1: .asciz "Erro: Logaritmando deve ser maior que 0.\n"
    msg_erro_log2: .asciz "Erro: A base deve ser um número diferente de 1.\n"

    # Entradas
    operador1: 
    operando: 
    operador2:
    
.section .bss

.section .text
.global _start

_start: