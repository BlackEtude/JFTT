%{
#include <stdio.h>
#include "calc_bison.h"
%}

%x comment
%%

"#"					BEGIN(comment);
<comment>\\\n 		;
<comment>\n			BEGIN(INITIAL);
<comment>[^\n]|[^\\]	;

"+"					{return ADD;}
"-"					{return SUB;}
"*"					{return MUL;}
"/"					{return DIV;}
"^"					{return POW;}
"%"					{return MOD;}
"(" 				{return LBR;}
")"					{return RBR;}
"\\\n"				;
[0-9]+				{yylval = atoi(yytext); return NUM;}
\n					{printf("\n"); return '\n';}
[\t ]*				;
.             		{printf("Unrecognized character %c\n", *yytext); return UND;}

%%