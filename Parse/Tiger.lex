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
<YYINITIAL> ","	{return tok(sym.COMMA);}
<YYINITIAL> ":"	{return tok(sym.COLON);}
<YYINITIAL> "-"	{return tok(sym.MINUS);}
<YYINITIAL> "."	{return tok(sym.DOT);}
<YYINITIAL> "("	{return tok(sym.LPAREN);}
<YYINITIAL> ")"	{return tok(sym.RPAREN);}
<YYINITIAL> ";"	{return tok(sym.SEMICOLON);}
<YYINITIAL> "+"	{return tok(sym.PLUS);}
<YYINITIAL> "[" {return tok(sym.LBRACE);}
<YYINITIAL> "]" {return tok(sym.RBRACE);}
<YYINITIAL> "{"	{return tok(sym.LBRACK);}
<YYINITIAL> "}"	{return tok(sym.RBRACK);}
<YYINITIAL> "/" {return tok(sym.DIVIDE));}
<YYINITIAL> ">" {return tok(sym.GT);}
<YYINITIAL> ">=" {return tok(sym.GE);}
<YYINITIAL> "<" {return tok(sym.LT);}
<YYINITIAL> "<=" {return tok(sym.LE);}
<YYINITIAL> "*" {return tok(sym.TIMES);}
<YYINITIAL> "<>" {return tok(sym.NEQ);}
<YYINITIAL> "=" {return tok(sym.EQ);}
. { err("Illegal character: " + yytext()); }
