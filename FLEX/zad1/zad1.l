%{
#include <stdio.h>
int yywrap();
int yylex();
int lines = 0, words = 0;
%}

WHITE [ \t]

%%
^{WHITE}*\n*		;
{WHITE}+$			;
{WHITE}+			{printf(" "); words++;}
\n 					{printf("\n"); lines++; words++;}
%%

int yywrap() {
  return 1;
}

int main() {
  yylex();
  printf("\nNumber of lines: %d\n", lines);
  printf("Number of words: %d\n", words);
  return 0;
}