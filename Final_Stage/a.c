#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

struct node
{
    char type[50];
    char name[50];
    char value[50];
} var_data;

struct node symbol_table[100];

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
        printf("%s\n", line);

        char *pos;
        if ((pos = strstr(line, "program")) != NULL)
        {
            strcpy(final, "#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <ctype.h>\n#include <stdbool.h>\nint main(){");
            fputs(final, cFile);
            fputs("\n", cFile);
            strcpy(final, "");
            continue;
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
                            while (line[j++] == " " || line[j++] == '.')
                                ;
                            temp = 0;
                            while (line[j] >= '0' && line[j] <= '9')
                            {
                                temp *= 10;
                                temp += line[j] - '0';
                                j++;
                            }
                            last = temp;
                            printf("temp: %d %d\n", first, last);
                        }
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
                    // printf("final: %s\n", final);
                    sprintf(final, "int %s[%d];", te, last - first);
                    printf("final: %s\n", final);
                }
                else if ((pos = strstr(line, "integer")) != NULL)
                {
                    pos = strchr(line, ':');
                    strncpy(final, "int ", 4);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                    int n = sizeof(line) / sizeof(char);
                    char dec[100];
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
                    n = sizeof(dec) / sizeof(char);
                    cnt = 0;
                    char token[100];
                    for (int i = 0; i < n; i++)
                    {
                        if (dec[i] == ',')
                        {
                        }
                        else
                        {
                            token[cnt++] = dec[i];
                        }
                    }
                }
                else if ((pos = strstr(line, "real")) != NULL)
                {
                    pos = strchr(line, ':');
                    strncpy(final, "float ", 6);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                }
                else if ((pos = strstr(line, "boolean")) != NULL)
                {
                    pos = strchr(line, ':');
                    strncpy(final, "bool ", 4); // In C, boolean is typically represented as an int
                    strncat(final, line, pos - line);
                    strcat(final, ";");
                }
                else if ((pos = strstr(line, "char")) != NULL)
                {
                    pos = strchr(line, ':');
                    strncpy(final, "char ", 4);
                    strncat(final, line, pos - line);
                    strcat(final, ";");
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
        if ((pos = strstr(line, "begin")) != NULL)
        {
            printf("Found begin\n");
            if (beginC)
                strcpy(final, "{");
            beginC = 1;
        }
        if ((pos = strstr(line, "end;")) != NULL)
            strcpy(final, "}");
        else if ((pos = strstr(line, "end.")) != NULL)
        {
            strcpy(final, "");
            break;
        }
        else if ((pos = strstr(line, "end")) != NULL)
        {
            strcpy(final, "}");
        }
        if ((pos = strstr(line, ":=")) != NULL)
        {
            strncpy(pos, "= ", 2);
            strcpy(final, line);
        }
        if ((pos = strstr(line, "if")) != NULL)
        {
            strncpy(pos, "if", 2);
            strcat(pos, " ");
        }
        if ((pos = strstr(line, "write")) != NULL)
        {
            // printf(" initial ---> ");
            // printf(line);

            int len = strlen(line);
            for (int j = len - 2; j >= 0; j--)
            {
                line[j + 1] = line[j];
            }
            strncpy(pos, "printf", 6);

            int comma = 0; // keep count of ','
            if (pos[7] != '"')
            {
                for (int i = 0; pos[i] != ')'; i++)
                {
                    if (pos[i] == ',')
                    {
                        comma++;
                    }
                }
                // extra characters '"",' and then '%d ' comma+1 times
                // total (comma+2)*3
                int push = (comma + 1) * 3 + 3;
                len = strlen(line);
                for (int j = len; j >= 0; j--)
                {
                    line[j + push] = line[j];
                }
                pos[7] = '"';
                int temppos = 8;

                while (comma-- > -1)
                {
                    pos[temppos++] = '\%';
                    pos[temppos++] = 'd';
                    pos[temppos++] = ' ';
                }
                pos[temppos++] = '"';
                pos[temppos] = ',';
                strncpy(pos, "printf(", 7);
            }

            // printf(" modified ---> ");
            printf(line);
            strcpy(final, line);
            printf("<--");
            // printf("%d %d %d ",number,D,KLNSDKJKL) ;

            strncpy(pos, "printf", 5);
        }

        if ((pos = strstr(line, "read(")) != NULL)
            strncpy(pos, "scanf ", 6);
        if ((pos = strstr(line, "else")) != NULL)
        {
            if ((pos = strstr(line, "if")) != NULL)
            {
                line[pos - line + 2] = '(';
                if ((pos = strstr(line, "then")) != NULL)
                {
                    line[pos - line - 1] = ')';
                    for (int i = 0; i <= 3; i++)
                        line[pos - line + i] = '\0';
                }

                int i = 0;
                while (line[i] != '\0')
                    i++;
                line[i + 1] = '{';
                strncpy(final, line, i + 1);
            }
            else
            {
                strncpy(final, line, sizeof(line));
            }
        }
        if ((pos = strstr(line, "if")) != NULL)
        {
            line[pos - line + 2] = '(';
            if ((pos = strstr(line, "then")) != NULL)
            {
                line[pos - line - 1] = ')';
                for (int i = 0; i <= 3; i++)
                    line[pos - line + i] = '\0';
            }

            int i = 0;
            while (line[i] != '\0')
                i++;

            strncpy(final, line, i);
        }
        if ((pos = strstr(line, "while")) != NULL)
        {
            line[pos - line + 5] = '(';
            if ((pos = strstr(line, "do")) != NULL)
            {
                line[pos - line - 1] = ')';
                for (int i = 0; i <= 1; i++)
                    line[pos - line + i] = '\0';
            }
            int j = 0;
            while (line[j] != '\0')
                j++;
            strncpy(final, line, j);
        }
        fputs(final, cFile);
        fputs("\n", cFile);
        strcpy(final, "");
    }
    // strcpy(final, "");
    while (fgets(line, sizeof(line), cFile))
    {
        printf("AAA%s\n", line);
    }
    memset(final, 0, sizeof(final));
    sprintf(final, "FILE *file = fopen(\"code.txt\",\"r\");");
    fputs(final, cFile);

    // system("gcc b.c -o output.out && ./output.out");
    memset(final, 0, sizeof(final));

    memset(final, 0, sizeof(final));
    sprintf(final, "return 0;\n}");
    fputs(final, cFile);
    fclose(pascalFile);
    fclose(cFile);

    printf("Conversion completed. The C code has been written to cCode.txt\n");

    return 0;
}