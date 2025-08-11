module Ri  where

type Id = String

data Tipo = TDouble | TInt | TString | TVoid deriving (Show, Eq)

data TCons = CDouble Double | CInt Int deriving Show

data Expr = Add Expr Expr | Sub Expr Expr | Mul Expr Expr | Div Expr Expr | Neg Expr | IdVar String | Chamada Id [Expr] | Lit String | Const TCons | Mod Expr Expr | IntDouble Expr | DoubleInt Expr | Ternario ExprL Expr Expr deriving Show

data ExprR = Rgt Expr Expr | Rdf Expr Expr | Rlt Expr Expr | Req Expr Expr | Rle Expr Expr | Rge Expr Expr deriving Show

data ExprL = And ExprL ExprL | Or ExprL ExprL | Not ExprL | Rel ExprR deriving Show

data Var = Id :#: (Tipo, Int) deriving Show

type Bloco = [Comando]

data Funcao = Id :->: ([Var], Tipo) deriving Show

data Programa = Prog [Funcao] [(Id, [Var], Bloco)] [Var] Bloco deriving Show

data Comando = If ExprL Bloco Bloco | While ExprL Bloco | DoWhile Bloco ExprL | Leitura Id | Imp Expr | Ret (Maybe Expr) | Proc Id [Expr] | Atrib String Expr deriving Show


-- Função que transforma a função no formato esperado para o Programa
transformaFuncao :: (Funcao, ([Var], Bloco)) -> (Id, [Var], Bloco)
transformaFuncao (funcao, (variaveisBloco, bloco)) =
    let
        -- Decompoe a função, extraindo o nome e as variáveis
        (identificador, parametrosFuncao) = decompoeFuncao funcao
        
        -- Combina as variáveis dos parametros da funcao da função com as variáveis do bloco
        todasVariaveis = parametrosFuncao ++ variaveisBloco
    in
        -- Retorna o identificador da função, todas as variáveis (parametrosFuncao + variáveis do bloco), e o bloco de comandos
        (identificador, todasVariaveis, bloco)

-- Função auxiliar para decompor uma função no estilo Id :->: ([Var], Tipo)
decompoeFuncao :: Funcao -> (Id, [Var])
decompoeFuncao (identificador :->: (variaveis, _)) = (identificador, variaveis)
