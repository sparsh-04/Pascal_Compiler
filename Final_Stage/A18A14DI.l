%option noyywrap
%option yylineno
%option caseless
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include <ctype.h>

#define YY_SKIP_YYWRAP

int lineNum = 0;
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
chara ['].[']
digit [0-9]
BOOL 0|1
float {digit}+\.{digit}+
%%

{keywords} {

    addToken(yytext, "Keyword");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }
    if(strcmp(yytext, "program") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return PROGRAM;
    }
        
    if(strcmp(yytext, "integer") == 0){
        strcpy(yylval.node_obj.name,"int");
        return INTEGER;
    }
    if(strcmp(yytext, "Integer") == 0){
        strcpy(yylval.node_obj.name,"int");
        return INTEGER;
    }
    if(strcmp(yytext, "real") == 0){
        strcpy(yylval.node_obj.name,"real");
        return REAL;
    }
    if(strcmp(yytext, "boolean") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return BOOLEAN;
    }
    if(strcmp(yytext, "char") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return CHAR;
    }
    if( strcmp(yytext, "var") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        
        return VAR;
    }
    if(strcmp(yytext, "to") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return TO;
    }
    if(strcmp(yytext, "downto") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return DOWNTO;
    }
    if( strcmp(yytext, "if") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return IF;
    }
    if(strcmp(yytext, "then") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return THEN;
    }
    if(strcmp(yytext, "else") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return ELSE;
    }
    if(strcmp(yytext, "while") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return WHILE;
    }
    if(strcmp(yytext, "for") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return FOR;
    }
    if(strcmp(yytext, "do") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return DO;
    }
    if(strcmp(yytext, "array") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return ARRAY;
    }
    if(strcmp(yytext, "begin") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return BEGINI;
    }
    if(strcmp(yytext, "end") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return END;
    }
    if(strcmp(yytext, "read") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return READ;
    }
    if(strcmp(yytext, "write") == 0 ){
        strcpy(yylval.node_obj.name,(yytext));
        return WRITE;
    }
    if(strcmp(yytext, "of") == 0){
        strcpy(yylval.node_obj.name,(yytext));
        return OF;
    }

}
{printStatement} {
    strcpy(yylval.node_obj.name,(yytext));
   addToken(yytext, "Punctuator");
  return PrintStatement;
}
{float} {
    addToken(yytext, "Float Number");
    // printf("Float Number %s\n",yytext);
    strcpy(yylval.node_obj.name,(yytext));
    return REAL_NUM;

}
"//".* {
    // printf("Comment %s\n",yytext);
    }
{punctuator} {
    addToken(yytext, "Punctuator");
    if(strcmp(yytext,"[")==0){
    strcpy(yylval.node_obj.name,(yytext));
    return '[';
    }
    if(strcmp(yytext,"]")==0){
    strcpy(yylval.node_obj.name,(yytext));
    return ']';
    }
    if(strcmp(yytext,"(")==0){
    strcpy(yylval.node_obj.name,(yytext));
    return '(';
    }
    if(strcmp(yytext,")")==0){
    strcpy(yylval.node_obj.name,(yytext));
    return ')';
    }
    if(strcmp(yytext,";")==0){
    strcpy(yylval.node_obj.name,(yytext));
    return ';';
    }
    if(strcmp(yytext,":")==0){
    strcpy(yylval.node_obj.name,(yytext));
    return ':';
    }
    if(strcmp(yytext,",")==0){
    strcpy(yylval.node_obj.name,(yytext));
    return ',';
    }
    if(strcmp(yytext,".")==0){
    strcpy(yylval.node_obj.name,(yytext));
    return '.';
    }

    return PUNCTUATOR;
}

{Arithmetic_operators} {
    addToken(yytext, "Arithmetic Operators");
        if(strcmp(yytext,"+")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return PLUS;
        }
        if(strcmp(yytext,"-")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return MINUS;
        }
        if(strcmp(yytext,"*")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return MUL;
        }
        if(strcmp(yytext,"%")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return MOD;
        }
        if(strcmp(yytext,"/")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return DIV;
        }

}
{Relational_operators} {
    addToken(yytext, "Relational Operators");
    if(strcmp(yytext,":=")==0){
        strcpy(yylval.node_obj.name,(yytext));
        return AssignOp;
    }
     if(strcmp(yytext,"=")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return EQ;
    }
    if(strcmp(yytext,"<>")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return NE;
    }
    if(strcmp(yytext,">")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return GR;
    }
    if(strcmp(yytext,"<")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return LESS;
    }
     if(strcmp(yytext,">=")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return LE;
    }
    if(strcmp(yytext,"<=")==0){
            strcpy(yylval.node_obj.name,(yytext));
            return GE;
    }

    
}
{Boolean_operators} {
    addToken(yytext, "Boolean Operators");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }
    if(strcmp(yytext,"and")==0){
        strcpy(yylval.node_obj.name,(yytext));
        return BOOLEAN_OPERATOR;
    }
    if(strcmp(yytext,"or")==0){
        strcpy(yylval.node_obj.name,(yytext));
        return BOOLEAN_OPERATOR;
    }
    if(strcmp(yytext,"not")==0){
        strcpy(yylval.node_obj.name,(yytext));
        return NOT;
    }
}

{identifier} {
    addToken(yytext, "Identifier");
    for(int i = 0; yytext[i]; i++) {
                    yytext[i] = tolower(yytext[i]);
                }    
    strcpy(yylval.node_obj.name,(yytext));
    return ID;
}

{Number} {
    addToken(yytext, "Number");
    strcpy(yylval.node_obj.name,(yytext));
    return NUMBER;
}
[-]?{digit}+\.{digit}{1,6}  {
    addToken(yytext, "Float Number");
    strcpy(yylval.node_obj.name,(yytext));
    return FLOAT_NUM; }

{chara} {
    addToken(yytext, "Character");
    strcpy(yylval.node_obj.name,(yytext));
    return CHARACTER;
}


[\t \r] ;
\n {
    lineNum++;
}

["].*["]  {
    addToken(yytext, "String");
    return STRING;
}



. {return yytext[0];} ;

%%