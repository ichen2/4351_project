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
<YYINITIAL> " "	{}
<YYINITIAL> [a-zA-Z][a-zA-Z0-9_]* {return tok(sym.ID, yytext());}
<YYINITIAL> \n	{newline();}
<YYINITIAL> ","	{return tok(sym.COMMA, null);}
<YYINITIAL> ":"	{return tok(sym.COLON, null);}
<YYINITIAL> "-"	{return tok(sym.MINUS, null);}
<YYINITIAL> "."	{return tok(sym.DOT, null);}
<YYINITIAL> "("	{return tok(sym.LPAREN, null);}
<YYINITIAL> ")"	{return tok(sym.RPAREN, null);}
<YYINITIAL> ";"	{return tok(sym.SEMICOLON, null);}
<YYINITIAL> "+"	{return tok(sym.PLUS, null);}
<YYINITIAL> "{"	{return tok(sym.LBRACE, null);}
<YYINITIAL> "}"	{return tok(sym.RBRACE, null);}
. { err("Illegal character: " + yytext()); }
