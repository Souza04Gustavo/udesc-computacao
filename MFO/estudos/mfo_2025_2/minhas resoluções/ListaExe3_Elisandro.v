Require Import Coq.Lists.List.
Import ListNotations.

(* Aluno: Elisandro Raizer da Cruz Junior *)

(** * Métodos Formais - Lista de Exercícios 3 *)

Require Import Coq.Lists.List.
Import ListNotations.

Fixpoint fold {X Y: Type} (f: X->Y->Y) (l: list X) (b: Y) : Y :=
  match l with
  | nil => b
  | h :: t => f h (fold f t b)
  end.

(** O tamanho da lista resultante da concatenação de duas listas é
    igual a soma dos tamanhos das listas. *)
Lemma app_length : forall (X:Type) (l1 l2 : list X),
  length (l1 ++ l2) = length l1 + length l2.
Proof.
  induction l1 as [|h t IH].
  - simpl. reflexivity.
  - intros. simpl. rewrite IH. reflexivity.
Qed.

(** A operação de reverso é distributiva em relação a concatenação. *)
Theorem rev_app_distr: forall X (l1 l2 : list X),
  rev (l1 ++ l2) = rev l2 ++ rev l1.
Proof.
  intros X l1 l2. induction l1 as [|h t IH].
  - simpl. rewrite app_nil_r. reflexivity.
  - simpl. rewrite IH. rewrite app_assoc. reflexivity.
Qed.

(** [fold] é comutativo em relação a concatenação. *)
Theorem app_comm_fold : forall {X Y} (f: X->Y->Y) l1 l2 b,
  fold f (l1 ++ l2) b = fold f l1 (fold f l2 b).
Proof.
  intros. induction l1 as [|h t IH].
  - simpl. reflexivity.
  - simpl. rewrite IH. reflexivity.
Qed.

(** Implementação de [length] via fold. *)
Definition fold_length {X : Type} (l : list X) : nat :=
  fold (fun _ n => S n) l 0.

Lemma fold_length_head : forall X (h : X) (t : list X),
  fold_length (h::t) = S (fold_length t).
Proof.
  intros. simpl. reflexivity.
Qed.

Theorem fold_length_correct : forall X (l : list X),
  fold_length l = length l.
Proof.
  intros. induction l as [|h t IH].
  - simpl. reflexivity.
  - simpl. rewrite fold_length_head. rewrite IH. reflexivity.
Qed.

(** Implementação de [map] via fold. *)
Definition fold_map {X Y: Type} (f: X -> Y) (l: list X) : list Y :=
  fold (fun h t => f h :: t) l [].

Example test_fold_map : fold_map (mult 2) [1; 2; 3] = [2; 4; 6].
Proof. reflexivity. Qed.

Theorem fold_map_correct : forall X Y (f: X -> Y) (l: list X),
  fold_map f l = map f l.
Proof.
  intros. induction l as [|h t IH].
  - simpl. reflexivity.
  - simpl. rewrite <- IH. reflexivity.
Qed.

(** Implementação de fold da esquerda para a direita. *)
Fixpoint foldl {X Y: Type} (f: Y->X->Y) (b: Y) (l: list X) : Y :=
  match l with 
  | nil => b
  | h :: t => foldl f (f b h) t
  end.

Example test_foldl : foldl minus 10 [1; 2; 3] = 4.
Proof. reflexivity. Qed.
