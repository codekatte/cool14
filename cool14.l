

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

#include "y.tab.h"
#include <stdio.h>
#define yylval()
extern int num_linea;

%}

DIGITO [0-9]
INTEGER [DIGITO][DIGITO]*
ID [a-z][a-zA-Z0-9_]*
IDO [A-Z][a-zA-Z0-9_]*

%%
\n  {num_linea++;}

"(*" { register int c;
	while((c=input())!=0)
	{
		if(c=='\n') num_linea++;
		else if(c=='*')
		{
			if((c=input())==')'){
				break;
			}
		}
		if(c==EOF)
		{
			printf("L%d Error: EOF en comentario\n",num_linea);
			break;
		}
	 }
      }
 
"--"[^}\n]* /*se coma los comentarios simples*/  
[\t ]+ /* se come los espacios en blanco */

"\""[^}\n]*"\"" return CADENA;

{DIGITO}+ return NUM;
class return CLASS;
else return ELSE;
false return FALSE;
fi return FI;
if return IF;
in return IN;
inherits return INHERITS;
isvoid return ISVOID;
let return LET;
loop return LOOP;
pool return POOL;
then return THEN;
while return WHILE;
case return CASE;
esac return ESAC;
new return NEW;
of return OF;
not return NOT;
true return TRUE;
{IDO} return ITIPO;
{ID} return IOBJ;
"(" return '(';
")" return ')';
"{" return '{';
"[" return '[';
"]" return ']';
"}" return '}';
":" return ':';
"~" return '~';
";" return ';';
"," return ',';
"<-" return ASIG;
"." return '.';
"+" return '+';
"-" return '-';
"*" return '*';
"/" return '/';
"<" return '<';
">" return '>';
"=" return EQ;
"<=" return MEQ;
"=>" return EQMA;
. return ERROR;
%%1
