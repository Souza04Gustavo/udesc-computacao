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
    

analisa :: Programa -> Result Programa
analisa (Prog funcoesDefs funcoesCorpos varsGlobais blocoPrincipal) = do
    
    verificaDuplicatas (\(fId :->:_) -> fId) funcoesDefs
    verificaDuplicatas (\(vId :#: _) -> vId) varsGlobais
    
    let envGlobal = (funcoesDefs, varsGlobais) -- Todas as funções são visíveis em todos os lugares.
    
    blocoPrincipal' <- analisaBloco envGlobal Nothing blocoPrincipal -- O 'Nothing' indica que não estamos dentro de uma função (importante para o 'return').
    
    funcoesCorpos' <- mapM (analisaFuncaoCompleta envGlobal) funcoesCorpos -- Analisar o corpo de cada função definida
    
    pure (Prog funcoesDefs funcoesCorpos' varsGlobais blocoPrincipal')



-- Analisa um bloco de comandos
analisaBloco :: Env -> Maybe Funcao -> Bloco -> Result Bloco
analisaBloco _ _ [] = pure [] -- Bloco vazio está sempre correto.
analisaBloco env maybeFuncao (cmd:cmds) = do

    cmd' <- analisaComando env maybeFuncao cmd -- Analisa o primeiro comando
    cmds' <- analisaBloco env maybeFuncao cmds -- Analisa o resto do bloco
    pure (cmd' : cmds') -- Retorna o novo bloco com os comandos analisados

analisaFuncaoCompleta :: Env -> (Id, [Var], Bloco) -> Result (Id, [Var], Bloco)
analisaFuncaoCompleta envGlobal (fId, locals, bloco) =
    -- Primeiro, encontramos a assinatura completa da função para obter seus parâmetros e tipo de retorno.
    case buscarFuncao fId envGlobal of
        Nothing -> do
            errorMsg ("errorMsg interno: Corpo definido para função '" ++ fId ++ "' que não possui assinatura.")
            pure (fId, locals, bloco)

        Just (funcao@(_ :->: (params, _))) -> do
            -- Verificar duplicatas entre parâmetros e variáveis locais.
            verificaDuplicatas (\(pId :#: _) -> pId) params
            verificaDuplicatas (\(vId :#: _) -> vId) locals
    
            -- Construir o ambiente LOCAL da função.
            let (funcoesGlobais, varsGlobais) = envGlobal
            let envLocal = (funcoesGlobais, locals ++ params ++ varsGlobais)

            -- Analisar o bloco da função com o ambiente local.
            bloco' <- analisaBloco envLocal (Just funcao) bloco

            -- Retorna a nova tupla representando o corpo da função analisada.
            pure (fId, locals, bloco')


coercao :: String -> Expr -> Expr -> Tipo -> Tipo -> Result (Tipo, Expr, Expr)
coercao opStr e1 e2 t1 t2
  | t1 == t2 && (t1 == TInt || t1 == TDouble) = return (t1, e1, e2)
  | t1 == TInt && t2 == TDouble = return (TDouble, IntDouble e1, e2)
  | t1 == TDouble && t2 == TInt = return (TDouble, e1, IntDouble e2)
  | otherwise = do
      errorMsg $ "Erro de tipos na expressao. Operador '" ++ opStr ++ "' nao pode ser aplicado a " ++
                 "operandos dos tipos " ++ show t1 ++ " e " ++ show t2 ++ "."
      return (TVoid, e1, e2) -- Retorna tipo de erro


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

    DoWhile bloco cond -> do
        cond' <- analisaExprL env cond
        bloco' <- analisaBloco env maybeFuncao bloco
        pure (DoWhile bloco' cond')


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

    -- varaivel tipo 'contador'
    IdVar id -> case buscarVar id env of
        Just tipo -> pure (tipo, IdVar id)
        Nothing -> do
            errorMsg("Variavel '" ++ id ++ "' nao declarada.")
            pure(TVoid, IdVar id) -- Retorna TVoid em caso de errorMsg

    -- CASOS RECURSIVOS

    Ternario cond eTrue eFalse -> do
        -- 1. Analisa a condição. Ela já deve ser uma ExprL, então usamos analisaExprL.
        cond' <- analisaExprL env cond

        -- 2. Analisa as duas expressões de resultado.
        (tipoTrue, eTrue') <- analisaExpr env eTrue
        (tipoFalse, eFalse') <- analisaExpr env eFalse

        -- 3. Verifica a compatibilidade dos tipos dos resultados.
        --    Esta lógica é muito parecida com a de 'coercao'.
        case (tipoTrue, tipoFalse) of
            -- Se os tipos são iguais, esse é o tipo final.
            (t1, t2) | t1 == t2 ->
                pure (t1, Ternario cond' eTrue' eFalse')
            
            -- Se um é Int e o outro é Double, o tipo final é Double.
            (TInt, TDouble) ->
                -- Coerge a expressão 'true' para Double.
                pure (TDouble, Ternario cond' (IntDouble eTrue') eFalse')
            (TDouble, TInt) ->
                -- Coerge a expressão 'false' para Double.
                pure (TDouble, Ternario cond' eTrue' (IntDouble eFalse'))

            -- Todos os outros casos são erros de tipo.
            (t1, t2) -> do
                errorMsg ("Tipos incompativeis no operador ternario: " ++ show t1 ++ " e " ++ show t2)
                pure (TVoid, Ternario cond' eTrue' eFalse')


    Neg e -> do
        -- Analise recursiva da expressão 'e'
        (tipoSubExpr, novaSubExpr) <- analisaExpr env e

        -- Verifica se o tipo é compatível com a negação (so nao é valida se for string)
        if tipoSubExpr == TString
            then do
                errorMsg("Nao se pode negar uma expressao do tipo String.")
                pure (TVoid, Neg novaSubExpr) -- Retorna TVoid em caso de errorMsg
            else
                -- Retorna o tipo e a nova expressão (Negar um Double retorna um double)
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
    if t1 == TString && t2 == TString then
        pure (construtor e1' e2')
    else do
        (_, coercedE1, coercedE2) <- coercao opStr e1' e2' t1 t2
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
    -- Caso base: uma expressao logica que é, na vv, uma relacional
    Rel exprR -> do 
        novaExprR <- analisaExprR env exprR
        pure (Rel novaExprR)

    -- Casos recursivos para operadores logicos
    And e1 e2 -> do
        novaE1 <- analisaExprL env e1
        novaE2 <- analisaExprL env e2
        pure (And novaE1 novaE2)

    Or e1 e2 -> do
        novaE1 <- analisaExprL env e1
        novaE2 <- analisaExprL env e2
        pure (Or novaE1 novaE2)

    Not e -> do
        novaE <- analisaExprL env e
        pure (Not novaE)