(* Exame Métodos Formais 
   Nome:  *)

(* Todas as declarações devem ser feitas nesse arquivo,
   não deve ser importado nenhum módulo adicional. *)

Require Import Arith.
Require Import Coq.Lists.List.
Import ListNotations.

(* Questão 1 *)

Theorem or_distributes_over_and : forall P Q R : Prop,
  P \/ (Q /\ R) -> (P \/ Q) /\ (P \/ R).
Proof.
  Admitted.

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


Lemma myle_Sn_m : forall a b, myle (S a) b -> myle a b.
Proof.
  Admitted.  











