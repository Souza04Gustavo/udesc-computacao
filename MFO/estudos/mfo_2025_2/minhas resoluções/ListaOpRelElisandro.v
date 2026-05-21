Require Export Arith.

(*Aluno: Elisandro Raizer da Cruz Junior*)

Theorem O_le_n : forall n, 0 <= n.
Proof.
  intro n. induction n.
  - apply le_n. (* Base case: 0 <= 0 *)
  - apply le_S. assumption. (* Passo indutivo: Se n <= n, então S n <= S n *)
Qed.


Print le_n.

Theorem n_le_m__Sn_le_Sm : forall n m, n <= m -> S n <= S m.
Proof.
  intros n m H. inversion H. (* Caso análise sobre n <= m *)
  - apply le_0. (* Base case: 0 <= m implica S 0 <= S m *)
  - apply le_S. assumption. (* Passo indutivo: Se n <= m, então S n <= S m *)
Qed.


Lemma n_le_m__Sn_le_Sm' : forall a b, a <= b -> S a <= S b.
Proof.
  intros a b H. apply n_le_m__Sn_le_Sm. assumption. (* Aplica o teorema anterior *)
Qed.


Theorem Sn_le_Sm__n_le_m : forall n m, S n <= S m -> n <= m.
Proof.
  intros n m H. inversion H.
  - apply le_0. (* Caso base: S 0 <= S 0 implica 0 <= 0 *)
  - apply le_S. assumption. (* Passo indutivo: Se S n <= S m, então n <= m *)
Qed.


Lemma le_trans : forall m n o, m <= n -> n <= o -> m <= o.
Proof.
  intros m n o H1 H2. inversion H1; inversion H2.
  - apply le_0. (* Caso base: 0 <= 0 implica 0 <= 0 *)
  - apply le_S. assumption. (* Passo indutivo: Se n <= m e n <= o, então m <= o *)
Qed.


Theorem le_plus_l : forall a b, a <= a + b.
Proof.
  intros a b. induction a.
  - apply le_n. (* Caso base: 0 <= 0 + b *)
  - apply le_S. assumption. (* Passo indutivo: Se a <= a + b, então S a <= S (a + b) *)
Qed.


Theorem lt_ge_cases : forall n m, n < m \/ n >= m.
Proof.
  intros n m. destruct (le_lt_dec n m).
  - right. assumption. (* Se n <= m, então n >= m *)
  - left. assumption. (* Se n < m, então n < m *)
Qed.


Inductive le' : nat -> nat -> Prop :=
  | le_0' m : le' 0 m
  | le_S' n m (H : le' n m) : le' (S n) (S m).

Lemma n_le'_m__Sn_le'_Sm : forall a b, le' a b -> le' (S a) (S b).
Proof.
  intros a b H. inversion H.
  - apply le_S'. apply le_0'. (* Caso base: le' 0 m implica le' (S 0) (S m) *)
  - apply le_S'. assumption. (* Passo indutivo: Se le' n m, então le' (S n) (S m) *)
Qed.

Lemma le'_n_n : forall a, le' a a.
Proof.
  intro a. induction a.
  - apply le_0'. (* Base case: le' 0 0 *)
  - apply le_S'. assumption. (* Passo indutivo: le' n n implica le' (S n) (S n) *)
Qed.
 
  
Lemma le'_n_Sm : forall a b, le' a b -> le' a (S b).
Proof.
  intros a b H. inversion H.
  - apply le_S'. apply le_0'. (* Caso base: le' 0 b implica le' 0 (S b) *)
  - apply le_S'. assumption. (* Passo indutivo: Se le' n m, então le' n (S m) *)
Qed.


Theorem le_le' : forall a b, le a b <-> le' a b.
Proof.
  split.
  - intros H. induction H.
    + apply le_0'. (* Caso base: le 0 m implica le' 0 m *)
    + apply le_S'. assumption. (* Passo indutivo: le (S n) (S m) implica le' (S n) (S m) *)
  - intros H. induction H.
    + apply le_n. (* Caso base: le' 0 m implica le 0 m *)
    + apply le_S. assumption. (* Passo indutivo: le' (S n) (S m) implica le (S n) (S m) *)
Qed.


Theorem plus_lt : forall n1 n2 m, n1 + n2 < m -> n1 < m /\ n2 < m.
Proof.
  intros n1 n2 m H. split.
  - apply lt_S. apply le_plus_l. assumption. (* Prova que n1 < m *)
  - apply lt_S. apply le_plus_l. assumption. (* Prova que n2 < m *)
Qed.


Theorem lt_S : forall n m, n < m -> n < S m.
Proof.
  intros n m H. inversion H.
  - apply lt_n_S. (* Caso base: n < m implica n < S m *)
  - apply lt_S. assumption. (* Passo indutivo: Se n < m, então n < S m *)
Qed.





