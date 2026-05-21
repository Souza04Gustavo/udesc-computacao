
Require Export Coq.Lists.List.
Import ListNotations.

Theorem dist_not_exists : forall (X:Type) (P : X -> Prop),
  (forall x, P x) -> ~ (exists x, ~ P x).
Proof.
  unfold not. intros X P H1 H2. destruct H2 as [x Hx]. apply Hx. apply H1.
Qed.

Theorem dist_exists_or : forall (X:Type) (P Q : X -> Prop),
  (exists x, P x \/ Q x) <-> (exists x, P x) \/ (exists x, Q x).
Proof.
  intros X P Q. split. 
  - intros H. destruct H as [ x Hx]. destruct Hx as [HP | HQ].
    + left. exists x. apply HP.
    + right. exists x. apply HQ.
  - intros H. destruct H as [H1 | H2]. 
    + destruct H1 as [x Hx]. exists x. left. apply Hx.
    + destruct H2 as [x Hx]. exists x. right. apply Hx. 
Qed.

Theorem dist_exists_and : forall (X:Type) (P Q : X -> Prop),
  (exists x, P x /\ Q x) -> (exists x, P x) /\ (exists x, Q x).
Proof.
  intros X P Q H. destruct H as [x Hx]. destruct Hx as [HP HQ]. split.
  - exists x. apply HP.
  - exists x. apply HQ.
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
  intros A B f l x. induction l as [|x' l' IHl'].
  - intros H. simpl in H. destruct H.
  - intros H. simpl in H. destruct H as [Hx | Hi].
    + rewrite Hx. simpl. left. reflexivity.
    + apply IHl' in Hi. simpl. right. apply Hi. 
Qed. 

Lemma In_map_iff :
  forall (A B : Type) (f : A -> B) (l : list A) (y : B),
    In y (map f l) <->
    exists x, f x = y /\ In x l.
Proof.
  intros A B f l y. split.
  - intros H. induction l as [|x' l' IHl'].
    + simpl in H. destruct H.
    + simpl in H. destruct H as [H2 | H3].
      * exists x'. split. apply H2. simpl. left. reflexivity.
      * apply IHl' in H3. destruct H3 as [ x Hx]. exists x. split. apply Hx. 
        simpl. right. apply Hx.
  - intros H. destruct H as [x Hx]. destruct Hx as [H1 H2]. rewrite <- H1. 
    apply In_map. apply H2.
Qed.

Lemma In_app_iff : forall A l l' (a:A),
  In a (l++l') <-> In a l \/ In a l'.
Proof.
  intros A l l' a. split.
  - intros H. induction l as [| h t IHl].
    + simpl in H. right. apply H.
    + simpl in H. destruct H as [H2 | H3]. left. simpl. left. apply H2.
      apply IHl in H3. destruct H3 as [H4 | H5]. left. simpl. right. apply H4.
      right. apply H5.
  - intros H. induction l as [| h t IHl]. 
    + destruct H as [H1 | H2]. simpl in H1. destruct H1. simpl. apply H2.
    + simpl. simpl in H. destruct H as [H6 | H7]. destruct H6 as [H7 | H8].
      left. apply H7. right. apply IHl. left. apply H8.
      right. apply IHl. right. apply H7.
Qed.

Theorem excluded_middle_irrefutable: forall (P:Prop),
  ~ ~ (P \/ ~ P).
Proof.
  intros P. unfold not. intros H. apply H. right. intros HP. apply H. left. apply HP.
Qed.

Theorem disj_impl : forall (P Q: Prop),
 (~P \/ Q) -> P -> Q.
Proof.
   intros P Q H. unfold not in H. intros HP. destruct H as [Hx | HQ].
  - apply Hx in HP. destruct HP.
  - apply HQ.
Qed.


Theorem Peirce_double_negation: forall (P:Prop), (forall P Q: Prop,
  (((P->Q)->P)->P)) -> (~~ P -> P).
Proof.
  intros P X IH. unfold not in IH. specialize X with (Q := False). apply X. 
  intros H2. apply IH in H2. destruct H2.
Qed.

Theorem double_negation_excluded_middle : forall (P:Prop),
  (forall (P:Prop), (~~ P -> P)) -> (P \/ ~P). 
Proof.
  intros P DNE.
  apply DNE. 
  unfold not. intros H_contra.
  apply H_contra. right. intros HP.
  apply H_contra. left. apply HP.
Qed.
  
   








