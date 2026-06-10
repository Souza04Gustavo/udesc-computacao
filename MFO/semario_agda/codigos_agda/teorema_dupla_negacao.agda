-- Definir o que são Booleanos e a função NOT
data Bool : Set where
    true  : Bool
    false : Bool

not : Bool → Bool
not true  = false
not false = true

-- Igualdade
data _≡_ {A : Set} (x : A) : A → Set where
    refl : x ≡ x

-- Teorema: not (not b) = b
not-not : (b : Bool) → not (not b) ≡ b
not-not true  = refl
not-not false = refl