#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int sym_cnt = 0;
struct node
{
    char type[50];
    char name[50];
    char value[50];
} var_data;

struct node *symbol_table[100];

int main()
{
    FILE *pascalFile = fopen("code.txt", "r");
    FILE *cFile = fopen("b.c", "w");
    int beginC = 0;
    if (!pascalFile)
    {
        printf("Unable to open Pascal file\n");
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
        if ((pos = strstr(line, "program")) != NULL)
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
            if ((pos = strstr(line, "var")) != NULL)
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
                        struct node *temp = (struct node *)malloc(sizeof(struct node));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Integer");
                        symbol_table[sym_cnt++] = temp;
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
                            struct node *temp = (struct node *)malloc(sizeof(struct node));
                            sprintf(temp->name, word);
                            sprintf(temp->type, "Integer");
                            symbol_table[sym_cnt++] = temp;
                            wordIndex = 0;
                            memset(word, 0, sizeof(word));
                        }
                    }
                    if (wordIndex > 0)
                    {
                        word[wordIndex] = '\0';
                        struct node *temp = (struct node *)malloc(sizeof(struct node));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Integer");
                        symbol_table[sym_cnt++] = temp;
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
                            struct node *temp = (struct node *)malloc(sizeof(struct node));
                            memset(temp->name, 0, sizeof(temp->name));
                            sprintf(temp->name, word);
                            sprintf(temp->type, "Float");
                            symbol_table[sym_cnt++] = temp;
                            wordIndex = 0;
                            memset(word, 0, sizeof(word));
                        }
                    }
                    if (wordIndex > 0)
                    {
                        // word[wordIndex] = '\0';
                        struct node *temp = (struct node *)malloc(sizeof(struct node));
                        memset(temp->name, 0, sizeof(temp->name));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Float");
                        symbol_table[sym_cnt++] = temp;
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
                            struct node *temp = (struct node *)malloc(sizeof(struct node));
                            sprintf(temp->name, word);
                            sprintf(temp->type, "Boolean");
                            symbol_table[sym_cnt++] = temp;
                            wordIndex = 0;
                            memset(word, 0, sizeof(word));
                        }
                    }
                    if (wordIndex > 0)
                    {
                        word[wordIndex] = '\0';
                        struct node *temp = (struct node *)malloc(sizeof(struct node));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Boolean");
                        symbol_table[sym_cnt++] = temp;
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
                            struct node *temp = (struct node *)malloc(sizeof(struct node));
                            sprintf(temp->name, word);
                            sprintf(temp->type, "Char");
                            symbol_table[sym_cnt++] = temp;
                            wordIndex = 0;
                            memset(word, 0, sizeof(word));
                        }
                    }
                    if (wordIndex > 0)
                    {
                        word[wordIndex] = '\0';
                        struct node *temp = (struct node *)malloc(sizeof(struct node));
                        sprintf(temp->name, word);
                        sprintf(temp->type, "Char");
                        symbol_table[sym_cnt++] = temp;
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
            if((pos = strstr(line, "begin")) != NULL){
                    if(beginC)
                    strcpy(final, "{");
                    beginC = 1;
                }
        if((pos = strstr(line, "end;")) != NULL)
            strcpy(final, "}");
        else if((pos = strstr(line, "end.")) != NULL){
            strcpy(final, "");
            break;
        }
        else if((pos = strstr(line, "end")) != NULL){
            strcpy(final, "}");
        }
        if((pos = strstr(line, ":=")) != NULL){
            strncpy(pos, "= ", 2);
            strcpy(final, line);
        }
        if((pos = strstr(line,"if")) != NULL){
            strncpy(pos, "if", 2);
            strcat(pos, " ");
        }
        if((pos = strstr(line, "write")) != NULL){
            char* xyz=strstr(line,"\"");
            char pehla[50]={'\0'};

            if(xyz==NULL){
                char* com=strstr(line,",");
                char* bra=strstr(line,"(");
                int x=bra-line;
                int y=com-line;int i=0;
                while(x!=y-1){
                    pehla[i++]=bra[x+1];
                    x++;
                }
                printf("#####%s######",pehla);
            }
           
            int len = strlen(line);
            for(int j=len-2;j>=0;j--){
                line[j+1] = line[j];
            }
            strncpy(pos, "printf", 6);

            int comma = 0; //keep count of ','
            if(pos[7] != '"'){
                for(int i=0;pos[i]!= ')';i++){
                    if(pos[i] == ','){
                        comma++;
                    }
                }
                //extra characters '"",' and then '%d ' comma+1 times
                //total (comma+2)*3
                int push = (comma+1)*3 + 3;
                len = strlen(line);
                for(int j = len;j>=0;j--){
                    line[j+push] = line[j];
                }
                pos[7] = '"';
                int temppos = 8;
                
                while(comma-- > -1){
                    pos[temppos++] = '\%';
                    pos[temppos++] = 'd';
                    pos[temppos++] = ' ';
                }
                pos[temppos++] = '"';
                pos[temppos]   = ',';
                strncpy(pos, "printf(", 7);
            }
            strcpy(final,line);

            strncpy(pos, "printf", 5);
        }
        if((pos = strstr(line, "read")) != NULL){
            char var_temp[50];
            int cnt = 0;
            memset(var_temp, 0 , sizeof(var_temp));
            for(int i = pos-line+5;i<sizeof(line)/sizeof(char);i++){
                if(line[i]==')'){
                    break;
                }else{
                    var_temp[cnt++] = line[i];
                }
            }
            char typee[50];
            memset(typee, 0, sizeof(typee));
            for(int i=0;i<sym_cnt;i++){
                printf("l%sl l%sl\n",symbol_table[i]->name ,var_temp);
                if(symbol_table[i]->name == var_temp){
                    sprintf(typee, symbol_table[i]->type);
                    break;
                }
            }
            if(typee[0] == 'I'){
                sprintf(final,"scanf(\"%%d\",\"%s\")",var_temp);
            }else if(typee[0] == 'F'){
                sprintf(final,"scanf(\"%%f\",\"%s\")",var_temp);
            }else if(typee[0] == 'B'){
                sprintf(final,"scanf(\"%%d\",\"%s\")",var_temp);
            }else if(typee[0] == 'C'){
                sprintf(final,"scanf(\"%%c\",\"%s\")",var_temp);
            }
            printf("this is final: %s",typee);
            fputs(final, cFile);
            
        }
        if((pos=strstr(line,"else"))!=NULL){
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
        if((pos = strstr(line,"if"))!=NULL){
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
        if((pos=strstr(line,"while"))!=NULL){
        line[pos-line+5]='(';
        if((pos=strstr(line,"do"))!=NULL){
             line[pos-line-1]=')';
                for(int i=0;i<=1;i++)
                line[pos-line+i]='\0';

        }int j=0;
        while(line[j]!='\0')j++;
            strncpy(final,line,j);
        }
        if((pos=strstr(line,"for"))!=NULL){
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
    sprintf(final, "printf(\"%sThe Symbol table: %s\");\n", "\\t\\t\\t\\t", "\\n");
    fputs(final, cFile3);
    memset(final, 0, sizeof(final));
    memset(final, 0, sizeof(final));
    for(int i=0;i<sym_cnt;i++){

        if(symbol_table[i]->type[0] == 'I'){
            sprintf(final, "printf(\"Value of %s is %%d and is of type int %s \",%s);\n",symbol_table[i]->name,"\\n",symbol_table[i]->name);
            fputs(final, cFile3);
        }
        else if(symbol_table[i]->type[0] == 'B'){
            sprintf(final, "printf(\"Value of %s is %%d and is of type bool %s \",%s);\n",    symbol_table[i]->name,"\\n",symbol_table[i]->name);
            fputs(final, cFile3);
        }
        else if(symbol_table[i]->type[0] == 'C'){
            sprintf(final, "printf(\"Value of %s is %%c and is of type char %s \",%s);\n",    symbol_table[i]->name,"\\n",symbol_table[i]->name);
            fputs(final, cFile3);
        }
        else if(symbol_table[i]->type[0] == 'F'){
            sprintf(final, "printf(\"Value of %s is %%f and is of type float  %s \",%s);\n",    symbol_table[i]->name,"\\n",symbol_table[i]->name);
            fputs(final, cFile3);
        }
    }

    memset(final, 0, sizeof(final));
    sprintf(final, "return 0;\n}");
    
    fputs(final, cFile3);
    fclose(cFile2);
	//system("rm c.c");
    fclose(cFile3);
    fclose(pascalFile);
    system("gcc c.c -o output && ./output");
	system("rm output");
	//system("rm c.c");
    printf("Conversion completed. The C code has been written to c.c\n");
    return 0;
}
