%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>

int num = 0;
int w = 0;
int num_comments = 0;
char stud_id[1000];
bool correct_Student = 0;
int course_Count = 0;
int course_Credit = 0;
int course_Grade = 0;
int total_Course_Credit = 0;
int total_Course_Grade = 0;
int num_records = 0;

%}
letter [a-zA-Z]
Alphanumeric [A-Z]+[0-9]+
digit [0-9]
INTEGER [+-]?[1-9][0-9]*|"0"
FLOAT [+-]?[1-9][0-9]*\.[0-9]+|[+-]?0\.[0-9]+

%s STATE1
%s Course
%s Grade
%s Credit
%s CourseEnd
%s StudentID
%s CourseOrDollar
%%
stop {yyterminate();}
"//".*          { num_comments++; }
\$ {printf("start "); BEGIN(StudentID); num_records++;}
<StudentID>{Alphanumeric} { if (strcmp(yytext,stud_id) == 0)
                            correct_Student = 1;
                            else correct_Student = 0;
                            printf(" xxxx ");}
<StudentID>" " { }
<StudentID>< { BEGIN(Course);}
<STATE1>\n {printf("New ");BEGIN(INITIAL);}
<Course>{Alphanumeric} {printf(" id ");BEGIN(Credit);}
<Credit>[2-4] {printf(" credit ");if(correct_Student)
                                    course_Credit = atoi(yytext);
                                    else course_Credit = 0;
                                    // printf("course_Credit %d ",course_Credit);
                                     BEGIN(Grade);} 
<Credit>" " { } 
<Grade>" " { } 

<Grade>A|B|C {printf(" grade ");
                                      if(correct_Student && yytext[0]=='A')
                                        course_Grade = 10;
                                      else if(correct_Student && yytext[0]=='B')
                                        course_Grade = 6;
                                      else if(correct_Student && yytext[0]=='C')
                                        course_Grade = 2;
                                      else course_Grade = 0;
                                       BEGIN(CourseEnd);} 
<Grade>B-|A- {printf(" grade ");
                                      if(correct_Student && yytext[0]=='A' && yytext[1]=='-')
                                        course_Grade = 8;
                                      else if(correct_Student && yytext[0]=='B' && yytext[1]=='-')
                                        course_Grade = 4;
                                      else course_Grade = 0;
                                      BEGIN(CourseEnd);}
<CourseEnd>" " {}

<CourseEnd>\> {printf(" end ");if(correct_Student){

                                            course_Count++;
                                            total_Course_Grade+= course_Credit*course_Grade;
                                            total_Course_Credit +=course_Credit;
                                            // printf("total_Course_Grade %d",course_Credit*course_Grade);
                                            }
                                            course_Credit=0;
                                            course_Grade = 0;
                                             BEGIN(CourseOrDollar);}
<CourseOrDollar>\< { BEGIN(Course);}
<CourseOrDollar>\$ { BEGIN(StudentID);}
<CourseOrDollar>\n { BEGIN(INITIAL);}


%%
int main()
{
    extern FILE *yyin;
  FILE *data = fopen("data.txt", "r");
  FILE *input = fopen("input.txt", "r");
  FILE *output = fopen("output.txt", "w");

  if (!data || !input || !output) {
    printf("Error opening files\n");
    return 1;
  }
  memset(stud_id, '\0', sizeof(char)*1000);

  fscanf(input, "%s", stud_id);
  printf("Student ID: %s\n", stud_id);
    yyin = fopen("data.txt", "r+");
        yylex();
        fclose(yyin);
printf("Number of Credits: %d\n", total_Course_Credit);
printf("Number of Courses: %d\n", course_Count);
printf("Total Grade: %d\n", total_Course_Grade);
total_Course_Grade = total_Course_Grade*100;
float gpa = (float)total_Course_Grade/total_Course_Credit;
int cgpa = round(gpa);


printf("GPA: %d\n", cgpa);
  fprintf(output, "@%d@%d@%d@%d#", num_records,num_comments, course_Count, cgpa);

  fclose(data);
  fclose(input);
  fclose(output);
return 0;

}