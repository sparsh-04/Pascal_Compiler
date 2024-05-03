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
char errors[1000][1000];
void update_type();
struct symbol_table {
    char * name;
    char * data_type ;
    char * type;
    int initialized;

} symbol_table[500];

int storeVarIndex = 0;
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
char type[100];
void insert_type() {
    strcpy(type, yytext);
    if(type[0]=='b')
    strcpy(type,"integer\0");

    update_type();
}
void update_type() {
        for(int j=0; j<count; j++) {
            if((symbol_table[j].type[0]=='V') && symbol_table[j].data_type[0]=='N') {
            // printf("%d %s %sV\n\n",strcmp(symbol_table[j].data_type,"NULL"),symbol_table[j].type,symbol_table[j].data_type);
                symbol_table[j].data_type = strdup(type);
            }
        
    }
}
int findVar(char* name){
    for(int j=0; j<count; j++) {
            if((strcmp(symbol_table[j].name,name)==0)) {
            // printf("%sV\n\n",symbol_table[j].data_type);
                return j;
            }
        
    }
    
    // return -1;
}

void add_symbol(char *name, char *type) {
    strcpy(symbol_table[count].name, name);
    strcpy(symbol_table[count].type, type);
    symbol_table[count].initialized = 0;
    count++;
}
// Function to check if a symbol exists in the symbol table
int symbol_exists(char *name) {
    for (int i = 0; i < count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            // printf("Symbol %s exists\n", name);
            return 1;
        }
    }
    sprintf(errors[sem_errors], "Line %d: Variable \"%s\" not declared before usage!\n", lineNum+1, name);  
        sem_errors++;    
    return 0;
}
int symbol_initialized(char *name) {
    for(int i=0;i<count;i++){
        if(strcmp(symbol_table[i].name,name)==0){
            if(symbol_table[i].initialized>0){
                return 1;
            }
        }
    }  
    // printf("F%dF ",q); 
    if(!q) {        
        sprintf(errors[sem_errors], "Line %d: Variable \"%s\" not initialized before usage!\n", lineNum+1, name);  
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
    for (int i = 0; i < count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].initialized = 1;
        }
    }
}

int same_type(char *name1, char *name2,char *type1,char *type2) {

    if(!strcmp(type2, "null")) {
    sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" has not the same type!\n", lineNum+1, name2);
        sem_errors++;
        return -1; 
    }
   
    if(type1[0]==type2[0])
    return 1;
    else{
        sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" and \"%s\" has not the same type!\n", lineNum+1, name1,name2);
        sem_errors++;
    return 0;
    } 


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

void print_ast_PreOrder(struct ast_node *node, FILE *fptr) {
    if (node == NULL) {
        return;
    }
    
    fprintf(fptr, "[");
    fprintf(fptr, "%s", node->node_type);
    print_ast_PreOrder(node->left, fptr);
    print_ast_PreOrder(node->right, fptr);
    fprintf(fptr, "]");
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
char * storeVar[100];

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
    struct var_name2 { 
			char name[100]; 
			struct node* nd;
			char type[10];
		} nd_obj2; 
} 

%token <node_obj> PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO DOWNTO IF THEN ELSE WHILE FOR DO ARRAY AND OR NOT BEGINI END READ WRITE ID PUNCTUATOR BOOLEAN_OPERATOR OF DOT NUMBER boolean CHARACTER REAL_NUM PrintStatement OpenB CloseB AssignOp STRING FLOAT_NUM  LE GE LESS GR NE EQ PLUS MINUS MUL DIV MOD
%type <node_obj> program declaration statements statement assignment_statement if_statement while_statement for_statement read_statement write_statement Type var_lists RELATIONAL_OPERATOR else_statement inc_or_dec assignment_statement_loop print_or_var ARITHMETIC_OPERATOR
%type <nd_obj2> value expression variable var_list condition var_list_for_print

%%

program: PROGRAM ID ';' declaration BEGINI {add('K',$5.name);} statements END {add('K',$8.name);} '.' {
   $5.nd = new_ast_node("begin", $7.nd, NULL);
   $2.nd = new_ast_node($2.name, $4.nd, NULL);
   $$.nd = new_ast_node("program", $2.nd, $5.nd);
    // $6.nd = new_ast_node("statements", $7.nd, NULL);
    head = $$.nd;
    return 0;};


declaration: VAR { add('K',$1.name); } var_lists {

    $1.nd = new_ast_node($1.name, NULL, NULL);
    $$.nd = new_ast_node("declaration",$1.nd, $3.nd);

};


var_lists :var_list ':' Type {
                storeVarIndex = 0;
                } ';' var_lists {
    

    
    struct ast_node *a = new_ast_node("variable", $1.nd,$3.nd);
    $$.nd = new_ast_node("var_lists", a , $6.nd);
    }
                |  {$$.nd = NULL;}
                ;

var_list: variable {add('V',$1.name) ; strcpy($1.type,type);} ',' var_list  { 
                    $$.nd = new_ast_node($1.name, $4.nd,NULL);
                    // strcpy($1.type,$$.type);
                    storeVar[storeVarIndex] = strdup($1.name);

                    storeVarIndex++;

                    strcpy($4.type,type);}
        | variable { 
            add('V',$1.name) ;
            $$.nd = new_ast_node($1.name, NULL, NULL);
            storeVar[storeVarIndex] = strdup($1.name);
            storeVarIndex++;
	  
            strcpy($1.type,type);
         }
        ;
var_list_for_print: variable { //strcpy($1.type,type);
symbol_exists($1.name);symbol_initialized($1.name);
} ',' var_list_for_print  { 

                    $$.nd = new_ast_node($1.name, $4.nd ,NULL);
                    }
        | variable { 
            symbol_exists($1.name);
          symbol_initialized($1.name);
            $$.nd = new_ast_node($1.name, NULL, NULL);
         
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

statement: assignment_statement { $$.nd = new_ast_node("assignment_statement", $1.nd, NULL);}
        | if_statement { $$.nd = $1.nd;}
        | while_statement  { $$.nd = $1.nd;}
        | for_statement { $$.nd = $1.nd; }
        | read_statement { $$.nd = $1.nd; }
        | write_statement { $$.nd = $1.nd; }
        ;

assignment_statement: variable AssignOp expression ';' { 
    $$.nd = new_ast_node($2.name, $1.nd, $3.nd);

    symbol_exists($1.name);
    int k = findVar($1.name);
    int t;
        if(k!=-1){

    t = same_type($1.name,$3.name,symbol_table[k].data_type, $3.type);
     //initialize_symbol($1.name);
    }
    else 
    {}

 
};

assignment_statement_loop: variable AssignOp expression {
    $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
    symbol_exists($1.name);
    int k = findVar($1.name);
    int t;
    if(k!=-1){

    t = same_type($1.name,$3.name,symbol_table[k].data_type, $3.type);
     //initialize_symbol($1.name);
    }
    
    
   
}

if_statement: IF {add('K',$1.name);} condition THEN BEGINI statements END else_statement ';'{
    $7.nd = new_ast_node("end", NULL, NULL);
   $5.nd = new_ast_node("begin", $6.nd, NULL);
   $4.nd = new_ast_node("then", $5.nd, $7.nd);
   $1.nd = new_ast_node("if", $3.nd, $4.nd);
   
    $$.nd = new_ast_node("if_statement_with_else", $1.nd, $8.nd);


   }
            | IF {add('K',$1.name);} condition THEN BEGINI statements END ';' {
                $5.nd = new_ast_node("begin", $6.nd, NULL);
                $4.nd = new_ast_node("then", $5.nd, NULL);
                $1.nd = new_ast_node("if", $3.nd, $4.nd);
                $$.nd = new_ast_node("if statement without else", $1.nd, $7.nd);
            }
            ;

else_statement: ELSE {add('K',$1.name);} BEGINI statements END {
    $5.nd = new_ast_node("end", NULL, NULL);
    $3.nd = new_ast_node("begin", $4.nd, NULL);
    $$.nd = new_ast_node("else", $3.nd, $5.nd);
}
|
;

while_statement: WHILE {add('K',$1.name);} condition DO BEGINI {} statements END ';' {
    $8.nd = new_ast_node("end", NULL, NULL);
    $5.nd = new_ast_node("begin", $7.nd, NULL);
   $4.nd = new_ast_node("do", $5.nd, $8.nd);
   $$.nd = new_ast_node("while", $3.nd, $4.nd);

};

for_statement: FOR {add('K',$1.name);} assignment_statement_loop inc_or_dec ';' {
    $$.nd = new_ast_node("for", $3.nd, $4.nd);
};

inc_or_dec: TO expression DO BEGINI statements END {
    $6.nd = new_ast_node("end", NULL, NULL);
    $4.nd = new_ast_node("begin", $5.nd, NULL);
    $3.nd = new_ast_node("do", $4.nd, $6.nd);
    $1.nd = new_ast_node("to", $2.nd, $3.nd);
    $$.nd = new_ast_node("increment", $1.nd, $3.nd);
};
| DOWNTO expression DO BEGINI statements END {
    $6.nd = new_ast_node("end", NULL, NULL);
    $3.nd = new_ast_node("begin", $4.nd, NULL);
    $3.nd = new_ast_node("do", $4.nd, $6.nd);
    $1.nd = new_ast_node("downto", $2.nd, $3.nd);
    $$.nd = new_ast_node("decrement", $1.nd, $3.nd);
};

read_statement: READ {add('K',$1.name);} '(' variable ')' ';' {
    $$.nd = new_ast_node("read", $4.nd, NULL);
    symbol_exists($4.name);
    initialize_symbol($4.name);
};

write_statement: WRITE {add('K',$1.name);} print_or_var ';'  { 
    $$.nd = new_ast_node("write", $3.nd, NULL);  
};

print_or_var: '(' PrintStatement ')' {
    $$.nd = new_ast_node($2.name, NULL, NULL); 

};

| '(' var_list_for_print ')'  {
    $$.nd = new_ast_node($2.name, NULL, NULL); 

};

condition: expression RELATIONAL_OPERATOR expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); 
                    if($1.type[0]!=$3.type[0]) {  
                                    sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" and \"%s\" are of different types!\n", lineNum+1,$1.name,$3.name );
                                    sem_errors++;
                    }
}
        | variable {$$.nd = new_ast_node($1.name, NULL,NULL); 
                    symbol_exists($1.name);
                    symbol_initialized($1.name);
                    int k = findVar($1.name);
                    int t = same_type($1.name,"integer",symbol_table[k].data_type, "integer");}

        | NOT variable {$$.nd = new_ast_node("NOT", $2.nd,NULL);
                    symbol_exists($2.name);
                    symbol_initialized($2.name);
                    int k = findVar($2.name);
                    int t = same_type($2.name,"integer",symbol_table[k].data_type, "integer");}
        | NOT condition {$$.nd = new_ast_node("NOT", $2.nd,NULL);} 
        | '(' condition ')' { $$.nd = new_ast_node("condition", $2.nd, NULL); }
        | expression EQ expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd); 
                                    if(!strcmp($1.type, $3.type)) {  
                                    sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" and \"%s\" are of different types!\n", lineNum+1,$1.name,$3.name );
				                    sem_errors++;
                    }
                    
        }
        | condition BOOLEAN_OPERATOR condition { $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
                            if(!strcmp($1.type, $3.type)) {  
                                    sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" and \"%s\" are of different types!\n", lineNum+1,$1.name,$3.name);
				                    sem_errors++; 
                                    }
        }
        ;

RELATIONAL_OPERATOR: LE
                    | GE
                    | LESS
                    | GR
                    | NE 
                    ;

expression: expression ARITHMETIC_OPERATOR expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
            if($1.type[0] != $3.type[0]) {  
                                    sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" and \"%s\" are of different types!\n", lineNum+1,$1.name,$3.name);
                                    sem_errors++; 
                                    
                sprintf($$.type, $1.type);  

            } 
        }
          | expression RELATIONAL_OPERATOR expression { $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
          
            if($1.type[0] != $3.type[0]) {  
                                    sprintf(errors[sem_errors], "Line %d: Variable name \"%s\" and \"%s\" are of different types!\n", lineNum+1,$1.name,$3.name);
                                    sem_errors++; 
                                    
                sprintf($$.type, $1.type);  

            }
        } 
            | '(' expression ')' { $$.nd = new_ast_node("expression", $2.nd, NULL); 
                    sprintf($$.type, $2.type);  

                }  
          | variable { $$.nd = new_ast_node($1.name, NULL, NULL);
            symbol_exists($1.name);
            // printf("JBKHBH %s ",$1.name);
            symbol_initialized($1.name);
            int k = findVar($1.name);
            sprintf($$.type, symbol_table[k].data_type);
             }
          | value {add('C',$1.name);} { 
            $$.nd = new_ast_node($1.name, NULL, NULL);
            strcpy($$.name, $1.name); 
            sprintf($$.type, $1.type); 
           }
          |MINUS value {add('C',$2.name);} { $$.nd = new_ast_node($1.name, $2.nd, NULL); $2.nd = new_ast_node($2.name, NULL, NULL); 
            strcpy($$.name, $2.name); 
            sprintf($$.type, $2.type); 
            }
          | PLUS value {add('C',$2.name);} { $$.nd = new_ast_node($1.name, $2.nd, NULL); $2.nd = new_ast_node($2.name, NULL, NULL); 
                strcpy($$.name, $2.name); 
                sprintf($$.type, $2.type); 
           }
        ;
ARITHMETIC_OPERATOR : PLUS
                    | MINUS
                    | MUL
                    | DIV
                    | MOD
                    ;
value:  NUMBER { strcpy($$.name, $1.name); sprintf($$.type, "integer"); add('C',$1.name); $$.nd = new_ast_node( $1.name,NULL, NULL); strcpy($$.name, $1.name); }
        | REAL_NUM { strcpy($$.name, $1.name); sprintf($$.type, "real"); add('C',$1.name); $$.nd = new_ast_node( $1.name,NULL, NULL);strcpy($$.name, $1.name); }
        | CHARACTER { strcpy($$.name, $1.name); sprintf($$.type, "char"); add('C',$1.name); $$.nd = new_ast_node( $1.name,NULL, NULL);strcpy($$.name, $1.name); }
        | variable{ 
            strcpy($$.name, $1.name); 
            char *id_type = get_type($1.name); 
            sprintf($$.type, id_type);
            symbol_exists($1.name);
            symbol_initialized($1.name); 
            $$.nd = new_ast_node( $1.name,NULL, NULL);
            strcpy($$.name, $1.name); }
        | boolean { strcpy($$.name, $1.name); sprintf($$.type, "integer"); add('C',$1.name); $$.nd = new_ast_node( $1.name,NULL, NULL); strcpy($$.name, $1.name); }

variable: ID '[' expression']' {$1.nd = new_ast_node($1.name, NULL, NULL); $$.nd = new_ast_node($1.name, $1.nd, $3.nd);  

            }
        | ID  {//add('V',$1.name); 
         $$.nd = new_ast_node($1.name, NULL, NULL); }
        ;

Type:
    INTEGER {insert_type(); $$.nd = new_ast_node($1.name, NULL, NULL);}
    | REAL {insert_type(); $$.nd = new_ast_node($1.name, NULL, NULL);}
    | CHAR {insert_type(); $$.nd = new_ast_node($1.name, NULL, NULL);}
    | BOOLEAN {insert_type(); $$.nd = new_ast_node($1.name, NULL, NULL);}
    | ARRAY {} '[' NUMBER '.' '.' NUMBER ']' OF Type {
        insert_type();
        for(int j=0;j<storeVarIndex;j++){
            // printf("%s %d ",storeVar[j],j);
            for(int i=atoi($4.name); i<=atoi($7.name); i++) {
                    char * t1 = malloc(256); 
                    strcpy(t1, storeVar[j]); // Copy the string from storeVar[0] to t1
                    char t2[256]; 
                    sprintf(t2, "[%d]", i);
                    strcat(t1, t2);
                    // printf("%s",t1);
                    add('V',t1);
                    free(t1); 
            }
        }
        insert_type();
        $$.nd = new_ast_node($10.name, $10.nd, NULL);
        }
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "syntax error" );
}

int main(int argc, char *argv[]){

    char* filename;
	
    filename=argv[1];

    extern FILE *yyin;
    yyin=fopen(filename, "r");
    //printf("%s",filename);
    yyparse();
   
   FILE *fptr = fopen("syntaxtree.txt", "w"); 
    print_ast_PreOrder(head,fptr);
   fclose(fptr);
     printf("\n\n");
    printf("\n");
    for(int i=0;i<sem_errors;i++){
        printf("%s",errors[i]);
    }
    return 0;

}

void add(char c,char *name) {
    if(c == 'V'){
		for(int i=0; i<20; i++){
			if(!strcmp(reserved[i], strdup(name))){
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
			symbol_table[count].name=strdup(name);
			symbol_table[count].data_type=strdup("N/A");
			symbol_table[count].initialized=lineNum;
			symbol_table[count].type=strdup("Keyword\t");
			count++;
		}
		else if(c == 'V') {
            // printf(" %s %d ",name,lineNum);
			symbol_table[count].name=strdup(name);
			symbol_table[count].data_type="NULL";
			symbol_table[count].initialized=0;
			symbol_table[count].type=strdup("Variable\0");
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
