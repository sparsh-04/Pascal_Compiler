%{
#include <stdio.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>

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

} symbol_table[100];
int sym_cnt = 0;
struct node1
{
    char type[50];
    char name[50];
    char value[50];
} var_data;

struct node1 *symbol_tables[100];

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
char type[10];
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
var_list_for_print: variable { strcpy($1.type,type);} ',' var_list_for_print  { 
                    $$.nd = new_ast_node($1.name, $4.nd,NULL);
                    strcpy($4.type,type);}
        | variable { 
            $$.nd = new_ast_node($1.name, NULL, NULL);
            strcpy($1.type,type);
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
    int t = same_type($1.name,$3.name,symbol_table[k].data_type, $3.type);

    initialize_symbol($1.name);
 
};

assignment_statement_loop: variable AssignOp expression {
    $$.nd = new_ast_node($2.name, $1.nd, $3.nd);
    symbol_exists($1.name);
    int k = findVar($1.name);
    int t = same_type($1.name,$3.name,symbol_table[k].data_type, $3.type);
    initialize_symbol($1.name);
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

        | '(' condition ')' { $$.nd = new_ast_node("condition", $2.nd, NULL); }
        | NOT condition {$$.nd = new_ast_node("NOT", $2.nd,NULL);} 
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

    printf("\n");
    extern FILE *yyin;
    yyin=fopen(filename, "r+");
    yyparse();

    FILE * pascalFile= fopen(filename,"r");
    FILE *cFile = fopen("b.c", "w");
    int beginC = 0;
    if (!pascalFile)
    {
        return 1;
    }

    char line[256];
    char final[256];

    while (fgets(line, sizeof(line), pascalFile))
    {
        // Convert the string line to lower case
        for (int i = 0; line[i]; i++)
        {
            line[i] = tolower(line[i]);
        }
        memset(final, 0, sizeof(final));

        char *pos;
        int comment = 10000;
        if((pos=strstr(line,"//"))!=NULL){
            comment = pos - line;
        }
        if ((pos = strstr(line, "program")) != NULL && pos-line<comment)
        {
            strcpy(final, "#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <ctype.h>\n#include <stdbool.h>\nint main(){");
            if ((pos = strstr(line, "program")) != NULL)
            {
                strcpy(final, "#include <stdio.h>\n#include <stdio.h>\n#include <ctype.h>\n#include <stdlib.h>\n#include <string.h>\n#include <ctype.h>\n#include <stdbool.h>\nint main(){");
                fputs(final, cFile);
                fputs("\n", cFile);
                strcpy(final, "");
                continue;
            }
        }
            if ((pos = strstr(line, "var")) != NULL  && pos-line<comment)
        {
            while (fgets(line, sizeof(line), pascalFile))
            {
                for (int i = 0; line[i]; i++)
                {
                    line[i] = tolower(line[i]);
                }
                memset(final, 0, sizeof(final));
                if ((pos = strstr(line, "array")) != NULL)
                {
                    pos = strchr(line, ':');
                    int first = 0;
                    int last = 0;
                    for (int j = 0; j < strlen(line); j++)
                    {
                        if (line[j] == '[')
                        {
                            // line[j] = '[';
                            while (line[j++] == " ")
                                ;
                            int temp = 0;
                            while (line[j] >= '0' && line[j] <= '9')
                            {

                                temp *= 10;
                                temp += line[j] - '0';
                                j++;
                            }
                            first = temp;
                            while (line[j] == " " || line[j++] == '.')
                                ;
                            j--;
                            temp = 0;
                            while (line[j] >= '0' && line[j] <= '9')
                            {
                                temp *= 10;
                                temp += line[j] - '0';
                                j++;
                            }
                            last = temp;
                            last = temp;
                        }
                    }
                    char des[100];
                    int des_cnt = 0;
                    memset(des, 0, sizeof(des));
                    for (int i = 0; i < strlen(line); i++)
                    {
                        if (line[i] == ':')
                        {
                            break;
                        }
                        else if (line[i] == ' ')
                        {
                        }
                        else
                        {
                            des[des_cnt++] = line[i];
                        }
                    }
                    char word[100];
                    memset(word, 0, sizeof(word));
                    for (int i = first; i <= last; i++)
                    {
                        sprintf(word, "%s[%d]", des, i);
                        struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Integer");
                        symbol_tables[sym_cnt++] = temp;
                        memset(word, 0, sizeof(word));
                    }
                    int j = 0;
                    for (; j < strlen(line); j++)
                    {
                        if (line[j] == ':')
                        {
                            break;
                        }
                    }
                    char te[100];
                    memset(te, 0, sizeof(te));
                    strncpy(te, line, j - 1);
                    sprintf(final, "int %s[%d];", des, last+1);
                }
                else if ((pos = strstr(line, "integer")) != NULL)
                {
                    pos = strchr(line, ':');
                    strncpy(final, "int ", 4);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                    int n = sizeof(line) / sizeof(char);
                    char dec[100];
                    memset(dec, 0, sizeof(dec));
                    int cnt = 0;
                    for (int i = 0; i < n; i++)
                    {
                        if (line[i] == ':')
                        {
                            break;
                        }
                        else if (line[i] == ' ')
                        {
                        }
                        else
                        {
                            dec[cnt++] = line[i];
                        }
                    }
                    char word[100];
                    memset(word, 0, sizeof(word));
                    int wordIndex = 0;
                    int i;
                    int length = sizeof(dec) / sizeof(char);
                    for (i = 0; i < length; i++)
                    {
                        if (dec[i] != ',')
                        {
                            word[wordIndex++] = dec[i];
                        }
                        else
                        {
                            word[wordIndex] = '\0';
                            struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                            sprintf(temp->name, word);
                            sprintf(temp->type, "Integer");
                            symbol_tables[sym_cnt++] = temp;
                            wordIndex = 0;
                            memset(word, 0, sizeof(word));
                        }
                    }
                    if (wordIndex > 0)
                    {
                        word[wordIndex] = '\0';
                        struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Integer");
                        symbol_tables[sym_cnt++] = temp;
                        memset(word, 0, sizeof(word));
                    }
                }
                else if ((pos = strstr(line, "real")) != NULL)
                {
                    pos = strchr(line, ':');
                    strncpy(final, "float ", 6);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                    int n = sizeof(line) / sizeof(char);
                    char dec[100];
                    memset(dec, 0, sizeof(dec));
                    int cnt = 0;
                    for (int i = 0; i < n; i++)
                    {
                        if (line[i] == ':')
                        {
                            break;
                        }
                        else if (line[i] == ' ')
                        {
                        }
                        else
                        {
                            dec[cnt++] = line[i];
                        }
                    }
                    char word[100];
                    memset(word, 0, sizeof(word));
                    int wordIndex = 0;
                    int i;
                    int length = sizeof(dec) / sizeof(char);
                    for (i = 0; i < length; i++)
                    {
                        if (dec[i] != ',')
                        {
                            word[wordIndex++] = dec[i];
                        }
                        else
                        {
                            word[wordIndex] = '\0';
                            // memset(word, 0, sizeof(word));
                            struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                            memset(temp->name, 0, sizeof(temp->name));
                            sprintf(temp->name, word);
                            sprintf(temp->type, "Float");
                            symbol_tables[sym_cnt++] = temp;
                            wordIndex = 0;
                            memset(word, 0, sizeof(word));
                        }
                    }
                    if (wordIndex > 0)
                    {
                        // word[wordIndex] = '\0';
                        struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                        memset(temp->name, 0, sizeof(temp->name));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Float");
                        symbol_tables[sym_cnt++] = temp;
                        memset(word, 0, sizeof(word));
                    }
                }
                else if ((pos = strstr(line, "boolean")) != NULL)
                {
                    pos = strchr(line, ':');
                    strncpy(final, "bool ", 4); // In C, boolean is typically represented as an int
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                    int n = sizeof(line) / sizeof(char);
                    char dec[100];
                    memset(dec, 0, sizeof(dec));
                    int cnt = 0;
                    for (int i = 0; i < n; i++)
                    {
                        if (line[i] == ':')
                        {
                            break;
                        }
                        else if (line[i] == ' ')
                        {
                        }
                        else
                        {
                            dec[cnt++] = line[i];
                        }
                    }
                    char word[100];
                    memset(word, 0, sizeof(word));
                    int wordIndex = 0;
                    int i;
                    int length = sizeof(dec) / sizeof(char);
                    for (i = 0; i < length; i++)
                    {
                        if (dec[i] != ',')
                        {
                            word[wordIndex++] = dec[i];
                        }
                        else
                        {
                            word[wordIndex] = '\0';
                            struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                            sprintf(temp->name, word);
                            sprintf(temp->type, "Boolean");
                            symbol_tables[sym_cnt++] = temp;
                            wordIndex = 0;
                            memset(word, 0, sizeof(word));
                        }
                    }
                    if (wordIndex > 0)
                    {
                        word[wordIndex] = '\0';
                        struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Boolean");
                        symbol_tables[sym_cnt++] = temp;
                        memset(word, 0, sizeof(word));
                    }
                }
                else if ((pos = strstr(line, "char")) != NULL)
                {
                    pos = strchr(line, ':');
                    strncpy(final, "char ", 4);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                    int n = sizeof(line) / sizeof(char);
                    char dec[100];
                    memset(dec, 0, sizeof(dec));
                    int cnt = 0;
                    for (int i = 0; i < n; i++)
                    {
                        if (line[i] == ':')
                        {
                            break;
                        }
                        else if (line[i] == ' ')
                        {
                        }
                        else
                        {
                            dec[cnt++] = line[i];
                        }
                    }
                    char word[100];
                    memset(word, 0, sizeof(word));
                    int wordIndex = 0;
                    int i;
                    int length = sizeof(dec) / sizeof(char);
                    for (i = 0; i < length; i++)
                    {
                        if (dec[i] != ',')
                        {
                            word[wordIndex++] = dec[i];
                        }
                        else
                        {
                            word[wordIndex] = '\0';
                            struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                            sprintf(temp->name, word);
                            sprintf(temp->type, "Char");
                            symbol_tables[sym_cnt++] = temp;
                            wordIndex = 0;
                            memset(word, 0, sizeof(word));
                        }
                    }
                    if (wordIndex > 0)
                    {
                        word[wordIndex] = '\0';
                        struct node1 *temp = (struct node1 *)malloc(sizeof(struct node1));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Char");
                        symbol_tables[sym_cnt++] = temp;
                        memset(word, 0, sizeof(word));
                    }
                }
                else if ((pos = strstr(line, "begin")) != NULL)
                {
                    strcpy(final, "");
                    break;
                    sprintf(final, "%s", final);
                }
                else
                {
                    strcpy(final, "");
                }

                fputs(final, cFile);
                fputs("\n", cFile);
                strcpy(final, "");
            }
        }
            if((pos = strstr(line, "begin")) != NULL && pos-line<comment){
                    if(beginC)
                    strcpy(final, "{");
                    beginC = 1;
                }
            if((pos = strstr(line, "end;")) != NULL && pos-line<comment)
                strcpy(final, "}");
            else if((pos = strstr(line, "end.")) != NULL && pos-line<comment){
            strcpy(final, "");
            break;
        }
            else if((pos = strstr(line, "end")) != NULL && pos-line<comment){
                strcpy(final, "}");
            }
        if((pos = strstr(line, ":=")) != NULL && pos-line<comment){
            strncpy(pos, "= ", 2);
            strcpy(final, line);
        }
        if((pos = strstr(line,"if")) != NULL && pos-line<comment){
            strncpy(pos, "if", 2);
            strcat(pos, " ");
        }
        if((pos = strstr(line, "write")) != NULL && pos-line<comment){
            char var_temp[50];
            int cnt = 0;
            int start = pos - line;
            while (line[start++] != '(')
                ;
            // int f = 0;
            char *f;
            if ((f = strstr(line, "\"")) != NULL)
            {
                for (int i = start - 1; i < sizeof(line) / sizeof(char); i++)
                {
                    var_temp[cnt++] = line[i];
                }
                sprintf(final, "printf%s", var_temp);
                memset(var_temp, 0, sizeof(var_temp));
                cnt = 0;
            }
            else
            {
                for (int i = start; i < sizeof(line) / sizeof(char); i++)
                {

                    if (line[i] == ')')
                    {
                        char typee[50];
                        memset(typee, 0, sizeof(typee));
                        for (int j = 0; j < sym_cnt; j++)
                        {
                            if (!strcmp(symbol_tables[j]->name, var_temp))
                            {
                                sprintf(typee, symbol_tables[j]->type);
                                break;
                            }
                        }
                        if (typee[0] == 'I')
                        {
                            sprintf(final, "printf(\"%%d\",%s);\n", var_temp);
                        }
                        else if (typee[0] == 'F')
                        {
                            sprintf(final, "printf(\"%%f\",%s);\n", var_temp);
                        }
                        else if (typee[0] == 'B')
                        {
                            sprintf(final, "printf(\"%%d\",%s);\n", var_temp);
                        }
                        else if (typee[0] == 'C')
                        {
                            sprintf(final, "printf(\"%%c\",%s);\n", var_temp);
                        }
                        memset(var_temp, 0, sizeof(var_temp));
                        cnt = 0;
                        fputs(final, cFile);
                        memset(final, 0, sizeof(final));
                        break;
                    }
                    else if (line[i] == ',')
                    {

                        char typee[50];
                        memset(typee, 0, sizeof(typee));
                        for (int j = 0; j < sym_cnt; j++)
                        {
                            if (!strcmp(symbol_tables[j]->name, var_temp))
                            {
                                sprintf(typee, symbol_tables[j]->type);
                                break;
                            }
                        }
                        if (typee[0] == 'I')
                        {
                            sprintf(final, "printf(\"%%d\",%s);\n", var_temp);
                        }
                        else if (typee[0] == 'F')
                        {
                            sprintf(final, "printf(\"%%f\",%s);\n", var_temp);
                        }
                        else if (typee[0] == 'B')
                        {
                            sprintf(final, "printf(\"%%d\",%s);\n", var_temp);
                        }
                        else if (typee[0] == 'C')
                        {
                            sprintf(final, "printf(\"%%c\",%s);\n", var_temp);
                        }

                        memset(var_temp, 0, sizeof(var_temp));
                        cnt = 0;
                        fputs(final, cFile);
                        memset(final, 0, sizeof(final));
                    }
                    else if (line[i]==' '){

                    }else
                    {
                        var_temp[cnt++] = line[i];
                    }
                }
            }
        }
        if((pos = strstr(line, "read")) != NULL && pos-line<comment){
            char var_temp[50];
            int cnt = 0;
            memset(var_temp, 0, sizeof(var_temp));
            for (int i = pos - line + 5; i < sizeof(line) / sizeof(char); i++)
            {
                if (line[i] == ')')
                {
                    break;
                }
                else
                {
                    var_temp[cnt++] = line[i];
                }
            }
            char typee[50];
            memset(typee, 0, sizeof(typee));
            for (int i = 0; i < sym_cnt; i++)
            {
                if (!strcmp(symbol_tables[i]->name, var_temp))
                {
                    sprintf(typee, symbol_tables[i]->type);
                    break;
                }
            }

            if (typee[0] == 'I')
            {
                sprintf(final, "scanf(\"%%d\",&%s);", var_temp);
            }
            else if (typee[0] == 'F')
            {
                sprintf(final, "scanf(\"%%f\",&%s);", var_temp);
            }
            else if (typee[0] == 'B')
            {
                sprintf(final, "scanf(\"%%d\",&%s);", var_temp);
            }
            else if (typee[0] == 'C')
            {
                sprintf(final, "scanf(\"%%c\",&%s);", var_temp);
            }

        }
        if((pos=strstr(line,"else"))!=NULL && pos-line<comment){
                if((pos = strstr(line,"if"))!=NULL){
            line[pos-line+2]='(';
            if((pos=strstr(line,"then"))!=NULL){
                line[pos-line-1]=')';
                for(int i=0;i<=3;i++)
                line[pos-line+i]='\0';
            }
            
            int i=0;
            while(line[i]!='\0')i++;
            line[i+1]='{';
            strncpy(final,line,i+1);
           
        }
        else {strncpy(final,line,sizeof(line));}
            }
        if((pos = strstr(line,"if"))!=NULL && pos-line<comment){
            line[pos-line+2]='(';
            if((pos=strstr(line,"then"))!=NULL){
                line[pos-line-1]=')';
                for(int i=0;i<=3;i++)
                line[pos-line+i]='\0';
            }
            
            int i=0;
            while(line[i]!='\0')i++;
            
            strncpy(final,line,i);
           
        }
        if((pos=strstr(line,"while"))!=NULL && pos-line<comment){
        line[pos-line+5]='(';
        if((pos=strstr(line,"do"))!=NULL){
             line[pos-line-1]=')';
                for(int i=0;i<=1;i++)
                line[pos-line+i]='\0';

        }int j=0;
        while(line[j]!='\0')j++;
            strncpy(final,line,j);
        }
        if((pos=strstr(line,"for"))!=NULL && pos-line<comment){
      // for i = number downto a+5 do
    memset(final,'\0',sizeof(final));
    char vari[50];char start[50];char end[50]; memset(vari,'\0',50); memset(start,'\0',50); memset(end,'\0',50);
    if((strstr(line,"downto"))!=NULL){
        char* x= strstr(line,"=");
        int xx=x-line;

        int forkistart=pos-line;int i=0;
        while(forkistart+3!=xx){
           
            vari[i]=line[forkistart+3];
            i++;
            forkistart++;
        }
        //variable aa gya abb start efsnd chahiye
      
        pos=strstr(line,"=");
         xx=pos-line+1;
        x=strstr(line,"downto");
        i=0;
        while(xx!=x-line){
        start[i]=line[xx];
        i++;
        xx++;}
        xx=x-line+6;
         int pqrst=2;
char *y = (char *)line;
       while (pqrst > 0 && (y = strstr(y, "do")) != NULL) {
        // Found the substring, decrement the instance count
        pqrst--;

        // If there are more instances to find, move the search pointer
        if (pqrst > 0) {
            y += strlen("do");
        }
    }
       
        i=0;
        while(xx!=y-line){
            end[i++]=line[xx++];
            
        }
            final[0]='f';final[1]='o';final[2]='r';
            final[3]='(';int j=0;
            for( j=0;vari[j]!='\0';j++){
                final[j+4]=vari[j];
            }
            final[j+4]=' ';j++;
            final[j+4]='=';j++;
            for(int k=0;start[k]!='\0';k++){
                final[j+4]=start[k];
                j++;
            }
            final[j+4]=';';
            j++;
            strcat(final,vari);
            while(final[j]!='\0')j++;
            final[j++]='>';
            final[j++]='=';
            strcat(final,end);
            while(final[j]!='\0')j++;
           final[j++]=';';
            strcat(final,vari);
            while(final[j]!='\0')j++;
            final[j++]='-';final[j++]='-';
            final[j++]=')';

    }
    else{
        char* x= strstr(line,"=");
        int xx=x-line;
        int forkistart=pos-line;int i=0;
        while(forkistart+3!=xx){
           
            vari[i]=line[forkistart+3];
            i++;
            forkistart++;
        }
        //variable aa gya abb start efsnd chahiye
      
        pos=strstr(line,"=");
         xx=pos-line+1;
        x=strstr(line,"to");
        i=0;
        while(xx!=x-line){
        start[i]=line[xx];
        i++;
        xx++;}
        xx=x-line+2;

        char* y=strstr(line,"do");i=0;
        while(xx!=y-line){
            end[i++]=line[xx++];
            
        }
            final[0]='f';final[1]='o';final[2]='r';
            final[3]='(';int j=0;
            for( j=0;vari[j]!='\0';j++){
                final[j+4]=vari[j];
            }
            final[j+4]=' ';j++;
            final[j+4]='=';j++;
            for(int k=0;start[k]!='\0';k++){
                final[j+4]=start[k];
                j++;
            }
            final[j+4]=';';
            j++;
            strcat(final,vari);
            while(final[j]!='\0')j++;
            final[j++]='<';
            final[j++]='=';
            strcat(final,end);
            while(final[j]!='\0')j++;
           final[j++]=';';
            strcat(final,vari);
            while(final[j]!='\0')j++;
            final[j++]='+';final[j++]='+';
            final[j++]=')';
    }
}
        if((pos=strstr(line,"//"))!=NULL && pos-line<comment){
            // printf("this is comment%d",pos-line);
            // continue;
        }
        fputs(final, cFile);
        fputs("\n", cFile);
        strcpy(final, "");
    
    }
    // strcpy(final, "");
    fclose(cFile);
    FILE * cFile2 = fopen("b.c", "r");
    FILE * cFile3 = fopen("c.c", "w");

    while (fgets(line, sizeof(line), cFile2)) {
        memset(final, 0, sizeof(final));
        char *pos;
        char newLine[256]; // Make sure this is large enough
    int i, j = 0;
    for(i = 0; i < strlen(line); i++) {
        if(line[i] == '<' && line[i+1] == '>') {
            newLine[j++] = '!';
            newLine[j++] = '=';
            i+=2; // Skip the next character
        }
        if(i+1<strlen(line) && line[i-1]!='f' && line[i] == 'o' && line[i+1] == 'r') {
            newLine[j++] = '|';
            newLine[j++] = '|';
            i+=2; // Skip the next character
        }
        if(i+2<strlen(line) && line[i] == 'n' && line[i+1] == 'o' && line[i+2] == 't'){
            newLine[j++] = '!';
            i += 3;
        }
        if(i+2<strlen(line) && line[i] == 'a' && line[i+1] == 'n' && line[i+2] == 'd'){
            newLine[j++] = '&';
            newLine[j++] = '&';
            i += 2;
        }
         else {
            newLine[j++] = line[i];
        }
    }
    newLine[j] = '\0';

        // fprintf(cFile2,newLine);
        fputs(newLine, cFile3);
    }
    
    memset(final, 0, sizeof(final));
    sprintf(final, "FILE *file = fopen(\"d.txt\",\"w\");\n");  
    fputs(final, cFile3);
    system("rm b.c");
    memset(final, 0, sizeof(final));
    sprintf(final, "printf(\"%sThe Symbol table: %s\");\n", "\\n\\n\\n\\n", "\\n\\n\\n");
    fputs(final, cFile3);
    memset(final, 0, sizeof(final));
    memset(final, 0, sizeof(final));
    for(int i=0;i<sym_cnt;i++){

        if(symbol_tables[i]->type[0] == 'I'){
            sprintf(final, "printf(\"Value of %s is %%d and is of type int %s\",%s);\n",symbol_tables[i]->name,"\\n",symbol_tables[i]->name);
            fputs(final, cFile3);
        }
        else if(symbol_tables[i]->type[0] == 'B'){
            sprintf(final, "printf(\"Value of %s is %%d and is of type bool %s\",%s);\n",    symbol_tables[i]->name,"\\n",symbol_tables[i]->name);
            fputs(final, cFile3);
        }
        else if(symbol_tables[i]->type[0] == 'C'){
            sprintf(final, "printf(\"Value of %s is %%c and is of type char %s\",%s);\n",    symbol_tables[i]->name,"\\n",symbol_tables[i]->name);
            fputs(final, cFile3);
        }
        else if(symbol_tables[i]->type[0] == 'F'){
            sprintf(final, "printf(\"Value of %s is %%f and is of type float  %s\",%s);\n",    symbol_tables[i]->name,"\\n",symbol_tables[i]->name);
            fputs(final, cFile3);
        }
    }

    memset(final, 0, sizeof(final));
    sprintf(final, "return 0;\n}");
    
    fputs(final, cFile3);
    fclose(cFile2);
    fclose(cFile3);
    fclose(pascalFile);
    system("gcc c.c -o output && ./output");
	system("rm output");
	system("rm d.txt");
	system("rm c.c");
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
            // symbol_exists(name);
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
