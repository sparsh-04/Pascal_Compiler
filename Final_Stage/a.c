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
            printf(" initial ---> ");
            printf(line);
            
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
                    pos[temppos++] = '*';
                    pos[temppos++] = 'd';
                    pos[temppos++] = ' ';
                }
                pos[temppos++] = '"';
                pos[temppos]   = ',';
            }
            

            strncpy(final, "bool ", 4);

            printf(" modified ---> ");
            printf(line);
            strcpy(final,line);
            printf("<--");
//printf("%d %d %d ",number,D,KLNSDKJKL) ;

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