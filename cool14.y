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

%{

#define YYSTYPE char*

%}

%token <yint> NUM  
%token <ystr> IOBJ
%token <ystr> ITIPO
%token <ystr> CADENA
%token CLASS ELSE FALSE FI IF IN INHERITS ISVOID LET LOOP POOL THEN WHILE
%token CASE ESAC NEW OF NOT TRUE SELFTYPE SELF ITIPO TOBJ ASIG
%token '(' ')' '{' '}' '[' ']' ',' ';' '.' ':'
%left IGIG  MENIG MAYIG '<' '>' '¬'
%left '+' '-'
%left '*' '/'
/*%type <type> type_specifier
%type <ast> programa class feature expr
%type <ast> class_list feature_list expr_list formal_list
*/
%%

programa : class_list  {printf("Programa correcto\n");}
;

class_list	: class ';'
		| class ';' class_list
;

class 	: CLASS TOBJ '{' feature_list '}'
	| CLASS TOBJ INHERITS TOBJ '{' feature_list '}'
;

feature_list	: feature feature_list
		| feature 
		| /* vacio*/
;
feature	: IOBJ '(' formal_list ')' ':' TOBJ '{' expr '}'
	| IOBJ ':' TOBJ ASIG expr
	| IOBJ ':' TOBJ
;
formal_list	: IOBJ ':' TOBJ ','
		| IOBJ ':' TOBJ
		| /* vacio*/
;
expr_list	: expr expr_list ';'
		| expr ';'
;

expr_list_e	: expr expr_list_e
		| expr 
		| /*expresion con epsilon*/
;
/* Falta poner: expr [@TYPE].ID(expr,*)
* 		let [[ID:TYPE[<- expr],]]+ in expr
*		case expr of [[ID:TYPE=> expr;]]+ ESAC
*/
expr	: IOBJ ASIG expr
	| IOBJ '(' expr_list_e ')'
	//| IF expr THEN expr ELSE expr FI 
	//| WHILE expr LOOP expr POOL
	| '{' expr_list '}'
	| NEW TOBJ
	| ISVOID expr
	| exp_aditive
	| '¬' expr
	| exp_aditive '<' exp_aditive
	| exp_aditive '>' exp_aditive
	| exp_aditive MENIG exp_aditive
	| exp_aditive IGIG exp_aditive
	| NOT expr 
	| IOBJ
	| CADENA
	| TRUE
	| FALSE
;

exp_aditive :exp_aditive '+' term
										
	|exp_aditive '-' term			
	|term				
;

term	:term '*' factor		
	|term '/' factor		
	|factor		
;
;
factor	:'(' exp_aditive ')'		
	|IOBJ						
	|NUM
;
%% 

int main() {
   yyparse(); ...
}

yyerror (char *s)
{
  printf ("%s\n", s);
}

int yywrap()  
{  
   return 1;  
} 

