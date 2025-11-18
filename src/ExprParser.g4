parser grammar ExprParser;

options {
  tokenVocab=ExprLexer;
}

// Ponto de entrada do programa
programa
  : MAIN LBRACE bloco RBRACE (funcao)* EOF 
  ;

// Bloco principal entre "inicio" e "fim"
bloco
  : comandos
;

// Lista de comandos
comandos
  : comando*
;

// Comando genérico
comando
  : declaracao
  | atribuicao
  | condicional
  | laco
  | chamadaFuncaoStandalone
  | retorno
  ;

// Declaração de variável com tipo (ex: inteiro x = 5;)
declaracao
  : DTYPE ID (EQ expressao)? SEMI
  ;

// Atribuição simples (ex: x = 10;)
atribuicao
  : ID EQ expressao SEMI
  ;

// Estrutura condicional completa com if, senãose e senao
condicional
  : IF LPAREN expressao RPAREN LBRACE comandos RBRACE
    (ELSIF LPAREN expressao RPAREN LBRACE comandos RBRACE)*
    (ELSE LBRACE comandos RBRACE)?
  ;

// Laços de repetição: enquanto e para
laco
  : WHILE LPAREN expressao RPAREN LBRACE comandos RBRACE
  | FOR LPAREN atribuicao expressao SEMI atribuicao RPAREN LBRACE comandos RBRACE
  ;

// Versão standalone das funções que exigem ponto e vírgula
chamadaFuncaoStandalone
  : chamadaFuncao SEMI
  ;

// Chamadas de função que retornam valores ou são usadas como expressão
chamadaFuncao
  : WRITE LPAREN argumentos? RPAREN
  | INPUT LPAREN RPAREN
  | RANDOM LPAREN argumentos? RPAREN
  | RANGE LPAREN argumentos? RPAREN
  | ABS LPAREN argumentos RPAREN
  | SQRT LPAREN argumentos RPAREN
  | ID LPAREN argumentos? RPAREN 
  ;

argumentos
  : expressao (COMMA expressao)*;

// Comando de retorno
retorno
  : RETURN expressao SEMI
  ;

// Definição de função personalizada
funcao
  : FUNCAO DTYPE ID LPAREN parametros? RPAREN LBRACE bloco RBRACE
  ;

parametros
  : DTYPE ID (COMMA DTYPE ID)*
  ;

// Expressões matemáticas, lógicas e chamadas de função
expressao
  : expressao POW expressao         #ExpOp
  | expressao MUL expressao         #MulOp
  | expressao DIV expressao         #DivOp
  | expressao MOD expressao         #ModOp
  | expressao SUM expressao         #AddOp
  | expressao SUB expressao         #SubOp
  | expressao ISEQ expressao        #EqOp
  | expressao DIFF expressao        #NeqOp
  | expressao GTHA expressao        #GtOp
  | expressao LTHA expressao        #LtOp
  | expressao GETHA expressao       #GeOp
  | expressao LETHA expressao       #LeOp
  | expressao AND expressao         #AndOp
  | expressao OR expressao          #OrOp
  | NOT expressao                   #NotOp
  | LPAREN expressao RPAREN         #Parens
  | chamadaFuncao                   #FuncaoExpr
  | valor                           #ValorExpr
  ;

// Literais e identificadores
valor
  : INT
  | FLOAT
  | BOOL
  | STRING
  | ID
  ;
