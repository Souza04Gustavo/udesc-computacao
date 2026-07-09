Require Import PeanoNat.
Require Import Coq.Arith.Le.
Require Import Coq.Bool.Bool.
Require Import Coq.Lists.List.
Import ListNotations.

Inductive reg_exp {T : Type} : Type :=
  | EmptySet
  | EmptyStr
  | Char (t : T)
  | App (r1 r2 : reg_exp)
  | Union (r1 r2 : reg_exp)
  | Star (r : reg_exp).

Reserved Notation "s =~ re" (at level 80).

Inductive exp_match {T} : list T -> reg_exp -> Prop :=
  | MEmpty : [] =~ EmptyStr
  | MChar x : [x] =~ (Char x)
  | MApp s1 re1 s2 re2
             (H1 : s1 =~ re1)
             (H2 : s2 =~ re2) :
             (s1 ++ s2) =~ (App re1 re2)
  | MUnionL s1 re1 re2
                (H1 : s1 =~ re1) :
                s1 =~ (Union re1 re2)
  | MUnionR re1 s2 re2
                (H2 : s2 =~ re2) :
                s2 =~ (Union re1 re2)
  | MStar0 re : [] =~ (Star re)
  | MStarApp s1 s2 re
                 (H1 : s1 =~ re)
                 (H2 : s2 =~ (Star re)) :
                 (s1 ++ s2) =~ (Star re)
  where "s =~ re" := (exp_match s re).

(* ================================================================= *)
(* Questão 1: Lógica Booleana.
   Motivo: O professor cobrou "true_or" antes. Essa é a irmã gêmea dela. 
   Testa o uso de "destruct" em booleanos e lógicas simultaneamente. *)

Theorem andb_true_iff : forall b1 b2 : bool,
  b1 && b2 = true <-> b1 = true /\ b2 = true.
Proof.
  intros b1 b2. split.
  - (* IDA *) 
    intros H. 
    (* Dica do Cheat Sheet: A função travou no booleano? Destruct nele! *)
    destruct b1.
    + simpl in H. split. reflexivity. apply H.
    + simpl in H. discriminate H. (* Absurdo, false = true *)
  - (* VOLTA *)
    intros H. destruct H as [H1 H2].
    rewrite H1. rewrite H2. simpl. reflexivity.
Qed.

(* ================================================================= *)
(* Questão 2: Listas e Indução.
   Motivo: Testa a indução padrão de listas e o comportamento do "simpl". *)

Theorem app_length : forall (X : Type) (l1 l2 : list X),
  length (l1 ++ l2) = length l1 + length l2.
Proof.
  intros X l1 l2.
  (* Fazemos indução na primeira lista, pois o '++' faz pattern match na esquerda *)
  induction l1 as [| h t IHl1].
  - (* Caso Base *)
    simpl. reflexivity.
  - (* Passo Indutivo *)
    simpl. 
    (* O objetivo é S (length (t ++ l2)) = S (length t + length l2) *)
    rewrite IHl1. 
    reflexivity.
Qed.

(* ================================================================= *)
(* Questão 3: Relações Indutivas Customizadas.
   Motivo: O professor criou o 'myle' na prova anterior. Aqui ele testará 
   se você sabe fazer a prova MAIS CLÁSSICA: a reflexividade (n <= n). *)

Inductive myle : nat -> nat -> Prop :=
  | myle_0 m : myle 0 m
  | myle_S n m (H : myle n m) : myle (S n) (S m).

Theorem myle_refl : forall n : nat, myle n n.
Proof.
  intros n. 
  (* Indução na variável n *)
  induction n as [| n' IHn].
  - (* Caso n = 0 *)
    apply myle_0.
  - (* Caso n = S n' *)
    (* O objetivo é myle (S n') (S n'). A regra myle_S resolve se provarmos myle n' n' *)
    apply myle_S.
    apply IHn.
Qed.

(* ================================================================= *)

(* Questão 4: Expressões Regulares (Regex)
   Motivo: O professor cobrou a regra do Union antes. Aqui temos um 
   EmptySet no meio. EmptySet não casa com nada! Testa o "inversion". *)

(*

(* (Assuma que as regras de exp_match estão carregadas) *)
Theorem union_emptyset_l : forall T (s : list T) (r : reg_exp),
  s =~ Union EmptySet r -> s =~ r.
Proof.
  intros T s r H.
  (* O Cheat Sheet (pág 10) diz: Union é o OU. O Coq cria MUnionL e MUnionR.
     Usamos inversion para quebrar a hipótese H *)
  inversion H.
  - (* Caso 1: A string validou o lado esquerdo (EmptySet). 
       Temos H2: s =~ EmptySet. Pelo Segredo de Mestre (Pág 10), isso explode! *)
    inversion H2.
  - (* Caso 2: A string validou o lado direito (r). 
       Temos H2: s =~ r. Exatamente nosso objetivo! *)
    apply H2.
Qed.
*)


(* ================================================================= *)
(* Questão 1: Lógica (Princípio da Explosão)
   Motivo: O professor gosta de lógicas fundamentais. Esse é o Teorema 
   Ex Falso Quodlibet (De uma mentira, prova-se qualquer coisa). *)

Theorem ex_falso : forall (P Q : Prop),
  P /\ ~P -> Q.
Proof.
  intros P Q H.
  (* H é um "E" (/\). Destruct sem barra (Cheat Sheet Pág. 4) *)
  destruct H as [Hp Hnot_p].
  (* unfold not revela que ~P é P -> False *)
  unfold not in Hnot_p.
  (* A tática exfalso (Pág. 3) troca nosso objetivo atual (Q) por False *)
  exfalso.
  (* Aplicamos Hnot_p para provar o False e Hp para fornecer o P *)
  apply Hnot_p.
  apply Hp.
Qed.

(* ================================================================= *)
(* Questão 2: Indução com Salva-Vidas
   Motivo: Exatamente a mesma pegadinha do "repeat_index", mas com a 
   função nativa 'In'. Testa se você lembra do generalize dependent. *)

Theorem in_map : forall (X Y : Type) (f : X -> Y) (l : list X) (x : X),
  In x l -> In (f x) (map f l).
Proof.
  intros X Y f l x H.
  (* PERIGO (Pág 6): Se fizermos indução em l, e x ficar fixo, pode quebrar.
     Mas como x não muda recursivamente, a indução em l direto funciona. *)
  induction l as [| h t IHl].
  - (* Caso l = [] *)
    simpl in H. destruct H. (* H é False, destruct mata a prova *)
  - (* Caso l = h :: t *)
    simpl in H. simpl.
    (* O 'In' gera um \/ (OU). Usamos destruct com barra vertical! *)
    destruct H as [H_head | H_tail].
    + (* Sub-caso: x é a cabeça (x = h) *)
      left. 
      rewrite H_head. reflexivity.
    + (* Sub-caso: x está na cauda (In x t) *)
      right.
      apply IHl.
      apply H_tail.
Qed.

(* ================================================================= *)
(* Questão 3: Indução em Evidência (O Coração do IndProp.v)
   Motivo: Essa questão é CLÁSSICA do arquivo IndProp.v ("ev_sum").
   O professor DEVE cobrar algo onde você faz indução na HIPÓTESE. *)

Inductive ev : nat -> Prop :=
  | ev_0                       : ev 0
  | ev_SS (n : nat) (H : ev n) : ev (S (S n)).

Theorem ev_sum : forall n m, ev n -> ev m -> ev (n + m).
Proof.
  intros n m Hn Hm.
  (* Não fazemos indução em n, fazemos indução NA PROVA DE QUE N É PAR (Hn) *)
  induction Hn as [| n' E' IH].
  - (* Caso Base: n era 0 *)
    simpl. apply Hm.
  - (* Passo Indutivo: n era S (S n') *)
    simpl.
    (* Objetivo: ev (S (S (n' + m))). Usamos a regra ev_SS! *)
    apply ev_SS.
    (* Agora o Coq pede para provarmos ev (n' + m).
       Isso é EXATAMENTE a nossa hipótese de indução (IH)! *)
    apply IH.
Qed.

(* ================================================================= *)
(* Questão 4: Expressões Regulares - Idempotência
   Motivo: Exercita o "inversion", "destruct" sem precisar de indução,
   mas exige entender bem a árvore lógica das regex. *)

Theorem union_idempotent : forall T (s : list T) (r : reg_exp),
  s =~ Union r r -> s =~ r.
Proof.
  intros T s r H.
  inversion H.
  - (* Caminho da esquerda (MUnionL) *)
    (* Aqui o Coq batizou a verdade de H2 *)
    apply H2.
  - (* Caminho da direita (MUnionR) *)
    (* Mas aqui o Coq mudou de ideia e batizou de H1! *)
    apply H1.
Qed.



(* ================================================================= *)
(* Questão 1: Construção Básica
   Motivo: O aluno sabe como a regra MApp junta duas listas? 
   DICA: Como o Coq não sabe onde cortar a lista [x; y], você precisa dar 
   uma "ajudinha" informando as metades para o MApp. *)

Theorem match_char_app : forall T (x y : T),
  [x; y] =~ App (Char x) (Char y).
Proof.
  intros T x y.
  (* A lista [x; y] é o mesmo que [x] ++ [y]. 
     Nós forçamos o Coq a usar a regra MApp dizendo quem é a primeira metade ([x]). *)
  apply (MApp [x] (Char x) [y] (Char y)).
  - (* O Coq pede para provar que [x] casa com Char x *)
    apply MChar.
  - (* O Coq pede para provar que [y] casa com Char y *)
    apply MChar.
Qed.

(* ================================================================= *)
(* Questão 2: Explosão em Cascata
   Motivo: Testa se você percebe que uma mentira dentro de uma regra válida 
   destrói a prova inteira. *)

Theorem app_emptyset_l : forall T (s : list T) (r : reg_exp),
  s =~ App EmptySet r -> False.
Proof.
  intros T s r H.
  (* Passo 1: O H é um App. Vamos quebrá-lo para ver o que tem dentro. *)
  inversion H.
  (* Passo 2: O Coq gerou as hipóteses para a metade 1 e metade 2.
     (LEMBRE-SE: Olhe no seu CoqIDE qual é a hipótese que diz "s1 =~ EmptySet").
     No meu Coq, ele chamou de H3. Vamos explodir ela! *)
  inversion H3.
Qed.

(* ================================================================= *)
(* Questão 3: Comutatividade do Union
   Motivo: Clássica prova de inversão. Se casa com (A ou B), 
   então casa com (B ou A). *)

Theorem union_comm : forall T (s : list T) (r1 r2 : reg_exp),
  s =~ Union r1 r2 -> s =~ Union r2 r1.
Proof.
  intros T s r1 r2 H.
  inversion H.
  - (* Caso validou r1 (MUnionL). O Coq extraiu s =~ r1 (provavelmente H2 ou H1) *)
    (* Para provar Union r2 r1 tendo r1, temos que ir pela DIREITA agora! *)
    apply MUnionR.
    apply H2. (* Confirme o nome no seu CoqIDE *)
  - (* Caso validou r2 (MUnionR). O Coq extraiu s =~ r2 (provavelmente H2 ou H1) *)
    (* Para provar Union r2 r1 tendo r2, temos que ir pela ESQUERDA agora! *)
    apply MUnionL.
    apply H1. (* Confirme o nome no seu CoqIDE *)
Qed.

(* ================================================================= *)
(* Questão 4: O Paradoxo do Star
   Motivo: Essa questão parece dificílima, mas tem 4 linhas. 
   O Star repete infinitamente. Mas se ele tentar repetir o EmptySet,
   a única forma de não gerar um erro é repetindo ZERO vezes (string vazia). *)
Theorem star_emptyset : forall T (s : list T),
  s =~ Star EmptySet -> s = [].
Proof.
  intros T s H.
  inversion H.
  - (* Caso MStar0: Ele repetiu zero vezes. 
       O Coq já te deu H0: [] = s. Basta inverter a igualdade ou dar reflexivity. *)
    reflexivity.
  - (* Caso MStarApp: Ele tentou arrancar um pedaço (s1). 
       A hipótese absurda (s1 =~ EmptySet) caiu no H2. EXPLODA ELA! *)
    inversion H2. 
Qed.




(* ================================================================= *)
(* Questão 1: O "não" básico de Regex
   Motivo: Garante que você não esqueceu como usar o "unfold not". *)

Theorem not_match_emptyset : forall T (s : list T),
  ~ (s =~ EmptySet).
Proof.
  intros T s.
  unfold not. 
  intros H.
  (* Simplesmente não existe regra para EmptySet. Inversion mata na hora. *)
  inversion H.
Qed.

(* ================================================================= *)
(* Questão 2: Irmã da questão que você errou os nomes
   Motivo: O EmptySet agora está na direita. Teste final para ver se você
   está olhando os nomes (H1, H2) gerados na tela! *)

Theorem union_emptyset_r : forall T (s : list T) (r : reg_exp),
  s =~ Union r EmptySet -> s =~ r.
Proof.
  intros T s r H.
  inversion H.
  - (* Caso validou r (Esquerda).
       Olhe o nome da variável que contém "s =~ r" no seu Coq e dê apply! *)
    apply H2. 
  - (* Caso validou EmptySet (Direita).
       Olhe o nome da variável que contém "s =~ EmptySet" e dê inversion! *)
    inversion H2.
Qed.

(* ================================================================= *)
(* Questão 3: O truque da concatenação vazia
   Motivo: O professor cobrou isso na sua "P2 PASSADA (1) Questão 4".
   Você tem 's' e precisa provar 'App EmptyStr r'. *)

Theorem app_emptystr_l : forall T (s : list T) (r : reg_exp),
  s =~ r -> s =~ App EmptyStr r.
Proof.
  intros T s r H.
  (* O Goal pede (s1 ++ s2). Como s = [] ++ s, nós podemos injetar um 
     mini-teorema na prova usando "assert" (Cheat Sheet Pág. 2) *)
  assert (H_igualdade : s = [] ++ s). 
  { reflexivity. }
  
  (* Trocamos 's' por '[] ++ s' no objetivo *)
  rewrite H_igualdade.
  
  (* Agora sim podemos usar o MApp! *)
  apply MApp.
  - (* Prove que a primeira parte ([]) é EmptyStr *)
    apply MEmpty.
  - (* Prove que a segunda parte (s) é r. Nós já temos isso em H! *)
    apply H.
Qed.

(* ================================================================= *)
(* Questão 4: A Prova Máster de Regex (App Distributivo)
   Motivo: Essa estava na sua "P2 PASSADA (1) Questão 1".
   Só que lá você tinha um "Lema" para usar. O professor ama cobrar essa 
   mesma prova exigindo que o aluno faça "na raça" apenas com inversion. *)

Theorem app_dist_union_ida : forall T (s : list T) (r1 r2 r3 : reg_exp),
  s =~ App (Union r1 r2) r3 -> s =~ Union (App r1 r3) (App r2 r3).
Proof.
  intros T s r1 r2 r3 H.
  
  (* 1. Quebramos o App principal (s = s1 ++ s2) *)
  inversion H.
  
  (* 2. A primeira metade da string (s1) caiu no (Union r1 r2). 
     Procure a hipótese que diz "s1 =~ Union r1 r2" (Ex: H3) e quebre ela! *)
  inversion H3. 
  
  - (* Sub-caso Esquerdo do Union (s1 =~ r1) *)
    (* O objetivo é Union. Vamos escolher o lado esquerdo (App r1 r3) *)
    apply MUnionL.
    (* O Coq escondeu a "casca" do s1 ++ s2 (veja a igualdade gerada no topo, tipo H0: s1 ++ s2 = s). 
       Se a igualdade estiver lá, use "rewrite <- H0". Senão, vá direto pro apply *)
    
    (* Reconstruímos o App usando as hipóteses geradas. 
       Olhe para a tela e use os nomes certos de s1 =~ r1 e s2 =~ r3! *)
    apply MApp. 
    + apply H7. (* Confirme o nome! *)
    + apply H4. (* Confirme o nome! *)
    
  - (* Sub-caso Direito do Union (s1 =~ r2) *)
    (* O objetivo é Union. Vamos escolher o lado direito (App r2 r3) *)
    apply MUnionR.
    
    (* Reconstruímos o App. *)
    apply MApp.
    + apply H7. (* Confirme o nome! *)
    + apply H4. (* Confirme o nome! *)
Qed.

(* ================================================================= *)


Require Import PeanoNat.
Require Import Coq.Arith.Le.
Require Import Coq.Lists.List.
Import ListNotations.

(* (Definições de Regex omitidas aqui para economizar espaço, 
   assuma que você já tem o reg_exp e o exp_match carregados) *)

(* ================================================================= *)
(* Questão 1: A Lógica de Reflection
   Motivo: O final do arquivo IndProp.v é todo sobre isso. A estrutura 
   'reflect' une um booleano a uma Proposição. *)

Inductive reflect (P : Prop) : bool -> Prop :=
  | ReflectT (H : P) : reflect P true
  | ReflectF (H : ~P) : reflect P false.

Theorem reflect_iff : forall P b, reflect P b -> (P <-> b = true).
Proof.
  intros P b H.
  (* O Cheat Sheet (Pág 1) diz que quando temos um Inductive, 
     'destruct' abre seus construtores possíveis. *)
  destruct H.
  - (* Caso ReflectT: b é true e temos H : P *)
    split.
    + intros Hp. reflexivity.
    + intros Htrue. apply H.
  - (* Caso ReflectF: b é false e temos H : ~P *)
    split.
    + intros Hp. 
      (* Temos Hp: P e H: ~P. Isso é um absurdo! (Pág 3, exfalso) *)
      unfold not in H.
      exfalso. apply H. apply Hp.
    + intros Hfalse. 
      (* Hfalse é "false = true". O discriminate explode isso (Pág 2). *)
      discriminate Hfalse.
Qed.

(* ================================================================= *)
(* Questão 2: Indução na Evidência (Menor ou Igual)
   Motivo: O le_trans é o teorema mais clássico da relação '<=' (le).
   Testa se você sabe fazer indução NA HIPÓTESE em vez da variável. *)

Theorem le_trans : forall m n o, m <= n -> n <= o -> m <= o.
Proof.
  intros m n o H1 H2.
  (* Se fizermos indução em 'n' ou 'o', o 'm' vai travar a prova.
     Temos que fazer indução na PROVA (H2) de que n <= o! *)
  induction H2 as [| o' H2' IHo'].
  - (* Caso Base da relação <= (le_n). Aqui, n = o. 
       O objetivo vira m <= n, o que já temos em H1! *)
    apply H1.
  - (* Passo Indutivo (le_S). O objetivo vira m <= S o'. 
       Usamos a regra de sucessor nativa do Coq (le_S). *)
    apply le_S.
    (* O objetivo vira m <= o'. A nossa Hipótese de Indução é exatamente isso! *)
    apply IHo'.
Qed.

(* ================================================================= *)
(* Questão 3: Bi-implicação (<->) de Regex (Disjunção)
   Motivo: Provar um SE E SOMENTE SE em cima do Union. *)

Theorem union_disj : forall T (s : list T) (r1 r2 : reg_exp),
  s =~ Union r1 r2 <-> s =~ r1 \/ s =~ r2.
Proof.
  intros T s r1 r2. split.
  - (* IDA: Union -> \/ *)
    intros H. inversion H.
    + (* A prova veio do lado esquerdo (MUnionL). O Coq gerou s =~ r1. *)
      left. apply H2. (* LEMBRE-SE: OLHE O NOME (H1, H2, H3...) NA SUA TELA *)
    + (* A prova veio do lado direito (MUnionR). O Coq gerou s =~ r2. *)
      right. apply H1. (* LEMBRE-SE: OLHE O NOME (H1, H2, H3...) NA SUA TELA *)
  - (* VOLTA: \/ -> Union *)
    intros H. destruct H as [H_left | H_right].
    + (* Se casou com a esquerda *)
      apply MUnionL. apply H_left.
    + (* Se casou com a direita *)
      apply MUnionR. apply H_right.
Qed.

(* ================================================================= *)
(* Questão 4: Destruição com Cabeça e Cauda (Listas + Regex)
   Motivo: No arquivo do professor, o lema `char_eps_suffix` cai na prova! *)

Theorem char_eps_suffix : forall T (a : T) (s : list T),
  (a :: s) =~ Char a <-> s = [].
Proof.
  intros T a s. split.
  - (* IDA *)
    intros H. inversion H.
    (* O Coq destruiu (a :: s) e descobriu que [a] = a :: s. 
       Isso força o 's' a ser uma lista vazia. O inversion já resolve e mata tudo! *)
    reflexivity.
  - (* VOLTA *)
    intros H.
    (* Trocamos 's' por '[]' *)
    rewrite H.
    (* Objetivo vira: (a :: []) =~ Char a. 
       Mas (a :: []) é EXATAMENTE [a]. A regra MChar resolve! *)
    apply MChar.
Qed.







(* ================================================================= *)
(* Questão 1: Inversion em Números Pares (ev)
   Motivo: O IndProp traz o "evSS_ev". A prova é assustadora, mas o 
   'inversion' resolve com duas mãos nas costas. *)

Theorem evSS_ev : forall n, ev (S (S n)) -> ev n.
Proof.
  intros n H.
  (* H diz que (S (S n)) é par. Queremos extrair que 'n' é par. *)
  inversion H.
  (* O inversion viu que a única forma de H ser verdade era usando a regra ev_SS.
     Ele jogou no contexto H1 (ou H2): ev n. Basta aplicar! *)
  apply H1. (* LEMBRE-SE: OLHE O NOME GERADO NA SUA TELA *)
Qed.

(* ================================================================= *)
(* Questão 2: Todo número é maior ou igual a zero
   Motivo: Exige indução pura na variável e uso dos construtores da lógica nativa. *)

Theorem O_le_n : forall n, 0 <= n.
Proof.
  intros n.
  (* O '0' está fixo na esquerda. A variável que cresce é o 'n'. Indução em n! *)
  induction n as [| n' IHn].
  - (* Caso n = 0. Objetivo: 0 <= 0. Regra nativa le_n *)
    apply le_n.
  - (* Caso n = S n'. Objetivo: 0 <= S n'. 
       A regra le_S diz que se (A <= B), então (A <= S B). *)
    apply le_S.
    (* Agora prove 0 <= n', que é exatamente nossa Hipótese de Indução! *)
    apply IHn.
Qed.

(* ================================================================= *)
(* Questão 3: Uso do Exists em Regex (app_exists)
   Motivo: É o maior desafio da Pág 11 do seu PDF. Saber fornecer um 
   'testemunha' (exists) a partir de um inversion. *)

Theorem app_exists_ida : forall T (s : list T) (r1 r2 : reg_exp),
  s =~ App r1 r2 -> exists s1 s2, s = s1 ++ s2 /\ s1 =~ r1 /\ s2 =~ r2.
Proof.
  intros T s r1 r2 H.
  (* H é a prova de um App. Vamos quebrá-la. *)
  inversion H.
  (* O Coq descobriu que 's' era na verdade 's1 ++ s2'. 
     E ele gerou provas s1 =~ r1 e s2 =~ r2.
     O Goal pede que você fornceça as duas listas usando exists. *)
  exists s1. (* Testemunha da primeira lista (Pág 3) *)
  exists s2. (* Testemunha da segunda lista *)
  
  (* Agora temos que provar os 'E's (/\). Usamos split duplo! *)
  split.
  + reflexivity. (* Prova que s1 ++ s2 = s1 ++ s2 *)
  + split.
    * apply H3. (* Prova s1 =~ r1 (VERIFIQUE O NOME NO SEU COQ) *)
    * apply H4. (* Prova s2 =~ r2 (VERIFIQUE O NOME NO SEU COQ) *)
Qed.

(* ================================================================= *)
(* Questão 4: A Letra Incorreta
   Motivo: Mistura a negação lógica (~) com propriedades de Regex. *)

Theorem char_nomatch_char : forall T (a b : T) (s : list T),
  a <> b -> ~ (a :: s =~ Char b).
Proof.
  intros T a b s H_diferente.
  unfold not.
  intros H_match.
  (* Tentaram casar (a :: s) com Char b. Vamos explodir a mentira. *)
  inversion H_match.
  
  (* O inversion foi tão inteligente que já quebrou a lista sozinho
     e nos deu a igualdade "H : a = b" direto no contexto! *)
  
  (* O objetivo já é False. O H_diferente é (a = b -> False). 
     Então basta aplicar H_diferente. *)
  apply H_diferente.
  
  (* Agora o Coq pede para provarmos (a = b). Nós aplicamos o H! *)
  apply H.
Qed.


(* ================================================================= *)
(* Simulado de Métodos Formais 6 - A Prova dos Campeões              *)
(* Assuntos: Lógica de 1ª Ordem, Filter, IndProp e Regex Aninhadas   *)
(* ================================================================= *)

Require Import PeanoNat.
Require Import Coq.Arith.Le.
Require Import Coq.Bool.Bool.
Require Import Coq.Lists.List.
Import ListNotations.

(* Assuma que as definições de reg_exp e exp_match (=~) já estão carregadas *)

(* ================================================================= *)
(* Questão 1: Lógica de Primeira Ordem (Valor: 2.0)                  *)
(* Motivo: O professor cobrou De Morgan e Contrapositiva. Outro      *)
(* clássico de provas é a distribuição do 'Para Todo' (forall) sobre *)
(* o 'E' (/\). Se "Todo mundo gosta de X e Y", então "Todo mundo     *)
(* gosta de X" E "Todo mundo gosta de Y".                            *)
(* ================================================================= *)

Theorem forall_and_distr : forall (X : Type) (P Q : X -> Prop),
  (forall x : X, P x /\ Q x) <-> (forall x : X, P x) /\ (forall x : X, Q x).
Proof.
  intros X P Q. split.
  - (* IDA *)
    intros H. 
    (* O objetivo é um E (/\). Usamos split para provar cada lado. *)
    split.
    + (* Lado esquerdo: provar (forall x, P x) *)
      intros x. 
      (* A hipótese H vale para QUALQUER x. Vamos especializá-la para este x *)
      destruct (H x) as [HP HQ]. 
      apply HP.
    + (* Lado direito: provar (forall x, Q x) *)
      intros x. 
      destruct (H x) as [HP HQ]. 
      apply HQ.
      
  - (* VOLTA *)
    intros H x. 
    (* H é um E (/\). Vamos abri-lo. *)
    destruct H as [H_todoP H_todoQ].
    (* O objetivo é P x /\ Q x. Usamos split. *)
    split.
    + apply H_todoP. (* Como H_todoP vale para todo x, o Coq aceita direto! *)
    + apply H_todoQ.
Qed.

(* ================================================================= *)
(* Questão 2: Indução com Funções de Alta Ordem (Valor: 2.0)         *)
(* Motivo: Testa se você entende como a função anônima (fun _ => ...)*)
(* interage com o 'simpl' dentro de uma indução.                     *)
(* ================================================================= *)

Theorem filter_true : forall X (l : list X),
  filter (fun _ => true) l = l.
Proof.
  intros X l.
  (* Como 'filter' desmonta a lista 'l', fazemos indução nela. *)
  induction l as [| h t IH].
  - (* Caso Base: l = [] *)
    simpl. reflexivity.
  - (* Passo Indutivo: l = h :: t *)
    (* O 'simpl' vai rodar o filter. A função (fun _ => true) sempre 
       retorna 'true'. Então o 'if true' vai manter o 'h' na lista! *)
    simpl. 
    (* O objetivo vira: h :: filter (fun _ => true) t = h :: t *)
    (* Basta usar a Hipótese de Indução para arrumar a cauda! *)
    rewrite IH. 
    reflexivity.
Qed.

(* ================================================================= *)
(* Questão 3: Indução na Variável com Propriedades (Valor: 2.0)      *)
(* Motivo: Diferente do 'ev_sum' (onde induzimos na evidência), aqui *)
(* a função 'double' é quem manda na estrutura. Então a indução é no *)
(* número 'n'!                                                       *)
(* ================================================================= *)

Fixpoint double (n:nat) : nat :=
  match n with
  | O => O
  | S n' => S (S (double n'))
  end.

Theorem ev_double : forall n : nat, 
  ev (double n).
Proof.
  intros n.
  (* Indução na variável n, pois a função 'double' faz match nela. *)
  induction n as [| n' IH].
  - (* Caso n = 0 *)
    simpl. 
    (* Objetivo: ev 0. Regra base! *)
    apply ev_0.
  - (* Caso n = S n' *)
    simpl. 
    (* Objetivo: ev (S (S (double n'))). 
       A regra ev_SS "arranca" os dois S da frente! *)
    apply ev_SS.
    (* O objetivo encolheu para ev (double n'). 
       Isso é EXATAMENTE a nossa Hipótese de Indução (IH). *)
    apply IH.
Qed.

(* ================================================================= *)
(* Questão 4: Regex - Inversão de Absurdos (Valor: 2.0)              *)
(* Motivo: O professor cobrou o EmptySet antes. Aqui cobramos o      *)
(* EmptyStr. A string vazia NÃO PODE casar com uma string que tem    *)
(* elementos (a :: s).                                               *)
(* ================================================================= *)

Theorem empty_nomatch_ne : forall T (a : T) (s : list T),
  ~ ((a :: s) =~ EmptyStr).
Proof.
  intros T a s.
  (* Passo 1: Desmascarar o '~' *)
  unfold not. 
  intros H_match.
  
  (* Passo 2: O H_match diz que uma lista cheia casou com EmptyStr.
     A ÚNICA regra do EmptyStr é a MEmpty, que exige que a lista seja [].
     Como (a :: s) nunca será [], isso é uma mentira matemática.
     Tática para explodir mentiras em árvores indutivas: inversion! *)
  inversion H_match.
Qed.

(* ================================================================= *)
(* Questão 5: Regex - Construção Aninhada (Valor: 2.0)               *)
(* Motivo: Na sua lista, você provou [x; y] =~ App. Mas e se tivermos*)
(* TRÊS caracteres? Isso testa se você sabe como o Coq agrupa as     *)
(* listas e como aplicar o MApp duas vezes seguidas.                 *)
(* ================================================================= *)

Theorem match_3_chars : forall T (x y z : T),
  [x; y; z] =~ App (Char x) (App (Char y) (Char z)).
Proof.
  intros T x y z.
  
  (* A lista [x; y; z] é a mesma coisa que [x] ++ [y; z].
     Vamos forçar o Coq a usar a regra MApp quebrando a lista nesse ponto.
     A primeira regex é (Char x) e a segunda é o App inteiro. *)
  apply (MApp [x] (Char x) [y; z] (App (Char y) (Char z))).
  
  - (* Sub-prova 1: Provar que [x] =~ Char x *)
    apply MChar.
    
  - (* Sub-prova 2: Provar que [y; z] =~ App (Char y) (Char z) *)
    (* Aqui temos OUTRO App! Fazemos o mesmo truque, quebrando a lista 
       em [y] e [z]. *)
    apply (MApp [y] (Char y) [z] (Char z)).
    + (* Provar que [y] =~ Char y *)
      apply MChar.
    + (* Provar que [z] =~ Char z *)
      apply MChar.
Qed.
