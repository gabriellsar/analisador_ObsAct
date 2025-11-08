TARGET = analisador

CC = gcc

FLEX = flex
BISON = bison	

C_SOURCES = analisador.tab.c lex.yy.c
H_SOURCES = analisador.tab.h

all: $(TARGET)

$(TARGET): $(C_SOURCES)
	$(CC) -o $(TARGET) $(C_SOURCES) -lm

analisador.tab.c analisador.tab.h: analisador.y
	$(BISON) -d analisador.y

lex.yy.c: analisador.l $(H_SOURCES)
	$(FLEX) analisador.l

clean:
	rm -f $(TARGET) analisador.tab.c analisador.tab.h lex.yy.c analisador.output *.output
	rm -f testes/saidas/*.c
	rm -f testes/saidas/exec/*

TEST_FILES = $(wildcard testes/*.obsact)

test: $(TARGET)
	@for f in $(TEST_FILES); do \
		base_name=$$(basename "$$f" .obsact); \
		output_file="testes/saidas/$$base_name.c"; \
		./$(TARGET) < $$f > $$output_file; \
	done
	@echo " ---- TESTES CONCLUIDOS ----"

run: 
	@./run.sh
