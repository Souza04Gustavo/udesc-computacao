-- GenCode.hs
module GenCode (gerar) where

import Ri
import Control.Monad.State
import qualified Data.Map as Map
import Data.Map (Map)

type SymTab = Map Id (Tipo, Int)   -- A symtab agora mapeia um id para uma tupla (Tipo, Indice)
type GenEnv = ([Funcao], SymTab) -- (Lista de funcoes, tabela de simbolos)

-- funcao para criar a tabela apartir da lista de varaiveis da AST, retorna a tabela e o prox indice livre
criarTabela :: [Var] -> Int -> (SymTab, Int)
criarTabela vars indiceInicial = (Map.fromList entradas, proxIndice)
    where
        entradas = zip (map getId vars) (zip (map getTipo vars) [indiceInicial..])
        proxIndice = indiceInicial + length vars
        -- funcs auxiliares para extrair o Id e Tipo de uma Var
        getId (id :#: _) = id
        getTipo (_ :#: (tipo, _)) = tipo

-- func para buscar um simbolo na tabela
buscarSimbolo :: Id -> SymTab -> Maybe (Tipo, Int)
buscarSimbolo nome tabela = Map.lookup nome tabela

novoLabel :: State Int String
novoLabel = do { n <- get; put (n + 1); return ("l" ++ show n) }

-- gera codigo para expressoes que sobem valores para a pilha
genExpr :: GenEnv -> Expr -> State Int (Tipo, String)
genExpr (_, symTab) (Const (CInt i))    = return (TInt, genInt i)
genExpr (_, symTab) (Const (CDouble d)) = return (TDouble, "\tldc2_w " ++ show d ++ "\n")
genExpr (_, symTab) (Lit s)             = return (TString, "\tldc \"" ++ s ++ "\"\n")

genExpr _ (BConst True)  = return (TBool, "\ticonst_1\n")
genExpr _ (BConst False) = return (TBool, "\ticonst_0\n")

genExpr (_, symTab) (IdVar nome) =
    case buscarSimbolo nome symTab of
        Nothing ->
            -- erro que nao deve acontecer mas deixar a verificacao dele aqui
            error("[CodeGen] Erro fatal: variavel '" ++ nome ++ "' nao encontrada na tabela de simbolos")

        Just (tipo, indice) ->
            let instr = case tipo of
                            TInt -> "iload"
                            TBool -> "iload"
                            TDouble -> "dload"
                            TString -> "aload"
                            _   -> error "[CodeGen] Tipo de variavel não suportada"   -- outro erro possivel
        
            in return (tipo, "\t" ++ instr ++ " " ++ show indice ++ "\n") -- o retorno é o tipo da variavel e o codigo para load na pilha

genExpr env@(_, tab) (Add e1 e2) = do
    (t1, e1') <- genExpr env e1
    (t2, e2') <- genExpr env e2
    return (t1, e1' ++ e2' ++ genOp t1 "add")

genExpr env@(_, tab) (Sub e1 e2) = do
    (t1, e1') <- genExpr env e1
    (t2, e2') <- genExpr env e2
    return (t1, e1' ++ e2' ++ genOp t1 "sub")

genExpr env@(_, tab) (Mul e1 e2) = do
    (t1, e1') <- genExpr env e1
    (t2, e2') <- genExpr env e2
    return (t1, e1' ++ e2' ++ genOp t1 "mul")

genExpr env@(_, tab) (Div e1 e2) = do
    (t1, e1') <- genExpr env e1
    (t2, e2') <- genExpr env e2
    return (t1, e1' ++ e2' ++ genOp t1 "div")

genExpr env@(_, tab) (Neg e) = do
    (tipo, code) <- genExpr env e
    return (tipo, code ++ genOp tipo "neg")

genExpr env@(_, tab) (Mod e1 e2) = do
    (t1, e1') <- genExpr env e1
    (t2, e2') <- genExpr env e2
    return (TInt, e1' ++ e2' ++ "\tirem\n") -- modulo de inteiros é "irem"

genExpr env@(_, tab) (IntDouble e) = do
    (_, code) <- genExpr env e
    return (TDouble, code ++ "\ti2d\n")

genExpr env@(_, tab) (DoubleInt e) = do
    (_, code) <- genExpr env e
    return (TInt, code ++ "\td2i\n")

genExpr env@(funcoes, _) (Chamada id args) = do
    results <- mapM (genExpr env) args  -- Gera o código e coleta os tipos para todos os argumentos, 'results' será uma lista de tuplas [(Tipo, String)]
    let argCode = concatMap snd results  -- Concatena todo o código dos argumentos em uma única string
    
    case buscarFuncaoNaLista id funcoes of
        Nothing -> error ("[CodeGen] Função '" ++ id ++ "'chamada mas não definida")

        Just(_ :->: (params, tipoRetorno)) -> do

            let nomeClasse = "MeuPrograma"
            let assinatura = geraAssinatura params tipoRetorno
            let invokeCode = "\tinvokestatic " ++ nomeClasse ++ "/" ++ id ++ assinatura ++ "\n"
    
            return (tipoRetorno, argCode ++ invokeCode) -- Retorna o tipo de retorno e o código final.
    


buscarFuncaoNaLista :: Id -> [Funcao] -> Maybe Funcao
buscarFuncaoNaLista _ [] = Nothing
buscarFuncaoNaLista id (f@(fId :->: _) : fs)
    | id == fId = Just f
    | otherwise = buscarFuncaoNaLista id fs


-- func que recebe a SymTab, a expressao, o label v e f
genExprL :: GenEnv -> ExprL -> String -> String -> State Int String
-- a expressao logica é uma unica expressao relacional
genExprL env (Rel exprR) lTrue lFalse = genExprR env exprR lTrue lFalse

genExprL env (And e1 e2) lTrue lFalse = do
    lMeio <- novoLabel

    code1 <- genExprL env e1 lMeio lFalse  -- gera o codigo de e1 e ve se pula pro final ou segue a avaliacao
    code2 <- genExprL env e2 lTrue lFalse -- o mesmo, mas aqui pode concluir que a exprL é V

    return (code1 ++ lMeio ++":\n" ++ code2)

genExprL env (Or e1 e2) lTrue lFalse = do
    lMeio <- novoLabel

    code1 <- genExprL env e1 lTrue lMeio -- se e1 é V entao pode pular para o final, se nao devemos segir para lMeio
    code2 <- genExprL env e2 lTrue lFalse

    return (code1 ++ lMeio ++ ":\n" ++ code2)

genExprL env (Not e) lTrue lFalse = 
    genExprL env e lFalse lTrue  -- basta inverter os saltos





-- Gera código para uma expressão RELACIONAL que resulta em um salto.
genExprR :: GenEnv -> ExprR -> String -> String -> State Int String
genExprR env@(_, tab) exprR lTrue lFalse = do
    -- A lógica de gerar o código das sub-expressões é a mesma para todos.
    let (op, e1, e2) = case exprR of
                        Req a b -> ("==", a, b)
                        Rdf a b -> ("/=", a, b)
                        Rle a b -> ("<=", a, b)
                        Rge a b -> (">=", a, b)
                        Rlt a b -> ("<",  a, b)
                        Rgt a b -> (">",  a, b)
    
    (tipo1, code1) <- genExpr env e1
    (_,     code2) <- genExpr env e2

    let relCode = genRel op tipo1 lTrue
    return (code1 ++ code2 ++ relCode ++ "\tgoto " ++ lFalse ++ "\n")

-- ADICAO int x = 5; 
genCmd :: GenEnv -> Comando -> State Int String
-- Adicione esta nova equação
-- Caso para uma declaração pura (ex: int x, y;).
-- O espaço para as variáveis já foi alocado em .limit locals.
-- Não há código a ser gerado para esta linha.
genCmd env (Decl _) = return ""

-- Adicione esta nova equação
-- Caso para uma declaração com atribuição (ex: int x = 10;).
-- Isso é funcionalmente idêntico a um comando de atribuição.
-- Reutilizamos a lógica de 'Atrib'.
genCmd env (DeclComAtrib (varId :#: _) expr) = genCmd env (Atrib varId expr)

genCmd env@(_, tab) (Atrib nome expr) = do
    (_, codeExpr) <- genExpr env expr -- gera o codigo para a expressao do lado direito, isso deixa a expressao no topo da pilha

    case buscarSimbolo nome tab of
        Nothing -> error ("[CodeGen] Erro fatal: variavel de atribuicao '"++ nome ++ "' nao encontrada")
        Just (tipo, indice) -> do
            let instr = case tipo of
                            TInt   -> "istore"
                            TBool -> "istore"
                            TDouble -> "dstore"
                            TString -> "astore"
                            _       -> error "[CodeGen] Atribuicao para tipo invalido!"
            return (codeExpr ++ "\t" ++ instr ++ " " ++ show indice ++ "\n")

genCmd env@(_, tab) (Imp expr) = do
    (tipoExpr, codeExpr) <- genExpr env expr
    let tipoJasmin = case tipoExpr of
                        TInt    -> "I"
                        TDouble -> "D"
                        TString -> "Ljava/lang/String;"
                        _       -> "V" -- so para casos de erros indefinidos
    return ( "\tgetstatic java/lang/System/out Ljava/io/PrintStream;\n" ++ codeExpr ++ "\tinvokevirtual java/io/PrintStream/println(" ++ tipoJasmin ++ ")V\n")

genCmd env (If cond blocoThen []) = do   -- if sem else
    lTrue <- novoLabel
    lEnd <- novoLabel 

    codeCond <-genExprL env cond lTrue lEnd
    codeThen <- genBloco env blocoThen
    return (codeCond ++ lTrue ++ ":\n" ++ codeThen ++ lEnd ++ ":\n")

genCmd env (If cond blocoThen blocoElse) = do   -- if com else
    lTrue <- novoLabel
    lFalse <- novoLabel
    lEnd <- novoLabel 

    codeCond <- genExprL env cond lTrue lFalse  -- gera o codigo e faz o salto se for true ou false

    codeThen <-genBloco env blocoThen
    codeElse <- genBloco env blocoElse

    return (codeCond ++ lTrue ++ ":\n" ++ codeThen ++ "\tgoto " ++ lEnd ++ "\n" ++ lFalse ++ ":\n" ++ codeElse ++ "\tgoto " ++ lEnd ++ "\n" ++ lEnd ++ ":\n")

genCmd env (While cond blocoLoop) = do
    lTeste <- novoLabel
    lCorpo <- novoLabel
    lEnd <- novoLabel

    codeCond <- genExprL env cond lCorpo lEnd
    codeBloco <- genBloco env blocoLoop

    return (lTeste ++ ":\n" ++ codeCond ++ lCorpo ++ ":\n" ++ codeBloco ++ "\tgoto " ++ lTeste ++ "\n" ++ lEnd ++ ":\n")


genCmd env (Ret maybeExpr) = do
    case maybeExpr of
        Nothing -> return "\treturn\n" -- retorno para funcoes do tipo void

        Just expr -> do  -- caso para return <expr>
            (tipo, codeExpr) <- genExpr env expr  -- gera o codigo para a expressao e coloca na pilha

            let returnInstr = case tipo of
                                TInt -> "ireturn"
                                TBool -> "ireturn" -- <<< ADICIONE ESTE CASO
                                TDouble -> "dreturn"
                                TString -> "areturn"
                                TVoid -> "return"
            return (codeExpr ++ "\t" ++ returnInstr ++ "\n")

genCmd env (Proc id args) = do
    (tipoRetorno, codeChamada) <- genExpr env (Chamada id args)  -- mesma logica de Chamada para gerar o codigo
    let popInstr = if tipoRetorno /= TVoid then "\tpop\n" else "" -- se a funcao chamada retornar um valor devemos remover ela da pilha
    

    return (codeChamada ++ popInstr)

genOp :: Tipo -> String -> String
genOp TInt    op = "\ti" ++ op ++ "\n"
genOp TDouble op = "\td" ++ op ++ "\n"
genOp _       op = error ("[CodeGen] Operador '" ++ op ++ "' não suportado para este tipo.")

-- Gera a instrução correta para uma constante inteira.
genInt :: Int -> String
genInt i
    | i == -1               = "\ticonst_m1\n"
    | i >= 0 && i <= 5      = "\ticonst_" ++ show i ++ "\n" -- Atalho para i==0, i==1, etc.
    | i >= -128 && i <= 127 = "\tbipush " ++ show i ++ "\n"
    | i >= -32768 && i <= 32767 = "\tsipush " ++ show i ++ "\n"
    | otherwise             = "\tldc " ++ show i ++ "\n"

genRel :: String -> Tipo -> String -> String
genRel op TInt labelTrue =
    let instr = case op of
                    "==" -> "if_icmpeq"
                    "/=" -> "if_icmpne"
                    "<"  -> "if_icmplt"
                    "<=" -> "if_icmple"
                    ">"  -> "if_icmpgt"
                    ">=" -> "if_icmpge"
                    _    -> error "[CodeGen] Operador relacional desconhecido."
    in "\t" ++ instr ++ " " ++ labelTrue ++ "\n"

-- logica do booleano
genRel op TBool labelTrue = genRel op TInt labelTrue

genRel op TDouble labelTrue =

    -- logica usada:
    -- 1 se valor1 > valor2
    -- 0 se valor1 == valor2
    -- -1 se valor1 < valor2
    
    let cmp_instr = "\tdcmpg\n"
        jump_instr = case op of
                        "==" -> "ifeq"
                        "/=" -> "ifne"
                        "<"  -> "iflt"
                        "<=" -> "ifle"
                        ">"  -> "ifgt"
                        ">=" -> "ifge"
                        _    -> error "[CodeGen] Operador relacional desconhecido para Double."

    in cmp_instr ++ "\t" ++ jump_instr ++" " ++ labelTrue ++ "\n"

genRel op TString labelTrue | op == "==" || op == "/=" = 
    let instr = case op of
                    "==" -> "if_acmpeq" --'acmp' signifca 'adress compare'
                    "/=" -> "if_acmpne"
    in "\t" ++ instr ++ " " ++ labelTrue ++ "\n"
genRel op TString _ = error ("[CodeGen] Operador relacional ' " ++ op ++ " ' não suportado para Strings.")

-- Caso de erro para outros tipos
genRel _ tipo _ = error ("[CodeGen] Comparações para o tipo " ++ show tipo ++ " ainda não implementadas.")

genBloco :: GenEnv -> Bloco -> State Int String
genBloco env comandos = concat <$> mapM (genCmd env) comandos

genMainCab :: Int -> Int -> String
genMainCab s l = ".method public static main([Ljava/lang/String;)V\n\t.limit stack "++show s++"\n\t.limit locals "++show l++"\n\n"



-- Converte um tipo da nossa linguagem para o descritor de tipo da JVM.
tipoParaJasmin :: Tipo -> String
tipoParaJasmin TInt    = "I"
tipoParaJasmin TDouble = "D"
tipoParaJasmin TBool = "Z"
tipoParaJasmin TString = "Ljava/lang/String;"
tipoParaJasmin TVoid   = "V"


-- Gera a assinatura completa de um método Jasmin a partir de uma lista de parâmetros e um tipo de retorno.
geraAssinatura :: [Var] -> Tipo -> String
geraAssinatura params tipoRetorno = "(" ++ paramsAssinatura ++ ")" ++ retornoAssinatura
    where
        getTipoParam (_ :#: (t, _)) = t
        paramsAssinatura = concatMap (tipoParaJasmin . getTipoParam) params
        retornoAssinatura = tipoParaJasmin tipoRetorno



genCabecalhoClasse :: [Char] -> [Char]
genCabecalhoClasse n = ".class public "++n++"\n.super java/lang/Object\n\n.method public <init>()V\n\taload_0\n\tinvokenonvirtual java/lang/Object/<init>()V\n\treturn\n.end method\n\n"

-- Gera o código para o método main
genMain :: [Funcao] -> [Var] -> Bloco -> State Int String
genMain listaFuncoes varsGlobais blocoPrincipal = do
    let (symTabGlobal, proxIndice) = criarTabela varsGlobais 1  -- cria a tabela de simbolos a partir da lista de [Var]
    
    let envMain = (listaFuncoes, symTabGlobal )

    let numLocals = 8
    let stackSize = 20
    let cabecalho = genMainCab stackSize numLocals
    corpo <- genBloco envMain blocoPrincipal

    return (cabecalho ++ corpo ++ "\treturn\n.end method\n")


-- func para gerar o codigo de uma funcao
genFuncao :: String -> [Funcao] -> Funcao -> (Id, [Var], Bloco) -> State Int String
genFuncao nomeClasse todasAsFuncoes (fId :->: (params, tipoRetorno)) (_, locais, bloco) = do
    -- 1. Criar a tabela de símbolos LOCAL para esta função.
    let (tabParams, proxIndiceParams) = criarTabela params 0
    let (tabLocais, proxIndiceLocais) = criarTabela locais proxIndiceParams
    let symTabLocal = Map.union tabParams tabLocais
    let numLocals = 8

    let envFuncao = (todasAsFuncoes, symTabLocal)

    -- 2. Construir o cabeçalho do método.
    let assinatura = geraAssinatura params tipoRetorno
    let cabecalho = "\n.method public static " ++ fId ++ assinatura ++ "\n"
                ++ "\t.limit stack 20\n"
                ++ "\t.limit locals " ++ show numLocals ++ "\n\n"

    -- 3. Gerar o código do corpo da função.
    corpoCode <- genBloco envFuncao bloco

    -- 4. Adicionar o 'return' default (necessário se não houver um explícito).
    -- A JVM exige que todo caminho de código termine com uma instrução de retorno.
    let finalReturn = case tipoRetorno of
                        TVoid -> "\treturn\n"
                        _     -> "" -- Assumimos que a função terá um 'Ret' explícito.
    
    -- 5. Montar o método completo.
    return (cabecalho ++ corpoCode ++ finalReturn ++ ".end method\n")



-- Orquestra a geração de código para o programa inteiro
genProg :: String -> Programa -> State Int String
genProg nomePrograma (Prog funcoesDefs funcoesCorpos varsGlobais blocoPrincipal) = do
    let cabecalhoClasse = genCabecalhoClasse nomePrograma
    
    -- Gera o código do main
    mainCode <- genMain funcoesDefs varsGlobais blocoPrincipal

    -- Gera o código para todas as outras funções
    -- 'zip' junta a lista de assinaturas com a lista de corpos
    let funcoesCompletas = zip funcoesDefs funcoesCorpos
    funcoesCodeList <- mapM (\(fDef, fCorpo) -> genFuncao nomePrograma funcoesDefs fDef fCorpo) funcoesCompletas
    let funcoesCode = concat funcoesCodeList

    return (cabecalhoClasse ++ mainCode ++ funcoesCode)

-- Função principal que será chamada por Main.hs
gerar :: String -> Programa -> String
gerar nomePrograma ast = fst $ runState (genProg nomePrograma ast) 0