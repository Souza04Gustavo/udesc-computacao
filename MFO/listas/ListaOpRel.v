Require Export Arith.

(* Não importar nenhuma biblioteca adicional *)


Theorem O_le_n : forall n,
  0 <= n.
Proof.
  Admitted.

Print le_n.

Theorem n_le_m__Sn_le_Sm : forall n m,
  n <= m -> S n <= S m.
Proof.
  Admitted.

Lemma n_le_m__Sn_le_Sm' : forall a b, a <= b -> S a <= S b.
Proof.
  Admitted.

Theorem Sn_le_Sm__n_le_m : forall n m,
  S n <= S m -> n <= m.
Proof.
  Admitted.

Lemma le_trans : forall m n o, m <= n -> n <= o -> m <= o.
Proof.
  Admitted.

Theorem le_plus_l : forall a b,
  a <= a + b.
Proof.
  Admitted.

Theorem lt_ge_cases : forall n m,
  n < m \/ n >= m.
Proof.
  Admitted.

Inductive le' : nat -> nat -> Prop :=
  | le_0' m : le' 0 m
  | le_S' n m (H : le' n m) : le' (S n) (S m).

Lemma n_le'_m__Sn_le'_Sm : forall a b, le' a b -> le' (S a) (S b).
Proof.
  Admitted.

Lemma le'_n_n : forall a, le' a a.
Proof.
  Admitted. 
  
Lemma le'_n_Sm : forall a b, le' a b -> le' a (S b). 
Proof.
  Admitted. 


Theorem le_le' : forall a b, le a b <-> le' a b.
Proof.
  Admitted.

Theorem plus_lt : forall n1 n2 m,
  n1 + n2 < m ->
  n1 < m /\ n2 < m.
Proof.
  Admitted.

  

Theorem lt_S : forall n m,
  n < m ->
  n < S m.
Proof.
  Admitted.





