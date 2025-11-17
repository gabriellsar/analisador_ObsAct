#include "core.h"
#include <stdio.h>

void ligar(char* id) {
  printf("%s ligado!\n", id);
}

void desligar(char* id) {
  printf("%s desligado!\n", id);
}

void alerta(char* id, char* msg) {
  printf("%s recebeu o alerta: ", id);
  printf("%s\n", msg);
}

void alertav(char* id, char* msg, int var) {
  printf("%s recebeu o alerta: ", id);
  printf("%s %d\n", msg, var);
}
