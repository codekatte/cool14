

%{

/*
*	Copyright (C) 2010 Agustin Ramirez Hernandez
*
*	This program is free software: you can redistribute it and/or modify
*	it under the terms of the GNU General Public License as published by
*	the Free Software Foundation, either version 3 of the License, or (at
*	your option) any later version.
*	This program is distributed in the hope that it will be useful, but
*	WITHOUT ANY WARRANTY; without even the implied warranty of
*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
*	General Public License for more details.
*	You should have received a copy of the GNU General Public License
*	along with this program. If not, see http://www.gnu.org/licenses/.
*
*/

#include <stdio.h>

static int num_linea=1;
 
%}

%token <yint> NUM  
%token <ystr> IOBJ
%token <ystr> ITIPO
%token <ystr> CADENA
%token CLASS ELSE FALSE FI IF IN INHERITS LET LOOP POOL THEN WHILE
%token CASE ESAC NEW OF NOT TRUE SELFTYPE SELF ASIG EQMA ERROR
%token '(' ')' '{' '}' '[' ']' ',' ';' '.' ':'
%right ASIG
%left NOT
%left MEQ '<' EQ 
%left '+' '-'
%left '*' '/'
%left ISVOID
%left '~'
%left '@'
%left '.'
%%

programa : class_list
;

class_list	:  class class_list ';'
		|  class ';'
;

class 	: CLASS ITIPO '{' feature_list '}' ';'
	| CLASS ITIPO INHERITS ITIPO '{' feature_list '}' ';'
;

feature_list	: feature feature_list 
		| feature 
		| /* vacio*/
;
feature	: IOBJ '(' formal_list ')' ':' ITIPO '{' expr '}'
	| IOBJ feature_tob
;

feature_tob	: ':' ITIPO ASIG expr
		| ':' ITIPO
;

formal_list	: IOBJ ':' ITIPO ','
		| IOBJ ':' ITIPO
		| /* vacio*/
;

expr	: IOBJ ASIG expr
	| exp_dispatch
	| IOBJ '(' expr_list_e ')'
	| WHILE expr LOOP expr POOL 
	| IF expr THEN expr ELSE expr FI 
	| expr_block
	//| LET IOBJ ':' ITIPO IN expr
	| CASE expr OF id_type_plus ESAC
	| NEW ITIPO
	| ISVOID expr
	| expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| '~' expr
	| expr '<' expr
	| expr MEQ expr
	| expr EQ expr
	| NOT expr
	| '(' expr ')'
	| CADENA
	| NUM
	| TRUE
	| FALSE
;

exp_dispatch: expr '@' ITIPO '.' IOBJ '(' expr_list_e ')'
	    | expr '.' IOBJ '(' expr_list_e ')'
;

expr_list	: expr_list expr ';' 
		| expr ';'
;
expr_block	: '{' expr_list '}'
;

expr_list_e	: expr ',' expr_list_e  
		| expr
		|
;
id_type_plus	: IOBJ ':' ITIPO EQMA expr ';'
		| id_type_plus IOBJ ':' ITIPO EQMA expr ';'
;
/*
id_plus : IOBJ ':' ITIPO id_plus_a  
;

id_plus_a : ASIG expr
	| ',' id_plus
;*/
%% 


int main() {
  yyparse();
  return 0;
}
             

int yyerror(s) 
char *s
{
    printf("Error L: %d %s\n",linea,m);
    return 0;
}

