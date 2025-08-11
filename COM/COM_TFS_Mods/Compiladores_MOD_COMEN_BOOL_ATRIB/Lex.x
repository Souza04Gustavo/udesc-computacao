{
module Lex where

import Token
}

%wrapper "basic"

$digit = [0-9]        -- digits
$alpha = [a-zA-Z]

@num_double = $digit+ \. $digit+ ($digit+)?
@num_int    = $digit+
@id  = $alpha ($alpha | $digit | \_ )*
@string_lit = \" (~[\"\\] | \\.)* \"

tokens :-

<0> $white+ ;
<0> \/\/.*; -- para ignorar comentarios de uma linha
<0> "int"       {\s -> KW_INT}
<0> "float"     {\s -> KW_FLOAT}
<0> "string"    {\s -> KW_STRING}
<0> "void"      {\s -> KW_VOID}
<0> "read"      {\s -> KW_READ}
<0> "while"     {\s -> KW_WHILE}
<0> "print"     {\s -> KW_PRINT}
<0> "if"        {\s -> KW_IF}
<0> "else"      {\s -> KW_ELSE}
<0> "return"    {\s -> KW_RETURN}
<0> "bool"      {\s -> KW_BOOL}
<0> "true"      {\s -> LIT_TRUE}
<0> "false"     {\s -> LIT_FALSE}

<0> @id  {\s -> ID s}
<0> @num_double {\s -> NUM (read s)}                                        -- Renomeado de @num, retorna NUM Double
<0> @num_int    {\s -> INT_LIT (read s)}                                    -- Para inteiros, retorna INT_LIT Int
-- <0> @string_lit {\s -> STRING_LIT (drop 1 (take (length s - 1) s)) }     -- lenghth s - 1 retorna a string sem o ultimo elemento, e drop 1 remove o primeiro
<0> @string_lit {\s -> STRING_LIT (init (tail s)) }                         -- tail remove o ultimo elemento da string e init remove o primeiro


<0> "%" {\s -> MOD}
<0> "+" {\s -> ADD}
<0> "-" {\s -> SUB}
<0> "*" {\s -> MUL}
<0> "/=" {\s -> RDF}
<0> "/" {\s -> DIV}
<0> "(" {\s -> LPAR}
<0> ")" {\s -> RPAR}
<0> "{" {\s -> LBRACE}
<0> "}" {\s -> RBRACE}
<0> "=" {\s -> EQ_ASSIGN}  -- Nova adição
<0> ";" {\s -> SEMI}      -- Nova adição
<0> "<=" {\n -> RLE}
<0> ">=" {\n -> RGE}
<0> ">" {\s -> RGT}
<0> "<" {\s -> RLT}
<0> "==" {\s -> REQ}
<0> "&&" {\s -> AND}
<0> "||" {\s -> OR}
<0> "!" {\s -> NOT}
<0> "," {\s -> COMMA}    -- Nova adição


{
-- As acoes tem tipo :: String -> Token

testLex = do s <- getLine
             print (alexScanTokens s)
}

