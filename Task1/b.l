%option noyywrap
%option yylineno
%option caseless
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define YY_SKIP_YYWRAP

int lineNum = 1;
int maxTokens = 0;

typedef struct {
    int lineNumber;
    char token[100];
    char tokenType[100];
} TokenInfo;

TokenInfo *tokenArray = NULL;

void addToken(const char *token, const char *tokenType) {
    TokenInfo newToken;
    newToken.lineNumber = lineNum;
    strcpy(newToken.token, token);
    strcpy(newToken.tokenType, tokenType);
    maxTokens++;
    tokenArray = (TokenInfo*)realloc(tokenArray, maxTokens * sizeof(TokenInfo));
    tokenArray[maxTokens - 1] = newToken;
}
// int yywrap() {
//     ;
// }
int yylex();
// int yyerror(const char *s) {
//     // fprintf(stderr, "%s\n", s);
//     // ;

// }
%}

keywords program|integer|real|boolean|char|var|to|downto|if|then|else|while|for|do|array|begin|end|read|write|writeln|of
punctuator "["|"]"|"("|")"|","|";"|":"|"."
Arithmetic_operators [+|\-|\*|/|\%]
Relational_operators "="|"<>"|"<"|">"|"<="|">="
Boolean_operators and|or|not
identifier [a-zA-Z_][a-zA-Z0-9_]*
Number "-"?[0-9]+
printStatement \".*\"
%%

{keywords} {

    addToken(yytext, "Keyword");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }
    if(strcmp(yytext, "program") == 0){
        // printf("Progrrwfwefewfam %d",strcmp(yytext, "program"));
        
    }
        
    if(strcmp(yytext, "integer") == 0){
        
        
    }
    if(strcmp(yytext, "Integer") == 0){
        
    }
    if(strcmp(yytext, "real") == 0){
        
    }
    if(strcmp(yytext, "boolean") == 0){
        
    }
    if(strcmp(yytext, "char") == 0){
        
    }
    if( strcmp(yytext, "var") == 0){
        // printf("var");
        
    }
    if(strcmp(yytext, "to") == 0){
       
    }
    if(strcmp(yytext, "downto") == 0){
        
    }
    if( strcmp(yytext, "if") == 0){
       
    }
    if(strcmp(yytext, "then") == 0){
       
    }
    if(strcmp(yytext, "else") == 0){
        
    }
    if(strcmp(yytext, "while") == 0){
        
    }
    if(strcmp(yytext, "for") == 0){
       
    }
    if(strcmp(yytext, "do") == 0){
        
    }
    if(strcmp(yytext, "array") == 0){
        
    }
    // if(strcmp(yytext, "and") == 0){
    //     ;
    // }
    // if(yytext == "or"){
    //     ;
    // }
    // if(yytext == "not"){
    //     ;
    // }
    if(strcmp(yytext, "begin") == 0){
        
    }
    if(strcmp(yytext, "end") == 0){
        
    }
    if(strcmp(yytext, "read") == 0){
        
    }
    if(strcmp(yytext, "write") == 0 ){
        
    }
    if(strcmp(yytext, "writeln") == 0 ){
        
    }
    if(strcmp(yytext, "of") == 0){
       
    }

}
{printStatement} {
    
  ;
}
"//".*\n {
    lineNum++;
    }
{punctuator} {
    addToken(yytext, "Punctuator");
    if(strcmp(yytext,"[")==0){
    
    }
    if(strcmp(yytext,"]")==0){
    
    }
    if(strcmp(yytext,"(")==0){
    
    }
    if(strcmp(yytext,")")==0){
    
    }
    if(strcmp(yytext,";")==0){
    
    }
    if(strcmp(yytext,":")==0){
    
    }
    if(strcmp(yytext,",")==0){
    
    }
    if(strcmp(yytext,".")==0){
       
    }

  
    
}

{Arithmetic_operators} {
    addToken(yytext, "Arithmetic Operators");
        

}
{Relational_operators} {
     if(strcmp(yytext,"=")==0){
    
    }
    ;
    addToken(yytext, "Relational Operators");
   
}
{Boolean_operators} {
    addToken(yytext, "Boolean Operators");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }
    
}

{identifier} {
    addToken(yytext, "Identifier");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }
    ;
    
}
{Number} {
    addToken(yytext, "Number");
    ;
    ;
}

[\t \r] ;
\n {
    lineNum++;
}

" " {} ;

%%

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

    yylex();

    fclose(yyin);

   
    for (int i = 0; i < maxTokens; i++) {
        printf("%d %s %s\n", tokenArray[i].lineNumber, tokenArray[i].token, tokenArray[i].tokenType);
    }
    free(tokenArray);

    return 0;
}