(* REVISÃO DE TUDO O QUE É ASSUNTO DA ULTIMA PROVA! *)

(* =========================================== *)

(* EXAME 1 *)

Require Import PeanoNat.
Require Import Coq.Arith.Le.
Require Import Coq.Bool.Bool.

(* Questão 1 - Prove o teorema true_or. *)

Theorem true_or : forall (b1 b2:bool), b1 = true \/ b2 = true -> b1 || b2 = true.
Proof.
  intros b1 b2 H. destruct H as [H1|H2].
  - rewrite H1. simpl. reflexivity.
  - rewrite H2. apply orb_true_r.
Qed.

(* Questão 2 Prove o teorema double_negation_excluded_middle. *)

Theorem double_negation_excluded_middle : forall (P:Prop),
  (forall (P:Prop), (~~ P -> P)) -> (P \/ ~P). 
Proof.
  intros P DNE. apply DNE. unfold not. intros H. apply H. right. intros Hp.
  apply H. left. apply Hp.
Qed.


Search "<=".

(* Questão 3 Prove o teorema le_leb. *)


Theorem le_leb : forall (a b:nat), a <= b -> a <=? b = true.
Proof.
  intros a b H. generalize dependent b. induction a as [| a' IHa].
  - intros b H. simpl. reflexivity.
  - destruct b as [|b'].
    + intros H. inversion H.
    + intros H. simpl. apply IHa. apply le_S_n in H. apply H.
Qed.

(* Questão 4 Prove o teorema myle_Sn_m. *)

Inductive myle : nat -> nat -> Prop :=
  | myle_0 m : myle 0 m
  | myle_S n m (H : myle n m) : myle (S n) (S m).


Lemma myle_Sn_m : forall a b, myle (S a) b -> myle a b.
Proof.
  intros a b. generalize dependent b. induction a as [|a' IH].
  - intros b H. apply myle_0.
  - intros b H. inversion H. apply myle_S. apply IH. apply H1.
Qed.




(* =========================================== *)

(* EXAME 2 *)

Require Import Arith.
Require Import Coq.Lists.List.
Import ListNotations.

(* Questão 1 *)

Theorem repeat_n : forall {X:Set} (n:nat) (x:X),
  length (repeat x n) = n.
Proof.
  intros X n x. induction n as [|n' IH].
  - simpl. reflexivity.
  - simpl. rewrite IH. reflexivity.
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
  intros a b. induction a as [|a' IH].
  - simpl. apply le_0_n.
  - simpl. apply le_n_S. apply IH. 
Qed.


(* Questão 3*)

Fixpoint index {X : Set} (n : nat) (l : list X) : option X :=
  match l with
  | [] => None
  | h :: t => if n =? 0 then Some h else index (pred n) t
  end. 

Search le.

Theorem repeat_index : forall {X:Set} (x:X) (i:nat) (n:nat) ,
  i <= n -> index i (repeat x (S n)) = Some x.
Proof.
  intros X x i n H. generalize dependent n.
  induction i as [|i' IH].
  - intros n H. simpl. reflexivity.
  - intros n H. destruct n.
    + inversion H.
    + simpl. apply IH. apply le_S_n in H. apply H. 
Qed.

(* Questão 4 *)
(* BIZARRA D+!*)

Theorem index_map : forall {X Y:Set} (n:nat) (f:X->Y) (l:list X) (x:X), 
  index n l = Some x -> Some (f x) = index n (map f l).
Proof.
  intros X Y n f l x.
  (* Introduzimos as variáveis, mas deixamos 'n' para depois da indução
     ou usamos generalize dependent para generalizá-lo. *)
  generalize dependent n. 
  
  (* Indução na lista l *)
  induction l as [|h t IHl].
  
  - (* Caso Base: l = [] *)
    intros n H.
    simpl in H.
    (* index n [] é None. None = Some x é uma contradição. *)
    discriminate H.
    
  - (* Passo Indutivo: l = h :: t *)
    intros n H.
    (* Precisamos analisar n para saber se paramos nesta cabeça (0) ou continuamos (S n) *)
    destruct n.
    
    + (* Caso n = 0 *)
      simpl in H.
      (* O index encontrou o elemento. h deve ser igual a x *)
      inversion H. subst.
      (* Agora provamos que index 0 (map ...) retorna a versão mapeada *)
      simpl. reflexivity.
      
    + (* Caso n = S n *)
      simpl in H.
      (* index (S n) (h::t) vira index n t.
         Do outro lado, index (S n) (map ...) vira index n (map ... t).
         Isso é exatamente a nossa Hipótese de Indução (IHl). *)
      simpl.
      apply IHl.
      apply H.
Qed.


(* =========================================== *)

(* P2 PASSADA (1) *)

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

(* Questão 1: *)

Theorem app_dist_union1 : forall T (s : list T) (r1 r2 r3 : reg_exp),
  s =~ App (Union r1 r2) r3 -> s =~ Union (App r1 r3) (App r2 r3).
Proof.
  intros T s r1 r2 r3 H. rewrite <- union_inv. inversion H. apply union_inv in H3.
  destruct H3 as [HL | HD].
  - left. apply MApp. apply HL. apply H4.
  - right. apply MApp. apply HD. apply H4.
Qed.

(* Questão 2: *)

Theorem app_dist_union2 : forall T (s : list T) (r1 r2 r3 : reg_exp),
  s =~ Union (App r1 r3) (App r2 r3) -> s =~ App (Union r1 r2) r3.
Proof.
  intros T s r1 r2 r3 H. apply union_inv in H. destruct H as [H1|H2].
  - inversion H1. apply MApp.
    + apply MUnionL. apply H3.
    + apply H4.
  - inversion H2. apply MApp.
    + apply MUnionR. apply H3.
    + apply H4.
Qed.


(* Questão 3: *)

Theorem neutral_app1 : forall T (s : list T) (r: reg_exp),
  s =~ App EmptyStr r /\ s =~ App r EmptyStr -> s =~ r.
Proof.
  intros T s r H. destruct H as [H2 H3].
  inversion H2. inversion H4. simpl. apply H5.
Qed.


(* Questão 4: *)
(* NÃO FIZ COMPLETAMENTE! *)

Theorem neutral_app2 : forall T (s : list T) (r: reg_exp),
  s =~ r -> s =~ App EmptyStr r /\ s =~ App r EmptyStr.
Proof.
  intros T s r H. split.
  - apply MApp with (s1 := nil) (s2 := s). apply MEmpty.
    apply H.
  - assert (Happ : s = s ++ []). {rewrite app_nil_r. reflexivity. }   
    rewrite Happ. apply MApp. apply H. apply MEmpty.
Qed.


(* =========================================== *)

(* P2 PASSADA (2) *)

Require Import Arith.
Require Import Coq.Lists.List.
Import ListNotations.

(* Questão 1 *)

Theorem or_distributes_over_and : forall P Q R : Prop,
  P \/ (Q /\ R) <-> (P \/ Q) /\ (P \/ R).
Proof.
  intros P Q R. split.
  
  - (* IDA: P \/ (Q /\ R) -> (P \/ Q) /\ (P \/ R) *)
    intros H. split. (* Aqui o split funciona, porque o objetivo é um /\ *)
    + (* Sub-objetivo 1: Provar P \/ Q *)
      (* O H é P \/ (Q /\ R). Vamos abrir os dois caminhos dele: *)
      destruct H as [Hp | Hqr].
      * left. apply Hp.  (* Se P for verdade, vou pela esquerda e provo P *)
      * right.           (* Se (Q /\ R) for verdade, vou pela direita provar Q *)
        (* Hqr é Q /\ R. Destruct sem barra separa os dois (Pág 4). *)
        destruct Hqr as [Hq Hr]. 
        apply Hq.
        
    + (* Sub-objetivo 2: Provar P \/ R *)
      destruct H as [Hp | Hqr].
      * left. apply Hp.
      * right. 
        destruct Hqr as [Hq Hr]. 
        apply Hr.

  - (* VOLTA: (P \/ Q) /\ (P \/ R) -> P \/ (Q /\ R) *)
    intros H. 
    (* H é um "E". O destruct separa em duas hipóteses (Pág 4) *)
    destruct H as [Hpq Hpr].
    
    (* Agora temos Hpq: P \/ Q  e  Hpr: P \/ R. O objetivo é P \/ (Q /\ R). *)
    (* Vamos abrir os caminhos do Hpq: *)
    destruct Hpq as [Hp | Hq].
    
    + (* CASO 1: Sabemos que P é verdade *)
      (* O objetivo é P \/ (Q /\ R). Como temos P, escolhemos o lado esquerdo! *)
      left. apply Hp.
      
    + (* CASO 2: Sabemos que Q é verdade. 
         Mas para provar o lado direito (Q /\ R), também precisamos do R! 
         Vamos abrir os caminhos do Hpr para descobrir se temos R ou P. *)
      destruct Hpr as [Hp | Hr].
      
      * (* Sub-caso 2.1: Sabemos que P é verdade *)
        left. apply Hp.
        
      * (* Sub-caso 2.2: Sabemos que R é verdade (E já sabíamos que Q era também) *)
        (* O objetivo é P \/ (Q /\ R). Vamos escolher o lado direito! *)
        right. 
        (* AGORA SIM o seu objetivo virou Q /\ R. Agora você PODE usar o split! *)
        split.
        -- apply Hq. (* O primeiro bullet do split pede Q *)
        -- apply Hr. (* O segundo bullet do split pede R *)
Qed.

(* Questão 2 *)
(* JÁ RESOLVIDA (do index_map)! *)

(* Questão 3 *)

Search (min).
(* Nota: A biblioteca Arith já possui Nat.min_l e Nat.max_r, 
   mas aqui faremos a prova manual por indução. *)

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

(*
  | myle_0 m : myle 0 m
  | myle_S n m (H : myle n m) : myle (S n) (S m).
*)

(* 
  Lema Auxiliar: Se n <= m, então n <= S m.
  Necessário para provar a questão 4. 
*)

Lemma myle_n_Sm : forall n m, myle n m -> myle n (S m).
Proof.
  intros n m H.
  induction H.
  - apply myle_0.
  - apply myle_S. apply IHmyle.
Qed.

(*
Lemma myle_Sn_m : forall a b, myle (S a) b -> myle a b.
Proof.
  intros a b H.
  (* Invertemos a hipótese:
     Se myle (S a) b, a única construção possível é myle_S.
     Isso implica que b deve ser (S m) e que vale (myle a m). *)
  inversion H. subst.
  (* Agora temos: H1 : myle a m. Queremos provar: myle a (S m).
     Usamos o lema auxiliar criado acima. *)
  apply myle_n_Sm.
  apply H1.
Qed.
*)


(* =========================================== *)
