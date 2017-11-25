%{
	#include <stdio.h>
	#include <string.h>
	#define YYDEBUG 1
	#define BUFF_SIZE 20
	#define OUT_SIZE 150
	int yylex();
	void yyerror(char const *);
	void clear_buffer();
	void negate_value(long int neg_val);
	long int value_in_base(long int a);
	long int add(long int a, long int b);
	long int subtract(long int a, long int b);
	long int multiply(long int a, long int b);
	long int divide(long int a, long int b);
	long int power(long int x, long int n);
	long int modulo(long int a, long int b);

	int error = 0;
	char buff[20];
	char out[150];	
%}

%token NUM
%token RBR LBR
%left ADD SUB
%left MUL DIV MOD
%right POW
%precedence NEG
%token UND

%%

input:
	%empty
|	input line
;

line:
 '\n'
| exp '\n'	{
	if(!error)
		printf("RPN: %s\nResult: %li\n\n\n", out, $1);
	error = 0;
	clear_buffer();
	}
| exp error {yyerror("Something went wrong.....\n");}
;

exp:
  NUM				{long int n = value_in_base($1); $$ = n; sprintf(buff, "%li ", n); strcat(out, buff);}
| exp ADD exp		{$$ = add($1, $3); strcat(out, "+ ");} 
| exp SUB exp		{$$ = subtract($1, $3); strcat(out, "- ");} 
| exp MUL exp		{$$ = multiply($1, $3); strcat(out, "* ");} 
| exp POW exp		{$$ = power($1, $3); strcat(out, "^ ");}
| LBR exp RBR		{$$ = $2;}
| SUB exp %prec NEG {negate_value($2); $$ = subtract(0, $2); }

| exp DIV exp		{if($3 == 0) {error = 1; yyerror("Error: dividing by 0\n");}
					else {$$ = divide($1, $3); strcat(out,  "/ ");}
					}
| exp MOD exp		{if($3 == 0) {error = 1; yyerror("Error: dividing mod by 0\n");}
					else {$$ = modulo($1, $3); strcat(out, "% ");}
					}
| UND				{error = 1;}

%%

#include <stdio.h>
#include <ctype.h>
#include "calc_funcs.h"

void yyerror(char const *s) {
	fprintf(stderr, "%s\n", s);
	clear_buffer();
}

void negate_value(long int val) {
	//go through 'out' from the end until reach space, erase; '-2' because need to skip also the last spacebar
	int out_len = strlen(out) - 2;
	while(out_len >= 0) {
		if(out[out_len] == ' ') break;
		out[out_len] = 0;
		out_len--;
	}

	char number[BUFF_SIZE];
	long int new_value = value_in_base(-val);

	sprintf(number, "%li ", new_value);
	strcat(out, number);
}

void clear_buffer() {
	for(int i = 0; i < BUFF_SIZE; i++) 
		buff[i] = 0;
	for(int i = 0; i < OUT_SIZE; i++)
		out[i] = 0;
}

void main(int argc, char** argv) {
	yyparse();
}