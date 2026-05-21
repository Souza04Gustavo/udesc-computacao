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
  intros n. induction n as [|n' H].
  - simpl. reflexivity.
  - simpl. rewrite H. reflexivity.
Qed.

(* Questão 2 Prove que se um número é par seu sucessor é impar.*)

Search "even".

Definition oddb (n:nat) : bool   :=   negb (evenb n).

Theorem even_S_odd : forall n, 
  evenb n = oddb (S n).
Proof.
  intros n. induction n as [| n' H].
  - simpl. reflexivity.
  - unfold oddb in H. destruct (evenb (S n')).
    + unfold oddb. simpl. rewrite H. simpl. reflexivity.
    + unfold oddb. simpl. rewrite H. simpl. reflexivity.
Qed.

(* Questão 3 Prove que a função reverso é distributiva em ralação a concatenação.*)

Search (_ ++ []).
Search "map".

(*
  app_nil_end: forall [A : Type] (l : list A), l = l ++ []
  app_nil_r: forall [A : Type] (l : list A), l ++ [] = l
*)

Theorem rev_app_distr: forall X (l1 l2 : list X),
  rev (l1 ++ l2) = rev l2 ++ rev l1.
Proof.
   intros X l1 l2. induction l1 as [|h t H].
   - simpl. rewrite <- app_nil_end. reflexivity.
   - simpl. rewrite H. rewrite <- app_assoc. reflexivity.
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
  intros A f l. intros H. unfold involutive in H. induction l as [|h t H1].
  - simpl. reflexivity.
  - simpl. rewrite H1. unfold compose. rewrite H. reflexivity.
Qed.
