(* Primeira Prova de Métodos Formais 13/10/2025 
   Nome: Elisandro Raizer da Cruz Junior *)

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

Theorem evenb_2 : forall n:nat, evenb (n * 2) = true.
Proof.
  intros n.
  induction n as [| n' IH].
  - (* Caso base: n = 0 *)
    simpl. reflexivity.
  - (* Passo indutivo: n = S n' *)
    simpl.
    (* Queremos provar que: evenb ((S n') * 2) = true *)
    simpl.
    rewrite IH. reflexivity.
Qed.


(* Questão 2 Prove que se um número é par seu sucessor é impar.*)

Definition oddb (n:nat) : bool   :=   negb (evenb n).

Theorem evenb_double : forall n,
  evenb (n + n) = true.
Proof.
  induction n; simpl; auto.
  rewrite <- plus_n_Sm. simpl. apply IHn.
Qed.


(* Questão 3 Prove que a função reverso é distributiva em ralação a concatenação.*)

Search (_ ++ []).

Fixpoint rev {X:Type} (l:list X) : list X :=
  match l with
  | [] => []
  | h::t => app (rev t) [h]
  end.

Theorem rev_app_distr: forall X (l1 l2 : list X),
  rev (l1 ++ l2) = rev l2 ++ rev l1.
Proof.
  intros X l1 l2. induction l1 as [|h t IH].
  - simpl. rewrite app_nil_r. reflexivity.
  - simpl. rewrite IH. rewrite app_assoc. reflexivity.
Qed.


(* Questão 4 - Prove que se uma função f é involutiva aplicar a composição de f em
uma lista resulta na própria lista. *)

Definition compose {A B C} (g : B -> C) (f : A -> B) :=
  fun x : A => g (f x).

Notation "g (.) f" := (compose g f)
                     (at level 5, left associativity).
Definition involutive {A : Type} (f : A -> A) :=
  forall x: A, f (f x) = x.


Theorem involutive_f_map2 : forall (A : Type)(f : A -> A) (l:list A), 
  (forall x:A, f (f x) = x) -> map f (.) f l = l.
Proof.
  intros. induction l as [|h t].
  - simpl. reflexivity.
  - simpl. specialize (H h). unfold compose in *. rewrite H. rewrite IHt. reflexivity.
Qed.
