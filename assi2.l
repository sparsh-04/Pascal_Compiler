%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

%}

keywords program|integer|real|boolean|char|var|to|downto|if|else|while|for|do|array|and|or|not|begin|end|read|write
punctuator [\[\]\(\),;:]
operators [+|\-|\*|/|=|<>|<|>|<=|>=|and|or|not]
identifier [a-zA-Z][a-zA-Z0-9]*

%%

{keywords} {
    addToken(yytext, "Keyword");
}

{punctuator} {
    addToken(yytext, "Punctuator");
}

{operators} {
    addToken(yytext, "Operator");
}

{identifier} {
    addToken(yytext, "Identifier");
}

\n {
    lineNum++;
}

. ;

%%

int main() {
    extern FILE *yyin;
    FILE *code = fopen("code.txt", "r");
    yyin = fopen("code.txt", "r+");
    yylex();
    fclose(yyin);
    for (int i = 0; i < maxTokens; i++) {
        printf("Line %d: Token '%s' - Type '%s'\n", tokenArray[i].lineNumber, tokenArray[i].token, tokenArray[i].tokenType);
    }
    free(tokenArray);
    return 0;
}
