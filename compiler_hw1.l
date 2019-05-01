/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	int num_of_line=0;
	int num_of_comment=0;
%}

/* Define regular expression label */
%x commentCpp
%x commentC
%x str
letter [a-zA-Z]
digit [0-9]
ignore [" "\t]
id {letter}+({letter}|{digit})*
number {digit}+

/* Rules section */
%%
"//"	{
	printf("%s",yytext);
	BEGIN(commentCpp);
}
<commentCpp>\n {
	printf(" \t C++ Comment\n");
	num_of_comment++;
	num_of_line++;
	BEGIN(INITIAL);
}
<commentCpp>. {printf("%s",yytext);}


"/*"	{
	printf("%s",yytext);
	BEGIN(commentC);
}
<commentC>"*/" {
	num_of_comment++;
	printf("%s \t C Comment\n",yytext);
	BEGIN(INITIAL);
}
<commentC>\n {
	num_of_comment++;
	num_of_line++;
	printf("%s",yytext);
}
<commentC>. {printf("%s",yytext);}


<str>"\\\"" { printf("%s",yytext);}
<str>"\"" {
	printf(" \t STR_CONST\n");
	printf("%s \t QUOTA\n",yytext);
	BEGIN(INITIAL);
	}
<str>. {printf("%s",yytext);}

"++"		{ printf("%s \t INC\n", yytext); }
"--"		{ printf("%s \t DEC\n", yytext); }
">="		{ printf("%s \t MTE\n", yytext); }
"<="		{ printf("%s \t LTE\n", yytext); }
"=="		{ printf("%s \t EQ\n", yytext); }
"!="		{ printf("%s \t NE\n", yytext); }
"+="		{ printf("%s \t ADDASGN\n", yytext); }
"-="		{ printf("%s \t SUBASGN\n", yytext); }
"*="		{ printf("%s \t MULASGN\n", yytext); }
"/="		{ printf("%s \t DIVASGN\n", yytext); }
"%="		{ printf("%s \t MODASGN\n", yytext); }
"&&"		{ printf("%s \t AND\n", yytext); }
"||"		{ printf("%s \t OR\n", yytext); }

"\""		{ printf("%s \t QUOTA\n",yytext);
		BEGIN(str);}
"("		{ printf("%s \t LB\n", yytext); }
")"		{ printf("%s \t RB\n", yytext); }
"{"		{ printf("%s \t LCB\n", yytext); }
"}"		{ printf("%s \t RCB\n", yytext); }
"["		{ printf("%s \t LSB\n", yytext); }
"]"		{ printf("%s \t RSB\n", yytext); }
","		{ printf("%s \t COMMA\n", yytext); }
";"		{ printf("%s \t SEMICOLON\n", yytext); }
"+" 	{ printf("%s \t ADD\n", yytext); }
"-"		{ printf("%s \t SUB\n", yytext); }
"*"		{ printf("%s \t MUL\n", yytext); }
"/"		{ printf("%s \t DIV\n", yytext); }
"%"		{ printf("%s \t MOD\n", yytext); }
"="		{ printf("%s \t ASGN\n", yytext); }
"!"		{ printf("%s \t NOT\n", yytext); }
">"		{ printf("%s \t MT\n", yytext); }
"<"		{ printf("%s \t LT\n", yytext); }

\n			{num_of_line++;}
int	{ printf("%s \t INT\n",yytext);}
float	{ printf("%s \t FLOAT\n",yytext);}
print	{ printf("%s \t PRINT\n",yytext);}
if	{ printf("%s \t IF\n",yytext);}
else	{ printf("%s \t ELSE\n",yytext);}
while	{ printf("%s \t WHILE\n",yytext);}
for	{ printf("%s \t FOR\n",yytext);}
string	{ printf("%s \t STRING\n",yytext);}
void	{ printf("%s \t VOID\n",yytext);}
bool	{ printf("%s \t BOOL\n",yytext);}
true	{ printf("%s \t TRUE\n",yytext);}
false	{ printf("%s \t FALSE\n",yytext);}
return	{ printf("%s \t RET\n",yytext);}
continue	{ printf("%s \t CONT\n",yytext);}
break	{ printf("%s \t BREAK\n",yytext);}
{number} { printf("%s \t I_CONST\n",yytext);}
{number}\.{number}	{ printf("%s \t F_CONST\n",yytext);}
{ignore} {;}
{id}	{ printf("%s \t ID\n", yytext); }

%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is %d.\n\n",num_of_line);
	printf("comment: %d lines\n\n",num_of_comment);

	return 0;
}
