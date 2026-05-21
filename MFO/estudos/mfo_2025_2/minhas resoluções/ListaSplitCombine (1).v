Require Export Coq.Lists.List.
Import ListNotations.

(* Aluno: Elisandro Raizer da Cruz Junior *)

Fixpoint combine {X Y : Type} (lx : list X) (ly : list Y)
           : list (X*Y) :=
  match lx, ly with
  | [], _ => []
  | _, [] => []
  | x :: tx, y :: ty => (x, y) :: (combine tx ty)
  end.

Fixpoint split {X Y : Type} (l : list (X*Y))
               : (list X) * (list Y) :=
  match l with
  | [] => ([], [])
  | (x, y) :: t =>
      match split t with
      | (lx, ly) => (x :: lx, y :: ly)
      end
  end.

Lemma eq_cons : forall (X:Type) (l1 l2: list X) (x: X),
  l1 = l2 -> x :: l1 = x :: l2.
  intros X l1 l2 x.
  intro H.
  rewrite H.
  reflexivity.
Qed.

Theorem combine_split : forall X Y (l : list (X * Y)) l1 l2,
  split l = (l1, l2) ->
  combine l1 l2 = l.
Proof.
  intros X Y l.
  induction l as [| [x y] t IH].
  - intros l1 l2 H.
    simpl in H. inversion H. reflexivity.
  - intros l1 l2 H.
    simpl in H.
    destruct (split t) as [lx ly].
    inversion H. simpl.
    rewrite (IH lx ly). reflexivity.
    reflexivity.
Qed.


Theorem split_combine : forall X Y (l1 : list X) (l2 : list Y) (l : list (X*Y)),
  length l1 = length l2 ->
  combine l1 l2 = l ->
  split l = (l1, l2).
Proof.
  intros X Y l1.
  induction l1 as [|x t1 IH].
  - intros l2 l Hlen H.
    destruct l2; simpl in *.
    + reflexivity.
    + inversion Hlen.
  - intros l2 l Hlen H.
    destruct l2 as [|y t2]; simpl in *.
    + inversion Hlen.
    + inversion H; subst.
      simpl. rewrite (IH t2 t Hlen H2). reflexivity.
Qed.
