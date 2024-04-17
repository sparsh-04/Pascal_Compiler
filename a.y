%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);
int yylex(void);
%}

%token PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE ID PUNCTUATOR ARITHMETIC_OPERATOR RELATIONAL_OPERATOR BOOLEAN_OPERATOR
%%

program: PROGRAM ID PUNCTUATOR declaration BEGINI statement END PUNCTUATOR ;


declaration: VAR var_list PUNCTUATOR type PUNCTUATOR ;

var_list: ID PUNCTUATOR var_list
        | ID
        ;
statement: assignment_statement
        | if_statement
        | while_statement
        | for_statement
        | read_statement
        | write_statement
        ;

assignment_statement: ID ARITHMETIC_OPERATOR expression PUNCTUATOR ;

if_statement: IF condition THEN statement ELSE statement PUNCTUATOR ;

while_statement: WHILE condition DO statement PUNCTUATOR ;

for_statement: FOR ID ARITHMETIC_OPERATOR expression TO expression DO statement PUNCTUATOR ;

read_statement: READ PUNCTUATOR ID PUNCTUATOR PUNCTUATOR ;

write_statement: WRITE PUNCTUATOR ID PUNCTUATOR PUNCTUATOR ;

condition: expression RELATIONAL_OPERATOR expression
        ;
expression: term ARITHMETIC_OPERATOR term
        ;

term: factor ARITHMETIC_OPERATOR factor
    ;

factor: ID
        | INTEGER
        ;



type:
    INTEGER
    | REAL
    | CHAR
    | BOOLEAN
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

// int main(void) {
//     yyparse();
//     return 0;
// }
