# Vamos assumir que:
# %rcx = índice onde queremos guardar (ex: 0, 1, 2...)
# %rdi = o ID que queremos guardar (inteiro)
# %xmm0 = o Resultado que queremos guardar (double)

gravar_tupla:
    # 1. Calcula a posição base da tupla: rax = rcx * 16
    movq %rcx, %rax
    shl $4, %rax        

    # 2. Guarda o ID no primeiro campo (Offset 0)
    movq %rdi, historico(%rax)

    # 3. Guarda o Resultado no segundo campo (Offset 8)
    movsd %xmm0, historico+8(%rax)

    ret

