# Gramática

Esta es la gramática del lenguaje analizado por [main.js](https://github.com/crguezl/prdcalc/blob/master/views/main.js): 

1.  *∑ = { ; =, ID, P, IF, THEN, <, >, <=, >=, ==, !=, +, \*, (, ), NUM }*,
2.  *V = { statements, statement, condition, expression, term, factor }*
3.  *Productions:*
    1.  *statements  → statement ';' statements | statement*
    2.  *statement  → ID '=' expression | P expression  | IF condition THEN statement*
    3.  *condition  → expression ('=='|'!='|'<'|'<='|'>'|'>=') expression*
    4.  *expression  → term '+' expression | term*
    5.  *term  → factor '\*' term | factor*
    6.  *factor  → '(' expression ')' | ID  | NUM*
4.  Start symbol: *statements*

* [Gramática en la Wikipedia](https://en.wikipedia.org/wiki/Recursive_descent_parser)

# Práctica: Analizador Descendente Predictivo Recursivo

* [Deployment in Heroku](http://predictiveparser.herokuapp.com/)

## Tareas

Añada:

* Extienda y modifique el analizador para que acepte el lenguaje descrito por la gramática EBNF del lenguaje PL/0 que se describe en la entrada de la Wikipedia Recursive descent parser. 
* [Gramática en la Wikipedia](https://en.wikipedia.org/wiki/Recursive_descent_parser)
* Procure que el arbol generado refleje la asociatividad correcta para las diferencias y las divisiones. No es necesario que el lenguaje sea exactamente igual pero debería ser parecido. Tener los mismos constructos.
* Use CoffeeScript para escribir el código (fichero views/main.coffee)
* Use slim para las vistas
* Usa Sass para las hojas de estilo
* Despliegue la aplicación en Heroku
* Añada pruebas

