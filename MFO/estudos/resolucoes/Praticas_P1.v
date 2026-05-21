(* Simulado de Métodos Formais - Preparatório 
   Assuntos: Basics, Induction, Lists, Poly, Tactics, Logic
   Tempo sugerido: 1h 30m
*)

Require Import Coq.Lists.List.
Require Import Coq.Bool.Bool.
Import ListNotations.

(* ================================================================= *)
(* Questão 1: Booleanos e Lógica (Valor: 2.0)                        *)
(* Prove que se a função AND retorna falso, isso é o equivalente     *)
(* lógico a dizer que ou o primeiro ou o segundo booleano é falso.   *)
(* Dica: Lembre-se de como "abrir" os booleanos para o Coq calcular. *)
(* ================================================================= *)

Search "&&".

Theorem andb_false_iff : forall b1 b2 : bool, 
  b1 && b2 = false <-> b1 = false \/ b2 = false.
Proof.
  intros b1 b2. split.
  - intros H1. destruct b1.
    + simpl in H1. right. apply H1.
    + simpl in H1. left. apply H1.
  - intros H2. destruct H2 as [H3 | H4].
    + rewrite H3. simpl. reflexivity.
    + rewrite H4. destruct b1.
      * simpl. reflexivity.
      * simpl. reflexivity.
Qed.

(* ================================================================= *)
(* Questão 2: Lógica Proposicional e Negação (Valor: 2.0)            *)
(* Prove uma das Leis de De Morgan: A negação de uma disjunção (OU)  *)
(* implica na conjunção (E) das negações.                            *)
(* Dica: O que significa o '~' no Coq? Lembre-se do Princípio da     *)
(* Explosão caso precise descartar uma hipótese.                     *)
(* ================================================================= *)

Theorem de_morgan_not_or : forall P Q : Prop, 
  ~ (P \/ Q) -> ~P /\ ~Q.
Proof.
   intros P Q H1. unfold not in H1. unfold not. split.
   - intros H2. apply H1. left. apply H2.
   - intros H3. apply H1. right. apply H3.
Qed.

(* ================================================================= *)
(* Questão 3: Polimorfismo e Indução em Listas (Valor: 2.0)          *)
(* Prove que a função 'map' distribui sobre a concatenação '++'.     *)
(* Ou seja, mapear uma função sobre duas listas coladas é o mesmo    *)
(* que mapear a função em cada uma e colar os resultados depois.     *)
(* ================================================================= *)

Theorem map_app : forall X Y (f : X -> Y) (l1 l2 : list X), 
  map f (l1 ++ l2) = map f l1 ++ map f l2.
Proof.
  intros X Y f l1 l2. induction l1 as [| h t IH].
  - simpl. reflexivity.
  - simpl. rewrite IH. reflexivity.
Qed.


(* ================================================================= *)
(* Questão 4: Programação com Proposições (Valor: 2.0)               *)
(* Prove que se um elemento 'a' está na lista 'l1', então ele        *)
(* obrigatoriamente estará na concatenação de 'l1' com qualquer      *)
(* outra lista 'l2'.                                                 *)
(* Dica: A função 'In' usa o operador lógico '\/'. Escolha o lado    *)
(* certo ao avançar na prova!                                        *)
(* ================================================================= *)

Fixpoint In {A : Type} (x : A) (l : list A) : Prop :=
  match l with
  | [] => False
  | x' :: l' => x' = x \/ In x l'
  end.

Theorem In_app_intro : forall A (l1 l2 : list A) (a : A), 
  In a l1 -> In a (l1 ++ l2).
Proof.
  intros A l1 l2 a H1. induction l1 as [| h t H2].
  - simpl in H1. destruct H1.
  - simpl. simpl in H1. destruct H1 as [H3 | H4].
    + left. apply H3.
    + right. apply H2 in H4. apply H4.
Qed.


(* ================================================================= *)
(* Questão 5: Leis de De Morgan para Booleanos (Valor: 2.0)          *)
(* O Coq diferencia a lógica (Prop) dos booleanos (bool). Prove que  *)
(* a negação (negb) de uma operação AND (&&) equivale a fazer um OR  *)
(* (||) com a negação de cada termo separadamente.                   *)
(* Dica: Booleanos só têm dois valores possíveis.                    *)
(* ================================================================= *)

Theorem negb_andb : forall b c : bool, 
  negb (b && c) = (negb b) || (negb c).
Proof.
  intros b c. destruct b.
  - simpl. reflexivity.
  - simpl. reflexivity.
Qed.


(* ================================================================= *)
(* Questão 6: Lógica Clássica - Contrapositiva (Valor: 2.0)          *)
(* Prove que se "P implica Q", então "Não Q implica Não P".          *)
(* Dica: Lembre-se do 'unfold not'. O seu objetivo final será        *)
(* gerar um 'False' nas hipóteses para encerrar a prova.             *)
(* ================================================================= *)

Theorem contrapositive : forall P Q : Prop, 
  (P -> Q) -> (~Q -> ~P).
Proof.
   intros P Q H1. unfold not. intros H2 H3. apply H2. apply H1. apply H3.
Qed.


(* ================================================================= *)
(* Questão 7: Indução em Listas e Tamanho (Valor: 2.0)               *)
(* Prove que o tamanho da junção de duas listas (++) é igual à soma  *)
(* dos tamanhos de cada uma individualmente.                         *)
(* Dica: A indução resolve quase tudo, mas escolha a lista certa     *)
(* para induzir!                                                     *)
(* ================================================================= *)

Theorem app_length : forall X (l1 l2 : list X), 
  length (l1 ++ l2) = length l1 + length l2.
Proof.
  intros X l1 l2. induction l1 as [| h t IH].
  - simpl. reflexivity.
  - simpl. rewrite IH. reflexivity.
Qed.



(* ================================================================= *)
(* Questão 8: Propriedades Lógicas Recursivas (Valor: 2.0)           *)
(* A função 'All' abaixo verifica se TODOS os elementos de uma lista *)
(* satisfazem uma propriedade P. Prove que 'All' distribui sobre a   *)
(* concatenação '++' de duas listas (ida e volta).                   *)
(* ================================================================= *)

Fixpoint All {T : Type} (P : T -> Prop) (l : list T) : Prop :=
  match l with
  | [] => True
  | h :: t => P h /\ All P t
  end.
Search ((_/\_)/\_).
Theorem All_app : forall T (P : T -> Prop) (l1 l2 : list T), 
  All P (l1 ++ l2) <-> All P l1 /\ All P l2.
Proof.
  intros T P l1 l2. split. intros H1. induction l1 as [| h t H2].
  - simpl in H1. simpl. split.
    + reflexivity.
    +  apply H1.
  - simpl in H1. simpl. rewrite and_assoc. split.
    + destruct H1 as [Hph HallP].
      * apply Hph.
    + destruct H1 as [H4 H5].
      * apply H2. apply H5.
  - intros H. simpl. induction l1 as [| h t H1].
    + simpl. destruct H as [H1 H2].
      * apply H2.
    + simpl. simpl in H. destruct H as [[HPH HALT] HAL2].
      * split. apply HPH. apply H1. split. apply HALT. apply HAL2. 
Qed.



(* ================================================================= *)
(* Questão 9: Lógica Clássica - O Princípio da Não-Contradição       *)
(* (Valor: 2.0)                                                      *)
(* Prove que é impossível que uma proposição seja verdadeira e       *)
(* falsa ao mesmo tempo.                                             *)
(* Dica: O símbolo '~' é um disfarce para '-> False'. Use 'unfold'.  *)
(* Você precisará "destruir" o operador 'E' (/\) nas suas hipóteses. *)
(* ================================================================= *)

Theorem not_both_true_and_false : forall P : Prop,
  ~ (P /\ ~P).
Proof.
  intros P. unfold not. intros H.
  destruct H. apply H0. exact H.
Qed.


(* ================================================================= *)
(* Questão 11: Polimorfismo e Tamanho de Listas (Valor: 2.0)          *)
(* Prove que a função 'map' altera apenas os valores de uma lista,   *)
(* mas nunca altera o seu tamanho (length).                          *)
(* Dica: Indução na lista. O passo indutivo sai com um simples       *)
(* rewrite da sua Hipótese de Indução.                               *)
(* ================================================================= *)

Theorem map_length : forall X Y (f : X -> Y) (l : list X),
  length (map f l) = length l.
Proof.
  intros X Y f l. induction l as[| h t IH].
  simpl. reflexivity.
  simpl. rewrite IH. reflexivity.
Qed.


(* ================================================================= *)
(* Questão 13: Quantificadores 'Para todo' vs 'Existe' (Valor: 2.0)   *)
(* Prove que: se uma propriedade P é válida para TODOS os elementos, *)
(* então NÃO EXISTE nenhum elemento onde a propriedade P falhe (~P). *)
(* Dica: unfold not. Como você destrói um 'exists' que está no seu   *)
(* contexto? Use a regra do 'forall' que você tem na mão aplicando-a *)
(* no elemento que você desempacotou!                                *)
(* ================================================================= *)

Theorem dist_not_exists : forall (X : Type) (P : X -> Prop),
  (forall x, P x) -> ~ (exists y, ~ P y).
Proof.
  intros X P H1. unfold not. intros H2. destruct H2 as [H3 H4]. apply H4. apply H1.
Qed.


(* ================================================================= *)
(* Questão 14: O Elo entre Booleanos e Proposições (Valor: 2.0)       *)
(* Prove que a função booleana OR (||) retorna 'true' se, e somente  *)
(* se, a proposição lógica correspondente (\/) for verdadeira.       *)
(* ================================================================= *)

Theorem orb_true_iff : forall b1 b2 : bool,
  b1 || b2 = true <-> b1 = true \/ b2 = true.
Proof.
  intros b1 b2. split.
  - intros H1. destruct b1.
    + simpl in H1. left. apply H1.
    + simpl in H1. right. apply H1.
  - intros H2. destruct b1.
    + simpl. reflexivity.
    + simpl. destruct H2. 
      * discriminate H.
      * apply H.
Qed.

(* ================================================================= *)
(* Questão 14: Lógica de Predicados e Existenciais (Valor: 2.0)       *)
(* Prove que se existe um elemento que satisfaz a propriedade P, e   *)
(* se todo elemento que satisfaz P também satisfaz Q, então          *)
(* obrigatoriamente existe um elemento que satisfaz Q.               *)
(* Dica: Use o 'x' que você extrair da primeira hipótese para        *)
(* construir a prova do objetivo!                                    *)
(* ================================================================= *)

Theorem exists_impl : forall (X : Type) (P Q : X -> Prop),
  (exists x, P x) -> 
  (forall y, P y -> Q y) -> 
  (exists z, Q z).
Proof.
 Admitted.

(* ================================================================= *)
(* Questão 15: Indução e Extensionalidade no Map (Valor: 2.0)         *)
(* Prove que se duas funções 'f' e 'g' geram os mesmos resultados    *)
(* para qualquer entrada 'x', então mapear 'f' em uma lista gera     *)
(* exatamente a mesma lista que mapear 'g'.                          *)
(* Dica: Indução na lista 'l'. No passo indutivo, use a hipótese     *)
(* 'H' da função para igualar as cabeças da lista!                   *)
(* ================================================================= *)

Theorem map_ext : forall X Y (f g : X -> Y) (l : list X),
  (forall x, f x = g x) -> 
  map f l = map g l.
Proof.
    intros X Y f g l H1. induction l as [| h t H2].
    - simpl. reflexivity.
    - simpl. rewrite H2. rewrite H1. reflexivity.
Qed.


(* ================================================================= *)
(* Questão 16: Indução com Táticas Avançadas (Valor: 2.0)             *)
(* Prove que se você somar 'p' em ambos os lados e os resultados     *)
(* forem iguais, então os números originais eram iguais.             *)
(* Dica: Faça indução em 'p' (pois a soma avalia pela esquerda). No  *)
(* passo indutivo, a hipótese será 'S (...) = S (...)'. Use a        *)
(* tática mágica para arrancar a "casca" do 'S'!                     *)
(* ================================================================= *)

Theorem plus_inj_l : forall p n m : nat,
  p + n = p + m -> n = m.
Proof.
  intros p n m H1. induction p as [|p' H2]. 
  - simpl in H1. apply H1.
  - simpl in H1. injection H1 as H3. apply H2. apply H3.
Qed.

(* ================================================================= *)
(* Questão 17: Filtragem e Concatenação (Valor: 2.0)                  *)
(* Prove que filtrar elementos em uma lista concatenada é o mesmo    *)
(* que filtrar cada lista separadamente e concatená-las depois.      *)
(* Dica de Ouro: Indução em 'l1'. No passo indutivo, o 'simpl' vai   *)
(* travar em um 'if (test h)'. O que você faz quando a prova trava   *)
(* em um if? Isso mesmo, 'destruct (test h)'! (MEIO VIAJADA)                        *)
(* ================================================================= *)

Theorem filter_app : forall X (test : X -> bool) (l1 l2 : list X),
  filter test (l1 ++ l2) = filter test l1 ++ filter test l2.
Proof.
  intros X test l1 l2. induction l1 as [| h t H1].
  - simpl. reflexivity.
  - simpl. destruct (test h).
    + rewrite H1. reflexivity.
    + rewrite H1. reflexivity.
Qed.


Fixpoint evenb (n:nat) : bool :=
  match n with
  | O        => true
  | S O      => false
  | S (S n') => evenb n'
  end.

(* ================================================================= *)
(* Questão 18 (Equivalente à Q1 original)                             *)
(* Considere a função 'double' que multiplica um número por 2        *)
(* estruturalmente. Prove que o dobro de qualquer número é par.      *)
(* ================================================================= *)

Fixpoint double (n:nat) : nat :=
  match n with
  | O => O
  | S n' => S (S (double n'))
  end.

Theorem evenb_double : forall n:nat,
  evenb (double n) = true.
Proof.
  intros n. induction n as [|n' H1].
  - simpl. reflexivity.
  - simpl. apply H1. 
Qed.


(* ================================================================= *)
(* Questão 2 (Equivalente à Q2 original)                             *)
(* Considere a função 'half' que divide um número por 2. Prove que   *)
(* se você dobrar um número e depois cortá-lo pela metade, você      *)
(* volta ao número original.                                         *)
(* ================================================================= *)

Fixpoint half (n:nat) : nat :=
  match n with
  | O => O
  | S O => O
  | S (S n') => S (half n')
  end.

Theorem half_double : forall n:nat, 
  half (double n) = n.
Proof.
  intros n. induction n as [|n' H1].
  - simpl. reflexivity.
  - simpl. rewrite H1. reflexivity.
Qed.


(* ================================================================= *)
(* Questão 3 (Equivalente à Q3 original)                             *)
(* Prove que aplicar um 'map' em uma lista invertida é a mesma coisa *)
(* que inverter a lista depois de aplicar o 'map'.                   *)
(* Dica do Professor: Você vai precisar de um lema auxiliar sobre a  *)
(* relação entre o 'map' e a concatenação '++'. Crie-o antes do      *)
(* teorema principal!                                                *)
(* ================================================================= *)

Search (map _ (_ ++ _)).

(*
 map_app:
  forall (X Y : Type) (f : X -> Y) (l1 l2 : list X),
  map f (l1 ++ l2) = map f l1 ++ map f l2
List.map_app:
  forall [A B : Type] (f : A -> B) (l l' : list A),
  map f (l ++ l') = map f l ++ map f l'
map_last:
  forall [A B : Type] (f : A -> B) (l : list A) (a : A),
  map f (l ++ [a]) = map f l ++ [f a]
*)

Theorem map_rev : forall X Y (f : X -> Y) (l : list X),
  map f (rev l) = rev (map f l).
Proof.
  intros X Y f l. induction l as [| h t H1].
  - simpl. reflexivity.
  - simpl. rewrite map_last. rewrite <- H1. reflexivity. 
Qed.  


(* ================================================================= *)
(* Questão 4 (Equivalente à Q4 original)                             *)
(* Na matemática, duas funções são "inversas à esquerda" se aplicar  *)
(* g e depois f resulta no valor original ( f(g(x)) = x ).           *)
(* Prove que, se 'f' e 'g' são inversas, aplicá-las em sequência     *)
(* usando 'map' sobre uma lista não altera a lista original.         *)
(* ================================================================= *)

Definition left_inverse {A B : Type} (f : B -> A) (g : A -> B) :=
  forall x : A, f (g x) = x.

Theorem map_inverse : forall (A B : Type) (f : B -> A) (g : A -> B) (l : list A), 
  left_inverse f g -> map f (map g l) = l.
Proof.
  intros A B f g l H1. induction l as [|h t H2]. 
  - simpl. reflexivity.
  - simpl. rewrite -> H2. rewrite H1. reflexivity. 
Qed.



