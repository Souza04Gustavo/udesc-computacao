(*Aluno: Elisandro Raizer da Cruz Junior*)

Require Import Coq.Arith.PeanoNat.
(* Não deve ser importado nenhum novo arquivo
todas as definições devem estar neste arquivo *)

Fixpoint div2 (n:nat) : nat :=
  match n with
  | O => O
  | S O => O
  | S (S n') => S (div2 n')
  end.

Fixpoint sum (n : nat) : nat :=
  match n with
  | O => O
  | S n' => n + sum n'
  end.

Theorem plus_n_1 : forall (n : nat),
  n + 1 = S (n).
Proof.
  intros n. induction n as [| n' IH].
  - simpl. reflexivity.
  - simpl. rewrite IH. reflexivity.
Qed.

Search (_ + S _ = _).

Theorem plus_n_Sm : forall (n m:nat),
  n + S m = S (n + m).
Proof.
  intros n m. induction n as [| n' IH].
  - simpl. reflexivity.
  - simpl. rewrite IH. reflexivity.
Qed.

Theorem mult_2_n_plus : forall (n : nat),
  n + n = 2 * n.
Proof.
  intros n. induction n as [| n' IH].
  - simpl. reflexivity.
  - simpl.
    (* 2 * S n' = 2 * n' + 2  (by Nat.mul_succ_r) *)
    rewrite Nat.mul_succ_r.
    (* usar IH: n' + n' = 2 * n' *)
    rewrite <- IH.
    (* agora mostrar S n' + S n' = (n' + n') + 2 *)
    simpl.
    (* S n' + S n' = S (n' + S n') = S (S (n' + n')) *)
    (* (n' + n') + 2 = S (S (n' + n')) também; conseguimos por simplificação *)
    reflexivity.
Qed.

Print Nat.mul_succ_l.

Theorem mul2_div2 : forall n : nat,
  n = div2 (2 * n).
Proof.
  intros n. induction n as [| n' IH].
  - simpl. reflexivity.
  - simpl.
    (* 2 * S n' = S (S (2 * n')) by simpl/unfold of mult *)
    rewrite Nat.mul_succ_r.
    simpl.
    (* div2 (S (S (2*n'))) = S (div2 (2*n')) *)
    rewrite IH. reflexivity.
Qed.

Theorem div2_mult2_plus: forall (n m : nat),
  n + div2 m = div2 (2 * n + m).
Proof.
  intros n m. induction n as [| n' IH].
  - simpl. reflexivity.
  - simpl.
    (* 2 * S n' + m = S (S (2*n')) + m = S (S (2*n' + m)) (modulo associatividade) *)
    rewrite <- plus_n_Sm. (* helps normalize forms when needed *)
    (* better to compute directly *)
    simpl.
    (* Actually unfold the sum: 2 * S n' = S (S (2*n')) by Nat.mul_succ_r *)
    rewrite Nat.mul_succ_r.
    simpl.
    (* div2 (S (S (2*n' + m))) = S (div2 (2*n' + m)) *)
    rewrite IH. reflexivity.
Qed.

Theorem mult_Sn_m : forall (n m : nat),
  S n * m = m + n * m.
Proof.
  intros n m. simpl. reflexivity.
Qed.

Theorem sum_Sn : forall n : nat,
  sum (S n) = S n + sum n.
Proof.
  intros n. simpl. reflexivity.
Qed.

Theorem sum_n : forall n : nat,
  sum n = div2 (n * (n + 1)).
Proof.
  intros n. induction n as [| n' IH].
  - simpl. reflexivity.
  - (* Usamos: sum (S n') = S n' + sum n' *)
    simpl.
    rewrite IH.
    (* queremos: S n' + div2 (n' * (n' + 1)) = div2 (S n' * (S n' + 1)) *)
    (* aplicamos div2_mult2_plus com n := S n' e m := n' * (n' + 1) *)
    replace (S n' + div2 (n' * (n' + 1))) with
            (div2 (2 * S n' + n' * (n' + 1))).
    2: { apply div2_mult2_plus. }
    (* agora basta mostrar: 2 * S n' + n' * (n' + 1) = S n' * (S n' + 1) *)
    (* provamos a igualdade aritmética *)
    rewrite <- Nat.mul_succ_r with (n:=2) (m:=n'). (* 2 * S n' = 2 * n' + 2 *)
    (* mas vamos transformar o lado direito *)
    (* calculamos S n' * (S n' + 1) *)
    simpl.
    (* Vamos desenvolver S n' * (S n' + 1) usando mult_Sn_m *)
    (* S n' * (S n' + 1) = (S n' + 1) + n' * (S n' + 1) by mult_Sn_m (aplicada a primeiro argumento S n') *)
    rewrite mult_Sn_m.
    (* note: mult_Sn_m expects form S n * m = m + n*m, com n' e m := S n' + 1 *)
    (* porém já aplicamos, agora reorganizamos para obter 2*S n' + n'*(n'+1) *)
    (* expandir (S n' + 1) *)
    simpl.
    (* (S n' + 1) = S (S n') = 2 + n' + n'? vamos reescrever de forma clara *)
    (* é mais direto demonstrar por aritmética que os lados são iguais *)
    lia.
Qed.
