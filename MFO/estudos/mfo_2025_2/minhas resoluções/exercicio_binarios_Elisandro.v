(* Nenhum outro arquivo deve ser importado.
   Nome: Elisandro Raizer da Cruz Junior *)

(**
  É possível representar números naturais de forma binária como uma listas de zeros 
  (representado por B0) e uns (representado por B1). O construtor de dados Z representa 
  a lista vazia. Por exemplo:

    
        decimal               binário                          unário
           0                       Z                              O
           1                    B1 Z                            S O
           2                B0 (B1 Z)                        S (S O)
           3                B1 (B1 Z)                     S (S (S O))
           4            B0 (B0 (B1 Z))                 S (S (S (S O)))
           5            B1 (B0 (B1 Z))              S (S (S (S (S O))))
           6            B0 (B1 (B1 Z))           S (S (S (S (S (S O)))))
           7            B1 (B1 (B1 Z))        S (S (S (S (S (S (S O))))))
           8        B0 (B0 (B0 (B1 Z)))    S (S (S (S (S (S (S (S O)))))))

  Note que para facilitar as operações a lista é definida com os bits mais significativos
  à direita. 
*)

Inductive bin : Type :=
  | Z
  | B0 (n : bin)
  | B1 (n : bin).

(** Implemente uma função que incrementa um valor binário: *)
Fixpoint incr (m:bin) : bin :=
  match m with
  | Z => B1 Z
  | B0 m => B1 m
  | B1 m => B0 (incr m)
  end.

(* Testes unitários *)
Example test_bin_incr1 : (incr (B1 Z)) = B0 (B1 Z).
Proof. reflexivity. Qed.

Example test_bin_incr2 : (incr (B0 (B1 Z))) = B1 (B1 Z).
Proof. reflexivity. Qed.

Example test_bin_incr3 : (incr (B1 (B1 Z))) = B0 (B0 (B1 Z)).
Proof. reflexivity. Qed.

(** Implemente uma função que converta um número binário para natural: *)
Fixpoint bin_to_nat (m:bin) : nat :=
  match m with
  | Z => 0
  | B0 n => 2 * (bin_to_nat n)
  | B1 n => 1 + 2 * (bin_to_nat n)
  end.

(* Testes unitários *)
Example test_bin_incr4 : bin_to_nat (B0 (B1 Z)) = 2.
Proof. reflexivity. Qed.

Example test_bin_incr5 :
  bin_to_nat (incr (B1 Z)) = 1 + bin_to_nat (B1 Z).
Proof. reflexivity. Qed.

Example test_bin_incr6 :
  bin_to_nat (incr (incr (B1 Z))) = 2 + bin_to_nat (B1 Z).
Proof. reflexivity. Qed.

(** 
 Prove as transformações definidas no seguinte diagrama:

                            incr
              bin ----------------------> bin
               |                           |
    bin_to_nat |                           |  bin_to_nat
               |                           |
               v                           v
              nat ----------------------> nat
                             S
*)

Lemma succ_plus_r: forall n m : nat,
  S(n + m) = n + (S m).
Proof.
  intros. induction n as [|k].
  - simpl. reflexivity.
  - simpl. rewrite IHk. reflexivity.
Qed.

Theorem bin_to_nat_pres_incr : forall b : bin,
  bin_to_nat (incr b) = 1 + bin_to_nat b.
Proof.
  intros. induction b as [|k'|k''].
  - simpl. reflexivity.
  - simpl. reflexivity.
  - simpl (incr (B1 k'')).
    simpl (bin_to_nat (B0 (incr k''))).
    rewrite IHk''.
    simpl (bin_to_nat (B1 k'')).
    rewrite succ_plus_r.
    reflexivity.
Qed.

(** Declare uma função que converta números naturais em binários: *)
Fixpoint nat_to_bin (n:nat) : bin :=
  match n with
  | O => Z
  | S n => incr (nat_to_bin n)
  end.

(** Prove que as conversões podem ser revertidas: *)
Theorem nat_bin_nat : forall n, bin_to_nat (nat_to_bin n) = n.
Proof.
  intros. induction n as [|k].
  - simpl. reflexivity.
  - simpl. rewrite bin_to_nat_pres_incr.
    rewrite IHk. reflexivity.
Qed.

(** Defina a função normalize, que remove zeros extras à esquerda *)
Fixpoint normalize (b:bin) : bin :=
  match b with
  | Z => Z
  | B0 Z => Z
  | B0 n =>
      match normalize n with
      | Z => Z
      | n' => B0 n'
      end
  | B1 n => B1 (normalize n)
  end.

(** Prove que nat_to_bin e bin_to_nat são inversas
    (até normalização). *)
Theorem bin_nat_bin : forall b,
  nat_to_bin (bin_to_nat b) = normalize b.
Proof.
  intros. induction b as [|k IH|k IH].
  - simpl. reflexivity.
  - simpl. destruct (normalize k) eqn:Hk.
    + simpl. reflexivity.
    + simpl. rewrite <- IH. reflexivity.
    + simpl. rewrite <- IH. reflexivity.
  - simpl. rewrite <- IH. reflexivity.
Qed.

(* Pesquise sobre a necessidade da função normalize no capítulo Induction. *)
