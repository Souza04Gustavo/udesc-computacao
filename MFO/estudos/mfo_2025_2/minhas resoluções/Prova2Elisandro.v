(* Exame Métodos Formais 
   Nome:  Elisandro Raizer da Cruz Junior*)

(* Todas as declarações devem ser feitas nesse arquivo,
   não deve ser importado nenhum módulo adicional. *)

Require Import Arith.
Require Import Coq.Lists.List.
Import ListNotations.

(* Questão 1 *)

Theorem or_distributes_over_and : forall P Q R : Prop,
  P \/ (Q /\ R) <-> (P \/ Q) /\ (P \/ R).
Proof.
  intros.
  split.
  - intros.
    split.
    + destruct H.
      * left. apply H.
      * destruct H.
        right.
        apply H.
    + destruct H.
      * left. apply H.
      * destruct H.
        right.
        apply H0.
  - intros.
    destruct H.
    destruct H.
    + left. apply H.
    + destruct H0.
      * left.
        apply H0.
      * right.
        split.
          apply H.
          apply H0.
Qed.

(* Questão 2 *)

Fixpoint index {X : Set} (n : nat) (l : list X) : option X :=
  match l with
  | [] => None
  | h :: t => if n =? 0 then Some h else index (pred n) t
  end.

Theorem index_map : forall {X Y:Set} (n:nat) (f:X->Y) (l:list X) (x:X), 
  index n l = Some x -> Some (f x) = index n (map f l).
Proof.
  Admitted.


(* Questão 3 *)

Search (min).

Theorem min_correct : forall (a b:nat), a <= b -> min a b = a /\ max a b = b.
Proof.
  Admitted.

(* Questão 4 *)


Inductive myle : nat -> nat -> Prop :=
  | myle_0 m : myle 0 m
  | myle_S n m (H : myle n m) : myle (S n) (S m).

Lemma myle_Sn_m: forall a b, myle a b -> myle (S a) (S b).
Proof.
  intros. apply myle_S. apply H.
Qed.










