Require Export Coq.Lists.List.
Import ListNotations.

(*Aluno: Elisandro Raizer da Cruz Junior*)

Theorem dist_not_exists :
  forall (X:Type) (P : X -> Prop),
    (forall x, P x) -> ~ (exists x, ~ P x).
Proof.
  intros X P H all.
  destruct all as [x Px].
  specialize (H x).
  contradiction.
Qed.

Theorem dist_exists_or :
  forall (X:Type) (P Q : X -> Prop),
  (exists x, P x \/ Q x) <-> (exists x, P x) \/ (exists x, Q x).
Proof.
  intros X P Q; split.
  - intros [x [HP | HQ]].
    + left; exists x; exact HP.
    + right; exists x; exact HQ.
  - intros [[x HP] | [x HQ]].
    + exists x; left; exact HP.
    + exists x; right; exact HQ.
Qed.

Theorem dist_exists_and :
  forall (X:Type) (P Q : X -> Prop),
    (exists x, P x /\ Q x) ->
    (exists x, P x) /\ (exists x, Q x).
Proof.
  intros X P Q [x [HP HQ]].
  split; now exists x.
Qed.

Fixpoint In {A : Type} (x : A) (l : list A) : Prop :=
  match l with
  | [] => False
  | x' :: l' => x' = x \/ In x l'
  end.

Lemma In_map :
  forall (A B : Type) (f : A -> B) (l : list A) (x : A),
    In x l ->
    In (f x) (map f l).
Proof.
  intros A B f l x H; induction l as [|h t IH]; simpl in *.
  - contradiction.
  - destruct H as [Hx | Ht].
    + subst; now left.
    + right; apply IH; exact Ht.
Qed.

Lemma In_map_iff :
  forall (A B : Type) (f : A -> B) (l : list A) (y : B),
    In y (map f l) <->
    exists x, f x = y /\ In x l.
Proof.
  intros A B f l y; split.
  - induction l as [|h t IH]; simpl.
    + intros H; contradiction.
    + intros [Hy | Ht].
      * exists h; split; auto; left; reflexivity.
      * apply IH in Ht as [x [H1 H2]].
        exists x; split; auto; right; exact H2.
  - intros [x [Hf Hin]].
    apply In_map; assumption.
Qed.

Lemma In_app_iff : forall A l l' (a:A),
  In a (l ++ l') <-> In a l \/ In a l'.
Proof.
  intros A l; induction l as [|h t IH]; intros l' a; simpl.
  - split.
    + intros H; right; exact H.
    + intros [H|H]; [contradiction|exact H].
  - split.
    + intros [Ha | Ht].
      * left; left; exact Ha.
      * apply IH in Ht as [H1 | H2].
        -- left; right; exact H1.
        -- right; exact H2.
    + intros [[Hh | Ht] | Hl'].
      * left; exact Hh.
      * right; apply IH; left; exact Ht.
      * right; apply IH; right; exact Hl'.
Qed.

Theorem excluded_middle_irrefutable :
  forall (P:Prop),
    ~ ~ (P \/ ~ P).
Proof.
  intros P H.
  apply H.
  right; intro HP.
  apply H.
  left; exact HP.
Qed.

Theorem disj_impl : forall (P Q: Prop),
 (~P \/ Q) -> P -> Q.
Proof.
  intros P Q H HP.
  destruct H as [HnP | HQ].
  - contradiction.
  - exact HQ.
Qed.

Theorem Peirce_double_negation :
  forall (P:Prop),
    (forall P Q: Prop, (((P->Q)->P)->P)) ->
    (~~ P -> P).
Proof.
  intros P Peirce H.
  apply Peirce with (Q := False).
  intro HPQ.
  exfalso.
  apply H.
  intro HP.
  apply HPQ.
  intro _.
  exact HP.
Qed.

Theorem double_negation_excluded_middle :
  forall (P:Prop),
    (forall P:Prop, ~~ P -> P) ->
    (P \/ ~P).
Proof.
  intros P DN.
  apply DN.
  intro H.
  apply H.
  right.
  intro HP.
  apply H.
  left; exact HP.
Qed.
