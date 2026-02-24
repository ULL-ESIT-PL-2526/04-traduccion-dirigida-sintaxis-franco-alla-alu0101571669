# Syntax Directed Translation with Jison

Jison is a tool that receives as input a Syntax Directed Translation and produces as output a JavaScript parser  that executes
the semantic actions in a bottom up ortraversing of the parse tree.
 

## Compile the grammar to a parser

See file [grammar.jison](./src/grammar.jison) for the grammar specification. To compile it to a parser, run the following command in the terminal:
``` 
➜  jison git:(main) ✗ npx jison grammar.jison -o parser.js
```

## Use the parser

After compiling the grammar to a parser, you can use it in your JavaScript code. For example, you can run the following code in a Node.js environment:

```
➜  jison git:(main) ✗ node                                
Welcome to Node.js v25.6.0.
Type ".help" for more information.
> p = require("./parser.js")
{
  parser: { yy: {} },
  Parser: [Function: Parser],
  parse: [Function (anonymous)],
  main: [Function: commonjsMain]
}
> p.parse("2*3")
6
```

# Describa la diferencia entre /* skip whitespace */ y devolver un token.

La principal diferencia es la siguiente:
* **Omitir espacios en blanco**: cuando el analizador léxico encuentra espacios, tabulaciones, etc. Simplemente avanza su puntero para continuar leyendo la sentencia escrita sin devolver nada.

* Devolver un token: cuando el analizador encuentyra en este caso un número o un operador, este devuelve el *token* con la información reconocida y se la entrega al parser.

# Escriba la secuencia exacta de tokens producidos para la entrada 123**45+@.
La secuencia para esa entrada sería la siguiente:

| **Entrada** | **Regla que coincide** | **Token devuelto** |
|-------------|--------------------|----------------|
|    123      |       [0-9]+       |     NUMBER     |
|    **       |        "**"        |       OP       |
|    45       |       [0-9]+       |     NUMBER     |
|    +        |       [-+*/]       |       OP       |
|    @        |         .          |     INVALID    |
|             |      <<EOF>>       |       EOF      |

1. El texto 123 coincide con la regla [0-9]+ y devuelve el token NUMBER.

2. El texto ** coincide con la regla "**" y devuelve el token OP.

3. El texto 45 coincide con la regla [0-9]+ y devuelve el token NUMBER.

4. El texto + coincide con la regla [-+*/] y devuelve el token OP.

5. El carácter @ no coincide con ninguna de las reglas anteriores, por lo que cae en la regla . y devuelve el token INVALID.


# Indique por qué ** debe aparecer antes que [-+*/].

Porque el analizador tiene un orden de prioridad, es decir, si este llag a encontrar primero la regla [-+*/] y se llega a tyener un `**`lo que hace es leer sólo el primer asterísco y devuelve un operdaor inmediatamente, luego el otro asterísco cuando lo lea devolverá otro operador. Al poner la regla `**` antes, el lexer primero comprobará si se trata de un doble asterísco ya sabrá que se trata de una operación de potencia en lugar de multiplicación .

3.4. Explique cuándo se devuelve EOF.


3.5. Explique por qué existe la regla . que devuelve INVALID.
