Require Export Coq.Lists.List.
Import ListNotations.

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
   intros X Y l. induction l as [|(x, y) t IH].
   - intros l1 l2 H. simpl in H. symmetry in H. injection H as H1 H2.
     rewrite H1. rewrite H2. simpl. reflexivity.
   - intros l1 l2 H. simpl in H. destruct (split t) as (lx, ly) eqn:E.
     injection H as Hl1 Hl2. rewrite <- Hl1. rewrite <- Hl2.
     simpl. rewrite IH. 
     + reflexivity.
     + reflexivity.
Qed.


Theorem split_combine : forall X Y (l1 : list X) (l2 : list Y) (l : list (X*Y)),
  length l1 = length l2 -> combine l1 l2 = l -> split l = (l1, l2).
Proof.
  intros X Y l1. induction l1 as [| h t IH].
  - intros l2 l Hlen Hcomb. simpl in Hlen. destruct l2 as [|h2 t2].
    + simpl in Hcomb. rewrite <- Hcomb. simpl. reflexivity.
    + simpl in Hlen. discriminate Hlen.
  - intros l2 l Hlen Hcomb. simpl in Hlen. destruct l2 as [| h2 t2].
    + simpl in Hlen. discriminate Hlen.
    + simpl in Hlen. injection Hlen as Hlen'. simpl in Hcomb.
      rewrite <- Hcomb. simpl. destruct (split (combine t t2)) as [lx ly] eqn:E.
      apply (IH t2 (combine t t2)) in Hlen'.
      rewrite Hlen' in E.
      injection E as E1 E2.
      rewrite <- E1. rewrite <- E2.
      reflexivity. reflexivity.
Qed.  


