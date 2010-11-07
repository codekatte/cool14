
main:			y.tab.c lex.yy.c 
			gcc lex.yy.c y.tab.c -o cool14 -lfl

y.tab.c y.tab.h:	cool14.y
			bison -y -d cool14.y

lex.yy.c:		cool14.l y.tab.h 
			flex cool14.l

clean:
	rm  lex.* y.tab.* cool14
