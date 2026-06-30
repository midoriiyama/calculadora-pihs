# # Variáveis
# DIR = executaveis
# OBJ_MAIN = $(DIR)/main.o
# OBJ_LIB = $(DIR)/lib.o
# ARQ1 = mainC.s
# ARQ2 = libC.s
# EXEC = $(DIR)/calculadora

# # Alvo padrão: cria a pasta primeiro e depois compila tudo
# all: $(DIR) $(EXEC)

# # Regra para criar a pasta (se ela não existir)
# $(DIR):
# 	mkdir -p $(DIR)

# # Regra para gerar o executável final juntando os dois arquivos e a libc
# $(EXEC): $(OBJ_MAIN) $(OBJ_LIB)
# # ld -dynamic-link /usr/bin/ld.so -lc $(OBJ_MAIN) $(OBJ_LIB) -e main -o $(EXEC)
# 	gcc $(OBJ_MAIN) $(OBJ_LIB) -o $(EXEC) -no-pie

# # Regra para compilar apenas o main.s
# $(OBJ_MAIN): $(ARQ1)
# 	as -g $(ARQ1) -o $(OBJ_MAIN)

# # Regra para compilar apenas o lib.s
# $(OBJ_LIB): $(ARQ2)
# 	as -g $(ARQ2) -o $(OBJ_LIB)

# # Limpa os arquivos gerados (apaga a pasta inteira)
# clean:
# 	rm -rf $(DIR)

# # Executa o programa
# run: all
# 	./$(EXEC)

# Variáveis para facilitar caso o nome do arquivo mude no futuro
FONTE = mainC.s
FONTE2 = libC.s
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