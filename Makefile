cool14 : cool14.tab.c lex.yy.c
	gcc -o cool14 cool14.tab.c lex.yy.c -lm

cool14.tab.c cool14.tab.h : cool14.y
	bison -d cool14.y

lex.yy.c : cool14.tab.h cool14.l
	flex cool14.l
