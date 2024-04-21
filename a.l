%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "a.tab.h"

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
int yywrap() {
    return 1;
}
int yylex();
// int yyerror(const char *s) {
//     // fprintf(stderr, "%s\n", s);
//     // return 0;

// }
%}
%option caseless

keywords program|integer|real|boolean|char|var|to|downto|if|then|else|while|for|do|array|begin|end|read|write|writeln|of
punctuator [\[\]\(\),;:\.]
Arithmetic_operators [+|\-|\*|/|\%]
Relational_operators "="|"<>"|"<"|">"|"<="|">="
Boolean_operators [and|or|not]
identifier [a-zA-Z][a-zA-Z0-9]*
Number "-"?[0-9]+
printStatement \".*\"
%%

{keywords} {
    addToken(yytext, "Keyword");
    if(strcmp(yytext, "program") == 0){
        // printf("Progrrwfwefewfam %d",strcmp(yytext, "program"));
        return PROGRAM;
    }
        
    if(strcmp(yytext, "integer") == 0){
        printf("integer");
        return INTEGER;
    }
    if(strcmp(yytext, "Integer") == 0){
        return INTEGER;
    }
    if(strcmp(yytext, "real") == 0){
        return REAL;
    }
    if(strcmp(yytext, "boolean") == 0){
        return BOOLEAN;
    }
    if(strcmp(yytext, "char") == 0){
        return CHAR;
    }
    if( strcmp(yytext, "var") == 0){
        printf("var");
        return VAR;
    }
    if(strcmp(yytext, "to") == 0){
        return TO;
    }
    if(strcmp(yytext, "downto") == 0){
        return DOWNTO;
    }
    if( strcmp(yytext, "if") == 0){
        return IF;
    }
    if(strcmp(yytext, "then") == 0){
        return THEN;
    }
    if(strcmp(yytext, "else") == 0){
        return ELSE;
    }
    if(strcmp(yytext, "while") == 0){
        return WHILE;
    }
    if(strcmp(yytext, "for") == 0){
        return FOR;
    }
    if(strcmp(yytext, "do") == 0){
        return DO;
    }
    if(strcmp(yytext, "array") == 0){
        return ARRAY;
    }
    // if(strcmp(yytext, "and") == 0){
    //     return AND;
    // }
    // if(yytext == "or"){
    //     return OR;
    // }
    // if(yytext == "not"){
    //     return NOT;
    // }
    if(strcmp(yytext, "begin") == 0){
        return BEGINI;
    }
    if(strcmp(yytext, "end") == 0){
        return END;
    }
    if(strcmp(yytext, "read") == 0){
        return READ;
    }
    if(strcmp(yytext, "write") == 0 ){
        return WRITE;
    }
    if(strcmp(yytext, "writeln") == 0 ){
        return WRITELN;
    }
    if(strcmp(yytext, "of") == 0){
        return OF;
    }

}
{printStatement} {
    printf("Print Statement");
  return PrintStatement;
}
"." { //printf("DOT");

return DOT;}
"//".* {
    // printf("Comment %s\n",yytext);
    }
{punctuator} {
    addToken(yytext, "Punctuator");
    if(strcmp(yytext,"[")==0){
    return '[';
    }
    if(strcmp(yytext,"]")==0){
    return ']';
    }
    if(strcmp(yytext,"(")==0){
    return '(';
    }
    if(strcmp(yytext,")")==0){
    return ')';
    }
    if(strcmp(yytext,";")==0){
    return ';';
    }
    if(strcmp(yytext,":")==0){
    return ':';
    }
    if(strcmp(yytext,",")==0){
    return ',';
    }
    if(strcmp(yytext,".")==0){
        printf("egw");
    return '.';
    }

    printf("Punctuator %s\n",yytext);
    return PUNCTUATOR;
}

{Arithmetic_operators} {
    addToken(yytext, "Arithmetic Operators");
        return ARITHMETIC_OPERATOR;

}
{Relational_operators} {
     if(strcmp(yytext,"=")==0){
    return '=';
    }
    printf("Relational Operators %s\n",yytext);
    addToken(yytext, "Relational Operators");
    return RELATIONAL_OPERATOR;
}
{Boolean_operators} {
    addToken(yytext, "Boolean Operators");
    return BOOLEAN_OPERATOR;
}

{identifier} {
    addToken(yytext, "Identifier");
    printf("Identifier %s\n",yytext);
    return ID;
}
{Number} {
    addToken(yytext, "Number");
    printf("Number %s\n",yytext);
    return NUMBER;
}

[\t ] ;
\n {
    lineNum++;
}

. ;

%%

// int main() {
//     extern FILE *yyin;
//     FILE *code = fopen("code.txt", "r");
//     yyin = fopen("code.txt", "r+");
//     yylex();
//     fclose(yyin);
//     printf("Total Tokens: %d\n", maxTokens);
//     for (int i = 0; i < maxTokens; i++) {
//         printf("Line %d: Token '%s' - Type '%s'\n", tokenArray[i].lineNumber, tokenArray[i].token, tokenArray[i].tokenType);
//     }
//     free(tokenArray);
//     return 0;
// }
