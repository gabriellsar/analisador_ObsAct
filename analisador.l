%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "analisador.tab.h"

%}

ID_DEVICE [a-zA-Z][a-zA-Z0-9]*

%%
"dispositivos"    {return T_DISPOSITIVOS;}
"fimdispositivos" {return T_FIMDISPOSITIVOS;}

":" {return ':';}
"[" {return '[';}
"]" {return ']';}

[ \t\n]+ ;
{ID_DEVICE} {yylval.str = strdup(yytext); return ID_DEVICE;}
%%
