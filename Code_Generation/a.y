%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<ctype.h>
#include "useless.h"

void yyerror(char *s);
int yylex(void);
void add(char,char *);
void insert_type();
int search(char *);
extern int lineNum;
extern char* yytext;
int count  = 0,q,sem_errors=0;
char errors[1000][1000];
int ic_idx = 0;
int label =0;
int is_for =0;
int is_while =0;
char buff[100];
char icg[50][100];
char var_nam[50];
char else_body_label[50];
char after_if[50];
int t = 0;
int isFirst = 0;
int first_exp = 0;

struct symbol_table {
    char * name;
    char * data_type ;
    char * type;
    int initialized;

} symbol_table[100];

int search(char *type) { 
    int i; 
    for(i=count-1; i>=0; i--) {
        if(strcmp(symbol_table[i].name, type)==0) {   
            return -1;
            break;  
        }
    } 
    return 0;
}
char type[10];
void insert_type() {
    strcpy(type, yytext);
}
int symbol_count = 0;
void add_symbol(char *name, char *type) {
    strcpy(symbol_table[symbol_count].name, name);
    strcpy(symbol_table[symbol_count].type, type);
    symbol_table[symbol_count].initialized = 0;
    symbol_count++;
}
// Function to check if a symbol exists in the symbol table
int symbol_exists(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return 1;
        }
    }
    sprintf(errors[sem_errors], "Line %d: Variable \"%s\" not declared before usage!\n", lineNum+1, name);  
        sem_errors++;    
    return 0;
}
int symbol_initialized(char *name) {
    q = search(name);    
    if(!q) {        
        sprintf(errors[sem_errors], "Line %d: Variable \"%s\" not declared before usage!\n", lineNum+1, name);  
        sem_errors++;
    }
    return 0;
}
char *get_type(char *var) { 
    for(int i=0; i<count; i++) {  
        if(!strcmp(symbol_table[i].name, var)) {   
            return symbol_table[i].data_type;  
        }
    }
    return "null";
}

// Function to set a symbol as initialized
void initialize_symbol(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].initialized = 1;
        }
    }
}

int same_type(char *name1, char *name2) {


    if(!strcmp(name2, "null")) {
sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" has not the same type!\n", lineNum+1, name2);
        return -1; 
    }
   
    if(strcmp(name1, name2)==0) 
    return 1;
    else{
        sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" and \"%s\" has not the same type!\n", lineNum+1, name1,name1);
return 0;
    } 
    // return strcmp(name1, name2);


}

struct ast_node *head;

struct ast_node *new_ast_node(char *node_type, struct ast_node *left, struct ast_node *right) {
    struct ast_node *new_node = calloc(1,sizeof(struct ast_node));
    new_node->node_type = strdup(node_type);

    new_node->left = left;
    new_node->right = right;
    return new_node;
}

char reserved[24][20] = {"program","integer","real","char","var","to","downto","if","then","else","while","for","do","array","and","or","not","begin","end","read","write","writeln"};

void print_ast_PreOrder(struct ast_node *node) {
    if (node == NULL) {
        return;
    }
    // if(node->node_type[0]!='\0')
    printf("[");
    printf("%s", node->node_type);
    print_ast_PreOrder(node->left);
    print_ast_PreOrder(node->right);
    printf("]");
    }
void print_ast_InOrder(struct ast_node *node) {
    if (node == NULL) {
        // printf("    q ");
        return;
    }
    printf("[");
    print_ast_InOrder(node->left);
    if(node->node_type[0]!='\0')
    printf("%s", node->node_type);
    print_ast_InOrder(node->right);
     printf("]");


}

%}
%left BOOLEAN_OPERATOR
%left '+' PLUS MINUS '-'
%left '*' '/' '%' MUL DIV MOD
// %left NOT 

%union { 
    struct node node_obj; 
    struct var_name2 nd_obj2; 

    struct var_name nd_obj3;
} 

%token <node_obj> PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE ID PUNCTUATOR ARITHMETIC_OPERATOR BOOLEAN_OPERATOR OF DOT NUMBER CHARACTER REAL_NUM PrintStatement OpenB CloseB AssignOp STRING FLOAT_NUM  LE GE LESS GR NE EQ PLUS MINUS MUL DIV MOD
%type <nd_obj3> program declaration statements statement assignment_statement if_statement while_statement for_statement read_statement write_statement Type var_lists var_list RELATIONAL_OPERATOR else_statement assignment_statement_loop print_or_var
%type <nd_obj3> value expression variable
%type <nd_obj3> condition inc_or_dec 

%%

program: PROGRAM ID ';' declaration BEGINI {add('K',$5.name);} statements END {add('K',$8.name);} '.' {
   $5.nd = new_ast_node("begin", $7.nd, NULL);
   $2.nd = new_ast_node($2.name, $4.nd, NULL);
   $$.nd = new_ast_node("program", $2.nd, $5.nd);
    // $6.nd = new_ast_node("statements", $7.nd, NULL);
    head = $$.nd;
    printf("valid input");return 0;};


declaration: VAR { add('K',$1.name); } var_lists {
    $1.nd = new_ast_node($1.name, NULL, NULL);
    $$.nd = new_ast_node("declaration",$1.nd, $3.nd);
    // $2.nd = new_ast_node("var_lists", $2.nd, NULL);
};

var_lists :var_list ':' Type ';' var_lists {
    // $3.nd = new_ast_node($3.name, NULL, NULL); //have to update type
    struct ast_node *a = new_ast_node("variable", $1.nd,$3.nd);
    $$.nd = new_ast_node("var_lists", a , $5.nd);
    }
    |  {$$.nd = NULL;}
    ;

var_list: variable 
    {
        add('V',$1.name); } ',' var_list  { 
        $$.nd = new_ast_node($1.name, $4.nd,NULL);
    }
    | variable 
    { 
        add('V',$1.name) ;$$.nd = new_ast_node($1.name, NULL, NULL);
    }
    ;

   
statements: statements statement { 
    if($1.nd == NULL){
        $$.nd = $2.nd;
    }else{
        $$.nd = new_ast_node("statements", $1.nd, $2.nd); 
    }
    }
    |  {$$.nd = NULL;}
    ;

statement: assignment_statement { 
    $$.nd = new_ast_node("assignment_statement", $1.nd, NULL);

    }
        | if_statement {$$.nd = $1.nd;}
        | while_statement  { $$.nd = $1.nd;}
        | for_statement { $$.nd = $1.nd; }
        | read_statement { $$.nd = $1.nd; }
        | write_statement { $$.nd = $1.nd; }
        ;

assignment_statement: variable AssignOp expression ';' {  
    $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
  sprintf(icg[ic_idx++], "%s %s %s\n", $1.name, $2.name, $3.name);
  int t = same_type($1.name, $3.type);
  symbol_exists($1.name);
};

assignment_statement_loop: variable AssignOp expression {sprintf(icg[ic_idx++], "%s %s %s\n", $1.name, $2.name, $3.name, $1.name);}{
    $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
  int t = same_type($1.name, $3.type);
  symbol_exists($1.name);
  strcpy(var_nam, $1.name);
}

if_statement: IF {add('K',$1.name);} condition { sprintf(icg[ic_idx++], "\nLABEL %s:\n", $3.if_body); } THEN BEGINI statements END {
    sprintf(after_if, "%d", label++);
    // after_if = label++;
     sprintf(icg[ic_idx++], "GOTO L%s\n", after_if); strcpy(else_body_label , $3.else_body);} else_statement ';'{
    $8.nd = new_ast_node("end", NULL, NULL);
   $6.nd = new_ast_node("begin", $8.nd, NULL);
   $5.nd = new_ast_node("then", $6.nd, $8.nd);
   $1.nd = new_ast_node("if", $3.nd, $5.nd);
    $$.nd = new_ast_node("if_statement_with_else", $1.nd, $10.nd);
    sprintf(icg[ic_idx++], "\nLABEL L%s:\n", after_if);

   }

else_statement: ELSE {add('K',$1.name);} { sprintf(icg[ic_idx++], "\nLABEL %s:\n", else_body_label); } BEGINI statements END {
    $6.nd = new_ast_node("end", NULL, NULL);
    $4.nd = new_ast_node("begin", $5.nd, NULL);
    $$.nd = new_ast_node("else", $4.nd, $6.nd);
}
| { sprintf(icg[ic_idx++], "\nLABEL %s:\n", else_body_label); }
;

while_statement: WHILE {add('K',$1.name); is_while=1;} { sprintf(icg[ic_idx++], "\nLABEL L%d:\n", label); } condition DO BEGINI statements END ';'{
    $8.nd = new_ast_node("end", NULL, NULL);
    $6.nd = new_ast_node("begin", $7.nd, NULL);
   $5.nd = new_ast_node("do", $6.nd, $8.nd);
   $$.nd = new_ast_node("while", $4.nd, $5.nd);
    sprintf(icg[ic_idx++], buff);
    sprintf(icg[ic_idx++], "JUMP to %s\n", $4.if_body);
    sprintf(icg[ic_idx++], "\nLABEL %s:\n", $4.else_body);

};

for_statement: FOR {add('K',$1.name); is_for =1;} assignment_statement_loop inc_or_dec ';' {
    $$.nd = new_ast_node("for", $3.nd, $4.nd);
};

inc_or_dec: TO {sprintf(icg[ic_idx++], "\nLABEL L%d:\n", label); sprintf($<nd_obj3>$.if_body , "L%d", label++);sprintf($<nd_obj3>$.else_body, "L%d", label++);} expression {sprintf(icg[ic_idx++], "if not (%s < %s) GOTO %s\n",var_nam,$3.name, $<nd_obj3>2.else_body);} DO BEGINI statements END {
    $8.nd = new_ast_node("end", NULL, NULL);
    $6.nd = new_ast_node("begin", $7.nd, NULL);
    $5.nd = new_ast_node("do", $6.nd, $8.nd);
    $1.nd = new_ast_node("to", $3.nd, $5.nd);
    $$.nd = new_ast_node("increment", $1.nd, $5.nd);
    sprintf(icg[ic_idx++], buff);
    sprintf(icg[ic_idx++], "%s := %s+1\n", var_nam , var_nam);
    sprintf(icg[ic_idx++], "JUMP to %s\n", $<nd_obj3>2.if_body);
    sprintf(icg[ic_idx++], "\nLABEL %s:\n", $<nd_obj3>2.else_body);
    
};
| DOWNTO {sprintf(icg[ic_idx++], "\nLABEL L%d:\n", label); sprintf($<nd_obj3>$.if_body , "L%d", label++);sprintf($<nd_obj3>$.else_body, "L%d", label++);} expression {sprintf(icg[ic_idx++], "if not (%s < %s) GOTO %s\n",var_nam,$3.name, $<nd_obj3>2.else_body);} DO BEGINI statements END {
    $8.nd = new_ast_node("end", NULL, NULL);
    $6.nd = new_ast_node("begin", $5.nd, NULL);
    $5.nd = new_ast_node("do", $6.nd, $8.nd);
    $1.nd = new_ast_node("downto", $3.nd, $5.nd);
    $$.nd = new_ast_node("decrement", $1.nd, $5.nd);
    sprintf(icg[ic_idx++], buff);
    sprintf(icg[ic_idx++], "%s := %s-1\n", var_nam , var_nam);
    sprintf(icg[ic_idx++], "JUMP to %s\n", $<nd_obj3>2.if_body);
    sprintf(icg[ic_idx++], "\nLABEL %s:\n", $<nd_obj3>2.else_body);
};

read_statement: READ {add('K',$1.name);} '(' variable ')' ';' {
    $$.nd = new_ast_node("read", $4.nd, NULL);
    sprintf(icg[ic_idx++], "Read: %s\n", $4.name);
};

write_statement: WRITE {add('K',$1.name);} print_or_var ';'  { 
    $$.nd = new_ast_node("write", $3.nd, NULL);  
};

print_or_var: '(' PrintStatement ')' {
    $$.nd = new_ast_node($2.name, NULL, NULL); 
    sprintf(icg[ic_idx++], "Write: %s\n", $2.name);
};

| '(' var_list ')'  {
    $$.nd = new_ast_node($2.name, NULL, NULL); 
};

condition: expression RELATIONAL_OPERATOR expression { 
    $$.nd = new_ast_node($2.name, $1.nd, $3.nd); 
    if(is_while){
        sprintf(icg[ic_idx++], "if NOT (%s %s %s) GOTO L%d\n", $1.name,$2.name,$3.name,label+1);
        sprintf($$.if_body , "L%d", label++);
        sprintf($$.else_body , "L%d", label++);
        is_while = 0;
    }
   else{
        sprintf(icg[ic_idx++], "if (%s %s %s) GOTO L%d else GOTO L%d\n", $1.name,$2.name,$3.name, label, label+1);
        sprintf($$.if_body , "L%d", label++);
        sprintf($$.else_body , "L%d", label++);
    }
}
        | variable {
            $$.nd = new_ast_node($1.name, NULL,NULL);
        if(is_while){
        sprintf(icg[ic_idx++], "if (%s is FALSE) GOTO L%d\n", $1.name,label+1);
        sprintf($$.if_body , "L%d", label++);
        sprintf($$.else_body , "L%d", label++);
        is_while = 0;
            }
        else{
                sprintf(icg[ic_idx++], "if (%s is TRUE) GOTO L%d else GOTO L%d\n", $1.name, label, label+1);
                sprintf($$.if_body , "L%d", label++);
                sprintf($$.else_body , "L%d", label++);
            }
             }
        | NOT variable {$$.nd = new_ast_node("NOT", $2.nd,NULL);
        if(is_while){
        sprintf(icg[ic_idx++], "if (%s is TRUE) GOTO L%d\n", $1.name,label+1);
        sprintf($$.if_body , "L%d", label++);
        sprintf($$.else_body , "L%d", label++);
        is_while = 0;
            }
        else{
                sprintf(icg[ic_idx++], "if (%s is TRUE) GOTO L%d else GOTO L%d\n", $1.name, label, label+1);
                sprintf($$.if_body , "L%d", label++);
                sprintf($$.else_body , "L%d", label++);
            }
        }
        | '(' condition ')' { $$.nd = new_ast_node("condition", $2.nd, NULL); }
        | expression EQ expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
        if(is_while){
            sprintf(icg[ic_idx++], "if NOT (%s %s %s) GOTO L%d\n", $1.name,$2.name,$3.name,label+1);
            sprintf($$.if_body , "L%d", label++);
            sprintf($$.else_body , "L%d", label++);
            is_while = 0;
        }
        else{
            sprintf(icg[ic_idx++], "if (%s %s %s) GOTO L%d else GOTO L%d\n", $1.name,$2.name,$3.name, label, label+1);
            sprintf($$.if_body , "L%d", label++);
            sprintf($$.else_body , "L%d", label++);
        }
        }
        | condition BOOLEAN_OPERATOR condition { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); }
        ;

RELATIONAL_OPERATOR: LE
                    | GE
                    | LESS
                    | GR
                    | NE 
                    ;

expression: expression PLUS expression { 
    $$.nd = new_ast_node($2.name, $1.nd, $3.nd); 
    sprintf($$.name , "t%d", t++);
    sprintf(icg[ic_idx++], "%s = %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
    if(!strcmp($1.type, $3.type)) {  
        sprintf($$.type, $1.type);  

    } }
    | expression RELATIONAL_OPERATOR expression {
        $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
        sprintf($$.name , "t%d", t++);
        sprintf(icg[ic_idx++], "%s = %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
        }
            
    | expression MINUS expression { 
            $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
            sprintf($$.name , "t%d", t++);
            sprintf(icg[ic_idx++], "%s = %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
            }
          | expression MUL expression { 
            $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
            sprintf($$.name , "t%d", t++);
            sprintf(icg[ic_idx++], "%s = %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
            }
          | expression DIV expression { 
            $$.nd = new_ast_node($2.name, $1.nd, $3.nd); 
            sprintf($$.name , "t%d", t++);
            sprintf(icg[ic_idx++], "%s = %s %s %s\n", $$.name, $1.name, $2.name, $3.name);}
          | expression MOD expression  { 
            $$.nd = new_ast_node($2.name, $1.nd, $3.nd); 
            sprintf($$.name , "t%d", t++);
            sprintf(icg[ic_idx++], "%s = %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
            }
          | '(' expression ')' { $$ = $2; }
          | '{' expression '}' { $$.nd = new_ast_node("expression", $2.nd, NULL); }
          | '[' expression ']' { $$.nd = new_ast_node("expression", $2.nd, NULL); }
          | variable { 
            $$.nd = new_ast_node($1.name, NULL, NULL);
            strcpy($$.name, $1.name); 
            sprintf($$.type, $1.type); 
            }
          | value {add('C',$1.name);} { $$.nd = new_ast_node($1.name, NULL, NULL);
            strcpy($$.name, $1.name); 
            sprintf($$.type, $1.type);
           }
          |MINUS value {add('C',$2.name);} { 
                $$.nd = new_ast_node($1.name, $2.nd, NULL); $2.nd = new_ast_node($2.name, NULL, NULL); 
                strcpy($$.name, $2.name); 
                sprintf($$.type, $2.type); 
                // sprintf(icg[ic_idx++], "%s %s;\n", $1.name, $2.name);

            }
          | PLUS value {add('C',$2.name);} { $$.nd = new_ast_node($1.name, $2.nd, NULL); $2.nd = new_ast_node($2.name, NULL, NULL); 
                strcpy($$.name, $2.name); 
                sprintf($$.type, $2.type); 
                // sprintf(icg[ic_idx++], "%s %s;\n",$1.name, $2.name);
           }
        ;
value:  NUMBER { strcpy($$.name, $1.name); sprintf($$.type, "int"); add('C',$1.name); $$.nd = new_ast_node( $1.name,NULL, NULL); }
        | REAL_NUM { strcpy($$.name, $1.name); sprintf($$.type, "real"); add('C',$1.name); $$.nd = new_ast_node( $1.name,NULL, NULL);}
        | CHARACTER { strcpy($$.name, $1.name); sprintf($$.type, "char"); add('C',$1.name); $$.nd = new_ast_node( $1.name,NULL, NULL);}
        | variable{ strcpy($$.name, $1.name); char *id_type = get_type($1.name); sprintf($$.type, id_type); symbol_initialized($1.name); $$.nd = new_ast_node( $1.name,NULL, NULL);}

variable: ID '[' expression']' { $$.nd = new_ast_node("array", $1.nd, $3.nd); $1.nd = new_ast_node($1.name, NULL, NULL); }
        | ID {add('V',$1.name);} {printf("JWHN %s",$1.name); $$.nd = new_ast_node($1.name, NULL, NULL); }
        ;

Type:
    INTEGER {insert_type(); $$.nd = new_ast_node($1.name, NULL, NULL);}
    | REAL {insert_type(); $$.nd = new_ast_node($1.name, NULL, NULL);}
    | CHAR {insert_type(); $$.nd = new_ast_node($1.name, NULL, NULL);}
    | BOOLEAN {insert_type(); $$.nd = new_ast_node($1.name, NULL, NULL);}
    | ARRAY '[' NUMBER '.' '.' NUMBER ']' OF Type {insert_type(); $$.nd = new_ast_node($1.name, $9.nd, NULL);}
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "syntax error" );
}

int main(int argc, char *argv[]){

    char* filename;

    filename=argv[1];

    printf("\n");
    extern FILE *yyin;
    yyin=fopen(filename, "r+");
    yyparse();
    printf("\n\n");
    printf("\t\t\t\t\t\t\t\t PHASE 1: LEXICAL ANALYSIS \n\n");
    printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
    printf("_______________________________________\n\n");
    int i=0;
    for(i=0; i<count; i++) {
        printf("%s\t%s\t%s\t\t\n", symbol_table[i].name, symbol_table[i].data_type, symbol_table[i].type);
    }
    for(i=0;i<count;i++) {
        free(symbol_table[i].name);
        free(symbol_table[i].type);
    }
    printf("\n\n");
    for(int i=0; i<ic_idx; i++){
        printf("%s", icg[i]);
    }
    printf("\n\n");
    printf("3\n");
    print_ast_PreOrder(head);
    return 0;

}

void add(char c,char *name) {
    if(c == 'V'){
        for(int i=0; i<10; i++){
            if(!strcmp(reserved[i], strdup(yytext))){
                sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" is a reserved keyword!\n", lineNum+1, name);
                sem_errors++;
                return;
            }
        }
    }
  q=search(name);

//   printf("%s",name);
  if(!q) {
    if(c == 'H') {
            symbol_table[count].name=strdup(name);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].initialized=lineNum;
            symbol_table[count].type=strdup("Header");
            count++;
        }
        else if(c == 'K') {
            // printf("ejifew");
            symbol_table[count].name=strdup(name);
            symbol_table[count].data_type=strdup("N/A");
            symbol_table[count].initialized=lineNum;
            symbol_table[count].type=strdup("Keyword\t");
            count++;
        }
        else if(c == 'V') {
            symbol_table[count].name=strdup(name);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].initialized=lineNum;
            symbol_table[count].type=strdup("Variable");
            count++;
        }
        else if(c == 'C') {
            symbol_table[count].name=strdup(name);
            symbol_table[count].data_type=strdup("CONST");
            symbol_table[count].initialized=lineNum;
            symbol_table[count].type=strdup("Constant");
            count++;
        }
    }
     else if(c == 'V' && q) {
        sprintf(errors[sem_errors], "Line %d: Multiple declarations of \"%s\" not allowed!\n", lineNum+1, name);
        sem_errors++;
    }
}
