#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void ligar(char* id) {
  printf("%s ligado!\n", id);
}

void desligar(char* id) {
  printf("%s desligado!\n", id);
}

void alerta(char* id, char* msg) {
  printf("%s recebeu o alerta:\n", id);
  printf("%s\n", msg);
}

void alerta(char* id, char* msg, char** var) {
  printf("%s recebeu o alerta:\n", id);
  printf("%s %s\n", msg, var);
}
