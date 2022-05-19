%code requires{
    #include "ast.h"
}

%{
    #include <cstdio>
    #include <fstream>
    #include <iostream>
    #include <map>
    using namespace std;
    int yylex();
    map<string, float> mapa;
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
%}

%union{
   Expr * expr_t;
   Statement * statement_t;
   float float_t;
   char * string_t;
}

%token TK_PRINT TK_IF TK_LET TK_BEGIN TK_END TK_PLUS TK_MINUS TK_MULTI TK_DIV TK_RETURN
%token TK_IGUAL TK_EQUALS
%token<float_t> TK_LIT_FLOAT
%token<string_t> TK_IDENTIFICADOR 
%type<float_t> term factor expression print_stmt assignment_stmt equality_expression relational_expression return_stmt print_invoke_expression invoke_method_stmt
%type<string_t> parameter parameter_list
%%

program: statements
;

statements: statements statement
          | statement 
          ;

statement: print_stmt
        |  assignment_stmt
        |  method_stmt
        |  if_stmt
        |  return_stmt
        |  invoke_method_stmt
        ;

print_stmt: TK_PRINT '(' print_invoke_expression ')' ';' { printf("%f\n", $3); }
    ;

assignment_stmt: TK_LET TK_IDENTIFICADOR TK_IGUAL expression ';' { if(!mapa.count($2)){ mapa[$2]=$4;} else { printf("Error: variable %s ya existe.\n",$2); return 0;} }
    ;

method_stmt: TK_LET TK_IDENTIFICADOR '(' parameter_list ')'  TK_IGUAL TK_BEGIN statements TK_END { if(!mapa.count($2)){ mapa[$2]=0;} else { printf("Error: metodo %s ya existe.\n",$2); return 0;} }
    ;

parameter_list: parameter_list ',' parameter {mapa[$3] = 0;}
    | parameter { mapa[$1] = 0;}
    ;

parameter: TK_IDENTIFICADOR { $$ = $1;}
    ;

return_stmt: TK_RETURN equality_expression ';' { $$ = $2;}
    ;

if_stmt: TK_IF '(' equality_expression ')' TK_BEGIN statement TK_END
    ;

print_invoke_expression: invoke_method_stmt {$$=$1;}
    | equality_expression {$$=$1;}
    ;

invoke_method_stmt: TK_IDENTIFICADOR '(' invoke_parameter_list ')' { if(mapa.count($1)){ $$ = mapa.find($1)->second;} else { printf("Error: metodo %s no existe.\n",$1); return 0;} }
    ;

invoke_parameter_list: invoke_parameter_list ',' invoke_parameter
    | invoke_parameter
    ;

invoke_parameter: equality_expression
    ;

equality_expression: equality_expression TK_EQUALS  relational_expression  {$$ = (float)($1==$3);}
                   | relational_expression {$$ = $1; }
                   ;

relational_expression: relational_expression '>' expression {$$ = (float)($1>$3);}
                     | relational_expression '<' expression {$$ = (float)($1<$3);}
                     | expression {$$ = $1;}
                     ;

expression: expression TK_PLUS factor { $$ = $1 + $3; }
    | expression TK_MINUS factor { $$ = $1 - $3; }
    | factor { $$ = $1; }
    ;
factor: factor TK_MULTI term { $$ = $1 * $3; }
    | factor TK_DIV term { $$ = $1 / $3; }
    | term { $$ = $1; }
    ;
term: TK_LIT_FLOAT { $$ = $1; }
    | TK_IDENTIFICADOR { if(mapa.count($1)){ $$ = mapa.find($1)->second;} else { printf("Error: variable %s no existe.\n",$1); return 0;} }
    ;
;   

%%
