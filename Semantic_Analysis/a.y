%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
    #include<ctype.h>

void yyerror(char *s);
int yylex(void);
void add(char,char *);
void insert_type();
int search(char *);
extern int lineNum;
extern char* yytext;
int count  = 0,q,sem_errors=0;
char errors[100][100];

struct symbol_table {
    char * name;
    char * data_type ;
    char * type;
    int initialized;

} symbol_table[100];

int search(char *type) { 
    int i; 
    for(i=count-1; i>=0; i--) {
        // printf("%s   %s]\n",symbol_table[i].name, type);
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
struct ast_node {
    char *node_type;
    // char *value;
    struct ast_node *left;
    struct ast_node *right;
};
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
    if(node->node_type[0]!='\0')
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
%left '+' '-'
%left '*' '/' '%'
// %left NOT 

%union { 
	struct node { 
		char name[100]; 
		struct ast_node* nd;
	} node_obj; 
} 

%token <node_obj> PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE WRITELN ID PUNCTUATOR ARITHMETIC_OPERATOR BOOLEAN_OPERATOR OF DOT NUMBER PrintStatement OpenB CloseB AssignOp STRING FLOAT_NUM  LE GE LESS GR NE EQ PLUS MINUS MUL DIV MOD
%type <node_obj> program declaration statements statement assignment_statement if_statement while_statement for_statement read_statement write_statement condition expression variable Type var_lists var_list RELATIONAL_OPERATOR
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
    $3.nd = new_ast_node("Type", NULL, NULL); //have to update type
    $1.nd = new_ast_node("variable", $3.nd,NULL); 
    $$.nd = new_ast_node("var_lists",  $1.nd, $5.nd);
    }
                |  {$$.nd = new_ast_node("var_lists", NULL,NULL);;}
                ;

var_list: variable {add('V',$1.name); } ',' var_list  { $$.nd = new_ast_node($1.name, $4.nd,NULL);}
        | variable { add('V',$1.name) ;$$.nd = new_ast_node($1.name, NULL, NULL);
         }
        ;

   
statements: statements statement { $$.nd = new_ast_node("statements", $1.nd, $2.nd); }
        | { $$.nd = NULL; }
        ;
statement: assignment_statement { $$.nd = new_ast_node("assignment statement", $1.nd, NULL);

 }
        | if_statement { $$.nd = new_ast_node("\0", $1.nd, NULL); }
        | while_statement  { $$.nd = new_ast_node("\0", $1.nd, NULL); }
        | for_statement { $$.nd = new_ast_node("\0", $1.nd, NULL); }
        | read_statement { $$.nd = new_ast_node("\0", $1.nd, NULL); }
        | write_statement { $$.nd = new_ast_node("\0", $1.nd, NULL); }
        ;

assignment_statement: variable AssignOp expression ';' {  $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
  //  $2.nd = new_ast_node(":=", $3.nd, NULL);
  int t = same_type($1.name, $3.nd->node_type);
 
};
if_statement: IF {add('K',$1.name);} condition THEN BEGINI statements END ELSE {add('K',$8.name);} BEGINI statements END ';'  {

    $12.nd = new_ast_node("end", NULL, NULL);
    $10.nd = new_ast_node("begin", $11.nd, NULL);
    $8.nd = new_ast_node("else", $10.nd, $12.nd);
    $7.nd = new_ast_node("end", NULL, NULL);
   $5.nd = new_ast_node("begin", $6.nd, NULL);
   $4.nd = new_ast_node("then", $5.nd, $7.nd);
   $1.nd = new_ast_node("if", $3.nd, $4.nd);
    $$.nd = new_ast_node("if statement with else", $1.nd, $8.nd);


   }
            | IF {add('K',$1.name);} condition THEN BEGINI statements END ';' {
                $5.nd = new_ast_node("begin", $6.nd, NULL);
                $4.nd = new_ast_node("then", $5.nd, NULL);
                $1.nd = new_ast_node("if", $3.nd, $4.nd);
                $$.nd = new_ast_node("if statement without else", $1.nd, $7.nd);
            }
            ;

while_statement: WHILE {add('K',$1.name);} condition DO BEGINI statements END ';' {
     $7.nd = new_ast_node("end", NULL, NULL);
    $5.nd = new_ast_node("begin", $6.nd, NULL);
   $4.nd = new_ast_node("do", $5.nd, $7.nd);
   $$.nd = new_ast_node("while", $3.nd, $4.nd);

};

for_statement: FOR {add('K',$1.name);} assignment_statement TO expression DO BEGINI statements END ';' {
    $9.nd = new_ast_node("end", NULL, NULL);
    $7.nd = new_ast_node("begin", $8.nd, NULL);
    $6.nd = new_ast_node("do", $7.nd, $9.nd);
    $4.nd = new_ast_node("to", $5.nd, $6.nd);
    $$.nd = new_ast_node("for", $3.nd, $4.nd);
}
            | FOR {add('K',$1.name);} assignment_statement DOWNTO expression DO BEGINI statements END ';' {
                $9.nd = new_ast_node("end", NULL, NULL);
                $7.nd = new_ast_node("begin", $8.nd, NULL);
                $6.nd = new_ast_node("do", $7.nd, $9.nd);
                $4.nd = new_ast_node("downto", $5.nd, $6.nd);
                $$.nd = new_ast_node("for", $3.nd, $4.nd);
            
            };

read_statement: READ {add('K',$1.name);} '(' variable ')' ';' {
    $$.nd = new_ast_node("read", $4.nd, NULL);
};

write_statement: WRITE {add('K',$1.name);} '(' PrintStatement ')' ';'  { $$.nd = new_ast_node("write", $4.nd, NULL); $4.nd = new_ast_node($4.name, NULL, NULL); }
                | WRITE {add('K',$1.name);} '(' var_list ')' ';' { $$.nd = new_ast_node("write", $4.nd, NULL); }
                | WRITELN {add('K',$1.name);} '(' PrintStatement ')' ';' { $$.nd = new_ast_node("writeln", $4.nd, NULL); $4.nd = new_ast_node($4.name, NULL, NULL);}
                | WRITELN {add('K',$1.name);} '(' var_list ')' ';' { $$.nd = new_ast_node("writeln", $4.nd, NULL); }
                ;

condition: expression RELATIONAL_OPERATOR expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); 
}
        | variable {$$.nd = new_ast_node($1.name, NULL,NULL); }
        | NOT variable {$$.nd = new_ast_node("NOT", $2.nd,NULL);}
        | '(' condition ')' { $$.nd = new_ast_node("condition", $2.nd, NULL); }
        | expression EQ expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); }
        | condition BOOLEAN_OPERATOR condition { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); }
        ;

RELATIONAL_OPERATOR: LE
                    | GE
                    | LESS
                    | GR
                    | NE
                    ;

expression: expression PLUS expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); }
          | expression MINUS expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); }
          | expression MUL expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); }
          | expression DIV expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); }
          | expression MOD expression  { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); }
          | '(' expression ')' { $$.nd = new_ast_node("expression", $2.nd, NULL); }
          | '{' expression '}' { $$.nd = new_ast_node("expression", $2.nd, NULL); }
          | '[' expression ']' { $$.nd = new_ast_node("expression", $2.nd, NULL); }
          | variable { $$.nd = new_ast_node($1.name, NULL, NULL); }
          | NUMBER {add('C',$1.name);} { $$.nd = new_ast_node($1.name, NULL, NULL); }
          |MINUS NUMBER {add('C',$2.name);} { $$.nd = new_ast_node($1.name, $2.nd, NULL); $2.nd = new_ast_node($2.name, NULL, NULL); }
          | PLUS NUMBER {add('C',$2.name);} { $$.nd = new_ast_node($1.name, $2.nd, NULL); $2.nd = new_ast_node($2.name, NULL, NULL); }
        ;

variable: ID '[' expression']' { $$.nd = new_ast_node("array", $1.nd, $3.nd); $1.nd = new_ast_node($1.name, NULL, NULL); }
        | ID {add('V',$1.name);} { $$.nd = new_ast_node($1.name, NULL, NULL); }
        ;

Type:
    INTEGER {insert_type();}
    | REAL {insert_type();}
    | CHAR {insert_type();}
    | BOOLEAN {insert_type();}
    | ARRAY '[' NUMBER '.' '.' NUMBER ']' OF Type {insert_type();}
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
printf("1\n");
    yyin=fopen(filename, "r+");
printf("2\n");
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
printf("3\n");
print_ast_InOrder(head);
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
