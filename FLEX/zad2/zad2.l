%{
#include <stdio.h>
int yywrap();
int yylex();
int doc = 1;
%}

WHITE [ \t]
%x IN_STRING
%x MULTI
%x DOC_MULTI
%x DOC
%x SINGLE

%%
\"											{BEGIN(IN_STRING); printf("\"");}
<IN_STRING>{
	\"										{BEGIN(INITIAL); printf("\"");}
	\\\"									{printf("\\\"");}
}

\/\*\*\/                                    ;

\/\*\*										{BEGIN(DOC_MULTI);if(doc == 1) printf("%s", yytext);}
<DOC_MULTI>{
    \/                                      {BEGIN(INITIAL);if(doc == 1) printf("%s", yytext);}
	\*\/									{BEGIN(INITIAL); if(doc == 1) printf("%s", yytext);}
	(\n|.)									{if(doc == 1) printf("%s", yytext);}
}
{WHITE}*"\/\/\/".*\\{WHITE}*\n				{BEGIN(DOC); if(doc == 1) printf("%s", yytext);}
^{WHITE}*"\/\/\/".*\n						{if(doc == 1) printf("%s", yytext);}
{WHITE}*"\/\/\/".*\n						{if(doc == 1) printf("%s", yytext);}

<DOC>{
	{WHITE}*.*\\{WHITE}*\n					{if(doc == 1) printf("%s", yytext);}
	\n										{BEGIN(INITIAL); printf("\n");}
	.										{if(doc == 1) printf("%s", yytext);}
}

\/\*										{BEGIN(MULTI);}
<MULTI>{
	\*\/									{BEGIN(INITIAL);}
	(\n|.)									;
}

{WHITE}*"\/\/".*\\{WHITE}*\n				{BEGIN(SINGLE); printf("\n");}
^{WHITE}*"\/\/".*\n							;
{WHITE}*"\/\/".*\n							{printf("\n");}

<SINGLE>{
	{WHITE}*.*\\{WHITE}*\n					;
	\n										{BEGIN(INITIAL); printf("\n");}
	.										;
}

%%

int yywrap() {
  return 1;
}

int main() {
  yylex();
  return 0;
}
