(* Exame de Métodos Formais 
   Nome:                                       *)

(* Todas as declarações devem ser feitas nesse arquivo,
   não deve ser importado nenhum módulo adicional. *)

Require Import PeanoNat.
Require Import Coq.Arith.Le.
Require Import Coq.Bool.Bool.


(* Questão 1 - Prove o teorema true_or. *)

Theorem true_or : forall (b1 b2:bool), b1 = true \/ b2 = true -> b1 || b2 = true.
Proof.
  intros b1 b2 H1. destruct H1.
  - rewrite H. simpl. reflexivity.
  - rewrite H. destruct b1.
    + simpl. reflexivity.
    + simpl. reflexivity.
Qed.

(* Questão 2 Prove o teorema double_negation_excluded_middle. *)

Theorem double_negation_excluded_middle : forall (P:Prop),
  (forall (P:Prop), (~~ P -> P)) -> (P \/ ~P). 
Proof.
  intros P H1. apply H1. unfold not. intros H2. apply H2.
  right. intros HP. apply H2. left. apply HP.
Qed.

(* Questão 3 Prove o teorema le_leb. *)


Theorem le_leb : forall (a b:nat), a <= b -> a <=? b = true.
Proof.
  Admitted.

(* Questão 4 Prove o teorema myle_Sn_m. *)

Inductive myle : nat -> nat -> Prop :=
  | myle_0 m : myle 0 m
  | myle_S n m (H : myle n m) : myle (S n) (S m).


Lemma myle_Sn_m : forall a b, myle (S a) b -> myle a b.
Proof.
  Admitted.

