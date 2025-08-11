module Token where

data Token
  = NUM Double
  | INT_LIT Int
  | STRING_LIT String
  | ADD
  | SUB
  | MUL
  | DIV
  | MOD
  | LPAR
  | RPAR
  | RGT
  | RLT
  | REQ
  | RLE
  | RGE
  | AND
  | RDF
  | OR
  | NOT
  | LBRACE
  | RBRACE
  | ID String
  | EQ_ASSIGN     -- Para o operador de atribuição '='
  | SEMI          -- Para o finalizador de comando ';'
  | KW_INT
  | KW_DO
  | KW_FLOAT
  | KW_STRING
  | KW_IF
  | KW_ELSE
  | KW_VOID
  | KW_READ       -- Para o comando read()
  | KW_WHILE      -- Para o comando while()
  | KW_PRINT      -- Para o comando print()
  | KW_RETURN     -- Para o comando return
  | COMMA         -- Para o elemento ','
  | INTERROGACAO         -- <<< ADICIONE
  | DOIS_PONTOS          -- <<< ADICIONE
  deriving (Eq, Show)
  

