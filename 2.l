%{
#include <stdio.h>
#include <math.h>
#include <string.h>

int num_records = 0;
int num_comments = 0;
int num_courses = 0;
float cgpa = 0.0;

char stud_id[1000];
char course_id[1000];
int units;
char grade[2];

struct course {
  char id[1000];
  int seen;
};

struct course courses[1000];

void init_course(char *id) {
  strcpy(courses[num_courses].id, id);
  courses[num_courses].seen = 0;
  num_courses++;
}

int find_course(char *id) {
  for (int i = 0; i < num_courses; i++) {
    if (strcmp(courses[i].id, id) == 0) {
      return i;
    }
  }
  return -1;
}

void update_cgpa(char grade[2]) {
    if(grade[0]=='A')
    cgpa += 10.0;
    else if(grade[0]=='A' && grade[1]=='-')
    cgpa += 8.0;
    else if(grade[0]=='B')
    cgpa += 6.0;
    else if(grade[0]=='B' && grade[1]=='-')
    cgpa += 4.0;
    else if(grade[0]=='C')
    cgpa += 2.0;
   
}
%}

%s STATE1
%s STATE2
%s STATE3
%s STATE4

%%

<INITIAL>{


"//".*          { num_comments++; }

"\$"             { BEGIN STATE1; }


[A-Z][A-Z0-9]*    { BEGIN STATE2; strcpy(stud_id, yytext); }

.|\n              { }


<STATE1>{


" "                { }

.|\n              { BEGIN INITIAL; }

}


<STATE2>{

[A-Z][A-Z0-9]*    { BEGIN STATE3; strcpy(course_id, yytext); }


.|\n              { BEGIN INITIAL; }
}



<STATE3>{



"[0-9]+"             { units = atoi(yytext); BEGIN STATE4; }


.|\n              { BEGIN INITIAL; }

}


<STATE4>{



[A-C]         { BEGIN INITIAL; grade[0] = yytext[0]; update_cgpa(grade[2]);
                        int idx = find_course(course_id);
                        if (idx == -1) init_course(course_id);
                        else courses[idx].seen++; }
[A-C][-]         { BEGIN INITIAL; grade[0] = yytext[0]; grade[1] = yytext[1]; update_cgpa(grade[2]);
                        int idx = find_course(course_id);
                        if (idx == -1) init_course(course_id);
                        else courses[idx].seen++; }

.|\n              { BEGIN INITIAL; }

}}
%%


int main() {
  FILE *data = fopen("data.txt", "r");
  FILE *input = fopen("input.txt", "r");
  FILE *output = fopen("output.txt", "w");

  if (!data || !input || !output) {
    printf("Error opening files\n");
    return 1;
  }

  yylex();

  fscanf(input, "%s", stud_id);

  int num_courses_seen = 0;
  for (int i = 0; i < num_courses; i++) {
    if (courses[i].seen > 0) {
      num_courses_seen++;
    }
  }

  cgpa /= num_courses * units; // Average grade points
  int rounded_cgpa = round(cgpa * 100);

  fprintf(output, "@%d@%d@%d@%d#", num_records, num_comments, num_courses_seen, rounded_cgpa);

  fclose(data);
  fclose(input);
  fclose(output);

  return 0;
}
