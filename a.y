%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);
int yylex(void);
%}

%token PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE WRITELN ID PUNCTUATOR ARITHMETIC_OPERATOR RELATIONAL_OPERATOR BOOLEAN_OPERATOR OF DOT NUMBER PrintStatement
%%

program: PROGRAM ID PUNCTUATOR declaration BEGINI statements END PUNCTUATOR ;


declaration: VAR var_lists;

var_lists :var_list PUNCTUATOR type PUNCTUATOR var_lists 
                |
                ;

var_list: var_list PUNCTUATOR ID
        | ID
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

assignment_statement: ID PUNCTUATOR RELATIONAL_OPERATOR expression PUNCTUATOR ;

if_statement: IF condition THEN BEGINI statements END ELSE BEGINI statements END PUNCTUATOR ;

while_statement: WHILE condition DO BEGINI statements END PUNCTUATOR ;

for_statement: FOR ID PUNCTUATOR RELATIONAL_OPERATOR NUMBER TO NUMBER DO BEGINI statements END PUNCTUATOR ;

read_statement: READ PUNCTUATOR variable PUNCTUATOR PUNCTUATOR ;

write_statement: WRITE PUNCTUATOR PrintStatement PUNCTUATOR PUNCTUATOR 
                | WRITELN PUNCTUATOR PrintStatement PUNCTUATOR PUNCTUATOR
                | WRITE PUNCTUATOR variable PUNCTUATOR PUNCTUATOR
                | WRITELN PUNCTUATOR variable PUNCTUATOR PUNCTUATOR;

condition: expression RELATIONAL_OPERATOR expression
        ;
expression: term ARITHMETIC_OPERATOR term
                | term

        ;

term: factor ARITHMETIC_OPERATOR factor
        | factor
    ;

factor: ID
        | NUMBER
        | variable
        ;

variable: ID
        | ID PUNCTUATOR ID PUNCTUATOR;

type:
    INTEGER
    | REAL
    | CHAR
    | BOOLEAN
    | ARRAY PUNCTUATOR NUMBER DOT DOT NUMBER PUNCTUATOR OF type
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
