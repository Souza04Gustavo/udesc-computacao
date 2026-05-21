(* Primeira Prova de Métodos Formais 
   Nome:                                      *) 


(* Todas as declarações devem ser feitas nesse arquivo,
   não deve ser importado nenhum módulo adicional. *)

Require Import Coq.Init.Nat.
Require Import Coq.Lists.List.
Import ListNotations.

(* Questão 1 - Prove a contrapositiva: *)

Theorem contrapositive : forall (P Q : Prop),
  (P -> Q) -> (~Q -> ~P).
Proof.
  Admitted.

(* Questão 2 - Prove a contrapositiva, assimindo a dupla negação: *)

Theorem contrapositive1_classic : forall (P Q : Prop),
  (forall X : Prop,  ~~X -> X) -> (~Q -> ~P) -> (P -> Q).
Proof.
  Admitted.

(* Questão 3 Indexando os elementos de uma lista começando em zero, 
   prove que não existe elemento na enésima posição de um lista de tamanho n: *) 

Fixpoint index {X : Set} (n : nat) (l : list X) : option X :=
  match l with
  | [] => None
  | h :: t => if n =? 0 then Some h else index (pred n) t
  end. 

Theorem len_index_none : forall {X : Set} (l : list X) (n : nat), 
  length l = n -> index n l = None.
Proof.
  Admitted.


(* Questão 4 *)

Definition compose {A B C} (g : B -> C) (f : A -> B) :=
  fun x : A => g (f x).

Notation "g (.) f" := (compose g f)
                     (at level 5, left associativity).

Definition involutive {A : Type} (f : A -> A) :=
  forall x: A, f (f x) = x.

Theorem involutive_f_map : forall (A : Type) (f : A -> A) (l:list A), 
  involutive f -> map f (.) f l = l.
Proof.
  Admitted.

