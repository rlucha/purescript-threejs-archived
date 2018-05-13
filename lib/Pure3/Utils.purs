module Pure3.Utils where

import Data.List (List(Nil), (:))

odds :: ∀ a. List a -> List a
odds Nil = Nil
odds (x:Nil) = (x:Nil)
odds (x:y:xs) = x : (odds xs)

evens :: ∀ a. List a -> List a
evens Nil = Nil
evens (x:Nil) = Nil
evens (x:y:xs) = y : (evens xs)
