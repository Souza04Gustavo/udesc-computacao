Require Export Arith.

(* Não importar nenhuma biblioteca adicional *)

Search "<=".
Print le_n.
Print le.

Theorem O_le_n : forall n,
  0 <= n.
Proof.
  intros n. induction n as [|n' IH].
  - apply le_n.
  - apply le_S. apply IH.
Qed.

Theorem n_le_m__Sn_le_Sm : forall n m,
  n <= m -> S n <= S m.
Proof.
  intros n m H1. induction H1 as [|m' H2 IH].
  - apply le_n.
  - apply le_S. apply IH.
Qed.

Lemma n_le_m__Sn_le_Sm' : forall a b, a <= b -> S a <= S b.
Proof.
   intros a b H1. induction H1 as [|b' H2 IH].
  - apply le_n.
  - apply le_S. apply IH.
Qed.

Theorem Sn_le_Sm__n_le_m : forall n m,
  S n <= S m -> n <= m.
Proof.
  intros n m H1. inversion H1.
  - apply le_n.
  - subst. induction H0 as [| m' H0_le IH].
    + apply le_S. apply le_n.
    + apply le_S. apply IH. apply le_S. apply H0_le.
Qed.

Lemma le_trans : forall m n o, m <= n -> n <= o -> m <= o.
Proof.
  intros m n o H1 H2. induction H2 as [|n' H3 IH].
  - apply H1.
  - apply le_S. apply IH.
Qed.


Theorem le_plus_l : forall a b,
  a <= a + b.
Proof.
  intros a b. induction a as [|a' IH].
  - simpl. apply O_le_n.
  - simpl. apply n_le_m__Sn_le_Sm. apply IH.
Qed.

Search "<".

Theorem lt_ge_cases : forall n m,
  n < m \/ n >= m.
Proof.
  intros n m. generalize dependent n. induction m as [|m' IH].
  - intros n. right. unfold ge. apply O_le_n.
  - intros n. destruct (IH n) as [H1 | H2].
    + left. unfold lt in *. apply le_S. apply H1.
    + unfold ge in H2. inversion H2. subst.
      * left. unfold lt. apply le_n.
      * right. unfold ge. apply n_le_m__Sn_le_Sm'. apply H.
Qed.

Inductive le' : nat -> nat -> Prop :=
  | le_0' m : le' 0 m
  | le_S' n m (H : le' n m) : le' (S n) (S m).

Lemma n_le'_m__Sn_le'_Sm : forall a b, le' a b -> le' (S a) (S b).
Proof.
  intros a b H. apply le_S'. apply H.
Qed.

Lemma le'_n_n : forall a, le' a a.
Proof.
  intros a. induction a as [| a' IH].
  - apply le_0'.
  - apply le_S'. apply IH.
Qed.

Lemma le'_n_Sm : forall a b, le' a b -> le' a (S b). 
Proof.
  intros a b IH. induction IH as [|n m H1 H2].
  - apply le_0'.
  - apply le_S'. apply H2.
Qed.

Theorem le_le' : forall a b, le a b <-> le' a b.
Proof.
  intros a b. split.
  - intros H. induction H.
    + apply le'_n_n.
    + apply le'_n_Sm. apply IHle.
  - intros IH. induction IH.
    + apply O_le_n.
    + apply n_le_m__Sn_le_Sm. apply IHIH.
Qed.


Theorem lt_S : forall n m,
  n < m ->
  n < S m.
Proof.
  intros n m IH. unfold lt in *. apply le_S. apply IH.
Qed.

Theorem plus_lt : forall n1 n2 m,
  n1 + n2 < m ->
  n1 < m /\ n2 < m.
Proof.
  intros n1 n2 m H.
  unfold lt in *. split.
  - induction n2 as [| n2' IHn2'].
    + rewrite Nat.add_0_r in H. apply H.
    + rewrite <- plus_n_Sm in H. assert (H_menor : S (n1 + n2') <= m).
      { apply le_trans with (n := S (S (n1 + n2'))).
        - apply le_S. apply le_n.
        - apply H. }
      apply IHn2' in H_menor.
      apply H_menor.
  - rewrite Nat.add_comm in H. induction n1 as [| n1' IHn1'].
    + rewrite Nat.add_0_r in H. apply H.
    + rewrite <- plus_n_Sm in H.
      assert (H_menor : S (n2 + n1') <= m).
      { apply le_trans with (n := S (S (n2 + n1'))).
        - apply le_S. apply le_n.
        - apply H. }
      apply IHn1' in H_menor.
      apply H_menor.
Qed.




