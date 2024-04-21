%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);
int yylex(void);
%}

%token PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE WRITELN ID PUNCTUATOR ARITHMETIC_OPERATOR RELATIONAL_OPERATOR BOOLEAN_OPERATOR OF DOT NUMBER PrintStatement OpenB CloseB
%%

program: PROGRAM ID ';' declaration BEGINI statements END DOT {printf("Success");return 0;};


declaration: VAR var_lists;

var_lists :var_list ':' type ';' var_lists 
                |
                ;

var_list: var_list ',' variable
        | variable
        ;
statements: statements statement
        |
        ;
statement: assignment_statement
        | if_statement
        | while_statement
        | for_statement
        | read_statement
        | write_statement
        ;

assignment_statement: variable ':' '=' expression ';' ;

if_statement: IF condition THEN BEGINI statements END ELSE BEGINI statements END ';' 
            | IF condition THEN BEGINI statements END ';'
            ;

while_statement: WHILE condition DO BEGINI statements END ';' ;

for_statement: FOR ID ':' '=' expression TO expression DO BEGINI statements END ';' 
            | FOR ID ':' '=' expression DOWNTO expression DO BEGINI statements END ';'

read_statement: READ '(' variable ')' ';' ;

write_statement: WRITE '(' PrintStatement ')' ';' 
                | WRITELN '(' PrintStatement ')' ';'
                | WRITE '(' var_list ')' ';'
                | WRITELN '(' variable ')' ';' ;

condition: expression RELATIONAL_OPERATOR expression
        | BOOLEAN
        | NOT BOOLEAN 
        | '(' condition ')'
        | expression '=' expression
        ;
expression: expression ARITHMETIC_OPERATOR expression
          | '(' expression ')' 
          | '{' expression '}'
          | '[' expression ']'
          | variable
          | NUMBER
        ;

variable: ID
        | ID '[' ID ']';
        | ID '[' NUMBER ']';

type:
    INTEGER
    | REAL
    | CHAR
    | BOOLEAN
    | ARRAY '[' NUMBER DOT DOT NUMBER ']' OF type
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    extern FILE *yyin;
    FILE *code = fopen("code.txt", "r");
    yyin = fopen("code.txt", "r+");
//     yylex();
    yyparse();
    fclose(yyin);
//     printf("Total Tokens: %d\n", maxTokens);
//     for (int i = 0; i < maxTokens; i++) {
//         printf("Line %d: Token '%s' - Type '%s'\n", tokenArray[i].lineNumber, tokenArray[i].token, tokenArray[i].tokenType);
//     }
//     free(tokenArray);
    return 0;
}
