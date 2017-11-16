%{
#include <stdio.h>
int yywrap();
int yylex();

%}

%%
^%.*					;
\\%						{printf("%%");}
\%.*					;


%%

int yywrap() {
  return 1;
}

int main() {
  yylex();

  return 0;
}