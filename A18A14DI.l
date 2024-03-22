%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdbool.h> 
typedef struct Courses {
  char data;
  int credit;
  int grade;
  struct Courses* children[500];
  bool isleaf;
} Courses;

Courses * makeTree(char data) {
  Courses * node = (Courses *)malloc(sizeof(Courses));
  node->data = data;
  for (int i=0; i<50; i++)
        node->children[i] = NULL;
  // node->credit = credit;
  // node->grade = grade;
  node->isleaf = 0;
  return node;
}

Courses* insert(Courses * root, char *word, int credit, int grade) {
  Courses* temp = root;
  
  for (int i=0; word[i] != '\0'; i++) {
    int idx = (int) word[i] - '0';
   if (temp->children[idx] == NULL) {
      temp->children[idx] = makeTree(word[i]);
    }
    temp = temp->children[idx];
  }
  temp->credit = credit;
  temp->grade = grade;
  temp->isleaf = 1;
  return root;
}


Courses* search(Courses * root, char word[]) {
  Courses* temp = root;
  for (int i=0; word[i] != '\0'; i++) {
    int idx = (int) word[i] - '0';
    if (temp->children[idx] == NULL) {
      return NULL;
    }
    temp = temp->children[idx];
  }
  if (temp != NULL && temp->isleaf) {
    return temp;
  }
  return NULL;
}
int num = 0;
int w = 0;
int num_comments = 0;
char stud_id[1000];
bool correct_Student = 0;
char course_ID[1000];
int course_Count = 0;
int course_Credit = 0;
int course_Grade = 0;
int total_Course_Credit = 0;
int total_Course_Grade = 0;
int num_records = 0;
int isRecordValid = -1;
Courses* root;
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
%s WaitForStudentID
%s WaitForCourse

%s CourseOrDollar


%%
stop {yyterminate();}
"//".*          { num_comments++; }
\$ { BEGIN(StudentID);
  isRecordValid = 1;}

<StudentID>" "* {  }

<StudentID>{Alphanumeric} { 
  if (strcmp(yytext,stud_id) == 0)
    correct_Student = 1;
  else correct_Student = 0;
    BEGIN(WaitForCourse);}
<StudentID>[^{Alphanumeric}] {BEGIN(INITIAL);}
<WaitForCourse>" "* { }
<WaitForCourse>< { BEGIN(Course);}
<WaitForCourse>. { BEGIN(INITIAL);}
<Course>" "* {}
<Course>{Alphanumeric} {
  BEGIN(Credit); 
  memset(course_ID, '\0', sizeof(char)*1000);
  strcpy(course_ID,yytext);}
<Course>\n {BEGIN(INITIAL);}
<Course>[^{Alphanumeric}" "] {BEGIN(CourseOrDollar); }

<Credit>" "* { }
<Credit>[2-4]" " {
  
  if(correct_Student)
    course_Credit = atoi(yytext);
  else 
    course_Credit = 0;
    BEGIN(Grade);} 

<Credit>. {
 BEGIN(CourseOrDollar);
}

<Grade>" "* { } //
<Grade>[ABC][^->" "] {
  BEGIN(CourseOrDollar);
}//<Grade>[A-Za-z][A-Za-z] {BEGIN(CourseOrDollar);}

<Grade>[AB][-][^>" "] {
  BEGIN(CourseOrDollar);
}

<Grade>[ABC]" "* {
  
  if(correct_Student && yytext[0]=='A')
    course_Grade = 10;
  else if(correct_Student && yytext[0]=='B')
    course_Grade = 6;
  else if(correct_Student && yytext[0]=='C')
    course_Grade = 2;
  else course_Grade = 0;
    BEGIN(CourseEnd);} 


<Grade>B-|A- {

  if(correct_Student && yytext[0]=='A' && yytext[1]=='-')
    course_Grade = 8;
  else if(correct_Student && yytext[0]=='B' && yytext[1]=='-')
    course_Grade = 4;
  else course_Grade = 0;
  BEGIN(CourseEnd);} 

<Grade>[^" "] {
  BEGIN(CourseOrDollar);
}//<Grade>[^ABC" "] {BEGIN(CourseOrDollar); }
<CourseEnd>" "* {
  
 }

<CourseEnd>\> {
 
  if(correct_Student && search(root,course_ID) == NULL){
    root = insert(root,course_ID,course_Credit,course_Grade);
    course_Count++;
    total_Course_Grade+= course_Credit*course_Grade;
    total_Course_Credit +=course_Credit;
    
    }
  else if(correct_Student && search(root,course_ID) != NULL){
    Courses * temp = search(root,course_ID);
    total_Course_Grade -= temp->credit*temp->grade;
    total_Course_Credit -= temp->credit;
    total_Course_Credit += course_Credit;
    temp->grade = course_Grade;
    temp->credit = course_Credit;
    total_Course_Grade += temp->credit*temp->grade;
   
  }
  if(isRecordValid == 1){
  num_records++;
  isRecordValid = -1;
  }
course_Credit=0;
course_Grade = 0;
BEGIN(CourseOrDollar);
}
<CourseEnd>. {
    BEGIN(CourseOrDollar);
}
<CourseOrDollar>\< {
  BEGIN(Course);}

<CourseOrDollar>" "* { }

<CourseOrDollar>\n { 
  BEGIN(INITIAL);}
[\t]+
\n {BEGIN(INITIAL);}
. 
%%

int main()
{
   
    extern FILE *yyin;
  FILE *data = fopen("data.txt", "r");
  FILE *input = fopen("input.txt", "r");
  FILE *output = fopen("output.txt", "w");

  if (!data || !input || !output) {
    
    return 1;
  }
  memset(stud_id, '\0', sizeof(char)*1000);
  root = makeTree('\0');
  fscanf(input, "%s", stud_id);
 
    yyin = fopen("data.txt", "r+");
    yylex();
    fclose(yyin);

total_Course_Grade = total_Course_Grade*100;
float gpa;
int cgpa;

if(!total_Course_Credit){
  cgpa = 0;
}else{
  gpa = (float)total_Course_Grade/total_Course_Credit;
  cgpa = round(gpa);
}
  fprintf(output, "@%d@%d@%d@%d#", num_records,num_comments, course_Count, cgpa);
  fclose(data);
  fclose(input);
  fclose(output);
return 0;
}
