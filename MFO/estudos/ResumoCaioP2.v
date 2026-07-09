(** ============================== Prova 2 - Versão 1 ============================== **)
Require Import Arith.
Require Import Coq.Lists.List.
Import ListNotations.


Fixpoint index {X : Set} (n : nat) (l : list X) : option X :=
  match l with
  | [] => None
  | h :: t => if n =? 0 then Some h else index (pred n) t
  end. 

(* Questão 1 *)

Theorem repeat_n : forall {X:Set} (n:nat) (x:X),
  length (repeat x n) = n.
Proof.
  intros. induction n as [|n' IHn].
  - reflexivity.
  - simpl. f_equal. apply IHn.
Qed.

(* Questão 2 *)
(* Alguns Teoremas uteis envolvendo <=
Theorem le_pred : forall n m, n <= m -> pred n <= pred m.
Theorem le_S_n  : forall n m, S n <= S m -> n <= m.
Theorem le_0_n  : forall n, 0 <= n.
Theorem le_n_S  : forall n m, n <= m -> S n <= S m. *)

Theorem le_plus_l : forall a b,
  a <= a + b.
Proof.
  intros. induction a as [|a' IHa].
  - simpl. apply le_0_n.
  - simpl. apply le_n_S. apply IHa.
Qed.

(* Questão 3*)
Theorem repeat_index : forall {X:Set} (x:X) (i:nat) (n:nat) ,
  i <= n -> index i (repeat x (S n)) = Some x.
Proof.
  induction i as [|i' IHi].
  - intros n H. simpl. reflexivity.
  - intros n H. destruct n.
    + simpl. inversion H.
    + apply IHi. apply le_S_n. apply H.
Qed.

(* Questão 4 *)
Theorem index_map : forall {X Y:Set} (n:nat) (f:X->Y) (l:list X) (x:X), 
  index n l = Some x -> Some (f x) = index n (map f l).
Proof.
  intros X Y n f l x.
  generalize dependent n. 
  induction l as [|h t IHl].
  
  - (* Caso Base: l = [] *)
    intros n H.
    simpl in H.
    discriminate H.
    
  - (* Passo Indutivo: l = h :: t *)
    intros n H.
    destruct n.
    
    + (* Caso n = 0 *)
      simpl in H.
      inversion H. subst.
      simpl. reflexivity.
      
    + (* Caso n = S n *)
      simpl in H.
      simpl.
      apply IHl.
      apply H.
Qed.

(** ============================== Prova 2 - Versão 2 ============================== **)
Require Import Arith.
Require Import Coq.Lists.List.
Import ListNotations.

(* Questão 1 *)

Theorem or_distributes_over_and : forall P Q R : Prop,
  P \/ (Q /\ R) <-> (P \/ Q) /\ (P \/ R).
Proof.
  intros.
  split.
  - intros. split.
    * destruct H. left. apply H. destruct H. right. apply H.
    * destruct H. left. apply H. right. apply H.
  - intros. destruct H. destruct H, H0.
    * left. apply H.
    * left. apply H.
    * left. apply H0.
    * right. split.
      + apply H.
      + apply H0.
Qed.

(* Questão 2 *)
(** Igual a questão 4 da versão 1
Fixpoint index {X : Set} (n : nat) (l : list X) : option X :=
  match l with
  | [] => None
  | h :: t => if n =? 0 then Some h else index (pred n) t
  end.

Theorem index_map : forall {X Y:Set} (n:nat) (f:X->Y) (l:list X) (x:X), 
  index n l = Some x -> Some (f x) = index n (map f l).
Proof.
  intros X Y n f l x H.
  (* Generalizamos n porque ele muda na recursão (pred n) *)
  generalize dependent n.
  induction l as [|h t IHl].
  - (* Caso Base: Lista vazia *)
    intros n H. simpl in H. discriminate H.
  - (* Passo Indutivo *)
    intros n H. simpl in *.
    destruct n.
    + (* n = 0 *)
      inversion H; subst. reflexivity.
    + (* n = S n' *)
      apply IHl. apply H.
Qed.
**)

(* Questão 3 *)
Theorem min_correct : forall (a b:nat), a <= b -> min a b = a /\ max a b = b.
Proof.
  intros a. induction a as [|a' IHa].
  - (* Caso a = 0 *)
    intros b H. simpl. split; reflexivity.
  - (* Caso a = S a' *)
    intros b H.
    destruct b as [|b'].
    + (* b = 0 *)
      inversion H. (* S a' <= 0 é impossível *)
    + (* b = S b' *)
      simpl.
      (* Sabemos que S a' <= S b' implica a' <= b' *)
      assert (H_le: a' <= b'). { apply le_S_n. apply H. }
      (* Aplicamos a Hipótese de Indução *)
      destruct (IHa b' H_le) as [Hmin Hmax].
      split.
      * rewrite Hmin. reflexivity.
      * rewrite Hmax. reflexivity.
Qed.

(* Questão 4 *)

Inductive myle : nat -> nat -> Prop :=
  | myle_0 m : myle 0 m
  | myle_S n m (H : myle n m) : myle (S n) (S m).

(* Lema Auxiliar: Se n <= m, então n <= S m.
   Necessário para provar a questão 4. *)
Lemma myle_n_Sm : forall n m, myle n m -> myle n (S m).
Proof.
  intros n m H.
  induction H.
  - apply myle_0.
  - apply myle_S. apply IHmyle.
Qed.

Lemma myle_Sn_m : forall a b, myle (S a) b -> myle a b.
Proof.
  intros a b H.
  inversion H. subst.
  apply myle_n_Sm.
  apply H1.
Qed.

(** ============================== Prova 2 - Versão 3 ============================== **)
(** Por algum motivo nesse arquivo, não funciona...mas está tudo correto, logo ficará tudo comentado
Require Import Coq.Lists.List.
Import ListNotations.


Inductive reg_exp {T : Type} : Type :=
  | EmptySet
  | EmptyStr
  | Char (t : T)
  | App (r1 r2 : reg_exp)
  | Union (r1 r2 : reg_exp)
  | Star (r : reg_exp).

Inductive exp_match {T} : list T -> reg_exp -> Prop :=
  | MEmpty : exp_match [] EmptyStr
  | MChar x : exp_match [x] (Char x)
  | MApp s1 re1 s2 re2
             (H1 : exp_match s1 re1)
             (H2 : exp_match s2 re2) :
             exp_match (s1 ++ s2) (App re1 re2)
  | MUnionL s1 re1 re2
                (H1 : exp_match s1 re1) :
                exp_match s1 (Union re1 re2)
  | MUnionR re1 s2 re2
                (H2 : exp_match s2 re2) :
                exp_match s2 (Union re1 re2)
  | MStar0 re : exp_match [] (Star re)
  | MStarApp s1 s2 re
                 (H1 : exp_match s1 re)
                 (H2 : exp_match s2 (Star re)) :
                 exp_match (s1 ++ s2) (Star re).

Notation "s =~ re" := (exp_match s re) (at level 80).

(* Questão 1 *)
Lemma union_inv : forall T (s : list T) (r1 r2 : reg_exp),
   s =~ r1 \/ s =~ r2 <-> s =~ Union r1 r2.
Proof.
  intros T s r1 r2. split.
  - intros H. destruct H as [H1 | H2].
    + apply MUnionL. apply H1.
    + apply MUnionR. apply H2.
  - intros H. inversion H.
    + left. apply H2.
    + right. apply H1.
Qed.

(* Questão 2 *)
Theorem app_dist_union1 : forall T (s : list T) (r1 r2 r3 : reg_exp),
  s =~ App (Union r1 r2) r3 -> s =~ Union (App r1 r3) (App r2 r3).
Proof.
  intros T s r1 r2 r3 H. rewrite <- union_inv.
  inversion H. apply union_inv in H3. 
  destruct H3 as [H3' | H3'].
  - left. apply MApp. apply H3'. apply H4.
  - right. apply MApp. apply H3'. apply H4.
Qed.

(* Questão 3 *)
Theorem app_dist_union2 : forall T (s : list T) (r1 r2 r3 : reg_exp),
  s =~ Union (App r1 r3) (App r2 r3) -> s =~ App (Union r1 r2) r3.
Proof.
  intros T s r1 r2 r3 H. apply union_inv in H.
  destruct H as [H1 | H1].
  - inversion H1. apply MApp. apply MUnionL. 
    apply H3. apply H4.
  - inversion H1. apply MApp. apply MUnionR.
    apply H3. apply H4.
Qed.

(* Questão 4 *)
Theorem neutral_app1 : forall T (s : list T) (r: reg_exp),
  s =~ App EmptyStr r /\ s =~ App r EmptyStr -> s =~ r.
Proof.
  intros T s r [H1 H2]. inversion H1. inversion H4.
    simpl. apply H5.
Qed.

(* Questão 5 *)
Theorem neutral_app2 : forall T (s : list T) (r: reg_exp),
  s =~ r -> s =~ App EmptyStr r /\ s =~ App r EmptyStr.
Proof.
  intros T s r H. split.
  - apply MApp with (s1 := nil) (s2 := s). apply MEmpty.
    apply H.
  - assert (Happ : s = s ++ []). {rewrite app_nil_r. reflexivity. }   
    rewrite Happ. apply MApp. apply H. apply MEmpty.
Qed.

(* Questão extra *)
Theorem neutral_app : forall T (s : list T) (r: reg_exp),
  s =~ App EmptyStr r /\ s =~ App r EmptyStr -> s =~ r.
Proof.
  intros T s r H.
  (* Separamos as duas hipoteses da conjuncao *)
  destruct H as [H_left H_right].
  
  (* Usamos a primeira hipotese: s =~ App EmptyStr r *)
  (* Fazemos inversion para descobrir como s foi construido *)
  inversion H_left; subst.
  (* Apos inversion:
     - H0 : s1 =~ EmptyStr
     - H3 : s2 =~ r
     - s = s1 ++ s2 (ja substituido por subst)
  *)
  
  (* Como s1 =~ EmptyStr, entao s1 = [] *)
  inversion H0; subst.
  (* Apos inversion de EmptyStr:
     - s1 = [] (ja substituido por subst)
     - s = [] ++ s2 = s2
  *)
  
  (* Agora s = s2, e s2 =~ r (que e H3) *)
  simpl.
  apply H3.
Qed.
**)
(** ============================== Questões extras ============================== **)
Require Import Bool.

Theorem map_repeat : forall {X Y : Type} (f : X -> Y) (x : X) (n : nat),
  map f (repeat x n) = repeat (f x) n.
Proof.
  intros X Y f x n.
  induction n as [|n' IHn].
  - (* Caso n = 0 *)
    simpl. reflexivity.
  - (* Caso n = S n' *)
    simpl. rewrite IHn. reflexivity.
Qed.

Theorem and_distributes_over_or : forall P Q R : Prop,
  P /\ (Q \/ R) <-> (P /\ Q) \/ (P /\ R).
Proof.
  intros P Q R. split.
  - (* Ida *)
    intros [H_P H_Q_ou_R].
    destruct H_Q_ou_R as [H_Q | H_R].
    + left. split. apply H_P. apply H_Q.
    + right. split. apply H_P. apply H_R.
  - (* Volta *)
    intros H_Or.
    destruct H_Or as [H_PandQ | H_PandR].
    + destruct H_PandQ as [H_P H_Q]. 
      split. apply H_P. left. apply H_Q.
    + destruct H_PandR as [H_P H_R]. 
      split. apply H_P. right. apply H_R.
Qed.

Theorem dist_not_forall : forall (X : Type) (P : X -> Prop),
  (exists x, ~ P x) -> ~ (forall x, P x).
Proof.
  intros X P H_existe_falso H_forall.
  destruct H_existe_falso as [x H_not_P].
  apply H_not_P.
  apply H_forall.
Qed.

Lemma myle_trans : forall a b c, myle a b -> myle b c -> myle a c.
Proof.
  intros a b c Hab Hbc.
  generalize dependent a.
  induction Hbc as [m | n m Hbc' IH].
  - (* Caso base: b = 0, c = m. Como a <= 0, a obrigatoriamente é 0 *)
    intros a Hab. inversion Hab. apply myle_0.
  - (* Passo indutivo: b = S n, c = S m *)
    intros a Hab. inversion Hab as [| a' n' Hab_step]; subst.
    + apply myle_0.
    + apply myle_S. apply IH. exact Hab_step.
Qed.

Theorem split_length : forall X Y (l : list (X * Y)) (l1 : list X) (l2 : list Y),
  split l = (l1, l2) -> length l = length l1 /\ length l = length l2.
Proof.
  intros X Y l. induction l as [| [x y] t IHt].
  - (* l = [] *)
    intros l1 l2 H. inversion H. split; reflexivity.
  - (* l = (x, y) :: t *)
    intros l1 l2 H. simpl in H.
    destruct (split t) as [lx ly] eqn:Heq.
    inversion H. subst.
    simpl.
    destruct (IHt lx ly eq_refl) as [Hlen1 Hlen2].
    split.
    + rewrite Hlen1. reflexivity.
    + rewrite Hlen2. reflexivity.
Qed.

Theorem map_app : forall X Y (f : X -> Y) (l1 l2 : list X),
  map f (l1 ++ l2) = map f l1 ++ map f l2.
Proof.
  intros X Y f l1 l2.
  induction l1 as [| h t IHl1].
  - (* Caso Base: l1 é vazia *)
    simpl. reflexivity.
  - (* Passo Indutivo: l1 é h :: t *)
    simpl. f_equal. apply IHl1.
Qed.

Theorem demorgan_or : forall P Q : Prop,
  ~(P \/ Q) <-> ~P /\ ~Q.
Proof.
  intros P Q. split.
  - (* Ida: ~(P \/ Q) -> ~P /\ ~Q *)
    intros H. split.
    + intros HP. apply H. left. apply HP.
    + intros HQ. apply H. right. apply HQ.
  - (* Volta: ~P /\ ~Q -> ~(P \/ Q) *)
    intros H_and H_or.
    destruct H_and as [HnP HnQ].
    destruct H_or as [HP | HQ].
    + apply HnP. apply HP.
    + apply HnQ. apply HQ.
Qed.

Theorem length_map : forall (X Y : Type) (f : X -> Y) (l : list X),
  length (map f l) = length l.
Proof.
  intros X Y f l.
  induction l as [| h t IHl].
  - (* Caso Base *)
    simpl. reflexivity.
  - (* Passo Indutivo *)
    simpl. f_equal. apply IHl.
Qed.

Lemma myle_refl : forall n, myle n n.
Proof.
  intros n.
  induction n as [| n' IHn].
  - (* Caso Base: n = 0 *)
    apply myle_0.
  - (* Passo Indutivo: n = S n' *)
    apply myle_S. apply IHn.
Qed.

Theorem index_None_iff : forall {X:Set} (l:list X) (n:nat),
  index n l = None <-> length l <= n.
Proof.
  induction l as [|h t IHt].
  - intros n. simpl. split.
    + intros _. apply le_0_n.
    + intros _. reflexivity.
  - intros n. simpl. destruct n as [|n'].
    + simpl. split.
      * intros H. discriminate H.
      * intros H. inversion H.
    + simpl. rewrite (IHt n'). split.
      * intros H. apply le_n_S. apply H.
      * intros H. apply le_S_n. apply H.
Qed.

Theorem combine_length : forall {X Y : Type} (l1 : list X) (l2 : list Y),
  length (combine l1 l2) = min (length l1) (length l2).
Proof.
  induction l1 as [|h1 t1 IH].
  - intros l2. simpl. reflexivity.
  - intros l2. destruct l2 as [|h2 t2].
    + simpl. reflexivity.
    + simpl. f_equal. apply IH.
Qed.

Theorem le_antisymmetric : forall n m, n <= m -> m <= n -> n = m.
Proof.
  induction n as [|n' IHn].
  - intros m H1 H2. inversion H2. reflexivity.
  - intros m H1 H2. destruct m as [|m'].
    + inversion H1.
    + f_equal. apply IHn.
      * apply le_S_n. apply H1.
      * apply le_S_n. apply H2.
Qed.

Theorem myle_iff_le : forall n m, myle n m <-> n <= m.
Proof.
  intros n m. split.
  - intros H. induction H as [m' | n' m' H' IH].
    + apply le_0_n.
    + apply le_n_S. apply IH.
  - intros H. induction H as [| m' H' IH].
    + apply myle_refl.
    + apply myle_n_Sm. apply IH.
Qed.

Theorem in_split : forall (X:Type) (x:X) (l:list X),
  In x l ->
  exists l1 l2, l = l1 ++ x :: l2.
Proof.
  intros X x l. induction l as [|h t IH].
  - simpl. intros [].
  - simpl. intros [Heq | Hin].
    + exists [], t. rewrite Heq. reflexivity.
    + apply IH in Hin. destruct Hin as [l1 [l2 Heq]].
      exists (h :: l1), l2. simpl. rewrite Heq. reflexivity.
Qed.

Theorem curry_prop : forall p q r : Prop,
  ((p /\ q) -> r) <-> (p -> (q -> r)).
Proof.
  intros p q r. split.
  - intros H hp hq. apply H. split; assumption.
  - intros H [hp hq]. apply H; assumption.
Qed.

Theorem excluded_middle_implies_to_or :
  (forall P : Prop, P \/ ~ P) ->
  (forall P Q : Prop, (P -> Q) -> (~P \/ Q)).
Proof.
  intros EM P Q H.
  destruct (EM P) as [HP | HnP].
  - right. apply H. apply HP.
  - left. apply HnP.
Qed.

Theorem not_true_iff_false : forall b : bool,
  b <> true <-> b = false.
Proof.
  destruct b.
  - split; intros H.
    + exfalso. apply H. reflexivity.
    + discriminate H.
  - split.
    + intros H. reflexivity.
    + intros H. discriminate.
Qed.

Theorem app_length : forall X (l1 l2 : list X),
  length (l1 ++ l2) = length l1 + length l2.
Proof.
  intros X l1 l2. 
  induction l1 as [| h t IHl1].
  - (* Caso Base: l1 é vazia *)
    simpl. reflexivity.
  - (* Passo Indutivo: l1 é h :: t *)
    simpl. f_equal. apply IHl1.
Qed.

Theorem contrapositive : forall P Q : Prop,
  (P -> Q) -> (~Q -> ~P).
Proof.
  intros P Q Hpq Hnq Hp.
  apply Hnq.
  apply Hpq.
  apply Hp.
Qed.

Theorem true_or : forall (b1 b2:bool), b1 = true \/ b2 = true -> b1 || b2 = true.
Proof.
  intros b1 b2 H. destruct H as [H1 | H2].
  - (* b1 = true *)
    rewrite H1. simpl. reflexivity.
  - (* b2 = true *)
    rewrite H2. destruct b1.
    + simpl. reflexivity.
    + simpl. reflexivity.
Qed.

Theorem le_leb : forall (a b:nat), a <= b -> a <=? b = true.
Proof.
  intros a. induction a as [|a' IHa].
  - (* a = 0 *)
    intros b H. simpl. reflexivity.
  - (* a = S a' *)
    intros b H. destruct b as [|b'].
    + (* Impossível S a' <= 0 *)
      inversion H.
    + (* a = S a' e b = S b' *)
      simpl. apply IHa. apply le_S_n. apply H.
Qed.

(** ============================== Lista ExerLogica ============================== **)
Require Export Coq.Lists.List.
Import ListNotations.

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


(** ============================== Lista LingReg ============================== **)
Require Export Coq.Init.Logic.
Require Export Coq.Bool.Bool.
Require Export Coq.Lists.List.
Import ListNotations.


Inductive reg_exp (T : Type) : Type :=
  | EmptySet
  | EmptyStr
  | Char (t : T)
  | App (r1 r2 : reg_exp T)
  | Union (r1 r2 : reg_exp T)
  | Star (r : reg_exp T).

Arguments EmptySet {T}.
Arguments EmptyStr {T}.
Arguments Char {T} _.
Arguments App {T} _ _.
Arguments Union {T} _ _.
Arguments Star {T} _.


Reserved Notation "s =~ re" (at level 80).

Inductive exp_match {T} : list T -> reg_exp T -> Prop :=
  | MEmpty : [] =~ EmptyStr
  | MChar x : [x] =~ (Char x)
  | MApp s1 re1 s2 re2
             (H1 : s1 =~ re1)
             (H2 : s2 =~ re2)
           : (s1 ++ s2) =~ (App re1 re2)
  | MUnionL s1 re1 re2
                (H1 : s1 =~ re1)
              : s1 =~ (Union re1 re2)
  | MUnionR re1 s2 re2
                (H2 : s2 =~ re2)
              : s2 =~ (Union re1 re2)
  | MStar0 re : [] =~ (Star re)
  | MStarApp s1 s2 re
                 (H1 : s1 =~ re)
                 (H2 : s2 =~ (Star re))
               : (s1 ++ s2) =~ (Star re)

  where "s =~ re" := (exp_match s re).


Fixpoint reg_exp_of_list {T} (l : list T) :=
  match l with
  | [] => EmptyStr
  | x :: l' => App (Char x) (reg_exp_of_list l')
  end.

Lemma reg_exp_of_list_spec : forall T (s1 s2 : list T),
  s1 =~ reg_exp_of_list s2 <-> s1 = s2.
Proof.
intros T s1 s2. split.
  - generalize dependent s1. induction s2 as [|x s2' IH].
    + intros s1 H. simpl in H. inversion H. reflexivity.
    + intros s1 H. simpl in H. inversion H. subst.
      inversion H3. subst.
      apply IH in H4. subst. reflexivity.
  - intros H. subst. induction s2 as [|x s2' IH].
    + simpl. apply MEmpty.
    + simpl. apply (MApp [x] (Char x) s2' (reg_exp_of_list s2')).
      * apply MChar.
      * apply IH.
Qed.

Fixpoint re_not_empty {T : Type} (re : @reg_exp T) : bool :=
  match re with
    | EmptySet => false
    | EmptyStr => true
    | Char _ => true
    | App re1 re2 => andb (re_not_empty re1) (re_not_empty re2)
    | Union re1 re2 => orb (re_not_empty re1) (re_not_empty re2)
    | Star re1 => true
end.

Lemma re_not_empty_correct : forall T (re : @reg_exp T),
  (exists s, s =~ re) <-> re_not_empty re = true.
Proof.
intros T re. split.
  - intros [s Hmatch]. induction Hmatch.
    + reflexivity.
    + reflexivity.
    + simpl. rewrite IHHmatch1. rewrite IHHmatch2. reflexivity.
    + simpl. rewrite IHHmatch. reflexivity.
    + simpl. rewrite IHHmatch. destruct (re_not_empty re1); reflexivity.
    + reflexivity.
    + reflexivity.
  - intros H. induction re.
    + discriminate H.
    + exists []. apply MEmpty.
    + exists [t]. apply MChar.
    + simpl in H. apply andb_true_iff in H. destruct H as [H1 H2].
      apply IHre1 in H1. apply IHre2 in H2.
      destruct H1 as [s1 Hs1]. destruct H2 as [s2 Hs2].
      exists (s1 ++ s2). apply MApp; assumption.
    + simpl in H. apply orb_true_iff in H. destruct H as [H | H].
      * apply IHre1 in H. destruct H as [s1 Hs1].
        exists s1. apply MUnionL. assumption.
      * apply IHre2 in H. destruct H as [s2 Hs2].
        exists s2. apply MUnionR. assumption.
    + exists []. apply MStar0.
Qed.

Fixpoint pumping_constant {T} (re : reg_exp T) : nat :=
  match re with
  | EmptySet => 1
  | EmptyStr => 1
  | Char _ => 2
  | App re1 re2 =>
      pumping_constant re1 + pumping_constant re2
  | Union re1 re2 =>
      pumping_constant re1 + pumping_constant re2
  | Star r => pumping_constant r
  end.

Fixpoint napp {T} (n : nat) (l : list T) : list T :=
  match n with
  | 0 => []
  | S n' => l ++ napp n' l
  end.

Lemma S_le : forall n m, S n <= m -> n <= m.
Proof.
  intros n m H. induction H.
  - apply le_S. apply le_n.
  - apply le_S. assumption.
Qed.

Lemma le_trans_helper : forall a b c, a <= b -> b <= c -> a <= c.
Proof.
  intros a b c H1 H2. induction H2.
  - assumption.
  - apply le_S. assumption.
Qed.

Lemma m_le_n_plus_m : forall n m, m <= n + m.
Proof.
  intros n m. induction n as [|n' IH].
  - simpl. apply le_n.
  - simpl. apply le_S. exact IH.
Qed.

Lemma le_S_n_helper : forall n m, S n <= S m -> n <= m.
Proof.
  intros n m H. inversion H; subst.
  - apply le_n.
  - apply S_le. assumption.
Qed.

Lemma le_n_S_helper : forall n m, n <= m -> S n <= S m.
Proof.
  intros n m H. induction H.
  - apply le_n.
  - apply le_S. assumption.
Qed.

Lemma zero_le_n : forall n, 0 <= n.
Proof.
  induction n as [|n' IH].
  - apply le_n.
  - apply le_S. assumption.
Qed.

Lemma add_le_cases : forall n m p q,
  n + m <= p + q -> n <= p \/ m <= q.
Proof.
  induction n as [|n' IH].
  - intros m p q H. left. apply zero_le_n. 
  - intros m p q H. destruct p as [|p'].
    + right. simpl in H. apply S_le in H.
      assert (H_m: m <= n' + m). { apply m_le_n_plus_m. }
      eapply le_trans_helper. exact H_m. exact H.
    + simpl in H. apply le_S_n_helper in H.
      apply IH in H. destruct H as [H1 | H2].
      * left. apply le_n_S_helper. assumption.
      * right. assumption.
Qed.

Lemma n_le_n_plus_m : forall n m, n <= n + m.
Proof.
  intros n m. induction n as [|n' IH].
  - apply zero_le_n.
  - simpl. apply le_n_S_helper. exact IH.
Qed.

Lemma pumping_constant_neq_0 : forall T (re : reg_exp T),
  pumping_constant re = 0 -> False.
Proof.
  intros T re. induction re.
  - discriminate.
  - discriminate.
  - discriminate.
  - simpl. destruct (pumping_constant re1).
    + intro H. apply IHre1. reflexivity.
    + intro H. discriminate.
  - simpl. destruct (pumping_constant re1).
    + intro H. apply IHre1. reflexivity.
    + intro H. discriminate.
  - simpl. apply IHre.
Qed.

Lemma weak_pumping : forall T (re : reg_exp T) s,
  s =~ re ->
  pumping_constant re <= length s ->
  exists s1 s2 s3,
    s = s1 ++ s2 ++ s3 /\
    s2 <> [] /\
    forall m, s1 ++ napp m s2 ++ s3 =~ re.
Proof.
  intros T re s Hmatch.
  induction Hmatch
    as [ | x | s1 re1 s2 re2 Hmatch1 IH1 Hmatch2 IH2
       | s1 re1 re2 Hmatch IH | re1 s2 re2 Hmatch IH
       | re | s1 s2 re Hmatch1 IH1 Hmatch2 IH2 ].
  - (* MEmpty *)
    simpl. intros contra. inversion contra.
 - (* MChar *)
    simpl. intros contra. inversion contra. inversion H0.
  - (* MApp *)
    simpl. intros Hlen. rewrite app_length in Hlen.
    apply add_le_cases in Hlen. destruct Hlen as [Hlen1 | Hlen2].
    + apply IH1 in Hlen1. destruct Hlen1 as [s1_1 [s1_2 [s1_3 [Heq [Hneq Hpump]]]]].
      exists s1_1, s1_2, (s1_3 ++ s2).
      split.
      * rewrite Heq. rewrite <- app_assoc. rewrite <- app_assoc. reflexivity.
      * split.
        -- assumption.
        -- intros m.
           assert (H_app: s1_1 ++ napp m s1_2 ++ s1_3 ++ s2 = (s1_1 ++ napp m s1_2 ++ s1_3) ++ s2).
           { rewrite <- app_assoc. rewrite <- app_assoc. reflexivity. }
           rewrite H_app.
           apply MApp.
           ++ apply Hpump.
           ++ apply Hmatch2.
    + apply IH2 in Hlen2. destruct Hlen2 as [s2_1 [s2_2 [s2_3 [Heq [Hneq Hpump]]]]].
      exists (s1 ++ s2_1), s2_2, s2_3.
      split.
      * rewrite Heq. rewrite <- app_assoc. reflexivity.
      * split.
        -- assumption.
        -- intros m.
           assert (H_app: (s1 ++ s2_1) ++ napp m s2_2 ++ s2_3 = s1 ++ (s2_1 ++ napp m s2_2 ++ s2_3)).
           { repeat rewrite app_assoc. reflexivity. }
           rewrite H_app.
           apply MApp.
           ++ apply Hmatch1.
           ++ apply Hpump.
  - (* MUnionL *)
    simpl. intros Hlen.
    assert (H_le: pumping_constant re1 <= length s1).
    { eapply le_trans_helper. apply n_le_n_plus_m. exact Hlen. }
    apply IH in H_le.
    destruct H_le as [s1_1 [s1_2 [s1_3 [Heq [Hneq Hpump]]]]].
    exists s1_1, s1_2, s1_3.
    split. { assumption. }
    split. { assumption. }
    intros m. apply MUnionL. apply Hpump.
  - (* MUnionR *)
    simpl. intros Hlen.
    assert (H_le: pumping_constant re2 <= length s2).
    { eapply le_trans_helper. apply m_le_n_plus_m. exact Hlen. }
    apply IH in H_le.
    destruct H_le as [s2_1 [s2_2 [s2_3 [Heq [Hneq Hpump]]]]].
    exists s2_1, s2_2, s2_3.
    split. { assumption. }
    split. { assumption. }
    intros m. apply MUnionR. apply Hpump.
  - (* MStar0 *)
    simpl. intros contra. inversion contra.
    apply pumping_constant_neq_0 in H0. destruct H0.
  - (* MStarApp *)
    simpl. intros Hlen. rewrite app_length in Hlen.
    destruct s1 as [|x s1'].
    + (* s1 = [] *)
      simpl in Hlen. apply IH2 in Hlen.
      destruct Hlen as [s2_1 [s2_2 [s2_3 [Heq [Hneq Hpump]]]]].
      exists s2_1, s2_2, s2_3.
      split. { assumption. }
      split. { assumption. }
      intros m. apply Hpump.
    + (* s1 = x :: s1' *)
      exists [], (x :: s1'), s2.
      split. { reflexivity. }
      split. { unfold not. intros contra. discriminate. }
      intros m. simpl.
      clear Hlen IH1 IH2.
      induction m as [|m' IHm].
      * simpl. apply Hmatch2.
      * change (napp (S m') (x :: s1')) with ((x :: s1') ++ napp m' (x :: s1')).
        assert (H_app: ((x :: s1') ++ napp m' (x :: s1')) ++ s2 = (x :: s1') ++ (napp m' (x :: s1') ++ s2)).
        { rewrite app_assoc. reflexivity. }
        rewrite H_app.
        apply MStarApp.
        -- apply Hmatch1.
        -- apply IHm.
Qed.

(** ==== Mais questões extras ==== **)
Lemma union_comm : forall T (s : list T) (r1 r2 : reg_exp T),
  s =~ Union r1 r2 <-> s =~ Union r2 r1.
Proof.
  intros T s r1 r2. split.
  - (* Ida *)
    intros H. inversion H.
    + apply MUnionR. apply H2.
    + apply MUnionL. apply H1.
  - (* Volta *)
    intros H. inversion H.
    + apply MUnionR. apply H2.
    + apply MUnionL. apply H1.
Qed.

Theorem star_app : forall T (s1 s2 : list T) (re : reg_exp T),
  s1 =~ Star re ->
  s2 =~ Star re ->
  s1 ++ s2 =~ Star re.
Proof.
  intros T s1 s2 re H1.
  remember (Star re) as re' eqn:Heqre'.
  generalize dependent s2.
  induction H1
    as [ | x' | s1' re1 s2' re2 Hmatch1 IH1 Hmatch2 IH2
       | s1' re1 re2 Hmatch IH | re1 s2' re2 Hmatch IH
       | re'' | s1' s2' re'' Hmatch1 IH1 Hmatch2 IH2 ].
  - discriminate.
  - discriminate.
  - discriminate.
  - discriminate.
  - discriminate.
  - injection Heqre' as Heqre''. intros s2 H. apply H.
  - injection Heqre' as Heqre''.
    intros s2 H2. rewrite <- app_assoc.
    apply MStarApp.
    + apply Hmatch1.
    + apply IH2.
      * rewrite Heqre''. reflexivity.
      * apply H2.
Qed.

Lemma app_exists : forall (T : Type) (s : list T) (re0 re1 : reg_exp T),
  s =~ App re0 re1 <->
  exists s0 s1, s = s0 ++ s1 /\ s0 =~ re0 /\ s1 =~ re1.
Proof.
  intros T s re0 re1.
  split.
  - intros H. inversion H as [| x' | s1 re1' s2 re2' Hmatch1 Hmatch2 Heqre1
      | s1 re1' re2' Hmatch1 | re1' s2 re2' Hmatch2
      | | s1 s2 re' Hmatch1 Hmatch2 ].
    exists s1, s2. split.
    * reflexivity.
    * split. apply Hmatch1. apply Hmatch2.
  - intros [s1 [s2 [Happ [Hmatch1 Hmatch2]]]].
    rewrite Happ. apply (MApp s1 re0 s2 re1 Hmatch1 Hmatch2).
Qed.

(** ============================== Lista split_combine ============================== **)
Require Export Coq.Lists.List.
Import ListNotations.

Fixpoint combine {X Y : Type} (lx : list X) (ly : list Y)
           : list (X*Y) :=
  match lx, ly with
  | [], _ => []
  | _, [] => []
  | x :: tx, y :: ty => (x, y) :: (combine tx ty)
  end.

Fixpoint split {X Y : Type} (l : list (X*Y))
               : (list X) * (list Y) :=
  match l with
  | [] => ([], [])
  | (x, y) :: t =>
      match split t with
      | (lx, ly) => (x :: lx, y :: ly)
      end
  end.

Lemma eq_cons : forall (X:Type) (l1 l2: list X) (x: X),
  l1 = l2 -> x :: l1 = x :: l2.
  intros X l1 l2 x.
  intro H.
  rewrite H.
  reflexivity.
Qed.

Theorem combine_split : forall X Y (l : list (X * Y)) l1 l2,
  split l = (l1, l2) ->
  combine l1 l2 = l.
Proof.
  intros X Y l. induction l as [| [x y] t IHt].
  - intros l1 l2 H. inversion H. reflexivity.
  - intros l1 l2 H. simpl in H. destruct (split t) as [lx ly] eqn:Heq.
    inversion H. simpl. rewrite (IHt lx ly eq_refl). reflexivity.
Qed.


Theorem split_combine : forall X Y (l1 : list X) (l2 : list Y) (l : list (X*Y)),
  length l1 = length l2 -> combine l1 l2 = l -> split l = (l1, l2).
Proof.
  intros X Y l1. induction l1 as [| h1 t1 IHt1].
  - intros l2 l Hlen Hcomb. destruct l2 as [| h2 t2].
    + rewrite <- Hcomb. reflexivity.
    + discriminate Hlen.
  - intros l2 l Hlen Hcomb. destruct l2 as [| h2 t2].
    + discriminate Hlen.
    + rewrite <- Hcomb. simpl. injection Hlen as Hlen'.
      assert (H : split (combine t1 t2) = (t1, t2)).
      { apply IHt1. apply Hlen'. reflexivity. }
      rewrite H. reflexivity.
Qed.

(** ============================== Lista OpRel ============================== **)
Require Export Arith.
Theorem O_le_n : forall n,
  0 <= n.
Proof.
  intros n. induction n as [| n' IHn'].
  - apply le_n.
  - apply le_S. apply IHn'.
Qed.

Print le_n.

Theorem n_le_m__Sn_le_Sm : forall n m,
  n <= m -> S n <= S m.
Proof.
  intros n m H. induction H.
  - apply le_n.
  - apply le_S. apply IHle.
Qed.

Lemma n_le_m__Sn_le_Sm' : forall a b, a <= b -> S a <= S b.
Proof.
  intros a b H. apply n_le_m__Sn_le_Sm. apply H.
Qed.

Theorem Sn_le_Sm__n_le_m : forall n m,
  S n <= S m -> n <= m.
Proof.
  intros n m. generalize dependent n. induction m as [| m' IHm'].
  - intros n H. inversion H.
    + apply le_n.
    + inversion H1.
  - intros n H. inversion H.
    + apply le_n.
    + apply le_S. apply IHm'. apply H1.
Qed.

Lemma le_trans : forall m n o, m <= n -> n <= o -> m <= o.
Proof.
  intros m n o H1 H2. induction H2.
  - apply H1.
  - apply le_S. apply IHle.
Qed.

(** Feito questão 2 versão 1
Theorem le_plus_l : forall a b,
  a <= a + b.
Proof.
  intros a b. induction a as [| a' IHa'].
  - simpl. apply O_le_n.
  - simpl. apply n_le_m__Sn_le_Sm. apply IHa'.
Qed.
**)

Theorem lt_ge_cases : forall n m,
  n < m \/ n >= m.
Proof.
  intros n m. generalize dependent n. induction m as [| m' IHm'].
  - intros n. right. apply O_le_n.
  - intros n. destruct n as [| n'].
    + left. unfold lt. apply n_le_m__Sn_le_Sm. apply O_le_n.
    + destruct (IHm' n') as [Hlt | Hge].
      * left. unfold lt in *. apply n_le_m__Sn_le_Sm. apply Hlt.
      * right. apply n_le_m__Sn_le_Sm. apply Hge.
Qed.

Inductive le' : nat -> nat -> Prop :=
  | le_0' m : le' 0 m
  | le_S' n m (H : le' n m) : le' (S n) (S m).

Lemma n_le'_m__Sn_le'_Sm : forall a b, le' a b -> le' (S a) (S b).
Proof.
  intros a b H. apply le_S'. apply H.
Qed.

Lemma le'_n_n : forall a, le' a a.
Proof.
  induction a as [| a' IHa'].
  - apply le_0'.
  - apply le_S'. apply IHa'.
Qed.
  
Lemma le'_n_Sm : forall a b, le' a b -> le' a (S b). 
Proof.
  intros a b H. induction H.
  - apply le_0'.
  - apply le_S'. apply IHle'.
Qed.

Theorem le_le' : forall a b, le a b <-> le' a b.
Proof.
  intros a b. split.
  - intros H. induction H as [| m H_le IH].
    + apply le'_n_n.
    + apply le'_n_Sm. apply IH.
  - intros H. induction H.
    + apply O_le_n.
    + apply n_le_m__Sn_le_Sm. apply IHle'.
Qed.

Lemma le_plus_r : forall a b, 
  b <= a + b.
Proof.
  intros a b. induction a as [| a' IHa'].
  - simpl. apply le_n.
  - simpl. apply le_S. apply IHa'.
Qed.

Theorem plus_lt : forall n1 n2 m,
  n1 + n2 < m ->
  n1 < m /\ n2 < m.
Proof.
  intros n1 n2 m H. split.
  - unfold lt in *. apply le_trans with (n := S (n1 + n2)).
    + apply n_le_m__Sn_le_Sm. apply le_plus_l.
    + apply H.
  - unfold lt in *. apply le_trans with (n := S (n1 + n2)).
    + apply n_le_m__Sn_le_Sm. apply le_plus_r.
    + apply H.
Qed.

Theorem lt_S : forall n m,
  n < m ->
  n < S m.
Proof.
  intros n m H. unfold lt in *. apply le_S. apply H.
Qed.

(** ==== Mais questões extras ==== **)
Theorem le'_trans : forall a b c, le' a b -> le' b c -> le' a c.
Proof.
  intros a b c Hab. generalize dependent c.
  induction Hab as [b' | a' b' Hab' IH].
  - intros c Hbc. apply le_0'.
  - intros c Hbc. inversion Hbc as [| b'' c' Hbc']; subst.
    apply le_S'. apply IH. apply Hbc'.
Qed.

Lemma MStar1 : forall T (s : list T) (re : reg_exp T),
  s =~ re -> s =~ Star re.
Proof.
  intros T s re H.
  assert (H_app : s = s ++ []). { rewrite app_nil_r. reflexivity. }
  rewrite H_app.
  apply MStarApp.
  - apply H.
  - apply MStar0.
Qed.

Theorem index_implies_length : forall {X : Set} (l : list X) (n : nat) (x : X),
  index n l = Some x -> S n <= length l.
Proof.
  intros X l. induction l as [| h t IHt].
  - (* Caso l = [] *)
    intros n x H. simpl in H. discriminate H.
  - (* Caso l = h :: t *)
    intros n x H. simpl in *. destruct n as [| n'].
    + (* Subcaso n = 0 *)
      simpl. apply n_le_m__Sn_le_Sm. apply O_le_n.
    + (* Subcaso n = S n' *)
      apply n_le_m__Sn_le_Sm. apply IHt with (x := x). apply H.
Qed.

Theorem min_l : forall a b, min a b <= a.
Proof.
  intros a b. generalize dependent b.
  induction a as [| a' IHa].
  - (* Caso a = 0 *)
    intros b. simpl. apply le_n.
  - (* Caso a = S a' *)
    intros b. destruct b as [| b'].
    + (* b = 0 *)
      simpl. apply O_le_n.
    + (* b = S b' *)
      simpl. apply n_le_m__Sn_le_Sm. apply IHa.
Qed.

(** ============================== Lista ChurchExercicio ============================== **)
Module Church.

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

End Church.