%option yylineno
%option noyywrap

%{
    #include "tokens.h"
%}

DIGIT [0-9]
IDENTIFICADOR [A-Za-z][A-Za-z0-9]*

%%
[ \t\n\r] {/*ignore*/ }
"if" { return TK_IF; }
"let" { return TK_LET; }
"begin" { return TK_BEGIN; }
"end" { return TK_END; }
"print" { return TK_PRINT; }
"return" { return TK_RETURN;}
{DIGIT}+"."{DIGIT}+ { yylval.float_t = atof(yytext); return TK_LIT_FLOAT; }
{IDENTIFICADOR} { yylval.string_t = strdup(yytext); return TK_IDENTIFICADOR;}
"+" { return TK_PLUS;}
"-" { return TK_MINUS;}
"/" { return TK_DIV;}
"*" { return TK_MULTI;}
"(" { return '('; }
")" { return ')'; }
";" { return ';'; }
"=" { return TK_IGUAL; }
"==" { return TK_EQUALS; }
">" { return '>'; }
"<" { return '<'; }
"," { return ',';}
. {printf("Invalid character %c, line %d\n", yytext[0], yylineno); yyterminate();}
%%