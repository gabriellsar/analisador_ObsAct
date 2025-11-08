TARGET = analisador

CC = gcc

FLEX = flex
BISON = bison	

C_SOURCES = analisador.tab.c analisador.lex.c
H_SOURCES = analisador.tab.h

all: $(TARGET)

$(TARGET): $(C_SOURCES)
	$(CC) -o $(TARGET) $(C_SOURCES) -lfl

$(C_SOURCES) $(H_SOURCES): analisador.y
	$(BISON) -d -v analisador.y

analisador.lex.c: analisador.l $(H_SOURCES)
	$(FLEX) -o analisador.lex.c analisador.l

clean:
	rm -f $(TARGET) analisador.tab.c analisador.tab.h analisador.lex.c analisador.output *.o
