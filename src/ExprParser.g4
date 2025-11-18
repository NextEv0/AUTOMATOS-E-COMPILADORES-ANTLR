parser grammar ExprParser;

options {
  tokenVocab=ExprLexer;
}

// --- Estrutura Principal ---

programa
  : MAIN LBRACE bloco RBRACE (funcao)* EOF 
  ;

bloco
  : comandos
  ;

comandos
  : comando*
  ;

comando
  : declaracao
  | atribuicaoCmd       // Atribuição como comando (com ;)
  | condicional
  | laco
  | chamadaCmd          // Chamada de função como comando (com ;)
  | retorno
  ;

// --- Declarações e Atribuições ---

// Ex: inteiro x = 10; ou inteiro x;
declaracao
  : DTYPE ID (EQ expressao)? SEMI
  ;

// Atribuição usada como comando isolado: x = 10;
atribuicaoCmd
  : atribuicaoExpr SEMI
  ;

// Atribuição usada dentro de expressões ou for: x = 10
atribuicaoExpr
  : ID EQ expressao
  ;

// --- Estruturas de Controle ---

condicional
  : IF LPAREN expressao RPAREN LBRACE bloco RBRACE
    (ELSIF LPAREN expressao RPAREN LBRACE bloco RBRACE)*
    (ELSE LBRACE bloco RBRACE)?
  ;

laco
  : WHILE LPAREN expressao RPAREN LBRACE bloco RBRACE
  // CORREÇÃO: O ';' agora faz parte da estrutura do FOR, não da atribuição
  | FOR LPAREN (atribuicaoExpr)? SEMI (expressao)? SEMI (atribuicaoExpr)? RPAREN LBRACE bloco RBRACE
  ;

// --- Funções ---

funcao
  : FUNCAO DTYPE ID LPAREN parametros? RPAREN LBRACE bloco RBRACE
  ;

parametros
  : DTYPE ID (COMMA DTYPE ID)*
  ;

retorno
  : RETURN expressao? SEMI
  ;

// Chamada de função "solta" no código (ex: escreve("Ola");)
chamadaCmd
  : chamadaFuncao SEMI
  ;

// Chamada de função real
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
  : expressao (COMMA expressao)*
  ;

// --- Expressões (Hierarquia de Precedência Correta) ---

expressao
  // 1. Nível Atômico (Parenteses, Funções, Literais)
  : LPAREN expressao RPAREN                   #Parens
  | chamadaFuncao                             #FuncaoExpr
  | valor                                     #ValorExpr
  
  // 2. Potência (Maior precedência matemática, associativa à direita)
  | <assoc=right> expressao POW expressao     #ExpOp
  
  // 3. Unários (Not lógico e Menos unário se houvesse)
  | NOT expressao                             #NotOp
  
  // 4. Multiplicativos
  | expressao (MUL | DIV | MOD) expressao     #MulDivModOp
  
  // 5. Aditivos
  | expressao (SUM | SUB) expressao           #AddSubOp
  
  // 6. Relacionais (Maior/Menor)
  | expressao (GTHA | LTHA | GETHA | LETHA) expressao #RelationalOp
  
  // 7. Igualdade
  | expressao (ISEQ | DIFF) expressao         #EqualityOp
  
  // 8. Lógico E (AND)
  | expressao AND expressao                   #AndOp
  
  // 9. Lógico OU (OR) - Menor precedência
  | expressao OR expressao                    #OrOp
  ;

valor
  : INT
  | FLOAT
  | BOOL
  | STRING
  | ID
  ;
