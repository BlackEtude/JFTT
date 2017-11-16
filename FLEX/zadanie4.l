%{
#include <stdio.h>
#include <math.h>
#define stack_size 1000
int yywrap();
int yylex();
static int sp = -1;
static int stack[stack_size];
int error = 0;

void operation(char* operand) {
	if(sp<1)
		error=2;
	else if(sp>=stack_size)
		error=3;
	else {
		int a=stack[sp--];
		int b=stack[sp--];

		if(*operand=='+')
			stack[++sp]=a+b;
		else if(*operand=='-')
			stack[++sp]=b-a;
		else if(*operand=='*')
			stack[++sp]=a*b;
		else if(*operand=='^')
			stack[++sp]=(int)pow((double)b,(double)a);
		else if(*operand=='/') {
			if(a==0)
				error=4;
			else
				stack[++sp]=b/a;
		}
		else if(*operand=='%') {
			if(a==0)
				error=4;
			else
				stack[++sp]=b%a;
		}
		else
			error=5;
	}
}

%}

NUM		"-"?[0-9]+
OPERAND	[\+\-\*\/\^\%]
SPACE	[ \t]
NOT_SPACE [^ \t]

%%
\n	{
		if(error==0&&sp==0)
			printf("%d\n", stack[sp]);		
		else if(error==1)
			printf("Error! Not a number!\n");
		else if(error==2)
			printf("Error! Incorrect sequence of operands or not enough arguments!\n");
		else if(error==3)
			printf("Error! Line is too long... stack overflow!\n");
		else if(error==4)
			printf("Error! Dividing by zero!\n");
		else if(sp>0)
			printf("Error! Too many arguments!\n");
		else
			printf("Unexpected error... :(\n");
		sp=-1;
		error=0;
	}

{NUM}		{ stack[++sp]=atoi(yytext); }
{OPERAND} 	{ operation(yytext); }
{SPACE}		
{NOT_SPACE} { error=1; }
%%

int yywrap() {
  return 1;
}

int main() {
  return yylex();
}
