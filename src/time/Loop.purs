module Time.Loop where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Foldable (sequence_)
import Data.Traversable (traverse)

foreign import setAnimationFrameBehaviour 
  :: forall eff. (Eff eff) Unit -> (Eff eff) Unit

type Time = Int 

data State = State { x :: Number }

-- recommendation to use newtype
-- newtype LoopCalculation = LoopCalculation (Time -> Number)
type LoopCalculation = Time -> Number
-- behaviours are not from time to behaviour but from calculation to Eff
-- one calculation can just be identity
-- Array of Number is just a very simple State temporariyl
type LoopBehaviour e = Array Number -> Eff e Unit
type LoopEffect e = Eff e Unit

makeLoop 
  :: forall e. 
  Array LoopCalculation ->
  Array (LoopBehaviour e) ->
  Array (LoopEffect e) ->
  -- State ->
  Time ->
  Eff e Unit

-- makeLoop calcs behs effs st t = do
makeLoop calcs behs effs t = do
  let results = calcs <*> [t] -- run calculations over time
  _ <- traverse (\f -> f results) behs  -- execute time bound effects
  sequence_ effs                  -- execute time free effects
  setAnimationFrameBehaviour $ makeLoop calcs behs effs (t+1) -- recurse

-- makeLoop will take eventually another param which is the results of traversing all the computations

-- comment from cvlad
-- Looks a lot like you're writing an interpreter, but in a quite explicit way. 
-- If you're not familiar with Free Monads, 
-- maybe it's worth watching @natefaubion’s excellent presentation (https://www.youtube.com/watch?v=eKkxmVFcd74) and playing with the idea. 
-- Perhaps even a look into `purescript-run` is worth it. (edited)