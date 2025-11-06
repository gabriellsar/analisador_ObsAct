TARGET = analisador

CC = gcc
CFLAGS = -g -Wall

FLEX = flex
BISON = bison	

C_SOURCES = analisador.tab.c analisador.lex.c
H_SOURCES = analisador.tab.h

all: $(TARGET)L

$(TARGET): $(C_SOURCES)
	$(CC) $(CFLAGS) -o $(TARGET) $(C_SOURCES) -lfl

	$(BISON) -d -v analisador.y
	$(FLEX) -o analisador.lex.c analisador.l

clean:
	rm -f $(TARGET) analisador.tab.c analisador.tab.h analisador.lex.c analisador.output *.o
