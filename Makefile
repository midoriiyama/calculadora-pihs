# Variáveis
DIR = executaveis
OBJ_MAIN = $(DIR)/main.o
OBJ_LIB = $(DIR)/lib.o
ARQ1 = main2.s
ARQ2 = lib2.s
EXEC = $(DIR)/calculadora
# Alvo padrão: cria a pasta primeiro e depois compila tudo
all: $(DIR) $(EXEC)
# Regra para criar a pasta (se ela não existir)
$(DIR):
	mkdir -p $(DIR)
# Regra para gerar o executável final juntando os dois arquivos e a libc
$(EXEC): $(OBJ_MAIN) $(OBJ_LIB)
# ld -dynamic-link /usr/bin/ld.so -lc $(OBJ_MAIN) $(OBJ_LIB) -e main -o $(EXEC)
	gcc $(OBJ_MAIN) $(OBJ_LIB) -o $(EXEC) -no-pie
# Regra para compilar apenas o main.s
$(OBJ_MAIN): $(ARQ1)
	as -g $(ARQ1) -o $(OBJ_MAIN)
# Regra para compilar apenas o lib.s
$(OBJ_LIB): $(ARQ2)
	as -g $(ARQ2) -o $(OBJ_LIB)
# Limpa os arquivos gerados (apaga a pasta inteira)
clean:
	rm -rf $(DIR)
# Executa o programa
run: all
	./$(EXEC)