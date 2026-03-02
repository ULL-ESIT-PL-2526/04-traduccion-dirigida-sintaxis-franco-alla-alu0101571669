/* Lexer */
%lex
%%
\s+                                     { /* skip whitespace */; }
"//".*                                  { /* skip comments */;   }
[0-9]+(\.[0-9]+([eE][+-]?[0-9]+)?)?     { return 'NUMBER';       }
"**"                                    { return 'OPOW';         }
[*/]                                    { return 'OPMU';         }
[-+]                                    { return 'OPAD';         }
"("                                     { return 'LPAREN';       }
")"                                     { return 'RPAREN';       }
<<EOF>>                                 { return 'EOF';          }
.                                       { return 'INVALID';      }
/lex

/* Parser */
%start expressions
%token NUMBER
%token LPAREN 
%token RPAREN
%left OPAD
%left OPMU 
%right OPOW 
%%

expressions
    : expression EOF
        { return $expression; }
    ;

expression
    : expression OPAD expression
        { $$ = operate($2, $1, $3); }
    | expression OPMU expression
        { $$ = operate($2, $1, $3); }
    | expression OPOW expression
        { $$ = operate($2, $1, $3); }
    | term
        { $$ = $term; }
    ;

term
    : NUMBER
        { $$ = Number(yytext); }
    |
    LPAREN expression RPAREN
        { $$ = $2; }
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
