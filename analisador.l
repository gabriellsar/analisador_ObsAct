%{

  


%}

  NUM       [0-9]+
  ID_OBS    [a-zA-Z]+
  ID_DEVICE [a-zA-Z][a-zA-Z0-9]*
  MSG       \"[^\"]"\

%%

  
  [ \t\n]+ /* eat up whitespaces */

%%
