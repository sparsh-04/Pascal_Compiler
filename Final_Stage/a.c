#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main() {
    FILE *pascalFile = fopen("code.txt", "r");
    FILE *cFile = fopen("cCode.txt", "w");
    int beginC = 0;
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
                if((pos = strstr(line, "array")) != NULL){
                    pos = strchr(line, ':');
                    int first = 0;
                    int last = 0;
                    for(int j=0;j<strlen(line);j++){
                        if(line[j]=='['){
                            // line[j] = '[';
                            while(line[j++]==" ");
                            int temp = 0;
                            while(line[j]>='0' && line[j]<='9') {
                                temp *=10; 
                                temp += line[j] - '0';
                                j++;
                            }
                            first = temp;
                            while(line[j++]==" " || line[j++]=='.');
                            temp = 0;
                            while(line[j]>='0' && line[j]<='9') {
                                temp *=10; 
                                temp += line[j] - '0';
                                j++;
                            }
                            last  = temp;
                            printf("temp: %d %d\n", first,last);
                        }

                    }
                    int j=0;
                    for(;j<strlen(line);j++){
                        if(line[j]==':'){
                            break;
                        }
                    
                    }
                        char te[100] ;
                        memset(te, 0, sizeof(te));
                        strncpy(te,line, j-1);
                        // printf("final: %s\n", final);
                        sprintf(final, "int %s[%d];", te, last-first);
                        printf("final: %s\n", final);
                }
                else if((pos = strstr(line, "integer")) != NULL){
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
                else if((pos = strstr(line, "char")) != NULL){
                    pos = strchr(line, ':');
                    strncpy(final, "char ", 4);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                }
                else if((pos = strstr(line, "begin")) != NULL){
                    strcpy(final, "");
                    break;
                sprintf(final, "%s", final);
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
                    if(beginC)
                    strcpy(final, "{");
                    beginC = 1;
                }
        if((pos = strstr(line, "end;")) != NULL)
            strcpy(final, "}");
        if((pos = strstr(line, "end.")) != NULL)
            strcpy(final, "}");
        if((pos = strstr(line, ":=")) != NULL){
            strncpy(pos, "= ", 2);
            strcpy(final, line);
        }
        if((pos = strstr(line,"if")) != NULL){
            strncpy(pos, "if", 2);
            strcat(pos, " ");
        }
        if((pos = strstr(line, "write")) != NULL){
            strncpy(pos, "printf", 5);
        }

        if((pos = strstr(line, "read(")) != NULL)
            strncpy(pos, "scanf ", 6);


        fputs(final, cFile);
        fputs("\n", cFile);
        strcpy(final, "");
    }

    fclose(pascalFile);
    fclose(cFile);

    printf("Conversion completed. The C code has been written to cCode.txt\n");

    return 0;
}