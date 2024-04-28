/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     BOOLEAN_OPERATOR = 258,
     PROGRAM = 259,
     INTEGER = 260,
     REAL = 261,
     BOOLEAN = 262,
     CHAR = 263,
     VAR = 264,
     TO = 265,
     DOWNTO = 266,
     IF = 267,
     THEN = 268,
     ELSE = 269,
     WHILE = 270,
     FOR = 271,
     DO = 272,
     ARRAY = 273,
     AND = 274,
     OR = 275,
     NOT = 276,
     BEGINI = 277,
     END = 278,
     READ = 279,
     WRITE = 280,
     WRITELN = 281,
     ID = 282,
     PUNCTUATOR = 283,
     ARITHMETIC_OPERATOR = 284,
     RELATIONAL_OPERATOR = 285,
     OF = 286,
     DOT = 287,
     NUMBER = 288,
     PrintStatement = 289,
     OpenB = 290,
     CloseB = 291,
     AssignOp = 292,
     STRING = 293,
     FLOAT_NUM = 294
   };
#endif
/* Tokens.  */
#define BOOLEAN_OPERATOR 258
#define PROGRAM 259
#define INTEGER 260
#define REAL 261
#define BOOLEAN 262
#define CHAR 263
#define VAR 264
#define TO 265
#define DOWNTO 266
#define IF 267
#define THEN 268
#define ELSE 269
#define WHILE 270
#define FOR 271
#define DO 272
#define ARRAY 273
#define AND 274
#define OR 275
#define NOT 276
#define BEGINI 277
#define END 278
#define READ 279
#define WRITE 280
#define WRITELN 281
#define ID 282
#define PUNCTUATOR 283
#define ARITHMETIC_OPERATOR 284
#define RELATIONAL_OPERATOR 285
#define OF 286
#define DOT 287
#define NUMBER 288
#define PrintStatement 289
#define OpenB 290
#define CloseB 291
#define AssignOp 292
#define STRING 293
#define FLOAT_NUM 294




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 95 "a.y"
{ 
	struct node { 
		char name[100]; 
		struct ast_node* nd;
	} node_obj; 
}
/* Line 1529 of yacc.c.  */
#line 134 "a.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

