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
	void showOut();
	void add_to_out(char *buff);
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
  NUM				{long int n = value_in_base($1); $$ = n; sprintf(buff, "%li ", n); add_to_out(buff);}
| exp ADD exp		{$$ = add($1, $3); add_to_out("+ ");} 
| exp SUB exp		{$$ = subtract($1, $3); add_to_out("- ");} 
| exp MUL exp		{$$ = multiply($1, $3); add_to_out("* ");} 
| exp POW exp		{$$ = power($1, $3); add_to_out("^ ");}
| LBR exp RBR		{$$ = $2;}
| SUB exp %prec NEG { $$ = subtract(0, $2); negate_value(-$2);}

| exp DIV exp		{if($3 == 0) {error = 1; yyerror("Error: dividing by 0\n");}
					else {$$ = divide($1, $3); add_to_out("/ ");}
					}
| exp MOD exp		{if($3 == 0) {error = 1; yyerror("Error: dividing mod by 0\n");}
					else {$$ = modulo($1, $3); add_to_out("% ");}
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

void add_to_out(char *buff) {
	strcat(out, buff);
	printf("Out: %s\n", out);
}

void negate_value(long int neg_val) {
	printf("Out before neg_val: %s\n", out);
	long int new_value = value_in_base(neg_val);
	long int n = new_value;
	long int new_value_length = 0;
	while(n > 0) {
		n /= 10;
		new_value_length++;
	}

	char char_value[new_value_length];
	sprintf(char_value, "%d", new_value);

	//clear old 'out'
	// int j = strlen(out) - 2;
 //  	while(out[j] > 47 && out[j] < 58)	{
 //    	out[j + 1] = ' ';
 //    	j--; 
 //  	}
 //  	out[j+1] = ' ';

	//save in 'out' in reversed order
	long int i = new_value_length - 1;
	while(new_value_length > 0) {
		out[i+1] = char_value[new_value_length];
		i--;
		new_value_length--;
	}
	out[i+1] = char_value[0];
	out[strlen(out)] = ' ';
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