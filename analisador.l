%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>

#define YY_DECL int yylex()

#include "analisador.tab.h"

void yyerror(const char *s);

%}

ID    [a-zA-Z][a-zA-Z0-9]*
NUM   [0-9]+
MSG   \"[^\"\n]*\"

%%
"dispositivos"    {return T_DISPOSITIVOS;}
"fimdispositivos" {return T_FIMDISPOSITIVOS;}
"def"             {return T_DEF;}
"quando"          {return T_QUANDO;}
"execute"         {return T_EXECUTE;}
"em"              {return T_EM;}
"senao"           {return T_SENAO;}
"and"             {return T_AND;}
"alerta"          {return T_ALERTA;}
"para"            {return T_PARA;}
"->"              {return T_SETA;}
"difundir"        {return T_DIFUNDIR;}

"True"            {yylval.num = 1; return T_BOOL;}
"False"           {yylval.num = 0; return T_BOOL;}
"ligar"           {yylval.str = strdup(yytext); return T_ACTION;}
"desligar"        {yylval.str = strdup(yytext); return T_ACTION;}
  
":" {return ':';}
";" {return ';';}
"," {return ',';}
"[" {return '[';}
"]" {return ']';}
"=" {return '=';}

">"  { yylval.str = strdup(yytext); return T_OPLOGIC; }
"<"  { yylval.str = strdup(yytext); return T_OPLOGIC; }
">=" { yylval.str = strdup(yytext); return T_OPLOGIC; }
"<=" { yylval.str = strdup(yytext); return T_OPLOGIC; }
"==" { yylval.str = strdup(yytext); return T_OPLOGIC; }
"!=" { yylval.str = strdup(yytext); return T_OPLOGIC; }

[ \t\n]+ ;
{ID}    {yylval.str = strdup(yytext); return ID;}
{NUM}   {yylval.num = atoi(yytext);   return NUM;}
{MSG}   {
  if (yyleng - 2 > 100) {
    yyerror("Erro: Mensagem (MSG) excede 100 caracteres");
  }else {
    yytext[yyleng-1] = '\0';
    yylval.str = strdup(yytext+1);
    return T_MSG;
  }
}
%%
