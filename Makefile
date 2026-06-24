# Variáveis para facilitar caso o nome do arquivo mude no futuro
FONTE = main.s
FONTE2 = lib.s
OBJETO = main.o
OBJETO2 = lib.o
EXEC = calculadora

# Alvo padrão: faz a montagem e a ligação
all: ${FONTE} ${FONTE2}
	as ${FONTE} -o ${OBJETO}
	as ${FONTE2} -o ${OBJETO2}
	ld ${OBJETO} ${OBJETO2} -o ${EXEC}

# Alvo para executar o programa automaticamente
run: all
	./${EXEC}

# Alvo para limpar os arquivos gerados (.o e executável)
clean:
	rm ${OBJETO} ${OBJETO2} ${EXEC}