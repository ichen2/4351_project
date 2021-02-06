Team members: Ian Chen & Gabe Hardy

What works:
Strings
Identifiers
Integers
Comments
All symbols
Escape sequences

What kind of works:
Control characters

What doesn't:
End of file errors for unclosed strings

To handle comments, we implemented a COMMENT state that starts
when the '/*' character is read. When in the comment state, we used a 
'commentDepth' integer to keep track of nested comments. This 
counter allows for nested comments.

To handle strings, we implemented a STRING state that starts 
when quotation marks are read. We used a stringBuilder to keep 
track of the String's value. We also included a check at end of file 
to catch unclosed string literals by checking if the stringBuffer 
variable was equal to null. Since the stringBuffer is initialized 
when the STRING state starts, and set to null when the state ends, 
if it is not null at EOF that means there's an unclosed string literal. 
However, this didn't work since we weren't able to figure out how to 
stop JLex from trying to parse it anyways and returning an 'Unmatched 
Input' lexical error.

Inside the STRING state we also implemented a state for escape charactes 
that starts when the '\' character is read. This state will look for valid 
escape characters, and return and error if one is not found. It works for all 
the escape characters allowed in JLex except for the control characters. For 
these, we weren't sure what to return. The video's made it seem like we should 
return the control character minus the 'A' characters (65), so that's what we did.