/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    PROGRAM = 258,                 /* PROGRAM  */
    INTEGER = 259,                 /* INTEGER  */
    REAL = 260,                    /* REAL  */
    BOOLEAN = 261,                 /* BOOLEAN  */
    CHAR = 262,                    /* CHAR  */
    VAR = 263,                     /* VAR  */
    TO = 264,                      /* TO  */
    DOWNTO = 265,                  /* DOWNTO  */
    IF = 266,                      /* IF  */
    THEN = 267,                    /* THEN  */
    ELSE = 268,                    /* ELSE  */
    WHILE = 269,                   /* WHILE  */
    FOR = 270,                     /* FOR  */
    DO = 271,                      /* DO  */
    ARRAY = 272,                   /* ARRAY  */
    AND = 273,                     /* AND  */
    OR = 274,                      /* OR  */
    NOT = 275,                     /* NOT  */
    BEGINI = 276,                  /* BEGINI  */
    END = 277,                     /* END  */
    READ = 278,                    /* READ  */
    WRITE = 279,                   /* WRITE  */
    WRITELN = 280,                 /* WRITELN  */
    ID = 281,                      /* ID  */
    PUNCTUATOR = 282,              /* PUNCTUATOR  */
    ARITHMETIC_OPERATOR = 283,     /* ARITHMETIC_OPERATOR  */
    RELATIONAL_OPERATOR = 284,     /* RELATIONAL_OPERATOR  */
    BOOLEAN_OPERATOR = 285,        /* BOOLEAN_OPERATOR  */
    OF = 286,                      /* OF  */
    DOT = 287,                     /* DOT  */
    NUMBER = 288,                  /* NUMBER  */
    PrintStatement = 289,          /* PrintStatement  */
    OpenB = 290,                   /* OpenB  */
    CloseB = 291                   /* CloseB  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define PROGRAM 258
#define INTEGER 259
#define REAL 260
#define BOOLEAN 261
#define CHAR 262
#define VAR 263
#define TO 264
#define DOWNTO 265
#define IF 266
#define THEN 267
#define ELSE 268
#define WHILE 269
#define FOR 270
#define DO 271
#define ARRAY 272
#define AND 273
#define OR 274
#define NOT 275
#define BEGINI 276
#define END 277
#define READ 278
#define WRITE 279
#define WRITELN 280
#define ID 281
#define PUNCTUATOR 282
#define ARITHMETIC_OPERATOR 283
#define RELATIONAL_OPERATOR 284
#define BOOLEAN_OPERATOR 285
#define OF 286
#define DOT 287
#define NUMBER 288
#define PrintStatement 289
#define OpenB 290
#define CloseB 291

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
