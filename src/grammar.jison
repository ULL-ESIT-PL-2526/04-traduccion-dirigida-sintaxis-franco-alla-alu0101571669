/* Lexer */
%lex
%%
\s+                                     { /* skip whitespace */; }
"//".*                                  { /* skip comments */;   }
[0-9]+(\.[0-9]+([eE][+-]?[0-9]+)?)?     { return 'NUMBER';       }
"**"                                    { return 'OPOW';         }
[*/]                                    { return 'OPMU';         }
[-+]                                    { return 'OPAD';         }
<<EOF>>                                 { return 'EOF';          }
.                                       { return 'INVALID';      }
/lex

/* Parser */
%start expressions
%token NUMBER
%token OPOW 
%token OPMU 
%token OPAD
%%

expressions
    : expression EOF
        { return $expression; }
    ;

expression
    : expression OPOW term
        { $$ = operate($OPOW, $expression, $term); }
    | expression OPMU term
        { $$ = operate($OPMU, $expression, $term); }
    | expression OPAD term
        { $$ = operate($OPAD, $expression, $term); }
    | term
        { $$ = $term; }
    ;

term
    : NUMBER
        { $$ = Number(yytext); }
    ;
%%

function operate(op, left, right) {
    switch (op) {
        case '+': return left + right;
        case '-': return left - right;
        case '*': return left * right;
        case '/': return left / right;
        case '**': return Math.pow(left, right);
    }
}
