%{
int yywrap(); 
int yylex();
%} 
%%
^[[:blank:]]\%						printf("\%");
%									printf("");
\n									{ printf("\n"); }
%%
int yywrap() { 
    return 1; 
} 
int main() { 
    return yylex(); 
}
