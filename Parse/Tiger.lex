package Parse;
import ErrorMsg.ErrorMsg;

%% 

%implements Lexer
%function nextToken
%type java_cup.runtime.Symbol
%char

%{

private StringBuffer stringBuffer;
private int commentDepth;

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

%eof{
  if(stringBuffer != null) err("Unclosed string literal");
  if(commentDepth >= 0) err("Unclosed comment literal");
%eof}

%eofval{
	{
	  return tok(sym.EOF, null);
  }
%eofval}       

%state STRING
%state COMMENT
%state ESCAPED

%%
<YYINITIAL> [" "|\f|\t]+	{}
<YYINITIAL> [\n\r] {newline();}

<YYINITIAL>function {return tok(sym.FUNCTION);}
<YYINITIAL>else {return tok(sym.ELSE);}
<YYINITIAL>nil {return tok(sym.NIL);}
<YYINITIAL>do {return tok(sym.DO);}
<YYINITIAL>of {return tok(sym.OF);}
<YYINITIAL>array {return tok(sym.ARRAY);}
<YYINITIAL>type {return tok(sym.TYPE);}
<YYINITIAL>for {return tok(sym.FOR);}
<YYINITIAL>to {return tok(sym.TO);}
<YYINITIAL>in {return tok(sym.IN);}
<YYINITIAL>end {return tok(sym.END);}
<YYINITIAL>if {return tok(sym.IF);}
<YYINITIAL>while {return tok(sym.WHILE);}
<YYINITIAL>var {return tok(sym.VAR);}
<YYINITIAL>break {return tok(sym.BREAK);}
<YYINITIAL>let {return tok(sym.LET);}
<YYINITIAL>then {return tok(sym.THEN);}

<YYINITIAL> "\"" {stringBuffer = new StringBuffer(); yybegin(STRING);}
<STRING> "\"" {String s = stringBuffer.toString(); stringBuffer = null; yybegin(YYINITIAL); return tok(sym.STRING, s);}
<STRING> \\ {yybegin(ESCAPED);}
<STRING> . {stringBuffer.append(yytext()); }

<ESCAPED> n {stringBuffer.append("\n"); yybegin(STRING);}
<ESCAPED> t {stringBuffer.append("\t"); yybegin(STRING);}
<ESCAPED> "^"[@-_] {stringBuffer.append("^" + (char)(yytext().charAt(1) - 'A')); yybegin(STRING);}
<ESCAPED> \\ {stringBuffer.append("\\"); yybegin(STRING);}
<ESCAPED> [\t|\r|" "|\n|\f]+[\\] {yybegin(STRING);}
<ESCAPED> [0-9][0-9][0-9] {int ascii = Integer.parseInt(yytext()); if(ascii <= 255) {stringBuffer.append((char)ascii); yybegin(STRING);} else err("Not in the ASCII range");}
<ESCAPED> . {err("Unexpected character " + yytext() + " after \\");}

<YYINITIAL> "/*" {commentDepth = 1; yybegin(COMMENT);}
<COMMENT> "/*" {commentDepth += 1;}
<COMMENT> [\n\r]+ {}
<COMMENT> "*/" {commentDepth--; if(commentDepth <= 0) yybegin(YYINITIAL);}
<COMMENT> . {}

<YYINITIAL> [0-9]+ {return tok(sym.INT, yytext());}
<YYINITIAL> [a-zA-Z][a-zA-Z0-9_]* {return tok(sym.ID, yytext());}
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
<YYINITIAL> "/" {return tok(sym.DIVIDE);}
<YYINITIAL> ">" {return tok(sym.GT);}
<YYINITIAL> ">=" {return tok(sym.GE);}
<YYINITIAL> "<" {return tok(sym.LT);}
<YYINITIAL> "<=" {return tok(sym.LE);}
<YYINITIAL> "*" {return tok(sym.TIMES);}
<YYINITIAL> "<>" {return tok(sym.NEQ);}
<YYINITIAL> "=" {return tok(sym.EQ);}
<YYINITIAL> "|" {return tok(sym.OR);}
<YYINITIAL> "&" {return tok(sym.AND);}
<YYINITIAL> ":=" {return tok(sym.ASSIGN);}
. { err("Illegal character: " + yytext()); }
