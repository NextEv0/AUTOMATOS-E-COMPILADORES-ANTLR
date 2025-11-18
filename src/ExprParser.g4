parser grammar LukeraParser;

options {
  tokenVocab=LukeraLexer;
}

// -----------------------------------------------------------
// ESTRUTURA DO PROGRAMA
// -----------------------------------------------------------

// Ponto de entrada: Main + Lista de Funções
programa
  : MAIN LBRACE comandos RBRACE lista_funcoes EOF 
  ;

// Lista de funções auxiliares (pode ser vazia)
lista_funcoes
  : funcao lista_funcoes 
  | /* epsilon (vazio) */
  ;

// Declaração de função
funcao
  : FUNCAO DTYPE ID LPAREN parametros_opc RPAREN LBRACE comandos RBRACE
  ;

// Parâmetros opcionais
parametros_opc
  : parametros
  | /* epsilon */
  ;

parametros
  : DTYPE ID cauda_parametros
  ;

cauda_parametros
  : COMMA DTYPE ID cauda_parametros
  | /* epsilon */
  ;

// -----------------------------------------------------------
// COMANDOS (STATEMENTS)
// -----------------------------------------------------------

comandos
  : comando comandos
  | /* epsilon */
  ;

// O parser decide qual comando é olhando o primeiro Token (Lookahead)
comando
  : declaracao
  | se_cmd
  | enquanto_cmd
  | para_cmd
  | retorno_cmd
  | comando_inicio_id  // Resolve ambiguidade: Atribuição vs Chamada
  ;

// Declaração: inteiro x = 10;
declaracao
  : DTYPE ID resto_declaracao SEMI
  ;

resto_declaracao
  : EQ expressao
  | /* epsilon */
  ;

// Comando SE (If / Else If / Else)
se_cmd
  : IF LPAREN expressao RPAREN LBRACE comandos RBRACE parte_senao
  ;

parte_senao
  : ELSE LBRACE comandos RBRACE
  | ELSIF LPAREN expressao RPAREN LBRACE comandos RBRACE parte_senao
  | /* epsilon */
  ;

// Laço Enquanto
enquanto_cmd
  : WHILE LPAREN expressao RPAREN LBRACE comandos RBRACE
  ;

// Laço Para (com atribuição interna simplificada)
para_cmd
  : FOR LPAREN para_atrib SEMI expressao_opc SEMI para_atrib RPAREN LBRACE comandos RBRACE
  ;

para_atrib
  : ID EQ expressao
  | /* epsilon */
  ;

expressao_opc
  : expressao
  | /* epsilon */
  ;

retorno_cmd
  : RETURN expressao_opc SEMI
  ;

// -----------------------------------------------------------
// FATORAÇÃO DO ID (O "Pulo do Gato" para LL(1))
// -----------------------------------------------------------
// Quando o parser vê um ID, ele entra aqui. Depois decide se é '=' ou '('

comando_inicio_id
  : ID resto_id SEMI
  ;

resto_id
  : EQ expressao                  // Era uma atribuição: x = 10;
  | LPAREN argumentos_opc RPAREN  // Era uma chamada: x();
  ;

// -----------------------------------------------------------
// EXPRESSÕES (Hierarquia de Precedência Explícita)
// -----------------------------------------------------------
// Ordem: OU < E < IGUAL < RELACIONAL < SOMA < MULT < UNARIO < POTENCIA < ATOMO

// 1. Lógico OU (Menor prioridade)
expressao
  : termo_e resto_expressao
  ;

resto_expressao
  : OR termo_e resto_expressao
  | /* epsilon */
  ;

// 2. Lógico E
termo_e
  : termo_igual resto_termo_e
  ;

resto_termo_e
  : AND termo_igual resto_termo_e
  | /* epsilon */
  ;

// 3. Igualdade (==, !=)
termo_igual
  : termo_rel resto_termo_igual
  ;

resto_termo_igual
  : ISEQ termo_rel resto_termo_igual
  | DIFF termo_rel resto_termo_igual
  | /* epsilon */
  ;

// 4. Relacional (>, <, >=, <=)
termo_rel
  : termo_soma resto_termo_rel
  ;

resto_termo_rel
  : GTHA  termo_soma resto_termo_rel
  | LTHA  termo_soma resto_termo_rel
  | GETHA termo_soma resto_termo_rel
  | LETHA termo_soma resto_termo_rel
  | /* epsilon */
  ;

// 5. Aditivo (+, -)
termo_soma
  : termo_mult resto_termo_soma
  ;

resto_termo_soma
  : SUM termo_mult resto_termo_soma
  | SUB termo_mult resto_termo_soma
  | /* epsilon */
  ;

// 6. Multiplicativo (*, /, %)
termo_mult
  : unario resto_termo_mult
  ;

resto_termo_mult
  : MUL unario resto_termo_mult
  | DIV unario resto_termo_mult
  | MOD unario resto_termo_mult
  | /* epsilon */
  ;

// 7. Unário (NOT, -)
// Permite "nao nao x" recursivamente
unario
  : NOT unario
// Se quiser suportar número negativo literal (-5) sem ser subtração:
//| SUB unario  
  | fator
  ;

// 8. Potência (^)
// Estratégia: base ^ (resto)
fator
  : atomo resto_fator
  ;

resto_fator
  : POW unario resto_fator
  | /* epsilon */
  ;

// 9. Átomo (Valores base)
atomo
  : INT
  | FLOAT
  | STRING
  | BOOL
  | LPAREN expressao RPAREN
  | chamada_nativa           // Funções embutidas (leia, escreva)
  | ID atomo_resto_id        // Variável ou Chamada de função com retorno
  ;

// Verifica se o ID numa expressão é variável 'x' ou função 'x(...)'
atomo_resto_id
  : LPAREN argumentos_opc RPAREN
  | /* epsilon */
  ;

// Argumentos de chamadas
argumentos_opc
  : argumentos
  | /* epsilon */
  ;

argumentos
  : expressao cauda_argumentos
  ;

cauda_argumentos
  : COMMA expressao cauda_argumentos
  | /* epsilon */
  ;

// Funções Nativas (Built-ins)
chamada_nativa
  : INPUT LPAREN RPAREN
  | WRITE LPAREN argumentos_opc RPAREN
  | SQRT  LPAREN argumentos RPAREN
  | ABS   LPAREN argumentos RPAREN
  | RANDOM LPAREN argumentos_opc RPAREN
  | RANGE LPAREN argumentos_opc RPAREN
  ;
