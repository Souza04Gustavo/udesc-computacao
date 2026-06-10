data ℕ : Set where
    zero : ℕ
    suc  : ℕ → ℕ

data Vec (A : Set) : ℕ → Set where
    []  : Vec A zero
    _∷_ : {n : ℕ} → A → Vec A n → Vec A (suc n)

head : {A : Set} {n : ℕ} → Vec A (suc n) → A
head (x ∷ xs) = x













