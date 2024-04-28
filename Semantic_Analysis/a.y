%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char *s);
int yylex(void);
extern int lineNum;
struct symbol_table {
    char name[10];
    char type[10];
    int initialized;
} symbols[100];

int symbol_count = 0;
void add_symbol(char *name, char *type) {
    strcpy(symbols[symbol_count].name, name);
    strcpy(symbols[symbol_count].type, type);
    symbols[symbol_count].initialized = 0;
    symbol_count++;
}
// Function to check if a symbol exists in the symbol table
int symbol_exists(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            return 1;
        }
    }
    return 0;
}
int symbol_initialized(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            return symbols[i].initialized;
        }
    }
    return 0;
}
// Function to set a symbol as initialized
void initialize_symbol(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            symbols[i].initialized = 1;
        }
    }
}

int same_type(char *name1, char *name2) {
    char type1[10];
    char type2[10];

    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name1) == 0) {
            strcpy(type1, symbols[i].type);
        }
        if (strcmp(symbols[i].name, name2) == 0) {
            strcpy(type2, symbols[i].type);
        }
    }

    return strcmp(type1, type2) == 0;
}
struct ast_node {
    char *node_type;
    // char *value;
    struct ast_node *left;
    struct ast_node *right;
};
struct ast_node *head;

struct ast_node *new_ast_node(char *node_type, struct ast_node *left, struct ast_node *right) {
    struct ast_node *new_node = malloc(sizeof(struct ast_node));
    new_node->node_type = strdup(node_type);

    new_node->left = left;
    new_node->right = right;
    return new_node;
}

void print_ast(struct ast_node *node) {
    if (node == NULL) {
        return;
    }
    printf("Node type: %s\n", node->node_type);
    print_ast(node->left);
    print_ast(node->right);
}

%}
%left BOOLEAN_OPERATOR
%left '+' '-'
%left '*' '/' '%'
// %left NOT 

%union { 
	struct node { 
		char name[100]; 
		struct ast_node* nd;
	} node_obj; 
} 

%token <node_obj> PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE WRITELN ID PUNCTUATOR ARITHMETIC_OPERATOR RELATIONAL_OPERATOR BOOLEAN_OPERATOR OF DOT NUMBER PrintStatement OpenB CloseB AssignOp STRING FLOAT_NUM 
%type <node_obj> program declaration statements statement assignment_statement if_statement while_statement for_statement read_statement write_statement condition expression variable type var_lists var_list
%%

program: PROGRAM ID ';' declaration BEGINI statements END '.' {
    $$.nd = new_ast_node("program", $2.nd, $4.nd);
    $4.nd = new_ast_node("declaration", $5.nd, $6.nd);
    $6.nd = new_ast_node("statements", $7.nd, NULL);
    head = $$.nd;
    printf("valid input");return 0;};


declaration: VAR var_lists {
    $$.nd = new_ast_node("declaration",$1.nd, $2.nd);
};

var_lists :var_list ':' type ';' var_lists {
    $$.nd = new_ast_node("var_lists",  $1.nd, $3.nd);
    $3.nd = new_ast_node("type", $5.nd,NULL); }
                |  {$$.nd = new_ast_node("var_lists", NULL,NULL);;}
                ;

var_list: var_list ',' variable { $$.nd = new_ast_node("var_list", $1.nd, $3.nd);}
        | variable { $$.nd = new_ast_node("var_list", $1.nd, NULL); }
        ;

   
statements: statements statement { $$.nd = new_ast_node("statements", $1.nd, $2.nd); }
        | { $$.nd =  new_ast_node("statements", NULL, NULL); }
        ;
statement: assignment_statement { $$.nd = new_ast_node("statement", $1.nd, NULL); }
        | if_statement { $$.nd = new_ast_node("statement", $1.nd, NULL); }
        | while_statement  { $$.nd = new_ast_node("statement", $1.nd, NULL); }
        | for_statement { $$.nd = new_ast_node("statement", $1.nd, NULL); }
        | read_statement { $$.nd = new_ast_node("statement", $1.nd, NULL); }
        | write_statement { $$.nd = new_ast_node("statement", $1.nd, NULL); }
        ;

assignment_statement: variable AssignOp expression ';' {  $$.nd = new_ast_node("assignment_statement", $1.nd, $2.nd);
    $2.nd = new_ast_node(":=", $3.nd, NULL);};

if_statement: IF condition THEN BEGINI statements END ELSE BEGINI statements END ';'  { $$.nd = new_ast_node("if_statement", $2.nd, $3.nd);
    $3.nd = new_ast_node("statements", $4.nd, $6.nd);
    $4.nd = new_ast_node("else", $5.nd, $10.nd);}
            | IF condition THEN BEGINI statements END ';'
            ;

while_statement: WHILE condition DO BEGINI statements END ';' ;

for_statement: FOR variable AssignOp expression TO expression DO BEGINI statements END ';' 
            | FOR variable AssignOp expression DOWNTO expression DO BEGINI statements END ';' ;

read_statement: READ '(' variable ')' ';' ;

write_statement: WRITE '(' PrintStatement ')' ';'  
                | WRITELN '(' PrintStatement ')' ';'
                | WRITE '(' var_list ')' ';'
                | WRITELN '(' variable ')' ';' ;

condition: expression RELATIONAL_OPERATOR expression
        | variable
        | NOT variable 
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
          | '+' NUMBER
        ;

variable: ID '[' expression']'
        | ID 
        ;

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

int main(int argc, char *argv[]){

    char* filename;

    filename=argv[1];

    printf("\n");
    FILE *yyin;
printf("1\n");
    yyin=fopen(filename, "r");
printf("2\n");
    yyparse();
printf("3\n");
    return 0;

}
