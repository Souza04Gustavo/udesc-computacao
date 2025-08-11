# Compilador para Linguagem Simples

Este repositório contém o desenvolvimento de um compilador, como parte da disciplina de Compiladores da UDESC (Universidade do Estado de Santa Catarina). O objetivo final do trabalho é a implementação de um compilador que gere *bytecodes Java* (utilizando Jasmin) para uma linguagem de programação simples especificada.

O projeto está atualmente na **2ª Etapa**, que inclui a implementação do **analisador léxico**, **sintático** e **semântico**. O analisador semântico é responsável por verificar a correção de tipos, escopo de variáveis e a lógica geral do programa, anotando a Árvore Sintática Abstrata (AST) com informações de tipo e coerções.

## Desenvolvedores

*   José Augusto Laube
*   Gustavo de Souza

## Estrutura dos Arquivos

O projeto está organizado nos seguintes arquivos principais:

*   **`Ri.hs`**:
    *   **Descrição**: Define as estruturas de dados em Haskell para a Árvore Sintática Abstrata (AST) da linguagem. Isso inclui tipos para representar expressões aritméticas (`Expr`), expressões relacionais (`ExprR`), e expressões lógicas (`ExprL`).
    *   **Conteúdo Principal**: Definições dos tipos de dados `Expr`, `ExprR`, `ExprL` e seus construtores.

*   **`Token.hs`**:
    *   **Descrição**: Define os tipos de tokens que são reconhecidos pelo analisador léxico. Cada token representa uma unidade lexical fundamental da linguagem (ex: número, operador, identificador).
    *   **Conteúdo Principal**: Definição do tipo de dado `Token` e seus construtores (e.g., `NUM`, `ADD`, `ID`, `AND`).

*   **`Lex.x`**:
    *   **Descrição**: Contém as regras para o analisador léxico, escritas na sintaxe da ferramenta Alex. Define como sequências de caracteres do código fonte são convertidas em tokens (definidos em `Token.hs`).
    *   **Conteúdo Principal**: Expressões regulares para reconhecer números, identificadores, operadores e outros símbolos, e as ações para gerar os tokens correspondentes.

*   **`Parser.y`**:
    *   **Descrição**: Contém as regras gramaticais da linguagem, escritas na sintaxe da ferramenta Happy. Define a estrutura sintática da linguagem, ou seja, como os tokens podem ser combinados para formar construções válidas (como expressões). Também inclui as ações semânticas para construir a AST (definida em `Ri.hs`) a partir das regras reconhecidas.
    *   **Conteúdo Principal**: Definição da gramática BNF da linguagem, precedência e associatividade de operadores, e ações para construção da AST. Inclui uma função `main` para testar o parser.

*   **`Semantic.hs`**: Implementa o **analisador semântico**. Percorre a AST gerada pelo parser para realizar a verificação de tipos, escopo e outras regras da linguagem. Utiliza uma Mônada para acumular erros e avisos.

*   **`Main.hs`**: O **ponto de entrada** do compilador. Orquestra o processo: lê um arquivo fonte, chama o lexer, o parser e, em seguida, o analisador semântico, imprimindo o resultado final.


## Funcionalidades Implementadas

-   **Análise Léxica e Sintática:** Reconhecimento completo da gramática da linguagem, incluindo declarações, comandos e expressões.
-   **Construção da AST:** O parser gera uma representação fiel do código fonte como uma Árvore Sintática Abstrata.
-   **Verificação de Declarações Duplicadas:** O analisador semântico detecta e reporta erros para funções ou variáveis globais declaradas múltiplas vezes.
-   **Verificação de Uso de Símbolos não Declarados:** Detecta o uso de variáveis ou funções que não foram previamente declaradas no escopo visível.
-   **Análise de Tipos em Expressões:** Verificação inicial de tipos para operadores aritméticos, lógicos e relacionais, incluindo as regras para uso do tipo `string`.

## Pré-requisitos e Instalação (Linux Ubuntu)

Para compilar e executar este projeto, você precisará das seguintes ferramentas:

1.  **GHC (Glasgow Haskell Compiler)**: O compilador para a linguagem Haskell.
2.  **Alex**: Um gerador de analisadores léxicos para Haskell.
3.  **Happy**: Um gerador de analisadores sintáticos para Haskell.

**Instruções de Instalação no Ubuntu:**

```bash
# Atualizar lista de pacotes
sudo apt update

# Instalar GHC (Glasgow Haskell Compiler)
sudo apt install ghc

# Instalar Alex e Happy
# Essas ferramentas são geralmente empacotadas como 'alex' e 'happy' nos repositórios do Ubuntu.
sudo apt install alex happy
```

## Como Compilar e Executar

1. **Gere os arquivos Haskell a partir do Alex e Happy:**
Navegue até o diretório do projeto no terminal e execute:

```bash
alex Lex.x      # Isso gerará o arquivo Lex.hs
happy Parser.y  # Isso gerará o arquivo Parser.hs
ghci Main.hs  # Isso executará o Parser.hs criado
```
2. **Teste:**
O programa irá ler o arquivo especificado em Main.hs, processá-lo e imprimir as mensagens de erro/aviso do analisador semântico, seguidas pela AST final. Modifique o nome do arquivo em Main.hs para testar diferentes códigos-fonte.

## Funcionalidades Pendentes (To-Do)

Esta seção descreve as funcionalidades restantes a serem implementadas no analisador semântico.

### Fase 4: Coerção de Tipos e Verificação de Atribuições

Esta fase foca em modificar a AST para inserir conversões de tipo implícitas e validar atribuições.

-   [ ] **Implementar Promoção de Tipo em Expressões (`int` para `double`)**
    -   **Onde:** Nas funções auxiliares de análise de expressões binárias (`analisaExprAritmeticaBinaria` e `analisaExprRelacionalBinaria`).
    -   **O que fazer:** Atualmente, uma expressão como `5 + 2.5` gera um erro de tipos incompatíveis. É necessário modificar a lógica para:
        1.  Detectar a combinação de operandos `TInt` e `TDouble`.
        2.  Envolver a sub-árvore do operando `TInt` com o construtor `IntDouble`.
        3.  Definir o tipo resultante da expressão inteira como `TDouble`.

-   [ ] **Implementar Coerção em Comandos de Atribuição**
    -   **Onde:** No `case` do comando `Atrib id expr` dentro de `analisaComando`.
    -   **O que fazer:** Após obter o tipo da variável (`tipoVar`) e o tipo da expressão (`tipoExpr`), implementar as seguintes regras:
        -   **Promoção (`int -> double`):** Se `tipoVar` é `TDouble` e `tipoExpr` é `TInt`, a AST da expressão deve ser modificada para `IntDouble expr'`.
        -   **Rebaixamento (`double -> int`):** Se `tipoVar` é `TInt` e `tipoExpr` é `TDouble`, a AST da expressão deve ser modificada para `DoubleInt expr'` e uma **mensagem de aviso (warning)** sobre possível perda de precisão deve ser emitida.
        -   **Erro de Tipos:** Se os tipos forem diferentes e nenhuma das regras de coerção acima se aplicar (ex: `int = string`), emitir uma mensagem de erro.

### Fase 5: Análise de Escopo de Funções e Verificação Completa

Esta é a fase final, que lida com o escopo local das funções, a validação de retornos e a verificação completa de chamadas de função.

-   [ ] **Analisar o Corpo das Funções**
    -   **Onde:** Na função principal `analisa`.
    -   **O que fazer:** Iterar sobre a lista de definições de funções (`corposFuncoes`). Para cada função, é preciso:
        1.  Criar um **ambiente de análise local**, que inclua as variáveis globais e os parâmetros da função.
        2.  Chamar `analisaBloco` passando o novo ambiente local e um `(Just funcao)` para que os comandos internos (como `return`) saibam em qual função estão.

-   [ ] **Implementar Verificação do Comando `return`**
    -   **Onde:** Adicionar um `case` para `Ret (Maybe Expr)` em `analisaComando`.
    -   **O que fazer:**
        1.  Verificar se o comando está dentro de uma função. Se não estiver, é um erro.
        2.  Comparar o tipo da expressão retornada com o tipo de retorno esperado pela função.
        3.  Aplicar as mesmas regras de coerção da atribuição.
        4.  Se o `return` for vazio (`Ret Nothing`), verificar se o tipo de retorno esperado da função é `TVoid`.

-   [ ] **Implementar Verificação Completa de Chamadas de Função**
    -   **Onde:** Nos `case` de `Chamada id args` e `Proc id args`.
    -   **O que fazer:** Expandir a lógica atual para:
        1.  **Verificação de Aridade:** Comparar o número de argumentos fornecidos com o número de parâmetros esperados.
        2.  **Verificação de Tipos dos Argumentos:** Para cada par `(argumento, parâmetro)`, aplicar a lógica de verificação e coerção de tipos, modificando a AST dos argumentos quando necessário.


##
