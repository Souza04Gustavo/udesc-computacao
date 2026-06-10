-- Números Naturais (ℕ)
data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

-- Soma (+) e sua precedência
infixl 6 _+_
_+_ : ℕ → ℕ → ℕ
zero + m = m
suc n + m = suc (n + m)

-- Igualdade (≡) e sua precedência
infix 4 _≡_
data _≡_ {A : Set} (x : A) : A → Set where
  refl : x ≡ x

-- Congruência (se x = y, então f(x) = f(y))
cong : {A B : Set} (f : A → B) {x y : A} → x ≡ y → f x ≡ f y
cong f refl = refl

-- Prova de n + 0 = n
+-identityʳ : ∀ (n : ℕ) → n + zero ≡ n
+-identityʳ zero = refl
+-identityʳ (suc n) = cong suc (+-identityʳ n)