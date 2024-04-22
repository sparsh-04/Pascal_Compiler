%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);
int yylex(void);
%}
%left '+' '-'
%left '*' '/' '%'
%left BOOLEAN_OPERATOR

%token PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE WRITELN ID PUNCTUATOR ARITHMETIC_OPERATOR RELATIONAL_OPERATOR BOOLEAN_OPERATOR OF DOT NUMBER PrintStatement OpenB CloseB
%%

program: PROGRAM ID ';' declaration BEGINI statements END '.' {printf("valid input");return 0;};


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

for_statement: FOR variable ':' '=' expression TO expression DO BEGINI statements END ';' 
            | FOR variable ':' '=' expression DOWNTO expression DO BEGINI statements END ';' ;

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
        | condition BOOLEAN_OPERATOR condition
        ;


expression: expression '+' expression
          | expression '-' expression
          | expression '*' expression
          | expression '/' expression
          | expression '%' expression
          | '(' expression ')' 
          | '{' expression '}'
          | '[' expression ']'
          | variable
          | NUMBER
          |'-' NUMBER
        ;

variable: ID '[' expression']'
        | ID 
        |'('ID')'
        |'['ID']'
        |'{'ID'}';

type:
    INTEGER
    | REAL
    | CHAR
    | BOOLEAN
    | ARRAY '[' NUMBER '.' '.' NUMBER ']' OF type
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "syntax error" );
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *code = fopen(argv[1], "r");
    if (code == NULL) {
        perror("Error opening file");
        return 1;
    }

    extern FILE *yyin;
    yyin = code;

    yyparse();

    fclose(yyin);

    return 0;
}
