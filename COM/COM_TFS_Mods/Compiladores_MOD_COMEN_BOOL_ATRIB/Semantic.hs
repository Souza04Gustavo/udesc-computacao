module Semantic where

import Ri   
import Control.Monad (when, zipWithM)

data Result a = Result (Bool, String, a) deriving Show

instance Functor Result where
  fmap f (Result (b, s, a)) = Result (b, s, f a)

instance Applicative Result where
  pure a = Result (False, "", a)
  Result (b1, s1, f) <*> Result (b2, s2, x) = Result (b1 || b2, s1 <> s2, f x)

instance Monad Result where
  Result (b, s, a) >>= f = let Result (b', s', a') = f a in Result (b || b', s++s', a')


-- ADICAO int x = 5; 
-- PASSADA 1: Coleta todas as variáveis declaradas em um bloco.
coletarVariaveis :: Bloco -> [Var]
coletarVariaveis bloco = concatMap extrair bloco
  where
    -- Função local que extrai Vars de um único Comando.
    extrair :: Comando -> [Var]
    extrair (Decl vars)            = vars
    extrair (DeclComAtrib var _)   = [var]
    -- Para qualquer outro comando, não há variáveis a serem extraídas.
    extrair _                      = []


errorMsg :: String -> Result ()
errorMsg s = Result (True, "Erro: " ++ s ++ "\n", ())

warningMsg :: String -> Result ()
warningMsg s = Result (False, "Advertencia: " ++ s ++ "\n", ())

-- O Ambiente de Análise: uma lista de todas as funções e uma lista das variáveis no escopo atual.
type Env = ([Funcao], [Var])

-- Busca uma variável no ambiente e retorna seu tipo.
buscarVar :: Id -> Env -> Maybe Tipo
buscarVar id (_, []) = Nothing -- Não achou na lista de variáveis
buscarVar id (funcoes, (var@(vId :#: (tipo, _))) : vs) =
    if id == vId
        then Just tipo
        else buscarVar id (funcoes, vs)

-- Busca uma função no ambiente e retorna sua assinatura completa.
buscarFuncao :: Id -> Env -> Maybe Funcao
buscarFuncao id ([], _) = Nothing -- Não achou na lista de funções
buscarFuncao id ((fun@(fId :->: _)) : fs, vars) =
    if id == fId
        then Just fun
        else buscarFuncao id (fs, vars)

--percorre a lista mantendo um registro dos nomes que ja foram visto
verificaDuplicatas :: (Eq a, Show a) => (b -> a) -> [b] -> Result ()
verificaDuplicatas extrairNome lista = go lista []
  where
    go [] _ = pure () -- Caso base: se a lista a verificar está vazia, terminamos sem errorMsgs.

    go (itemAtual : restoDaLista) nomesVistos = do
        let nomeAtual = extrairNome itemAtual

        if nomeAtual `elem` nomesVistos -- Verifica se o nome extraído já está na lista de nomes vistos
        
            then errorMsg ("Identificador duplicado encontrado: " ++ show nomeAtual)
            else go restoDaLista (nomeAtual : nomesVistos)
    

-- ADICAO int x = 5; 
analisa :: Programa -> Result Programa
analisa (Prog funcoesDefs funcoesCorpos _ blocoPrincipal) = do -- Ignoramos varsGlobais do parser
    -- PASSADA 1 (para o main): Coleta de variáveis globais.
    let varsGlobais = coletarVariaveis blocoPrincipal

    -- Verificação de duplicatas
    verificaDuplicatas (\(fId :->:_) -> fId) funcoesDefs
    verificaDuplicatas (\(vId :#: _) -> vId) varsGlobais
    
    -- Construir o ambiente global
    let envGlobal = (funcoesDefs, varsGlobais)

    -- PASSADA 2 (para o main): Analisar o bloco principal com o ambiente completo.
    blocoPrincipal' <- analisaBloco envGlobal Nothing blocoPrincipal
    
    -- Analisar o corpo de cada função definida
    funcoesCorpos' <- mapM (analisaFuncaoCompleta envGlobal) funcoesCorpos
    
    -- Retorna a AST final, usando a 'varsGlobais' que NÓS coletamos.
    pure (Prog funcoesDefs funcoesCorpos' varsGlobais blocoPrincipal')



-- Analisa um bloco de comandos
analisaBloco :: Env -> Maybe Funcao -> Bloco -> Result Bloco
analisaBloco _ _ [] = pure [] -- Bloco vazio está sempre correto.
analisaBloco env maybeFuncao (cmd:cmds) = do

    cmd' <- analisaComando env maybeFuncao cmd -- Analisa o primeiro comando
    cmds' <- analisaBloco env maybeFuncao cmds -- Analisa o resto do bloco
    pure (cmd' : cmds') -- Retorna o novo bloco com os comandos analisados

-- ADICAO int x = 5; 
analisaFuncaoCompleta :: Env -> (Id, [Var], Bloco) -> Result (Id, [Var], Bloco)
analisaFuncaoCompleta envGlobal (fId, _, bloco) = -- Ignoramos a lista de locais do parser
    case buscarFuncao fId envGlobal of
        Nothing -> do
            errorMsg ("Erro interno: Corpo definido para função '" ++ fId ++ "' que não possui assinatura.")
            pure (fId, [], bloco)

        Just (funcao@(_ :->: (params, _))) -> do
            -- 1. FAZ A PASSADA DE COLETA para encontrar todas as variáveis locais.
            let locais = coletarVariaveis bloco
            
            -- 2. VERIFICA DUPLICATAS (como antes).
            verificaDuplicatas (\(pId :#: _) -> pId) params
            verificaDuplicatas (\(vId :#: _) -> vId) locais
            
            -- 3. CONSTRÓI O AMBIENTE LOCAL COMPLETO.
            let (funcoesGlobais, varsGlobais) = envGlobal
            let envLocal = (funcoesGlobais, params ++ locais ++ varsGlobais)

            -- 4. FAZ A PASSADA DE ANÁLISE com o ambiente completo.
            bloco' <- analisaBloco envLocal (Just funcao) bloco

            -- 5. Retorna o resultado. Note que agora retornamos a lista 'locais' que NÓS coletamos.
            pure (fId, locais, bloco')


coercao :: String -> Expr -> Expr -> Tipo -> Tipo -> Result (Tipo, Expr, Expr)
coercao opStr e1 e2 t1 t2

  -- NOVO GUARD: Se qualquer um dos operandos for booleano, é um erro.
  | t1 == TBool || t2 == TBool = do
      errorMsg $ "Operador aritmetico '" ++ opStr ++ "' nao pode ser aplicado a operandos do tipo booleano."
      return (TVoid, e1, e2)
  -- Seus outros guards continuam os mesmos

  | t1 == t2 && (t1 == TInt || t1 == TDouble) = return (t1, e1, e2)
  | t1 == TInt && t2 == TDouble = return (TDouble, IntDouble e1, e2)
  | t1 == TDouble && t2 == TInt = return (TDouble, e1, IntDouble e2)
  | otherwise = do
      errorMsg $ "Erro de tipos na expressao. Operador '" ++ opStr ++ "' nao pode ser aplicado a " ++
                 "operandos dos tipos " ++ show t1 ++ " e " ++ show t2 ++ "."
      return (TVoid, e1, e2) -- Retorna tipo de erro

-- ADICAO int x = 5; 
analisaComando :: Env -> Maybe Funcao -> Comando -> Result Comando
analisaComando env maybeFuncao cmd = case cmd of
    
    -- comando print(expr)
    Imp expr -> do
        (_, expr') <- analisaExpr env expr  -- warningMsg "Comando 'print' encontrado."
        pure (Imp expr')  -- Retorna o comando Imp com a expressão analisada.
    
    -- Comando 'id = expr;'
    Atrib id expr -> do
        (tipoExpr, expr') <- analisaExpr env expr
        case buscarVar id env of
            Nothing -> do
                errorMsg ("Variável de atribuição '" ++ id ++ "' não declarada.")
                pure (Atrib id expr')
 
            Just tipoVar -> do
                -- Se a expressão já resultou em errorMsg, não fazemos mais nada.
                if tipoExpr == TVoid then
                    pure (Atrib id expr')
                else case (tipoVar, tipoExpr) of
                    -- Caso 1: Tipos são idênticos. Atribuição válida.
                    (TDouble, TDouble) -> pure (Atrib id expr')
                    (TInt, TInt)       -> pure (Atrib id expr')
                    (TString, TString) -> pure (Atrib id expr')
                    (TBool, TBool)     -> pure (Atrib id expr') -- <<< LINHA ADICIONADA

                    -- Caso 2: Promoção (int -> double). Válido.
                    (TDouble, TInt) -> pure (Atrib id (IntDouble expr'))

                    -- Caso 3: Rebaixamento (double -> int). Válido, mas com aviso.
                    (TInt, TDouble) -> do
                        warningMsg ("Atribuição de Double para Int na variável '" ++ id ++ "'. Pode haver perda de precisão.")
                        pure (Atrib id (DoubleInt expr'))
                    
                    -- Caso 4: Todos os outros são errorMsgs de tipo.
                    _ -> do
                        errorMsg ("errorMsg de tipo na atribuição para '" ++ id ++ "'. Esperado " ++ show tipoVar ++ " mas obteve " ++ show tipoExpr ++ ".")
                        pure (Atrib id expr')


    -- Chamada de um procedimento (função que não retorna valor)
    Proc id args -> case buscarFuncao id env of
        Nothing -> do
            errorMsg ("Procedimento '" ++ id ++ "' não declarado.")
            pure (Proc id args)

        Just (_ :->: (params, tipoRetorno)) -> do
            when (tipoRetorno /= TVoid) $
                warningMsg ("Função '" ++ id ++ "' que retorna " ++ show tipoRetorno ++ " está sendo chamada como um procedimento. O valor de retorno será descartado.")
            
            -- Mesma lógica da Chamada de função
            novosArgs <- analisaArgumentos env params args
            pure (Proc id novosArgs)


    If cond blocoThen blocoElse -> do
        cond' <- analisaExprL env cond  -- Analisamos a condicao, que deve ser uma expressao logica, exemplo (12 == 90)

        -- Analisamos os blocos de comandos como de costume
        blocoThen' <- analisaBloco env maybeFuncao blocoThen
        blocoElse' <- analisaBloco env maybeFuncao blocoElse

        pure (If cond' blocoThen' blocoElse') -- Retorna o comando If com a condição e os blocos analisados

    While cond bloco -> do
        -- Mesma lógica do If
        cond' <- analisaExprL env cond
        bloco' <- analisaBloco env maybeFuncao bloco
        pure (While cond' bloco')


    Ret maybeExpr -> case maybeFuncao of
        Nothing -> do
            errorMsg "Comando de retorno ('return') encontrado fora de uma função."
            -- Analisa a expressão mesmo assim, se houver, para encontrar outros erros.
            case maybeExpr of
                Just expr -> Ret . Just . snd <$> analisaExpr env expr
                Nothing   -> pure (Ret Nothing)

        Just (funcao@(_ :->: (_, tipoRetornoEsperado))) ->
            case (maybeExpr, tipoRetornoEsperado) of
                -- Caso correto: return; em uma função void.
                (Nothing, TVoid) -> pure (Ret Nothing)

                -- Erro: return; em uma função que espera um valor.
                (Nothing, tipo) -> do
                    errorMsg ("Função espera um retorno do tipo " ++ show tipo ++ ", mas 'return' foi chamado sem valor.")
                    pure (Ret Nothing)

                -- Erro: return <expr>; em uma função void.
                (Just expr, TVoid) -> do
                    errorMsg ("Função com retorno 'void' não pode retornar um valor, mas uma expressão foi fornecida.")
                    Ret . Just . snd <$> analisaExpr env expr -- Analisa a expressão por outros erros.

                -- Caso correto: return <expr>; em uma função que espera um valor.
                (Just expr, tipo) -> do
                    (tipoExpr, expr') <- analisaExpr env expr
                    if tipoExpr == TVoid then
                        pure (Ret (Just expr')) -- Erro já emitido na análise da expressão.
                    else case (tipo, tipoExpr) of
                        _ | tipo == tipoExpr -> pure (Ret (Just expr'))
                        (TDouble, TInt)      -> pure (Ret (Just (IntDouble expr')))
                        (TInt, TDouble)      -> do
                            warningMsg ("Retorno de Double em uma função que espera Int. Pode haver perda de precisão.")
                            pure (Ret (Just (DoubleInt expr')))
                        _ -> do
                            errorMsg ("Tipo de retorno incorreto. Esperado " ++ show tipo ++ " mas a função retorna " ++ show tipoExpr ++ ".")
                            pure (Ret (Just expr'))

    -- ADICAO int x = 5; 
    (Decl _) -> pure (Decl [])

    -- Caso para uma declaração com atribuição (ex: int x = 10;).
    (DeclComAtrib var expr) -> do
        -- O registro da variável já foi feito. Agora, tratamos isso como uma atribuição.
        -- A lógica é a mesma do comando 'Atrib'.
        let (varId :#: (varTipo, _)) = var
        (tipoExpr, expr') <- analisaExpr env expr
        
        -- Lógica de verificação e coerção
        if tipoExpr == TVoid then
            pure (DeclComAtrib var expr') -- Propaga o erro
        else case (varTipo, tipoExpr) of
            _ | varTipo == tipoExpr -> pure (DeclComAtrib var expr')
            (TDouble, TInt)       -> pure (DeclComAtrib var (IntDouble expr'))
            (TInt, TDouble)       -> do
                warningMsg ("Atribuicao de Double para Int na declaracao da variavel '" ++ varId ++ "'. Pode haver perda de precisao.")
                pure (DeclComAtrib var (DoubleInt expr'))
            _ -> do
                errorMsg ("Erro de tipo na declaracao da variavel '" ++ varId ++ "'. Esperado " ++ show varTipo ++ " mas obteve " ++ show tipoExpr ++ ".")
                pure (DeclComAtrib var expr')


    _ -> pure cmd


-- Analisa e aplica coerção aos argumentos de uma chamada de função.
analisaArgumentos :: Env -> [Var] -> [Expr] -> Result [Expr]
analisaArgumentos ambienteDoChamador parametrosDaFuncao argumentosDaChamada = do
    
    -- Primeiro, verifica se o número de argumentos corresponde ao número de parâmetros.
    if length argumentosDaChamada /= length parametrosDaFuncao
    then do
        errorMsg ("Numero incorreto de argumentos. Esperado: " ++ show (length parametrosDaFuncao) ++ ", fornecido: " ++ show (length argumentosDaChamada) ++ ".")
        -- Analisa os argumentos mesmo assim para encontrar outros erros, usando o ambiente do chamador.
        mapM (fmap snd . analisaExpr ambienteDoChamador) argumentosDaChamada
    
    else
        -- 'zipWithM' itera sobre cada par (parâmetro, argumento) e aplica a análise.
        zipWithM analisaPar parametrosDaFuncao argumentosDaChamada

  where
    -- Função auxiliar para analisar um único par (parâmetro, argumento).
    analisaPar :: Var -> Expr -> Result Expr
    analisaPar parametro argumento = do
        -- Para verificar o tipo e a coerção, simulamos uma atribuição do argumento ao parâmetro.
        let (funcoes, varsDoChamador) = ambienteDoChamador
        let ambienteTemporario = (funcoes, parametro : varsDoChamador)
        
        -- O resultado é a AST do argumento, possivelmente modificada com nós de coerção.
        analisaComando ambienteTemporario Nothing (Atrib (getId parametro) argumento) >>= \(Atrib _ argumentoModificado) -> pure argumentoModificado

    -- Função auxiliar para extrair o Id de uma Var.
    getId :: Var -> Id
    getId (id :#: _) = id


-- adicao MOD e booleano
analisaExpr :: Env ->  Expr -> Result (Tipo, Expr)
analisaExpr env expr = case expr of
    
    -- CASOS BASE (Sem recursão) ABAIXO:

    -- Se for uma constante, retornamos o tipo e a expressão.
    Const (CInt n) -> do
        pure (TInt, Const (CInt n))

    -- Ex: 12.2123
    Const (CDouble d) -> do
        pure (TDouble, Const (CDouble d))

    -- Um literal string como "jose lindo"
    Lit s -> do
        pure(TString, Lit s)

    -- Adicione este novo caso, talvez perto dos outros literais.
    BConst b -> pure (TBool, BConst b)

    -- varaivel tipo 'contador'
    IdVar id -> case buscarVar id env of
        Just tipo -> pure (tipo, IdVar id)
        Nothing -> do
            errorMsg("Variavel '" ++ id ++ "' nao declarada.")
            pure(TVoid, IdVar id) -- Retorna TVoid em caso de errorMsg

    -- adicao do booleano
    -- CASOS RECURSIVOS
    Neg e -> do
        (tipoSubExpr, novaSubExpr) <- analisaExpr env e
        -- Verifica se o tipo é INVÁLIDO para a negação aritmética.
        if tipoSubExpr == TString || tipoSubExpr == TBool
            then do
                errorMsg ("Operador unario '-' nao pode ser aplicado a uma expressao do tipo " ++ show tipoSubExpr)
                -- Mesmo com erro, retornamos um resultado para não parar a análise.
                pure (TVoid, Neg novaSubExpr)
            else
                -- Se o tipo for válido (Int ou Double), o tipo do resultado é o mesmo.
                pure (tipoSubExpr, Neg novaSubExpr)

    Add e1 e2 -> do
        (t1, e1') <- analisaExpr env e1
        (t2, e2') <- analisaExpr env e2
        (tipoFinal, e1'', e2'') <- coercao "+" e1' e2' t1 t2
        return (tipoFinal, Add e1'' e2'')

    Sub e1 e2 -> do
        (t1, e1') <- analisaExpr env e1
        (t2, e2') <- analisaExpr env e2
        (tipoFinal, e1'', e2'') <- coercao "-" e1' e2' t1 t2
        return (tipoFinal, Sub e1'' e2'')

    Mul e1 e2 -> do
        (t1, e1') <- analisaExpr env e1
        (t2, e2') <- analisaExpr env e2
        (tipoFinal, e1'', e2'') <- coercao "*" e1' e2' t1 t2
        return (tipoFinal, Mul e1'' e2'')

    Div e1 e2 -> do
        (t1, e1') <- analisaExpr env e1
        (t2, e2') <- analisaExpr env e2
        (tipoFinal, e1'', e2'') <- coercao "/" e1' e2' t1 t2
        return (tipoFinal, Div e1'' e2'')
    
    Mod e1 e2 -> do
        (t1, e1') <- analisaExpr env e1
        (t2, e2') <- analisaExpr env e2
        -- modulo so funciona para inteiros
        if t1 == TInt && t2 == TInt 
            then return (TInt, Mod e1' e2')
            else do
                errorMsg ("Operador de modulo '%' so pode ser aplicado a operandos do tipo Int")
                return (TVoid, Mod e1' e2')


    -- Chamada de função como 'f(a,b)'
    Chamada id args -> case buscarFuncao id env of
        Nothing -> do
            errorMsg ("Funcao '" ++ id ++ "' nao declarada.")
            pure (TVoid, Chamada id args)

        Just (_ :->: (params, tipoRetorno)) -> do
            -- A nova função cuida de tudo: aridade, tipos e coerção.
            novosArgs <- analisaArgumentos env params args
            pure (tipoRetorno, Chamada id novosArgs)

    
    _ -> pure(TVoid, expr)



analisaExprRelacionalBinaria :: Env -> (Expr -> Expr -> ExprR) -> String -> Expr -> Expr -> Result ExprR
analisaExprRelacionalBinaria env construtor opStr e1 e2 = do
    (t1, e1') <- analisaExpr env e1
    (t2, e2') <- analisaExpr env e2

    if t1 == TBool && t2 == TBool then
        if opStr == "==" || opStr == "/=" then
            pure (construtor e1' e2')
        else do
            errorMsg ("Operador relacional '" ++ opStr ++ "' invalido para operandos booleanos.")
            pure (construtor e1' e2')
    
    else if t1 == TString && t2 == TString then
        if opStr == "==" || opStr == "/=" then
            pure (construtor e1' e2')
        else do
            errorMsg ("Operador relacional '" ++ opStr ++ "' invalido para operandos do tipo String.")
            pure (construtor e1' e2')

    else do
        -- CORREÇÃO AQUI:
        -- 1. Chamamos 'coercao' com a string do operador, não com 'fakeOp'.
        -- 2. Fazemos o pattern match com uma tupla de 3 elementos.
        (_, coercedE1, coercedE2) <- coercao opStr e1' e2' t1 t2
        
        -- 3. Agora podemos usar as expressões com coerção diretamente.
        pure (construtor coercedE1 coercedE2)

        
analisaExprR :: Env -> ExprR -> Result ExprR
analisaExprR env exprR = case exprR of
    Req e1 e2 -> analisaExprRelacionalBinaria env Req "==" e1 e2
    Rdf e1 e2 -> analisaExprRelacionalBinaria env Rdf "/=" e1 e2
    Rlt e1 e2 -> analisaExprRelacionalBinaria env Rlt "<"  e1 e2
    Rgt e1 e2 -> analisaExprRelacionalBinaria env Rgt ">"  e1 e2
    Rle e1 e2 -> analisaExprRelacionalBinaria env Rle "<=" e1 e2
    Rge e1 e2 -> analisaExprRelacionalBinaria env Rge ">=" e1 e2



analisaExprL :: Env -> ExprL -> Result ExprL
analisaExprL env exprL = case exprL of
    -- Caso para uma expressão relacional (ex: x > 5)
    Rel exprR -> do
        novaExprR <- analisaExprR env exprR
        pure (Rel novaExprR)

    -- Caso para o operador 'And'
    And e1 e2 -> do
        novaE1 <- analisaExprL env e1
        novaE2 <- analisaExprL env e2
        pure (And novaE1 novaE2)

    -- Caso para o operador 'Or'
    Or e1 e2 -> do
        novaE1 <- analisaExprL env e1
        novaE2 <- analisaExprL env e2
        pure (Or novaE1 novaE2)

    -- Caso para o operador 'Not'
    Not e -> do
        novaE <- analisaExprL env e
        pure (Not novaE)
