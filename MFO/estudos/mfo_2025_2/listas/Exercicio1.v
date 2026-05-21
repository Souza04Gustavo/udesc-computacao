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

(** Implemente uma função que incrementa um valor binário: *)

Fixpoint incr (m:bin) : bin
  (* Coloque a definição aqui *). Admitted.

(** Implemente uma função que converta um número binário para natural: *)


Fixpoint bin_to_nat (m:bin) : nat
  (* Coloque a definição aqui *). Admitted.

(* Faça os seguintes testes unitários: *)

Example test_bin_incr1 : (incr (B1 Z)) = B0 (B1 Z).
 Admitted.

Example test_bin_incr2 : (incr (B0 (B1 Z))) = B1 (B1 Z).
 Admitted.

Example test_bin_incr3 : (incr (B1 (B1 Z))) = B0 (B0 (B1 Z)).
 Admitted.

Example test_bin_incr4 : bin_to_nat (B0 (B1 Z)) = 2.
Admitted.

Example test_bin_incr5 :
        bin_to_nat (incr (B1 Z)) = 1 + bin_to_nat (B1 Z).
Admitted.

Example test_bin_incr6 :
        bin_to_nat (incr (incr (B1 Z))) = 2 + bin_to_nat (B1 Z).
 Admitted.

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
  Admitted.

(** Declare uma função que converta números naturais em binários: *)

Fixpoint nat_to_bin (n:nat) : bin 
 (* Coloque a definição aqui *). Admitted. 


(** Prove que as conversões podem ser revertidas: *)

Theorem nat_bin_nat : forall n, bin_to_nat (nat_to_bin n) = n.
Proof.
  Admitted.

Fixpoint normalize (b:bin) : bin
 (* Coloque a definição aqui *). Admitted.

Theorem bin_nat_bin : forall b, nat_to_bin (bin_to_nat b) = normalize b.
Proof.
   Admitted.

(* Pesquise sobre a necessidade da função normalize no capítulo Induction. *) 


