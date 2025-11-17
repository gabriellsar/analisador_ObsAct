%{
  #include <stdio.h>
  #include <ctype.h>
  #include <stdlib.h>
  #include <string.h>

  struct DevListNode {
    char* id;
    struct DevListNode* prox;
  };

  extern int yylex();
  extern int yyparse();
  extern FILE* yyin;

  void yyerror(const char *s);
  int validar_ID_DEVICE(char* id_device);
%}

%union {
  char *str;
  unsigned int num;
  struct DevListNode* devList;
}

%token <str> ID T_OPLOGIC T_ACTION T_MSG
%token <num> NUM T_BOOL
%token T_DISPOSITIVOS T_FIMDISPOSITIVOS T_DEF T_QUANDO T_EXECUTE T_EM T_SENAO T_AND T_ALERTA T_PARA T_SETA T_DIFUNDIR

%type <num> VAL
%type <str> OBS
%type <devList> DEV_LIST_N

%%
  PROGRAM: DEV_SEC CMD_SEC
  ;
  DEV_SEC: T_DISPOSITIVOS ':' DEV_LIST T_FIMDISPOSITIVOS
  ;
  DEV_LIST: DEVICE DEV_LIST | DEVICE
  ;
  DEV_LIST_N: ID ',' DEV_LIST_N {
      if(!validar_ID_DEVICE($1)) YYABORT;

      $$ = (struct DevListNode*)malloc(sizeof(struct DevListNode));
      $$->id = $1;
      $$->prox = $3;
    } 
    | ID {
       if(!validar_ID_DEVICE($1)) YYABORT;

      $$ = (struct DevListNode*)malloc(sizeof(struct DevListNode));
      $$->id = $1;
      $$->prox = NULL;
    } 
  ;
  DEVICE:
    ID {if(!validar_ID_DEVICE($1)) YYABORT;}
    | ID '[' ID ']' {
      printf("int %s = 0;\n",$3);

      if(!validar_ID_DEVICE($1)) YYABORT;
    }
  ;
  CMD_SEC:
    {printf("\nint main(int argc, char **argv) {\n");}
    CMD_LIST
    {printf("\n\treturn 0;\n}\n");}
  ;
  CMD_LIST:';' |CMD';' CMD_LIST | CMD';'
  ;
  CMD: ATTRIB
      | OBSACT {printf("\t}\n");}
      | ACT
  ;
  ATTRIB:
    T_DEF ID '=' VAL {
      printf("\t%s = %d;\n",$2,$4);
    }
  ;
  OBSACT: 
    {printf("\n\tif (");} T_QUANDO OBS ':' {printf(") {\n");} ACT 
    OBSACT_LIST
  ;
  OBS:
    ID T_OPLOGIC VAL {
     printf("%s %s %d",$1,$2,$3);
    } 
    OBS_LIST
  ;
  ACT:
    T_EXECUTE T_ACTION T_EM ID {
      if(!validar_ID_DEVICE($4)) YYABORT;
      printf("\t\t%s(\"%s\");\n",$2,$4);
    }
    | T_ALERTA T_PARA ID ':' T_MSG {
      if(!validar_ID_DEVICE($3)) YYABORT;
      printf("\t\talerta(\"%s\",\"%s\");\n", $3, $5);
      free($5);
    }
    | T_ALERTA T_PARA ID ':' T_MSG ',' ID {
      if(!validar_ID_DEVICE($3)) YYABORT;
      printf("\t\talertav(\"%s\",\"%s\", %s);\n", $3, $5, $7);
      free($5);
    }
    | T_DIFUNDIR ':' T_MSG T_SETA '['DEV_LIST_N']' {
      struct DevListNode* atual = $6;
      struct DevListNode* temp;

      while (atual != NULL) {
        printf("\t\talerta(\"%s\",\"%s\");\n",atual->id,$3);

        temp = atual;
        atual = atual->prox;

        free(temp->id);
        free(temp);
      }
      free($3);
    }
    | T_DIFUNDIR':' T_MSG ID T_SETA '['DEV_LIST_N']' {
      if(!validar_ID_DEVICE($4)) YYABORT;

      struct DevListNode* atual = $7;
      struct DevListNode* temp;

      while (atual != NULL) {
        printf("\t\talertav(\"%s\",\"%s\", %s);\n",atual->id,$3,$4);

        temp = atual;
        atual = atual->prox;
        free(temp->id);
        free(temp);
      }
      free($3);
      free($4);
    }
  ;
  OBSACT_LIST:
    | {printf("\t} else {\n");} T_SENAO ACT
  ;
  OBS_LIST:
    | T_AND {printf(" && ");} OBS 
  ;
  VAL:
    NUM {$$ = $1;} | T_BOOL {$$ = $1;}
  ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro de parse: %s\n", s);
}

int validar_ID_DEVICE(char* id_device) {
 if (strlen(id_device) > 100) {
    yyerror("Erro em ID_DEVICE: Nome excede 100 caracteres");
    return 0;
  }
  for (int i = 0; id_device[i] != '\0'; i++) {
    if (!isalpha(id_device[i])) {
      yyerror("Erro em ID_DEVICE: Contem numeros ou caracteres invalidos");
      return 0;
    }
  }  return 1;
}

int main(void) {
    printf("#include <stdio.h>\n");
    printf("#include <stdbool.h>\n");
    printf("#include \"core.h\"\n\n");
    yyparse();
    return 0;
}
