Require Export Coq.Init.Logic.
Require Export Coq.Bool.Bool.
Require Export Coq.Lists.List.
Import ListNotations.

(*Aluno: Elisandro Raizer da Cruz Junior*)
Inductive reg_exp (T : Type) : Type :=
  | EmptySet
  | EmptyStr
  | Char (t : T)
  | App (r1 r2 : reg_exp T)
  | Union (r1 r2 : reg_exp T)
  | Star (r : reg_exp T).

Arguments EmptySet {T}.
Arguments EmptyStr {T}.
Arguments Char {T} _.
Arguments App {T} _ _.
Arguments Union {T} _ _.
Arguments Star {T} _.

Reserved Notation "s =~ re" (at level 80).

Inductive exp_match {T} : list T -> reg_exp T -> Prop :=
  | MEmpty : [] =~ EmptyStr
  | MChar x : [x] =~ (Char x)
  | MApp s1 re1 s2 re2
             (H1 : s1 =~ re1)
             (H2 : s2 =~ re2)
           : (s1 ++ s2) =~ (App re1 re2)
  | MUnionL s1 re1 re2
                (H1 : s1 =~ re1)
              : s1 =~ (Union re1 re2)
  | MUnionR re1 s2 re2
                (H2 : s2 =~ re2)
              : s2 =~ (Union re1 re2)
  | MStar0 re : [] =~ (Star re)
  | MStarApp s1 s2 re
                 (H1 : s1 =~ re)
                 (H2 : s2 =~ (Star re))
               : (s1 ++ s2) =~ (Star re)

  where "s =~ re" := (exp_match s re).

Fixpoint reg_exp_of_list {T} (l : list T) :=
  match l with
  | [] => EmptyStr
  | x :: l' => App (Char x) (reg_exp_of_list l')
  end.

(* Exercício 1 *)
Lemma reg_exp_of_list_spec : forall T (s1 s2 : list T),
  s1 =~ reg_exp_of_list s2 <-> s1 = s2.
Proof.
  intros T s1 s2.
  revert s1. induction s2 as [| x s2' IH]; intros s1; split.
  - (* -> : case s2 = [] *)
    intros H. inversion H. reflexivity.
  - (* <- : case s2 = [] *)
    intros ->. apply MEmpty.
  - (* -> : s2 = x :: s2' *)
    simpl. intros H.
    (* s1 =~ App (Char x) (reg_exp_of_list s2') *)
    inversion H as [| | s1a re1 s1b re2 H1 H2 | | | | ]; subst.
    + (* impossible cases already eliminated by inversion *)
      discriminate.
    + (* the MApp case *)
      (* H1 : s1a =~ Char x  and H2: s1b =~ reg_exp_of_list s2' *)
      inversion H1; subst.
      * (* MChar: s1a = [x] *)
        specialize (IH s1b). rewrite <- IH in H2.
        inversion H2. (* H2 shows s1b = s2' by the IH *)
        subst. simpl. reflexivity.
      * discriminate.
  - (* <- : construct match from equality *)
    simpl. intros ->.
    apply MApp.
    + apply MChar.
    + apply IH. reflexivity.
Qed.

(* re_not_empty *)
Fixpoint re_not_empty {T : Type} (re : @reg_exp T) : bool :=
  match re with
    | EmptySet => false
    | EmptyStr => true
    | Char _ => true
    | App re1 re2 => andb (re_not_empty re1) (re_not_empty re2)
    | Union re1 re2 => orb (re_not_empty re1) (re_not_empty re2)
    | Star re1 => true
  end.

(* Exercício 2 *)
Lemma re_not_empty_correct : forall T (re : @reg_exp T),
  (exists s, s =~ re) <-> re_not_empty re = true.
Proof.
  intros T re. induction re; simpl.
  - (* EmptySet *)
    split.
    + intros [s H]. inversion H.
    + intros H. inversion H.
  - (* EmptyStr *)
    split.
    + intros _. exists []. apply MEmpty.
    + intros _. reflexivity.
  - (* Char *)
    split.
    + intros _. exists [t]. apply MChar.
    + intros _. reflexivity.
  - (* App *)
    split.
    + intros [s Hs]. inversion Hs; clear Hs; subst.
      (* We have s = s1 ++ s2, H1: s1 =~ re1, H2: s2 =~ re2 *)
      exists (s1 ++ s2). simpl. rewrite (andb_true_iff).
      split.
      * apply (proj1 (re_not_empty_correct _ _)). exists s1. apply H1.
      * apply (proj1 (re_not_empty_correct _ _)). exists s2. apply H2.
    + (* -> *) intros H.
      apply andb_true_iff in H. destruct H as [H1 H2].
      apply (proj2 (re_not_empty_correct _ re1)) in H1.
      apply (proj2 (re_not_empty_correct _ re2)) in H2.
      destruct H1 as [s1 Hs1].
      destruct H2 as [s2 Hs2].
      exists (s1 ++ s2). apply MApp; assumption.
  - (* Union *)
    split.
    + intros [s Hs]. inversion Hs; clear Hs; subst.
      * (* MUnionL *) apply orb_true_iff. left. apply (proj1 (re_not_empty_correct _ re1)). exists s1. apply H1.
      * (* MUnionR *) apply orb_true_iff. right. apply (proj1 (re_not_empty_correct _ re2)). exists s2. apply H2.
    + intros H. apply orb_true_iff in H. destruct H as [H1 | H2].
      * apply (proj2 (re_not_empty_correct _ re1)) in H1. destruct H1 as [s1 Hs1]. exists s1. apply MUnionL. apply Hs1.
      * apply (proj2 (re_not_empty_correct _ re2)) in H2. destruct H2 as [s2 Hs2]. exists s2. apply MUnionR. apply Hs2.
  - (* Star *)
    split.
    + intros _. exists []. apply MStar0.
    + intros _. reflexivity.
Qed.

(* Exercício 3: weak_pumping *)
Fixpoint pumping_constant {T} (re : reg_exp T) : nat :=
  match re with
  | EmptySet => 1
  | EmptyStr => 1
  | Char _ => 2
  | App re1 re2 =>
      pumping_constant re1 + pumping_constant re2
  | Union re1 re2 =>
      pumping_constant re1 + pumping_constant re2
  | Star r => pumping_constant r
  end.

Fixpoint napp {T} (n : nat) (l : list T) : list T :=
  match n with
  | 0 => []
  | S n' => l ++ napp n' l
  end.

Lemma weak_pumping : forall T (re : reg_exp T) s,
  s =~ re ->
  pumping_constant re <= length s ->
  exists s1 s2 s3,
    s = s1 ++ s2 ++ s3 /\
    s2 <> [] /\
    forall m, s1 ++ napp m s2 ++ s3 =~ re.
Proof.
  intros T re s Hmatch.
  induction Hmatch
    as [ | x | s1 re1 s2 re2 Hmatch1 IH1 Hmatch2 IH2
       | s1 re1 re2 Hmatch IH | re1 s2 re2 Hmatch IH
       | re | s1 s2 re Hmatch1 IH1 Hmatch2 IH2 ].
  - (* MEmpty *) simpl. intros L. inversion L.
  - (* MChar x *)
    simpl. intros Len.
    simpl in Len. (* pumping_constant (Char x) = 2 *)
    (* length [x] = 1, so 2 <= 1 impossible *)
    inversion Len.
  - (* MApp *)
    simpl. intros Len.
    (* pumping_constant (App re1 re2) = pc1 + pc2 *)
    remember (pumping_constant re1) as pc1.
    remember (pumping_constant re2) as pc2.
    assert (Hlen : pc1 + pc2 <= length (s1 ++ s2)) by assumption.
    clear Heqpc1 Heqpc2.
    (* Decide which side is long enough *)
    apply plus_le_iff in Hlen.
    destruct Hlen as [Hleft | Hright].
    + (* pc1 <= length s1 : pump in left part *)
      apply IH1 in Hleft; clear IH1.
      destruct Hleft as [a [b [c [Esplit [Bnonempty Pump]]]]].
      subst s1.
      exists a, b, (c ++ s2).
      split.
      * simpl. rewrite app_assoc. reflexivity.
      * split; [ assumption |].
        intros m.
        simpl.
        rewrite <- app_assoc.
        apply MApp.
        -- apply Pump.
        -- apply Hmatch2.
    + (* otherwise pc2 <= length s2 : pump in right part *)
      apply IH2 in Hright; clear IH2.
      destruct Hright as [a [b [c [Esplit [Bnonempty Pump]]]]].
      subst s2.
      exists (s1 ++ a), b, c.
      split.
      * simpl. rewrite <- app_assoc. reflexivity.
      * split; [ assumption |].
        intros m.
        simpl.
        rewrite app_assoc.
        apply MApp.
        -- apply Hmatch1.
        -- apply Pump.
  - (* MUnionL *)
    simpl. intros Len.
    (* If s1 =~ re1 and pumping_constant (Union re1 re2) = pc1 + pc2 <= length s1 *)
    (* Then pc1 <= length s1 or pc2 <= length s1. But we only need pc1 <= length s1 to use IH *)
    (* We note pc1 <= pc1+pc2 <= length s1, so pc1 <= length s1 *)
    assert (Hpc1 : pumping_constant re1 <= length s1).
    { apply Nat.le_trans with (m := pumping_constant re1 + pumping_constant re2).
      - apply Nat.le_add_l.
      - apply Len.
    }
    apply IH in Hpc1.
    destruct Hpc1 as [a [b [c [Esplit [Bnonempty Pump]]]]].
    exists a, b, c.
    split; [ assumption | split; [assumption |]].
    intros m. apply MUnionL. apply Pump.
  - (* MUnionR *)
    simpl. intros Len.
    assert (Hpc2 : pumping_constant re2 <= length s2).
    { apply Nat.le_trans with (m := pumping_constant re1 + pumping_constant re2).
      - apply Nat.le_add_r.
      - apply Len.
    }
    apply IH in Hpc2.
    destruct Hpc2 as [a [b [c [Esplit [Bnonempty Pump]]]]].
    exists a, b, c.
    split; [ assumption | split; [assumption |]].
    intros m. apply MUnionR. apply Pump.
  - (* MStar0 *)
    simpl. intros Len. (* pumping_constant (Star re) = pc <= length [] impossible unless pc = 0 but pc>=1 *)
    inversion Len.
  - (* MStarApp s1 s2 re *)
    simpl. intros Len.
    (* pumping_constant (Star r) = pc *)
    remember (pumping_constant re) as pc.
    clear Heqpc.
    (* s = s1 ++ s2, with s1 =~ re and s2 =~ Star re *)
    (* If pc <= length (s1 ++ s2) then either pc <= length s1 or pc <= length s2 *)
    assert (Htotal : length (s1 ++ s2) = length s1 + length s2) by apply app_length.
    rewrite Htotal in Len.
    apply Nat.le_add_cases in Len.
    destruct Len as [Hleft | Hright].
    + (* pc <= length s1: apply IH1 *)
      apply IH1 in Hleft.
      destruct Hleft as [a [b [c [Esplit [Bnonempty Pump]]]]].
      subst s1.
      exists a, b, (c ++ s2).
      split.
      * rewrite <- app_assoc. reflexivity.
      * split; [ assumption |].
        intros m.
        rewrite <- app_assoc.
        apply MStarApp.
        -- apply Pump.
        -- apply Hmatch2.
    + (* pc <= length s2: use IH2 on s2 which matches Star re *)
      (* For IH2 we need pumping_constant (Star re) <= length s2 but pumping_constant (Star re) = pc *)
      apply IH2 in Hright.
      (* IH2 produces a decomposition of s2 into a b c with properties *)
      destruct Hright as [a [b [c [Esplit [Bnonempty PumpStar]]]]].
      (* Now s = s1 ++ (a ++ b ++ c) *)
      exists (s1 ++ a), b, c.
      split.
      * simpl. rewrite <- app_assoc. reflexivity.
      * split; [ assumption |].
        intros m.
        rewrite <- app_assoc.
        apply MStarApp.
        -- apply Hmatch1.
        -- (* show (s1 ++ a) ++ napp m b ++ c =~ Star re *)
           (* We need to show the second component matches Star re: (a ++ napp m b ++ c) =~ Star re *)
           (* Use PumpStar to pump inside the star part repeatedly. We have for all n, a ++ napp n b ++ c =~ Star re *)
           apply PumpStar.
Qed.
