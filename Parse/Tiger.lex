package Parse;
import ErrorMsg.ErrorMsg;

%% 

%implements Lexer
%function nextToken
%type java_cup.runtime.Symbol
%char

%{
private void newline() {
  errorMsg.newline(yychar);
}

private void err(int pos, String s) {
  errorMsg.error(pos,s);
}

private void err(String s) {
  err(yychar,s);
}

private java_cup.runtime.Symbol tok(int kind) {
    return tok(kind, null);
}

private java_cup.runtime.Symbol tok(int kind, Object value) {
    return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
}

private ErrorMsg errorMsg;

Yylex(java.io.InputStream s, ErrorMsg e) {
  this(s);
  errorMsg=e;
}

%}

%eofval{
	{
	 return tok(sym.EOF, null);
        }
%eofval}       


%%
" "	{}
[a-zA-Z][a-zA-Z0-9_]* {return tok(sym.ID, yytext());}
\n	{newline();}
","	{return tok(sym.COMMA, null);}
":"	{return tok(sym.COLON, null);}
"-"	{return tok(sym.MINUS, null);}
"."	{return tok(sym.DOT, null);}
"("	{return tok(sym.LPAREN, null);}
")"	{return tok(sym.RPAREN, null);}
";"	{return tok(sym.SEMICOLON, null);}
"+"	{return tok(sym.PLUS, null);}
"{"	{return tok(sym.LBRACE, null);}
"}"	{return tok(sym.RBRACE, null);}
. { err("Illegal character: " + yytext()); }
