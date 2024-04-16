%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);
int yylex(void);
%}

%token INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF ELSE WHILE FOR DO ARRAY AND OR NOT BEGIN END READ WRITE
%%

program: 'program' ID ';' declaration 'begin' statement 'end' '.' ;


declaration: 'var' var_list ':' type ';' ;

var_list: ID ',' var_list
        | ID
        ;
statement: assignment_statement
        | if_statement
        | while_statement
        | for_statement
        | read_statement
        | write_statement
        ;

assignment_statement: ID ':=' expression ';' ;

if_statement: 'if' condition 'then' statement 'else' statement ';' ;

while_statement: 'while' condition 'do' statement ';' ;

for_statement: 'for' ID ':=' expression 'to' expression 'do' statement ';' ;

read_statement: 'read' '(' ID ')' ';' ;

write_statement: 'write' '(' ID ')' ';' ;

condition: expression '<' expression
        | expression '>' expression
        | expression '=' expression
        | expression '<>' expression
        | expression '<=' expression
        | expression '>=' expression
        ;

expression: term '+' term
        | term '-' term
        ;

term: factor '*' factor
    |   factor '/' factor
    ;

factor: ID
        | NUMBER
        ;


type:
    'integer'
    | 'real'
    | 'char'
    | 'boolean'
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

// int main(void) {
//     yyparse();
//     return 0;
// }
