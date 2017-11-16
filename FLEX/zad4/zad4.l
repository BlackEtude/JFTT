%{
#include <stdio.h>
#include <math.h>
#include "Stack.h"

int yywrap();
int yylex();
void getResult();
void calculate(char* operand);
List* list;
int numbers = 0;
int operands = 0;
int error = 0;
char forbidden;
%}

NUMBER      "-"?[0-9]+
OPERAND     [\+\-\*\/\^\%]
WRONG       [^0-9\+\-\*\/\^\% ]
%x ERROR

%%
\n            {printf("\n"); getResult(); printf("\n\n"); error = 0;}
{WRONG}       {BEGIN(ERROR); printf("%s", yytext); forbidden = *yytext;}
<ERROR>.*\n   {BEGIN(INITIAL); printf("%s", yytext); operands = 0; numbers = 0; printf("ERROR: forbidden char: %c \n\n\n", forbidden);}
{OPERAND}     {printf("%s", yytext); operands++; calculate(yytext);}
{NUMBER}      {printf("%s", yytext); numbers++; push(list, atoi(yytext));}
%%

void getResult() {
    if(error == 1) {
        empty(list);
        operands = 0;
        numbers = 0;
        return;
    }
    if(numbers - operands > 1) {
        printf("ERROR: too many numbers\n");
        empty(list);
        operands = 0;
        numbers = 0;
        return;
    }
    else if(numbers - operands < 1) {
        printf("ERROR: too many operands\n");
        empty(list);
        operands = 0;
        numbers = 0;
        return;
    }
    else if(list->size == 1) {
        printf("= %d\n", getValue(list, 1));
        empty(list);
        operands = 0;
        numbers = 0;    
        return;
    }
    operands = 0;
    numbers = 0;
    empty(list);
    printf("In else\n");
    
}

void calculate(char* op) {
    int x = pull(list), y = pull(list);

    switch(*op) {
        case '+': {
            push(list, x+y);
            break;
        }
        case '-': {
            push(list, y-x);
            break;
            }
        case '*': {
            push(list, x*y);
            break;
        }
        case '/': {
            if(x == 0) {
                printf("\nERROR: dividing by 0");
                error = 1;
                return;
            }
            push(list, y/x);
            break;
        }
        case '^': {
            if(x == 0 && y == 0) {
                printf("\nERROR: undefined symbol 0^0");
                error = 1;
                return;
            }
            push(list, (int)pow((double)y, (double)x));
            break;
        }
        case '%': {
            if(x == 0) {
                printf("\nERROR: undefined xmod0");
                error = 1;
                return;
            }
            push(list, y%x);
            break;
        }
        default: {printf("Error\n"); error = 1;}
    }
}

int yywrap() {
    return 1;
}

int main() {
    list = create();
    yylex();
    return 0;
}
