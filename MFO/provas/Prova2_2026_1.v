(* Segunda Prova de Métodos Formais 
   Nome: Gustavo de Souza       *) 


(* Todas as declarações devem ser feitas nesse arquivo,
   não deve ser importado nenhum módulo adicional. *)


Require Setoid.
Require Import Coq.Init.Logic.
Require Import Coq.Init.Nat.
Require Import Coq.Lists.List.
Import ListNotations.

(* Exercício 1 *)

Theorem or_distributes_over_and : forall P Q R : Prop,
  P \/ (Q /\ R) -> (P \/ Q) /\ (P \/ R).
Proof.
  intros P Q R H. split.
  - destruct H as [Hp | Hqr].
    * left. apply Hp.
    * destruct Hqr as [Hq Hr]. right. apply Hq.
  - destruct H as [Hp | Hqr].
    * left. apply Hp.
    * destruct Hqr as [Hq Hr]. right. apply Hr.
Qed.


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

(* Exercício 2 *)

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


(* Exercício 3 *)

Theorem union_comm : forall T (s: list T) (r1 r2 : reg_exp),
  s =~ Union r1 r2 -> s =~ Union r2 r1.
Proof.
  intros T s r1 r2 H.
  inversion H.
  - apply MUnionR. apply H2.
  - apply MUnionL. apply H1.
Qed.


(* Exercício 4 *)

Theorem union_dist_app : forall T (s : list T) (r1 r2 r3 : reg_exp),
  s =~ App r1 (Union r2 r3) <-> s =~ Union (App r1 r2) (App r1 r3).
Proof.
  intros T s r1 r2 r3. split. 
  - intros H. rewrite <- union_inv. inversion H. apply union_inv in H4.
    destruct H4 as [HL | HD].
    + left. apply MApp. apply H3. apply HL.
    + right. apply MApp. apply H3. apply HD.
  - intros H. apply union_inv in H. destruct H as [H1|H2].
    + inversion H1. apply MApp.
      * apply H3.
      * apply MUnionL. apply H4.
    + inversion H2. apply MApp.
      * apply H3.
      * apply MUnionR. apply H4.
Qed.






