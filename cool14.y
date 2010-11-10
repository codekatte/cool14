

%{


#include <stdio.h>
#define yywrap() 0	
#define YYSTYPE char*
int num_linea=1;
%}

%token NUM  
%token IOBJ
%token ITIPO
%token CADENA
%token CLASS ELSE FALSE FI IF IN INHERITS LET LOOP POOL THEN WHILE
%token CASE ESAC NEW OF NOT TRUE ASIG EQMA ERROR
%token '(' ')' '{' '}' '[' ']' ',' ';' '.' ':'
%right ASIG
%right IN	
%left NOT
%left MEQ '<' '>' EQ 
%left '+' '-'
%left '*' '/'
%left ISVOID
%left '~'
%left '@'
%left '.'
%%

programa : class_list
;

class_list	:  class_list class
		|  class
;

class 	: CLASS ITIPO '{' feature_list '}' ';'
	| CLASS ITIPO INHERITS ITIPO '{' feature_list '}' ';'
;

feature_list	: feature ';' feature_list
		| /* vacio*/
;

feature		: IOBJ ':' ITIPO
		| IOBJ ':' ITIPO ASIG expr
		| IOBJ '(' formal_list ')' ':' ITIPO '{' expr '}'
;

formal_list	:  formal_list ',' IOBJ ':' ITIPO
		| IOBJ ':' ITIPO
		| /* vacio*/
;

expr_asig: ASIG expr
;

expr	: IOBJ expr_asig
	| exp_dispatch
	| IOBJ '(' expr_param ')'
	| IF expr THEN expr ELSE expr FI 
	| WHILE expr LOOP expr POOL
	| '{' expr_list '}'
	| expr_let
	| CASE expr OF id_type_plus ESAC
	| NEW ITIPO
	| ISVOID expr
	| expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| '~' expr
	| expr '<' expr
	| expr '>' expr
	| expr MEQ expr
	| expr EQ expr
	| NOT expr
	| '(' expr ')'
	| CADENA
	| NUM
	| TRUE
	| FALSE
	| IOBJ
;
expr_let: LET let_formal_lst IN expr
;

let_formal_lst	: IOBJ ':' ITIPO ',' let_formal_lst
		| IOBJ ':' ITIPO expr_asig ',' let_formal_lst
		| IOBJ ':' ITIPO
		| IOBJ ':' ITIPO expr_asig
;

exp_dispatch: expr '.' IOBJ '(' expr_param ')' 
	    | expr '@' ITIPO '.' IOBJ '(' expr_param ')'
;

expr_list	: expr ';' expr_list 
		| expr ';'
;

expr_param	: expr ',' expr_param  
		| expr
		|/*Epsilon */
;

id_type_plus	: IOBJ ':' ITIPO EQMA expr ';'
		| id_type_plus IOBJ ':' ITIPO EQMA expr ';'
;
%% 

int main(int argc,char **argv) {
  yyparse();
return 0;
}

int yyerror(char *m) {
    printf("Linea:%d %s\n",num_linea,m);
    return 0;
}
