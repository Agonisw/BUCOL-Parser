/*
    Run process:
    1. flex lexer.l 
    2. gcc lex.yy.c -o lexer -lfl
    {But if u use macos, it is possible to meet the problem:

    ld: library not found for -lfl
    clang: error: linker command failed with exit code 1 (use -v to see invocation)
    
    So u need to change the lfl to your libfl.a path, it is located in the opt->homebrew->Cellar->flex>2.6.64_2->lib->libfl.a, if u use the homebrew to isntall the flex, bison and gccc.
    So the 2. gcc lex.yy.c -o lexer /opt/homebrew/Cellar/flex/2.6.4_2/lib/libfl.a }
    3. ./lexer
    Then u can use this lexer to do some simple identify
*/
%option yylineno

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//This function checks if the input is valid
int is_valid_input(void);
%}

%%

"START."                 { printf("Keyword: START\n"); }
"END."                   { printf("Keyword: END\n"); }
"MAIN."                  { printf("Keyword: MAIN\n"); }
"MOVE"                   { printf("Keyword: MOVE\n"); }
"ADD"                    { printf("Keyword: ADD\n"); }
"INPUT"                  { printf("Keyword: INPUT\n"); }
"PRINT"                  { printf("Keyword: PRINT\n"); }
"TO"                     { printf("Keyword: TO\n"); }
[0-9]+                   { printf("Number: %s\n", yytext); }
[_a-zA-Z][_a-zA-Z0-9\-_]* { printf("Identifier: %s\n", yytext); }
\"[^\"]*\"               { printf("String: %s\n", yytext); }
[ \t\r\n]                { ++yylineno; }
";"                      { printf("Delimiter: %s\n", yytext); }
"."                      { printf("Delimiter: %s\n", yytext); }
\\^S+                    { printf("Size: %s\n", yytext); }
.                        { fprintf(stderr, "Unexpected character '%c'\n", yytext[0]); exit(1); }

%%

int is_valid_input(void) {
    int error_found = 0;
    while (yylex()) {
        if (feof(yyin)) {
            break;
        }
        error_found = 1;
    }
    return !error_found;
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Cannot open file: %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }

    if (is_valid_input()) {
        printf("The input is valid.\n");
    } else {
        printf("The input is invalid.\n");
    }

    return 0;
}

#ifndef yywrap
int yywrap(void) {
    return 1;
}
#endif
