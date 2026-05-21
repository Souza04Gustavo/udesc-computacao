(*==================================Prova===========================================*)
Require Import Coq.Lists.List.
Import ListNotations.

Fixpoint evenb (n:nat) : bool :=
  match n with
  | O        => true
  | S O      => false
  | S (S n') => evenb n'
  end.

(* Questão 1 Prove que todo número natural multiplicado por 2 é par.*)

Theorem evenb_2 : forall n:nat,
  evenb (n * 2) = true.
Proof. 
  intros n. induction n as [| n' IHn'].
  - simpl. reflexivity.
  - simpl. rewrite IHn'. reflexivity.
Qed.

(* Questão 2 Prove que se um número é par seu sucessor é impar.*)
Definition oddb (n:nat) : bool   :=   negb (evenb n).

Theorem even_S_odd : forall n, 
  evenb n = oddb (S n).
Proof.
  intros n. unfold oddb. induction n as [| n' IHn'].
  - simpl. reflexivity.
  - (* 1. Trocamos APENAS o lado direito, sem deixar o Coq abrir o lado esquerdo *)
    change (evenb (S (S n'))) with (evenb n').
    
    (* O seu goal agora é um limpo e seguro: evenb (S n') = negb (evenb n') *)
    
    (* 2. Aplicamos a hipótese normalmente *)
    rewrite IHn'.
    
    (* O goal vira: evenb (S n') = negb (negb (evenb (S n'))) *)
    
    (* 3. Agora sim, como o lado esquerdo está intacto, o destruct funciona! *)
    destruct (evenb (S n')).
    + reflexivity.
    + reflexivity.
Qed.

(* Questão 3 Prove que a função reverso é distributiva em ralação a concatenação.*)

Search (_ ++ []).

Theorem rev_app_distr: forall X (l1 l2 : list X),
  rev (l1 ++ l2) = rev l2 ++ rev l1.
Proof.
  intros X l1 l2. induction l1 as [| h t IHt].
  - simpl. rewrite app_nil_r. reflexivity.
  - simpl. rewrite IHt. rewrite app_assoc. reflexivity.
Qed.

(* Questão 4 - Prove que se uma função f é involutiva aplicar a composição de f em
uma lista resulta na própria lista. *)

Definition compose {A B C} (g : B -> C) (f : A -> B) :=
  fun x : A => g (f x).

Notation "g (.) f" := (compose g f)
                     (at level 5, left associativity).
Definition involutive {A : Type} (f : A -> A) :=
  forall x: A, f (f x) = x.

Theorem involutive_f_map : forall (A : Type) (f : A -> A) (l:list A), 
  involutive f -> map f (.) f l = l.
Proof.
  intros A f l H_inv. induction l as [| h t IHt].
  - simpl. reflexivity.
  - simpl. 
    (* Usamos o change para focar apenas no primeiro elemento (h), 
       impedindo o Coq de destruir o 'map' do lado direito! *)
    change ((f (.) f) h) with (f (f h)).
    
    (* O goal agora é: f (f h) :: map f (.) f t = h :: t *)
    
    (* A hipótese involutiva transforma f(f(h)) em h *)
    rewrite H_inv. 
    
    (* A hipótese de indução (que agora está intacta!) resolve o resto da lista *)
    rewrite IHt. 
    
    reflexivity.
Qed.

(*==================================EXTRAS===========================================*)

(* ================================================================= *)
(* Questão 1: O Teorema da Combinação com Lista Vazia                *)
(* A função 'combine' junta elementos de duas listas formando pares. *)
(* Mas o que acontece se você tentar parear algo com o vazio? Nada!  *)
(* Prove que se a segunda lista estiver vazia, o resultado final     *)
(* sempre será uma lista vazia, independentemente da primeira lista. *)
(* DICA DE OURO: Como o 'combine' inspeciona as duas listas ao mesmo *)
(* tempo, você precisará fazer um 'destruct' na primeira lista para  *)
(* destravar a avaliação da função!                                  *)
(* ================================================================= *)
Theorem combine_nil : forall (X: Type) (Y: Type) (l1: list X)  (l2:list Y),
  l2 = [] -> combine l1 l2 = [].
Proof.
  intros X Y l1 l2 H.
  rewrite H. 
  destruct l1 as [| h t].
  - reflexivity.
  - simpl. reflexivity.
Qed.

(* ================================================================= *)
(* Questão 2: Naturais e Paridade                                    *)
(* Em vez de usar a multiplicação padrão, vamos usar uma função      *)
(* estrutural 'double'. Prove que o sucessor do dobro de             *)
(* qualquer número é sempre ímpar (ou seja, 2n + 1 é ímpar).         *)
(* ================================================================= *)

Fixpoint double (n:nat) : nat :=
  match n with
  | O => O
  | S n' => S (S (double n'))
  end.

Theorem odd_S_double : forall n : nat,
  oddb (S (double n)) = true.
Proof.
  intros n. unfold oddb. induction n as [| n' IHn'].
  - simpl. reflexivity.
  - simpl. apply IHn'.
Qed.

(* ================================================================= *)
(* Questão 3: Lógica Booleana                                        *)
(* Prove que a função de negação booleana é involutiva.              *)
(* ================================================================= *)
Theorem negb_involutive : forall b : bool,
  negb (negb b) = b.
Proof.
  intros b. destruct b.
  - simpl. reflexivity.
  - simpl. reflexivity.
Qed.

(* ================================================================= *)
(* Questão 4: Distributividade do Map na Concatenação                *)
(* Prove que mapear uma função em duas listas concatenadas é o mesmo *)
(* que concatenar as listas depois de mapeadas.                      *)
(* ================================================================= *)
Theorem map_app : forall X Y (f : X -> Y) (l1 l2 : list X),
  map f (l1 ++ l2) = map f l1 ++ map f l2.
Proof.
  intros X Y f l1 l2. induction l1 as [| h t IHt].
  - simpl. reflexivity.
  - simpl. rewrite IHt. reflexivity.
Qed.

(* ================================================================= *)
(* Questão 5: Map e Reverso                                          *)
(* Prove que mapear uma função numa lista revertida é igual a        *)
(* reverter a lista mapeada.                                         *)
(* DICA DE OURO: Você precisará usar o teorema da Questão 3 (map_app)*)
(* no meio desta prova usando a tática 'rewrite'!                    *)
(* ================================================================= *)
Theorem map_rev : forall X Y (f : X -> Y) (l : list X),
  map f (rev l) = rev (map f l).
Proof.
  intros X Y f l. induction l as [| h t IHt].
  - simpl. reflexivity.
  - simpl. 
    (* O objetivo tem um 'map f (rev t ++ [h])'. Usamos a Q3 para quebrar isso! *)
    rewrite map_app. 
    
    (* Agora aplicamos a hipótese de indução *)
    rewrite IHt. 
    
    (* Um último simpl para o Coq calcular o map na listinha [h] *)
    simpl. reflexivity.
Qed.

(* ================================================================= *)
(* Questão 6: O "Calcanhar de Aquiles" da Aritmética                 *)
(* No Coq, 0 + n = n é trivial por definição (tente dar simpl nisso).*)
(* Porém, n + 0 = n NÃO é trivial, pois a adição é definida em cima  *)
(* do lado esquerdo. Prove esse teorema clássico!                    *)
(* ================================================================= *)

Theorem add_0_r : forall n : nat,
  n + 0 = n.
Proof.
  intros n. induction n as [| n' IHn'].
  - simpl. reflexivity.
  - simpl. rewrite IHn'. reflexivity.
Qed.

(* ================================================================= *)
(* Questão 7: A Lógica da Distributividade                           *)
(* Dizer que "Tenho P, e também (Q ou R)" é o mesmo que dizer        *)
(* "(Tenho P e Q) ou (Tenho P e R)". Prove essa equivalência lógica. *)
(* DICA: Você precisará encadear vários destructs.                   *)
(* ================================================================= *)

Theorem and_or_distrib : forall P Q R : Prop,
  P /\ (Q \/ R) <-> (P /\ Q) \/ (P /\ R).
Proof.
  intros P Q R. split.
  - (* IDA -> *)
    intros H. 
    (* Quebramos o AND externo *)
    destruct H as [HP HQR]. 
    (* Quebramos o OR interno *)
    destruct HQR as [HQ | HR].
    + left. split. apply HP. apply HQ.
    + right. split. apply HP. apply HR.
  - (* VOLTA <- *)
    intros H. 
    (* Quebramos o OR externo *)
    destruct H as [HPQ | HPR].
    + destruct HPQ as [HP HQ]. 
      split. apply HP. left. apply HQ.
    + destruct HPR as [HP HR]. 
      split. apply HP. right. apply HR.
Qed.

(* ================================================================= *)
(* Questão 8: Associatividade da Concatenação                        *)
(* Você usou essa propriedade indiretamente na sua prova oficial     *)
(* ao invocar o 'app_assoc'. Agora é hora de provar do zero que a    *)
(* ordem dos parênteses não importa ao concatenar 3 listas.          *)
(* ================================================================= *)
Theorem app_assoc : forall A (l1 l2 l3 : list A),
  (l1 ++ l2) ++ l3 = l1 ++ (l2 ++ l3).
Proof.
  intros A l1 l2 l3. induction l1 as [| h t IHt].
  - simpl. reflexivity.
  - simpl. rewrite IHt. reflexivity.
Qed.

(* ================================================================= *)
(* Questão 9: O Boss do "If/Then/Else" - Filter e Concatenação       *)
(* A função filter mantém na lista apenas os elementos que passam no *)
(* teste lógico. Prove que filtrar uma concatenação é igual a        *)
(* filtrar cada parte e concatenar os resultados depois.             *)
(* DICA DE OURO: No caso indutivo, você ficará travado em um         *)
(* (if test h then...). Use a tática 'destruct (test h)' para testar *)
(* o que acontece se o if for verdadeiro e se for falso!             *)
(* ================================================================= *)

Fixpoint filter {X:Type} (test: X->bool) (l:list X) : list X :=
  match l with
  | []     => []
  | h :: t => if test h then h :: (filter test t)
                        else filter test t
  end.

Theorem filter_app : forall X (test : X -> bool) (l1 l2 : list X),
  filter test (l1 ++ l2) = filter test l1 ++ filter test l2.
Proof.
  intros X test l1 l2. induction l1 as [| h t IHt].
  - simpl. reflexivity.
  - simpl. 
    (* O Coq avalia o test h, gerando o caminho if (true) e else (false) *)
    destruct (test h).
    + (* test h = true *)
      simpl. rewrite IHt. reflexivity.
    + (* test h = false *)
      rewrite IHt. reflexivity.
Qed.
(*==================================LISTAS===========================================*)
(*==============LISTA 1==============*)
Inductive bin : Type :=
  | Z
  | B0 (n : bin)
  | B1 (n : bin).

(** Implemente uma função que incrementa um valor binário: *)

Fixpoint incr (m:bin) : bin :=
  match m with
  | Z     => B1 Z
  | B0 m' => B1 m'
  | B1 m' => B0 (incr m')
  end.

(** Implemente uma função que converta um número binário para natural: *)


Fixpoint bin_to_nat (m:bin) : nat :=
  match m with
  | Z => 0
  | B0 m' => 2 * (bin_to_nat m')
  | B1 m' => 1 + 2 * (bin_to_nat m')
  end.

(* Faça os seguintes testes unitários: *)

Example test_bin_incr1 : (incr (B1 Z)) = B0 (B1 Z).
  - simpl. reflexivity. Qed.

Example test_bin_incr2 : (incr (B0 (B1 Z))) = B1 (B1 Z).
  - simpl. reflexivity. Qed.

Example test_bin_incr3 : (incr (B1 (B1 Z))) = B0 (B0 (B1 Z)).
  - simpl. reflexivity. Qed.

Example test_bin_incr4 : bin_to_nat (B0 (B1 Z)) = 2.
  - simpl. reflexivity. Qed.

Example test_bin_incr5 :bin_to_nat (incr (B1 Z)) = 1 + bin_to_nat (B1 Z).
  - simpl. reflexivity. Qed.

Example test_bin_incr6 :bin_to_nat (incr (incr (B1 Z))) = 2 + bin_to_nat (B1 Z).
  - simpl. reflexivity. Qed.

Theorem bin_to_nat_pres_incr : forall b : bin,
  bin_to_nat (incr b) = 1 + bin_to_nat b.
Proof.
  intros b. induction b as [| b' IHb' | b' IHb'].
  - simpl. reflexivity.
  - simpl. reflexivity.
  - simpl. rewrite IHb'. simpl. rewrite <- plus_n_Sm. reflexivity.
Qed. 

(** Declare uma função que converta números naturais em binários: *)

Fixpoint nat_to_bin (n:nat) : bin :=
  match n with
  | 0    => Z
  | S n' => incr (nat_to_bin n')
  end.

(** Prove que as conversões podem ser revertidas: *)

Theorem nat_bin_nat : forall n, bin_to_nat (nat_to_bin n) = n.
Proof.
  intros n. induction n as [| n' IHn'].
  - simpl. reflexivity.
  - simpl. rewrite bin_to_nat_pres_incr. simpl. rewrite IHn'. reflexivity.
Qed.  

Fixpoint normalize (b:bin) : bin :=
  match b with
  | Z     => Z
  | B0 b' =>
    match (normalize b') with
    | Z   => Z
    | nb' => B0 nb'
    end
  | B1 b' => B1 (normalize b')
  end.

(** Lema extra para última prova *)
Lemma nat_to_bin_double : forall n,
  nat_to_bin (n + n) = match nat_to_bin n with
                       | Z => Z
                       | b => B0 b
                       end.
Proof.
  induction n as [| n' IHn'].
  - simpl. reflexivity.
  - simpl. rewrite <- plus_n_Sm. simpl. rewrite IHn'. destruct (nat_to_bin n') as [| b' | b']; simpl; reflexivity.
Qed.

(** Lema extra para última prova *)
Lemma nat_to_bin_double_plus_1 : forall n,
  nat_to_bin (S (n + n)) = B1 (nat_to_bin n).
Proof.
  induction n as [| n' IHn'].
  - simpl. reflexivity.
  - simpl. rewrite <- plus_n_Sm. rewrite IHn'. simpl. reflexivity.
Qed.

(** Lema extra para última prova *)
Lemma add_0_right : forall n : nat, n + 0 = n.
Proof.
  induction n as [| n' IHn'].
  - simpl. reflexivity.
  - simpl. rewrite IHn'. reflexivity.
Qed.

Theorem bin_nat_bin : forall b, nat_to_bin (bin_to_nat b) = normalize b.
Proof.
  intros b. induction b as [| b' IHb' | b' IHb'].
  - simpl. reflexivity.
  - simpl. rewrite add_0_right. rewrite nat_to_bin_double. rewrite IHb'. reflexivity.
  - simpl bin_to_nat. rewrite add_0_right. rewrite nat_to_bin_double_plus_1. rewrite IHb'. simpl. reflexivity.
Qed.

(*==============LISTA 2==============*)
Fixpoint fold {X Y: Type} (f: X->Y->Y) (l: list X) (b: Y)
                         : Y :=
  match l with
  | nil => b
  | h :: t => f h (fold f t b)
  end.

(** O tamanho da lista resultante da concatenação de duas listas é
    igual a soma dos tamanhos das listas, prove esse teorema *)

Lemma app_length : forall (X:Type) (l1 l2 : list X),
  length (l1 ++ l2) = length l1 + length l2.
Proof.
  intros X l1 l2. induction l1 as [| h t IHt].
  -simpl. reflexivity.
  -simpl. rewrite IHt. reflexivity.
Qed.

(* Search(_ ++ []). *)

(** Informalmente podemos dizer, que o seguinte teorema estabelece que a 
    função [fold] é comutativa em relação a concatenação ([++]), prove esse 
    teorema: *)
 
Theorem app_comm_fold :forall {X Y} (f: X->Y->Y) l1 l2 b,
  fold f (l1 ++ l2) b = fold f l1 (fold f l2 b).
Proof.
  intros. induction l1 as [| h t IHt].
  -simpl. reflexivity. 
  -simpl. rewrite <- IHt. reflexivity.
Qed.

(** Como visto no módulo [Poly.v], muitas funções sobre listas podem ser 
    implementadas usando a função [fold], por exemplo, a função a função 
    que retorna o número de elementos de uma listas pode ser implementada 
    como: *)

Definition fold_length {X : Type} (l : list X) : nat :=
  fold (fun _ n => S n) l 0.

(** Prove que [fold_length] retorna a número de elementos de uma lista.
    Para facilitar essa prova demostre o lema [fold_length_head]. Dica
    as vezes a tática [reflexivty] aplica uma simplificação mais agressiva 
    que a tática [simpl], isso seŕá util na prova desse lema. *) 

Lemma fold_length_head : forall X (h : X) (t : list X),
  fold_length (h::t) = S (fold_length t).
Proof.
  intros X h t.
  -unfold fold_length. simpl. reflexivity.
Qed.

Theorem fold_length_correct : forall X (l : list X),
  fold_length l = length l.
Proof. 
  intros X l. induction l as [| h t IHt].
  -simpl. reflexivity.
  -simpl. rewrite fold_length_head. rewrite IHt. reflexivity.
Qed.

(** Também é possível definir a função [map] por meio da função [fold]. *)

Definition fold_map {X Y: Type} (f: X -> Y) (l: list X) : list Y :=
  fold (fun h t => f h::t) l [ ].

Example test_fold_map : fold_map (mult 2) [1; 2; 3] = [2; 4; 6].
Proof. reflexivity. Qed. 

(** Prove que [fold_map] tem um comportamento identico a [map], defina lemas 
    auxiliares se necessário *)

(* Lema auxiliar *)
Lemma fold_map_head : forall X Y (f: X -> Y) (h : X) (t : list X),
  fold_map f (h::t) = f h :: fold_map f t.
Proof.
  intros.
  -unfold fold_map. simpl. reflexivity.
Qed.

Theorem fold_map_correct : forall X Y (f: X -> Y) (l: list X),
  fold_map f l = map f l.
Proof. 
  intros. induction l as [| h t IHt].
  -simpl. reflexivity.
  -rewrite fold_map_head. rewrite IHt. simpl. reflexivity.
Qed. 

(** Podemos imaginar que a função [fold] coloca uma operação binária entre
    cada elelento de uma lista, por exemplo, [fold plus [1; 2; 3] 0] é igual 
    (1+(2+(3+0))). Da forma que foi declarada a função [fold] a operação 
    binária é executada da direita para esquerda. Declare uma função [foldl]
    que aplique a operação da esquerda para direita: *)

Fixpoint foldl {X Y: Type} (f: Y->X->Y) (b: Y) (l: list X) : Y :=
  match l with
  | nil => b
  | h :: t => foldl f (f b h) t
  end.

(** Exemplo: [foldl minus 10 [1; 2; 3]] igual (((10-1)-2)-3). *)

Example test_foldl : foldl minus 10 [1; 2; 3] = 4.
Proof. reflexivity. Qed.

Definition prod_curry {X Y Z : Type}
  (f : X * Y -> Z) (x : X) (y : Y) : Z := f (x, y). 

Definition prod_uncurry {X Y Z : Type}
  (f : X -> Y -> Z) (p : X * Y) : Z :=
  match p with
  | (x, y) => f x y
  end.

Check @prod_curry.
Check @prod_uncurry.

Theorem uncurry_curry : forall (X Y Z : Type)
                        (f : X -> Y -> Z)
                        x y,
  prod_curry (prod_uncurry f) x y = f x y.
Proof.
  intros. reflexivity.
Qed.

Theorem curry_uncurry : forall (X Y Z : Type)
                        (f : (X * Y) -> Z) (p : X * Y),
  prod_uncurry (prod_curry f) p = f p.
Proof.
  intros. destruct p as [x y]. simpl. reflexivity.
Qed.

(*==============LISTA 3 (CHURCH)==============*)
Definition cnat := forall X : Type, (X -> X) -> X -> X.


Definition zero : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => x.

Definition one : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => f x.


Definition two : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => f (f x).

Definition three : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => f (f (f x)).

Definition cnatId (n : cnat) : cnat := fun (X : Type) (f : X -> X) (x : X) => n X f x.

Example cnatId_1 : one = cnatId one.
Proof. simpl. reflexivity. Qed.

Example cnatId_2 : two = cnatId two.
Proof. simpl. reflexivity. Qed.

Definition succ (n : cnat) : cnat := fun (X : Type) (f : X -> X) (x : X) => f (n X f x).

Example succ_1 : succ zero = one.
Proof. simpl. reflexivity. Qed.

Example succ_2 : succ one = two.
Proof. simpl. reflexivity. Qed.

Example succ_3 : succ two = three.
Proof. simpl. reflexivity. Qed.

(* Exercícios - Numerais de Church: Dado o tipo cnat que representa um numeral de Church,
   declare funções que executem as seguintes operações aritméticas sobre os números: *)

(* Adição: *)

Definition plus (n m : cnat) : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => n X f (m X f x).

Example plus_1 : plus zero one = one.
Proof.
  -reflexivity.
Qed.

Example plus_2 : plus two three = plus three two.
Proof.
  -reflexivity.
Qed.

Example plus_3 :
  plus (plus two two) three = plus one (plus three three).
Proof.
  -reflexivity.
Qed.

Check plus.

(** Multiplicação: *)

Definition mult (n m : cnat) : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => n X (m X f) x.

Example mult_1 : mult one one = one.
Proof.
  -reflexivity.
Qed.

Example mult_2 : mult zero (plus three three) = zero.
Proof.
  -reflexivity.
Qed.

Example mult_3 : mult two three = plus three three.
Proof.
  -reflexivity.
Qed.

(** Exponenciação: *)

Definition exp (n m : cnat) : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => m (X -> X) (n X) f x.

Check exp.

Compute (exp two three). 

Compute (exp three two).

Compute (exp two (plus two two)).

Example exp_1 : exp two two = plus two two.
Proof.
  -reflexivity.
Qed.

Example exp_2 : exp three zero = one.
Proof.
  -reflexivity.
Qed.

Example exp_3 : exp three two = plus (mult two (mult two two)) one.
Proof.
  -reflexivity.
Qed.

(*==============LISTA 4 (ExerLogica)==============*)
Theorem dist_not_exists : forall (X:Type) (P : X -> Prop),
  (forall x, P x) -> ~ (exists x, ~ P x).
Proof.
  intros X P H_univ.
  intros H_existe_nao_P.
  destruct H_existe_nao_P as [x H_falha].
  apply H_falha.
  apply H_univ.
Qed.

Theorem dist_exists_or : forall (X:Type) (P Q : X -> Prop),
  (exists x, P x \/ Q x) <-> (exists x, P x) \/ (exists x, Q x).
Proof.
  intros X P Q.
  split.
  - 
    intros H_existe_ou.
    destruct H_existe_ou as [x H_ou].
    destruct H_ou as [H_P | H_Q].

    + 
      left.
      exists x.
      apply H_P.
    + 
      right.
      exists x.
      apply H_Q.
  - 
    intros H_ou_existes.
    destruct H_ou_existes as [H_existe_P | H_existe_Q].
    + 
      destruct H_existe_P as [x H_P].
      exists x.
      left.
      apply H_P.
    + 
      destruct H_existe_Q as [x H_Q].
      exists x.
      right.
      apply H_Q.
Qed.

Theorem dist_exists_and : forall (X:Type) (P Q : X -> Prop),
  (exists x, P x /\ Q x) -> (exists x, P x) /\ (exists x, Q x).
Proof.
  intros X P Q.
  intros H_existe_e.
  destruct H_existe_e as [x H_P_e_Q].
  destruct H_P_e_Q as [H_P H_Q].
  split.
  -
    exists x.
    apply H_P.

  -
    exists x.
    apply H_Q.
Qed.

Fixpoint In {A : Type} (x : A) (l : list A) : Prop :=
  match l with
  | [] => False
  | x' :: l' => x' = x \/ In x l'
  end.

Lemma In_map :
  forall (A B : Type) (f : A -> B) (l : list A) (x : A),
    In x l ->
    In (f x) (map f l).
Proof.
    intros A B f l x.
    induction l as [| h t IHt].
  -
    intros H_in.
    simpl in H_in.
    destruct H_in.
  -
    intros H_in.
    simpl in H_in.
    destruct H_in as [H_igual | H_ta_na_cauda].
    +
      simpl.
      left.
      rewrite H_igual.
      reflexivity.
    +
      simpl.
      right.
      apply IHt.
      apply H_ta_na_cauda.
Qed.

Lemma In_map_iff :
  forall (A B : Type) (f : A -> B) (l : list A) (y : B),
    In y (map f l) <->
    exists x, f x = y /\ In x l.
Proof.
  intros A B f l y.
  induction l as [| h t IHt].
  - simpl.
    split.
    + intros H_falso. 
      destruct H_falso. 
    + intros H_existe.
      destruct H_existe as [x H_and].
      destruct H_and as [H_fx_y H_falso].
      destruct H_falso.
  - simpl.
    split.
    + intros H_or. 
      destruct H_or as [H_fh_y | H_in_map].
      * exists h. 
        split.
        -- apply H_fh_y. 
        -- left. reflexivity. 
      * apply IHt in H_in_map.
        destruct H_in_map as [x H_and].
        destruct H_and as [H_fx_y H_in_t].
        exists x.
        split.
        -- apply H_fx_y. 
        -- right. apply H_in_t. 
    + intros H_existe.
      destruct H_existe as [x H_and].
      destruct H_and as [H_fx_y H_in_lista].
      destruct H_in_lista as [H_h_x | H_in_t].
      * left. 
        rewrite H_h_x. 
        apply H_fx_y. 
      * right. 
        apply IHt. 
        exists x.
        split.
        -- apply H_fx_y.
        -- apply H_in_t.
Qed.

Lemma In_app_iff : forall A l l' (a:A),
  In a (l++l') <-> In a l \/ In a l'.
Proof.
  intros A l l' a.
  induction l as [| h t IHt].
  - simpl.
    split.
    + intros H_in_l'. right. apply H_in_l'.
    + intros H_or. destruct H_or as [H_falso | H_in_l'].
      * destruct H_falso.
      * apply H_in_l'.
  - simpl.
    split.
    + intros H_or. destruct H_or as [H_h_a | H_in_app].
      * left. left. apply H_h_a.
      * apply IHt in H_in_app. destruct H_in_app as [H_in_t | H_in_l'].
        -- left. right. apply H_in_t.
        -- right. apply H_in_l'.
    + intros H_or. destruct H_or as [H_in_l | H_in_l'].
      * destruct H_in_l as [H_h_a | H_in_t].
        -- left. apply H_h_a.
        -- right. apply IHt. left. apply H_in_t.
      * right. apply IHt. right. apply H_in_l'.
Qed.

Theorem excluded_middle_irrefutable: forall (P:Prop),
  ~ ~ (P \/ ~ P).
Proof.
  intros P.
  intros H_nunca_acontece.
  apply H_nunca_acontece.
  right.
  intros H_P.
  apply H_nunca_acontece.
  left.
  apply H_P.
Qed.

Theorem disj_impl : forall (P Q: Prop),
 (~P \/ Q) -> P -> Q.
Proof.
  intros P Q.
  intros H_or H_P.
  destruct H_or as [H_not_P | H_Q].
  - apply H_not_P in H_P.
    destruct H_P.
  - apply H_Q.
Qed.

Theorem Peirce_double_negation: forall (P:Prop), (forall P Q: Prop,
  (((P->Q)->P)->P)) -> (~~ P -> P).
Proof.
  intros P H_peirce.
  intros H_not_not_P.
  apply (H_peirce P False).
  intros H_not_P.
  apply H_not_not_P in H_not_P.
  destruct H_not_P.
Qed.

Theorem double_negation_excluded_middle : forall (P:Prop),
  (forall (P:Prop), (~~ P -> P)) -> (P \/ ~P). 
Proof.
  intros P H_DNE.
  apply H_DNE.
  intros H_nunca_acontece.
  apply H_nunca_acontece.
  right.
  intros H_P.
  apply H_nunca_acontece.
  left.
  apply H_P.
Qed.
