%{
	#include "pic.hh"
	#include "parse.tab.h"
	using namespace std;
%}

/* DEFINITIONS */

/* yywrap handles the end-of-input logic, if noyywrap is used, program exits on end-of-file (EOF) */
%option noyywrap

digit                       [0-9]
fraction                    ([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)
ws							[ \t]*
letter                      [a-zA-Z_]

%x DATA

/* RULES */
%%

<INITIAL>{
	[^,\n]*											{ yylval.str_ptr = new string(yytext); return HSTRING;}			
	,												{ return COMMA; }
	\n												{ BEGIN(DATA); return ENDOFLINE;} // switch to DATA state when newline is encountered
}

<DATA>{
	true												{ return TRUE_CONST; }
	false												{ return FALSE_CONST; }
	null												{ return NULL_CONST; }
	,													{ return COMMA; }
	\n													{ return ENDOFLINE; }
	-?{digit}+											{ yylval.int_val = atoi(yytext); return INT_CONST; }
	-?{fraction}										{ yylval.flt_val = atof(yytext); return FLT_CONST; }
	([^,\n]*)			               					{ yylval.str_ptr = new string(yytext); return STR_CONST; }
	.	     											{ fprintf(stderr, "unknown_token: %d\n", yytext[0]); exit(1); }
}