module Time.Loop where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Foldable (sequence_)
import Data.Traversable (traverse_)

foreign import setAnimationFrameBehaviour :: forall eff. (Eff eff) Unit -> (Eff eff) Unit

newtype Time = Time Int
-- recommendation to use newtype
-- newtype LoopCalculation = LoopCalculation (Time -> Number)
type LoopCalculation = Time -> Number
-- behaviours are not from time to behaviour but from calculation to Eff
-- one calculation can just be identity
-- Array of Number is just a very simple State temporariyl
type LoopBehaviour e = Array Number -> Eff e Unit
type LoopEffect e = Eff e Unit

runCalculations :: Array LoopCalculation -> Time -> Array Number 
runCalculations calcs t = calcs <*> [t]

runBehaviours :: forall e. Array Number -> Array (LoopBehaviour e) -> Eff e Unit
runBehaviours rs bs = traverse_ (\f -> f rs) bs

runEffects :: forall e. Array (LoopEffect e) -> Eff e Unit
runEffects effs = sequence_ effs

increaseTime :: Time -> Int -> Time
increaseTime (Time t) i = Time (t + i)

makeLoop 
  :: forall e. 
  Array LoopCalculation ->
  Array (LoopBehaviour e) ->
  Array (LoopEffect e) ->
  Time ->
  Eff e Unit
makeLoop cs bs effs t = do
  runBehaviours results bs
  runEffects effs
  setAnimationFrameBehaviour $ makeLoop cs bs effs inc
  where results = runCalculations cs t
        inc = increaseTime t 1


-- makeLoop will take eventually another param which is the results of traversing all the computations

-- comment from cvlad
-- Looks a lot like you're writing an interpreter, but in a quite explicit way. 
-- If you're not familiar with Free Monads, 
-- maybe it's worth watching @natefaubion’s excellent presentation (https://www.youtube.com/watch?v=eKkxmVFcd74) and playing with the idea. 
-- Perhaps even a look into `purescript-run` is worth it. (edited)

