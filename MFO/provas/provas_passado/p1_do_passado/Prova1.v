(* Primeira Prova de Métodos Formais 13/10/2025 
   Nome:                                       *)

(* Deve ser postado um unico arquivo, todas as declarações devem ser feitas nesse arquivo,
   não deve ser importado nenhum módulo adicional. *)

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
  intros n. induction n as [|n' IH].
  - simpl. reflexivity.
  - simpl. rewrite IH. reflexivity.
Qed.


(* Questão 2 Prove que se um número é par seu sucessor é impar.*)

Definition oddb (n:nat) : bool   :=   negb (evenb n).

Theorem even_S_odd : forall n, 
  evenb n = oddb (S n).
Proof.
  intros n. induction n as [| n' IH].
  - simpl. reflexivity.
  - unfold oddb in *. destruct (evenb (S n')).
    + simpl. rewrite IH. simpl. reflexivity.
    + simpl. rewrite IH. simpl. reflexivity.
Qed.

(* Questão 3 Prove que a função reverso é distributiva em ralação a concatenação.*)

Search (_ ++ []).
Search "app".

(*
  app_nil_end: forall [A : Type] (l : list A), l = l ++ []
  app_nil_r: forall [A : Type] (l : list A), l ++ [] = l
*)

Theorem rev_app_distr: forall X (l1 l2 : list X),
  rev (l1 ++ l2) = rev l2 ++ rev l1.
Proof.
  intros X l1 l2. induction l1 as [| n l1' IHl1].
  - simpl. rewrite <- app_nil_end. reflexivity.
  - simpl. rewrite IHl1. rewrite app_assoc. reflexivity.
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
  intros A f l H. induction l as [| h t IH].
  - simpl. reflexivity.
  - simpl. rewrite IH. unfold compose. unfold involutive in H. rewrite H. reflexivity.
Qed.
