-- TODO avoid exposing Frame constructor maybe?
module Timeline 
  ( create
  , Frame(..)
  ) where
  
-- Exports create, a function that takes 
-- calculations
-- behaviours
-- and free effects
-- and calls them on each browser animation frame

import Prelude
import Control.Monad.Eff (Eff)
import Data.Foldable (sequence_)
import Data.Traversable (sequence, traverse_)

foreign import setAnimationFrameBehaviour :: ∀ eff. (Eff eff) Unit -> (Eff eff) Unit

-- behaviours are not from Frame to behaviour but from calculation to Eff
-- one calculation can just be identity
-- Array of Number is just a very simple State temporariyl

-- Array Number here should be CalculationsState or something
-- type LoopBehaviour e = Array Number -> Eff e Unit

-- newtype Results = Results {}

-- putResult :: {r :: Number} -> Results -> Results
-- putResult r rs = rs { r = r }

-- calculation :: Frame -> Symbol e -> Record { e :: Number }
-- calculation = _

-- Description of the problem
-- I need a function that takes Frame and returns a record of one label :: Number
-- So I need the type of all the functions that take Frame and return a Record of
-- any label and a value of type number
-- How to express "label"?
-- After that I need to modify a "collector Record" that will merge all the results
-- in itself to be passes around 

newtype Frame = Frame Int

-- Should I make all this newtypes?
type LoopCalculation = Frame -> Number
type LoopBehaviour e = Array Number -> Eff e Unit
type LoopEffect e = Eff e Unit

runCalculations :: Array LoopCalculation -> Frame -> Array Number 
runCalculations calcs t = calcs <*> [t]

runBehaviours :: ∀ e. Array Number -> Array (LoopBehaviour e) -> Eff e Unit
runBehaviours rs bs = traverse_ (\f -> f rs) bs

runEffects :: ∀ e. Array (LoopEffect e) -> Eff e Unit
runEffects effs = sequence_ effs

increaseFrame :: Frame -> Int -> Frame
increaseFrame (Frame t) i = Frame (t + i)

create :: ∀ e
   . Array LoopCalculation 
  -> Array (LoopBehaviour e) 
  -> Array (LoopEffect e) 
  -> Frame 
  -> Eff e Unit
create cs bs effs t = 
  let 
    results = runCalculations cs t
    inc = increaseFrame t 1 
  in do
    runBehaviours results bs
    runEffects effs
    setAnimationFrameBehaviour $ create cs bs effs inc
  
  -- comment from cvlad
  -- Looks a lot like you're writing an interpreter, but in a quite explicit way. 
  -- If you're not familiar with Free Monads, 
  -- maybe it's worth watching @natefaubion’s excellent presentation (https://www.youtube.com/watch?v=eKkxmVFcd74) and playing with the idea. 
  -- Perhaps even a look into `purescript-run` is worth it. (edited)

