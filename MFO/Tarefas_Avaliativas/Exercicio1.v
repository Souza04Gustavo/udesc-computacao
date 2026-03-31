(** ** Exercício 1 - Números Binários 
 Nome:  
 Todas as definições devem estar contidas nesse arquivo, não importar outros módulos.*)

(** É possível representar números naturais de forma binária como uma listas de zeros 
    (representado por B0) e uns (representado por B1). O contrutor de dados Z representa 
    a lista vázia. Por exemplo:

    
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
  à direita. *)    


Inductive bin : Type :=
  | Z
  | B0 (n : bin)
  | B1 (n : bin).

Search (_+_).

(** Implemente uma função que incrementa um valor binário: *)

Fixpoint incr (m:bin) : bin :=
  match m with
  | Z => B1 Z
  | B0 b => B1 b
  | B1 b => B0 (incr b)
  end.

Compute (incr (B1 Z)).

(** Implemente uma função que converta um número binário para natural: *)
Fixpoint bin_to_nat (m:bin) : nat :=
  match m with
  | Z => 0
  | B0 b => bin_to_nat b + bin_to_nat b
  | B1 b => S (bin_to_nat b + bin_to_nat b)
  end.

Compute (bin_to_nat (B1(B1(B1 Z))) ).

(* Faça os seguintes testes unitários: *)

Example test_bin_incr1 : (incr (B1 Z)) = B0 (B1 Z).
 Proof.
  simpl. reflexivity.
 Qed.

Example test_bin_incr2 : (incr (B0 (B1 Z))) = B1 (B1 Z).
 Proof.
  simpl. reflexivity.
 Qed.

Example test_bin_incr3 : (incr (B1 (B1 Z))) = B0 (B0 (B1 Z)).
 Proof.
  simpl. reflexivity.
 Qed.

Example test_bin_incr4 : bin_to_nat (B0 (B1 Z)) = 2.
 Proof.
  simpl. reflexivity.
 Qed.


Example test_bin_incr5 :
        bin_to_nat (incr (B1 Z)) = 1 + bin_to_nat (B1 Z).
 Proof.
  simpl. reflexivity.
 Qed.



Example test_bin_incr6 :
        bin_to_nat (incr (incr (B1 Z))) = 2 + bin_to_nat (B1 Z).
 Proof.
  simpl. reflexivity.
 Qed.



(** Prove as transformações definidas no seguinte diagrama:

                            incr
              bin ----------------------> bin
               |                           |
    bin_to_nat |                           |  bin_to_nat
               |                           |
               v                           v
              nat ----------------------> nat
                             S


*)

Theorem bin_to_nat_pres_incr : forall b : bin,
  bin_to_nat (incr b) = 1 + bin_to_nat b.
Proof.
  intros b. 
  induction b as [| b' IH | b' IH].
  - simpl. reflexivity.
  - simpl. reflexivity.
  - simpl. rewrite -> IH. simpl. rewrite <- plus_n_Sm. reflexivity.
Qed.


(** Declare uma função que converta números naturais em binários: *)

Fixpoint nat_to_bin (n:nat) : bin :=
  match n with
  | O => Z
  | S n' => incr (nat_to_bin n') 
  end.
 
Compute (nat_to_bin 6).

(** Prove que as conversões podem ser revertidas: *)

Theorem nat_bin_nat : forall n, bin_to_nat (nat_to_bin n) = n.
Proof.
  intros.
  induction n as [| n' IH].
  - simpl. reflexivity.
  - simpl. rewrite -> bin_to_nat_pres_incr. simpl. rewrite -> IH. reflexivity.
Qed.

(* Só representações do Zero: *)
Fixpoint normalize (b:bin) : bin :=
  match b with
  | Z => Z
  | B1 b => B1 (normalize b)
  | B0 b => 
    match (normalize b) with
    | Z => Z
    | n => B0 n
    end
  end.

Compute (normalize (B1(B0(B1(B0 Z))))).


(* Definições auxiliares para provar bin_nat_bin: *)

Definition double_bin (b : bin) : bin :=
  match b with
  | Z => Z
  | _ => B0 b
  end.

Lemma double_incr_bin : forall b,
    double_bin (incr b) = incr (incr (double_bin b)).
Proof.
  destruct b; simpl; reflexivity.
Qed.

Lemma nat_to_bin_double : forall n,
  nat_to_bin (n + n) = double_bin (nat_to_bin n).
Proof.
  induction n as [| n' IHn'].
  - simpl. reflexivity.
  - simpl. rewrite <- plus_n_Sm.
    simpl. rewrite IHn'. 
    rewrite double_incr_bin. reflexivity.
Qed.


Theorem bin_nat_bin : forall b, nat_to_bin (bin_to_nat b) = normalize b.
Proof.
   intros b.
   induction b as [ |b' IH | b' IH].
   - simpl. reflexivity.
   - simpl. rewrite nat_to_bin_double. rewrite IH. 
     destruct (normalize b'). reflexivity. reflexivity. reflexivity. 
   - simpl. rewrite nat_to_bin_double. rewrite IH. destruct (normalize b'). 
     simpl. reflexivity.
     simpl. reflexivity.
     simpl. reflexivity.
Qed.

(* Pesquise sobre a necessidade da função normalize no capítulo Induction. *) 


