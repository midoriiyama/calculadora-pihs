.section .text
.global

.section .data
    msg_in_op1: .asciz "\Digite o primeiro operando: "
    msg_in_operador: .asciz "Digite o operador: " 
    msg_in_op2: .asciz "Digite o segundo operando: "
    msg_resultado: .asciz "O resultado é: "

    msg_operando_invalido: .asciz "O operando é inválido.\n"
    msg_operador_invalido: .asciz "O operador é inválido.\n"

    msg_erro_zero: .asciz "Erro: Não é possível realizar a operação para 0.\n"
    msg_erro_int: .asciz "Erro: Operando precisa ser um inteiro não negativo.\n"
    msg_erro_neg: .asciz "Erro: Não é possível realizar a operação para valor negativo.\n"
    msg_erro_ac: .asciz "Erro: O valor do primeiro operando deve ser maior ou igual ao segundo.\n"
    msg_erro_op_invalido: .asciz "Erro: Operador inválido.\n"
    msg_erro_log1: .asciz "Erro: Logaritmando deve ser maior que 0.\n"
    msg_erro_log2: .asciz "Erro: A base deve ser um número diferente de 1.\n"

    fmt_in:	.asciz "%lld"
    fmt_op: .asciz " %c"
    fmt_out_int: .asciz "%lld\n"
    fmt_out_double: .asciz "%lf"

.section .bss

.section .text

ler_operando1:
ler_operando2:
verifica_erro_operando:
fim_ler_operando:

limpar_buffer:
loop_limpar_buffer:
fim_limpar_buffer:

ler_operador:
verifica_erro_operador:

mostrar_resultado: # ver se tem como transformar os dois em um so
mostrar_resultado_float:

soma:

subtracao:

multiplicacao:

divisao:

exponenciacao:
loop_exponenciacao:
fim_exponenciacao:

combinacao:

arranjo:

logaritmo:

fatorial:
loop_fatorial:
fim_fatorial:

inverso:

raiz:

primo: # falta arrumar: primo(1) = 2 
loop_primo:
sucessor:
fim_primo:

verifica_zero: # serve para divisao, e inverso (lembrar de trocar para o xmm1)

verifica_int_nao_negativo: # serve para fatorial, e uma parte do ac

verifica_menor_ac: # para a outra parte do ac

# Erros únicos:
# nao_pode_logaritmo1: "Logaritmando deve ser maior que 0"
# nao_pode_logaritmo2: "Base deve ser um número diferente de 1"
verifica_logaritmo:
nao_pode_logaritmo1:
nao_pode_logaritmo2:
fim_verifica_logaritmo:

# Erro único:
# nao_pode_raiz: "Não é possível realizar operação para valor negativo"
verifica_raiz:
nao_pode_raiz:
fim_verifica_raiz:


