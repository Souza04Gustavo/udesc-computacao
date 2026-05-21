Module Church.

Definition cnat := forall X : Type, (X -> X) -> X -> X.


Definition zero : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => x.

Definition one : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => f x.


Definition two : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => f (f x).

Definition three : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => f (f (f x)).

Definition cnatId (n : cnat) : cnat := fun (X : Type) (f : X -> X) (x : X) => n X f x.

Example cnatId_1 : one = cnatId one.
Proof. simpl. reflexivity. Qed.

Example cnatId_2 : two = cnatId two.
Proof. simpl. reflexivity. Qed.

Definition succ (n : cnat) : cnat := fun (X : Type) (f : X -> X) (x : X) => f (n X f x).

Example succ_1 : succ zero = one.
Proof. simpl. reflexivity. Qed.


Example succ_2 : succ one = two.
Proof. simpl. reflexivity. Qed.

Example succ_3 : succ two = three.
Proof. simpl. reflexivity. Qed.

(** [] *)

(* Exercícios - Numerais de Church: Dado o tipo cnat que representa um numeral de Church,
   declare funções que executem as seguintes operações aritméticas sobre os números: *)

(* Adição: *)

Definition plus (n m : cnat) : cnat :=
  fun (X : Type) (f : X -> X) (x : X) => n X f (m X f x).

Example plus_1 : plus zero one = one.
Proof. 
  reflexivity.
Qed.

Example plus_2 : plus two three = plus three two.
Proof. 
  reflexivity.
Qed.

Example plus_3 :
  plus (plus two two) three = plus one (plus three three).
Proof. 
  reflexivity.
Qed.
 

Check plus.

(** [] *)


(** Multiplicação: *)
Definition mult (n m : cnat) : cnat :=
  fun (X : Type) (f :  X -> X) (x : X) => n X (m X f) x.
  

Example mult_1 : mult one one = one.
Proof. 
  simpl. reflexivity.
Qed.

Example mult_2 : mult zero (plus three three) = zero.
Proof. 
  simpl. reflexivity.
Qed.

Example mult_3 : mult two three = plus three three.
Proof.
  simpl. reflexivity.
Qed.


(** [] *)


(** Exponenciação: *)

(** Iterar sobre o tipo cnat pode ser complicado. Para declarar a exponenciação 
    será necessário aplicar a expressão lambda n como o parâmetro que representa o sucessor na
    expressão lambda m, por isso o tipo polimórfico passado para m deve ser (X->X). *)

Definition exp (n m : cnat) : cnat :=
  fun (X : Type) (f: X -> X) (x : X) =>  (m (X -> X) (n X)) f x.


Check exp.

Compute (exp two three). 

Compute (exp three two).

Compute (exp two (plus two two)).

Example exp_1 : exp two two = plus two two.
Proof. 
  reflexivity.
Qed.

Example exp_2 : exp three zero = one.
Proof.
  reflexivity.
Qed.

Example exp_3 : exp three two = plus (mult two (mult two two)) one.
Proof.
  reflexivity.
Qed.

(** [] *)

End Church.




