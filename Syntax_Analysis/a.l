%option noyywrap
%option yylineno
%option caseless
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "a.tab.h"
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

int yylex();

%}

keywords program|integer|real|boolean|char|var|to|downto|if|then|else|while|for|do|array|begin|end|read|write|writeln|of
punctuator [\[\]\(\),;:\.]
Arithmetic_operators [+|\-|\*|/|\%]
Relational_operators "="|"<>"|"<"|">"|"<="|">="|":="
Boolean_operators and|or|not
identifier [a-zA-Z_][a-zA-Z0-9_]*
Number [0-9]+
printStatement \".*\"
char ['].[']
%%

{keywords} {

    addToken(yytext, "Keyword");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }
    if(strcmp(yytext, "program") == 0){
        return PROGRAM;
    }
        
    if(strcmp(yytext, "integer") == 0){
        
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
   addToken(yytext, "Punctuator");
  return PrintStatement;
}

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
       
    return '.';
    }

    return PUNCTUATOR;
}

{Arithmetic_operators} {
    addToken(yytext, "Arithmetic Operators");
        if(strcmp(yytext,"+")==0){
            return '+';
        }
        if(strcmp(yytext,"-")==0){
            return '-';
        }
        if(strcmp(yytext,"*")==0){
            return '*';
        }
        if(strcmp(yytext,"%")==0){
            return '%';
        }
        if(strcmp(yytext,"/")==0){
            return '/';
        }
        return ARITHMETIC_OPERATOR;

}
{Relational_operators} {
        if(strcmp(yytext,":=")==0){
            return AssignOp;
        }
     if(strcmp(yytext,"=")==0){
    return '=';
    }
    
    addToken(yytext, "Relational Operators");
    return RELATIONAL_OPERATOR;
}
{Boolean_operators} {
    addToken(yytext, "Boolean Operators");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }
    return BOOLEAN_OPERATOR;
}

{identifier} {
    addToken(yytext, "Identifier");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }    
    return ID;
}
{Number} {
    addToken(yytext, "Number");
   
    return NUMBER;
}
[-]?{digit}+\.{digit}{1,6}  {
    addToken(yytext, "Float Number");
    return FLOAT_NUM; }

{char} {
return NUMBER;
}

["].*["]  {
    addToken(yytext, "String");
    return STRING;
}



. {return yytext[0];} ;

%%