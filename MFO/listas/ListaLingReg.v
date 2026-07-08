(* Exercícios - Expressões Regulares *)
(* Não importar nenhuma biblioteca adicional *)


Require Export Coq.Init.Logic.
Require Import Coq.micromega.Lia.
Require Export Coq.Bool.Bool.
Require Export Coq.Lists.List.
Import ListNotations.


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


(* Exercício 1*)
(* Dica pode ser necessário o uso da tática [generalize dependent]. *)

Lemma reg_exp_of_list_spec : forall T (s1 s2 : list T),
  s1 =~ reg_exp_of_list s2 <-> s1 = s2.
Proof.
  intros T s1 s2. split.
  - intros H. generalize dependent s1. induction s2 as [| x s2' IH].
    + intros s1 H. inversion H. reflexivity.
    + intros s1 H. inversion H. inversion H3. subst. apply IH in H4. rewrite H4. simpl. reflexivity.
  - intros H. subst. induction s2 as [| h t IH].
    + simpl. apply MEmpty.
    + simpl. change (h :: t) with ([h] ++ t). apply MApp.
      * apply MChar.
      * apply IH. 
Qed.

Fixpoint re_not_empty {T : Type} (re : @reg_exp T) : bool :=
  match re with
    | EmptySet => false
    | EmptyStr => true
    | Char _ => true
    | App re1 re2 => andb (re_not_empty re1) (re_not_empty re2)
    | Union re1 re2 => orb (re_not_empty re1) (re_not_empty re2)
    | Star re1 => true
end.

Search "&&".

(* Exercício 2*)
Lemma re_not_empty_correct : forall T (re : @reg_exp T),
  (exists s, s =~ re) <-> re_not_empty re = true.
Proof.
  intros T re. split.
  - intros [s H]. induction H.
    + simpl. reflexivity.
    + simpl. reflexivity.
    + simpl. rewrite IHexp_match1. rewrite IHexp_match2. simpl. reflexivity.
    + simpl. rewrite IHexp_match. simpl. reflexivity.
    + simpl. apply orb_true_iff. right. apply IHexp_match.
    + simpl. reflexivity.
    + simpl. reflexivity.
  - intros H. induction re.
    + simpl in H. discriminate H.
    + exists []. apply MEmpty.
    + exists [t]. apply MChar.
    + simpl in H. apply andb_true_iff in H. destruct H as [H1 H2].
      apply IHre1 in H1. destruct H1 as [s1 Hm1].
      apply IHre2 in H2. destruct H2 as [s2 Hm2].
      exists (s1 ++ s2). apply MApp.
      apply Hm1. apply Hm2.
    + simpl in H. apply orb_true_iff in H. destruct H as [H1|H2].
      * apply IHre1 in H1. destruct H1 as [s1 H_match1].
        exists (s1). apply MUnionL. apply H_match1.
      * apply IHre2 in H2. destruct H2 as [s2 H_match2].
        exists (s2). apply MUnionR. apply H_match2.
    + exists []. apply MStar0.
Qed.

(* Exercício 3*)

(* Informalmente, o lema do bombeamento estabelece que qualquer cadeia s suficientemente 
   longa gerada por uma expressão regular re tem que ser bombeada, isto é, uma parte 
   intermediária de s é repetida um número arbitrário de vezes. A função pumping_constant 
   define o que é uma cadeia suficientemente longa para uma determinada expressão regular: *)

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

(* A função napp tem como objetivo repetir (bombear) a lista l (ou string) n vezes *)

Fixpoint napp {T} (n : nat) (l : list T) : list T :=
  match n with
  | 0 => []
  | S n' => l ++ napp n' l
  end.

(* Se uma lista (string) s é gerada por uma expressão regular re e s é suficientemente
   grande (pumping_constant re <= length s) então existem listas s1, s2 e s3, sendo s2 
   diferente de vazio, tal que s = s1 ++ s2^m ++ s3. *)   

(* Vários dos lemas sobre [le] que foram apresentados em um exercício opcional 
   anterior deste capítulo podem ser úteis. *)

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
  - (* MEmpty *)
    simpl. intros contra. inversion contra.

  - (* MChar *)
    simpl. intros contra. inversion contra. inversion H0.
  
  - (* MApp *)
    simpl. intros Hlen. 
    rewrite app_length in Hlen. 
    
    assert (H_ou : pumping_constant re1 <= length s1 \/ pumping_constant re2 <= length s2).
    { lia. }
    
    destruct H_ou as [Hlen1 | Hlen2].
    
    + (* A primeira metade (s1) pode ser bombeada *)
      apply IH1 in Hlen1. destruct Hlen1 as [s1_1 [s1_2 [s1_3 [Heq [Hneq Hpump]]]]].
      exists s1_1, s1_2, (s1_3 ++ s2).
      split. { rewrite Heq. rewrite <- app_assoc. rewrite <- app_assoc. reflexivity. }
      split. { apply Hneq. }
      intros m. rewrite app_assoc. rewrite app_assoc. apply MApp.
      * rewrite <- app_assoc. apply Hpump.
      * apply Hmatch2.
      
    + (* A segunda metade (s2) pode ser bombeada *)
      apply IH2 in Hlen2. destruct Hlen2 as [s2_1 [s2_2 [s2_3 [Heq [Hneq Hpump]]]]].
      exists (s1 ++ s2_1), s2_2, s2_3.
      split. { rewrite Heq. rewrite <- app_assoc. reflexivity. }
      split. { apply Hneq. }
      intros m. rewrite <- app_assoc. apply MApp.
      * apply Hmatch1.
      * apply Hpump.

   - (* MUnionL *)
    simpl. intros Hlen.
    assert (H_pc: pumping_constant re1 <= length s1). { lia. }
    apply IH in H_pc. destruct H_pc as [s1_1 [s1_2 [s1_3 [Heq [Hneq Hpump]]]]].
    exists s1_1, s1_2, s1_3.
    split. { apply Heq. }
    split. { apply Hneq. }
    intros m. apply MUnionL. apply Hpump.

  - (* MUnionR *)
    simpl. intros Hlen.
    assert (H_pc: pumping_constant re2 <= length s2). { lia. }
    apply IH in H_pc. destruct H_pc as [s2_1 [s2_2 [s2_3 [Heq [Hneq Hpump]]]]].
    exists s2_1, s2_2, s2_3.
    split. { apply Heq. }
    split. { apply Hneq. }
    intros m. apply MUnionR. apply Hpump.

  - (* MStar0 *)
    simpl. intros Hlen. 
    assert (H_verdade : 1 <= pumping_constant re).
    { induction re; simpl; lia. }
    lia.

  - (* MStarApp *)
    simpl. intros Hlen. rewrite app_length in Hlen.
    destruct s1 as [| x s1'].
    
    + (* Sub-caso: s1 é vazio *)
      simpl in Hlen. apply IH2 in Hlen.
      destruct Hlen as [s2_1 [s2_2 [s2_3 [Heq [Hneq Hpump]]]]].
      exists s2_1, s2_2, s2_3.
      split. { simpl. apply Heq. }
      split. { apply Hneq. }
      intros m. simpl. apply Hpump.
      
    + (* Sub-caso: s1 NÃO é vazio *)
      assert (H_napp_star : forall m, napp m (x :: s1') ++ s2 =~ Star re).
      { intros m. induction m as [| m' IHm'].
        - (* Caso m = 0: 0 repetições vira apenas s2 *)
          simpl. apply Hmatch2.
        - (* Caso m = S m': repete mais uma vez *)
          change ( ((x :: s1') ++ napp m' (x :: s1')) ++ s2 =~ Star re ).
          rewrite <- app_assoc. 
          apply MStarApp.
          * apply Hmatch1.
          * apply IHm'. }
      exists [], (x :: s1'), s2.
      split. { reflexivity. }
      split. { discriminate. }
      
      intros m. simpl. apply H_napp_star.

Qed.

