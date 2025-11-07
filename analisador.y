%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>

  extern int yylex();
  extern int yyparse();
  extern FILE* yyin;

  void yyerror(const char *s);
%}

%union {
  char *str;
}

%token <str> ID_DEVICE
%token T_DISPOSITIVOS T_FIMDISPOSITIVOS

%%
  PROGRAM:
    DEV_SEC
  ;
  DEV_SEC:
    T_DISPOSITIVOS ':' DEV_LIST T_FIMDISPOSITIVOS
  ;
  DEV_LIST:
    DEVICE DEV_LIST
    | DEVICE
  ;
  DEVICE:
    ID_DEVICE
    | ID_DEVICE '[' ID_DEVICE ']' {
      printf("int %s = 0;\n",$3);
    
      free($1);
      free($3);
    }
  ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro de parse: %s\n", s);
}

int main(void) {
    printf("#include <stdio.h>\n");
    printf("#include \"core.h\"\n\n");
    yyparse();
    return 0;
}
