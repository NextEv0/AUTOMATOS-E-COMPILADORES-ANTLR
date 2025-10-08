// DELETE THIS CONTENT IF YOU PUT COMBINED GRAMMAR IN Parser TAB
lexer grammar ExprLexer;

// =====================
// Delimitadores de Algoritmos
// =====================
MAIN  : 'principal';
BEGIN : 'inicio';
END   : 'fim';
RETURN : 'retorna';
FUNCAO : 'funcao';


// =====================
// Palavras-chave / Tipos
// =====================
DTYPE
 : 'inteiro'
 | 'real'
 | 'logico'
 | 'texto'
 ;

// Operadores Lógicos
AND : 'e';
OR  : 'ou';
NOT : 'nao';

// Condicionais
IF    : 'se';
ELSIF : 'senaose';
ELSE  : 'senao';

// Laços
WHILE : 'enquanto';
FOR    : 'para';

// Funções pré-definidas (mantenha acentuação consistente!)
INPUT   : 'entrada';
WRITE   : 'escreve';
RANDOM  : 'aleatorio';   // ou 'aleatório'
RANGE   : 'faixa';
ABS     : 'absoluto';
SQRT    : 'raiz';

// =====================
// Operadores
// =====================
SUM  : '+';
SUB  : '-';
MUL  : '*';
DIV  : '/';
POW  : '^';
MOD  : '%';
EQ   : '=';

ISEQ : '==';
DIFF : '!=';
GTHA : '>';
LTHA : '<';
GETHA: '>=';
LETHA: '<=';

// =====================
// Delimitadores
// =====================
DELIM   : ':';     // se precisar de dois-pontos
COMMA   : ',';
SEMI    : ';';
LPAREN  : '(';
RPAREN  : ')';
LBRACK  : '[';
RBRACK  : ']';
LBRACE  : '{';
RBRACE  : '}';

// =====================
// Literais e identificadores
// =====================
// Inteiro (sem sinal; trate unário no parser)
INT     : [0-9]+ ;

// Float simples 1.23 ou 0.5 ou 12. sem expoente (adicione se quiser)
FLOAT   : [0-9]+ '.' [0-9]+ ( [eE] [+\-]? [0-9]+ )? ;

// Booleanos
BOOL    : 'verdadeiro' | 'falso';

// String com escapes básicos \" \\ \n \t
STRING
 : '"' ( '\\' [btnr"\\] | ~["\\\r\n] )* '"'
 ;

// Identificadores
ID      : [a-zA-Z_][a-zA-Z_0-9]* ;

// =====================
// Comentários e espaços
// =====================
LINE_COMMENT  : '//' ~[\r\n]* -> skip ;
BLOCK_COMMENT : '/' .? '*/'  -> skip ;
WS            : [ \t\r\n\f]+   -> skip ;