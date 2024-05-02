#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main() {
    FILE *pascalFile = fopen("code.txt", "r");
    FILE *cFile = fopen("cCode.txt", "w");

    if (!pascalFile) {
        printf("Unable to open Pascal file\n");
        return 1;
    }

    char line[256];
    char final[256];
    while (fgets(line, sizeof(line), pascalFile)) {
        // Convert the string line to lower case
        for(int i = 0; line[i]; i++){
            line[i] = tolower(line[i]);
        }
        memset(final, 0, sizeof(final));
        printf("%s\n", line);

        char *pos;
        if((pos = strstr(line, "program")) != NULL){
            strcpy(final, "#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <ctype.h>\nint main(){");
            fputs(final, cFile);
            fputs("\n", cFile);
            strcpy(final, "");
            continue;
        }

        if((pos = strstr(line, "var")) != NULL){
            while(fgets(line, sizeof(line), pascalFile)){
                for(int i = 0; line[i]; i++){
                    line[i] = tolower(line[i]);
                }
                memset(final, 0, sizeof(final));
            
                if((pos = strstr(line, "integer")) != NULL){
                    pos = strchr(line, ':');
                    strncpy(final, "int ", 4);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                }   
                else if((pos = strstr(line, "real")) != NULL){
                    pos = strchr(line, ':');
                    strncpy(final, "float ", 6);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                }
                else if((pos = strstr(line, "boolean")) != NULL){
                    pos = strchr(line, ':');
                    strncpy(final, "bool ", 4); // In C, boolean is typically represented as an int
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                }
                else if((pos = strstr(line, "begin")) != NULL){
                    strcpy(final, "");
                    break;
                }
                else{
                    strcpy(final, "");
                }

                fputs(final, cFile);
                fputs("\n", cFile);
                strcpy(final, "");

            }
        }
        if((pos = strstr(line, "begin")) != NULL){
                    printf("Found begin\n");
                    strcpy(final, "");
                }
        if((pos = strstr(line, "end;")) != NULL)
            strncpy(pos, "}   ", 4);

        if((pos = strstr(line, ":=")) != NULL)
            strncpy(pos, "= ", 2);

        if((pos = strstr(line, "write")) != NULL){
            strncpy(pos, "printf", 5);
            strncpy(final, "bool ", 4);
            // printf("Found write\n");
            
        }

        if((pos = strstr(line, "read(")) != NULL)
            strncpy(pos, "scanf ", 6);
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
        fputs(final, cFile);
        fputs("\n", cFile);
        strcpy(final, "");
    }

    fclose(pascalFile);
    fclose(cFile);

    printf("Conversion completed. The C code has been written to cCode.txt\n");

    return 0;
}