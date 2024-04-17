%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);
int yylex(void);
%}

%token PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE WRITELN ID PUNCTUATOR ARITHMETIC_OPERATOR RELATIONAL_OPERATOR BOOLEAN_OPERATOR OF DOT NUMBER
%%

program: PROGRAM ID PUNCTUATOR declaration BEGINI statement END PUNCTUATOR ;


declaration: VAR var_list PUNCTUATOR type PUNCTUATOR ;

var_list: var_list PUNCTUATOR ID
        | ID
        ;
statements: statement PUNCTUATOR statements
        | statement
        ;
statement: assignment_statement
        | if_statement
        | while_statement
        | for_statement
        | read_statement
        | write_statement
        ;

assignment_statement: ID ARITHMETIC_OPERATOR expression PUNCTUATOR ;

if_statement: IF condition THEN BEGINI statements END ELSE BEGINI statements END PUNCTUATOR ;

while_statement: WHILE condition DO BEGINI statements END PUNCTUATOR ;

for_statement: FOR ID ARITHMETIC_OPERATOR expression TO expression DO BEGINI statements END PUNCTUATOR ;

read_statement: READ PUNCTUATOR ID PUNCTUATOR PUNCTUATOR ;

write_statement: WRITE PUNCTUATOR ID PUNCTUATOR PUNCTUATOR 
                | WRITELN PUNCTUATOR ID PUNCTUATOR PUNCTUATOR;

condition: expression RELATIONAL_OPERATOR expression
        ;
expression: term ARITHMETIC_OPERATOR term
        ;

term: factor ARITHMETIC_OPERATOR factor
    ;

factor: ID
        | NUMBER
        ;



type:
    INTEGER
    | REAL
    | CHAR
    | BOOLEAN
    | ARRAY PUNCTUATOR NUMBER DOT DOT NUMBER PUNCTUATOR OF type PUNCTUATOR
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
