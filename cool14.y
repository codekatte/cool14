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
%token CASE ESAC NEW OF NOT TRUE SELFTYPE SELF ASIG
%token '(' ')' '{' '}' '[' ']' ',' ';' '.' ':'
%left ASIG
%left NOT
%left LEQ GEQ EQ NEQ '<' '>' '¬'
%left '+' '-'
%left '*' '/'
%left ISVOID
%left '@'
%left '.'

/*%type <type> type_specifier
%type <ast> programa class feature expr
%type <ast> class_list feature_list expr_list formal_list
*/
%%

programa : class_list  {printf("Programa correcto\n");}
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

expr_list	: expr feature_list ';' 
		| expr ';'
;

expr_list_e	: expr ','
		| expr ',' expr_list_e
		| /* expresion con epsilon */
;
/* Falta poner:
* 		let [[ID:TYPE[<- expr],]]+ in expr
*		case expr of [[ID:TYPE=> expr;]]+ ESAC
*/

expr	: exp_asigna
	| IOBJ '(' expr_list_e ')' // genera un conflicot de recuccion
	| IF exp_simple THEN expr ELSE expr FI 
	| exp_bloques
	| exp_dispatch 
	| WHILE exp_simple LOOP expr POOL
	| NEW ITIPO
	| ISVOID expr
	| exp_simple
	| '¬' expr
	| NOT expr
	| CADENA
	| TRUE
	| FALSE
;

exp_bloques: '{' expr_list '}'
;
exp_dispatch: expr '@' ITIPO '.' IOBJ '(' expr_list_e ')'
	    | expr '.' IOBJ '(' expr_list_e ')'
;
exp_asigna	: IOBJ ASIG exp_aditive
		| IOBJ ASIG CADENA
;

exp_simple:     exp_aditive LEQ exp_aditive
		|exp_aditive '<' exp_aditive
		|exp_aditive '>' exp_aditive
		|exp_aditive GEQ exp_aditive
		|exp_aditive EQ exp_aditive
		|exp_aditive NEQ exp_aditive
		|exp_aditive
;

exp_aditive :exp_aditive '+' term						
	|exp_aditive '-' term			
	|term				
;

term	:term '*' factor		
	|term '/' factor		
	|factor		
;
factor	:'(' exp_simple ')'		
	|IOBJ						
	|NUM
;

%% 

int main(int argc,char **argv)
{
    //init_stringpool(10000); /* String table */
    yyparse();
    return type_check(ast_root);
}
int yyerror(char *m) {
    fprintf(stderr,"line %d: %s\n",lineno,m);
    return 0;
}

