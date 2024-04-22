Name of members: 
Kshitiz Agarwal 2021A7PS1818H
Sparsh Khandelwal 2021A7PS1320H
Rohan Chavan 2021A7PS2739H
Soumya Choudhury 2021A7PS2674H
Ayush Patel 2021A7PS2601H

How to run for Lexical Analysis:
flex a.l
gcc lex.yy.c
./a.out <filename.txt>

After ./a.out give a space and then write file name.
filename should be given as command line argument without <>.
Also the filename.txt should be in the same folder as the code file.

How to run for Syntax Analysis:
yacc -d a.y
flex a.l
cc y.tab.c lex.yy.c -ll
./a.out filename.txt

After ./a.out give a space and then write file name.
filename should be given as command line argument without <>.
Also the filename.txt should be in the same folder as the code file.