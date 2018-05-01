module Time.Loop where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Foldable (sequence_)

foreign import setAnimationFrameBehaviour 
  :: forall eff. (Eff eff) Unit -> (Eff eff) Unit

-- makeLoop 
--   :: forall e b c. Array (Int -> (Eff e Unit))
--   -> Int 
--   -> Eff e Unit
-- makeLoop fns n = do
--   -- This gets passes fns from Int to Eff but it won't execute those functions in JS!
--   _ <- pure $ fns <*> [n]
--   -- _ <- log $ show c
--   setAnimationFrameBehaviour (makeLoop fns (n+1))

-- How to make makeLoop to accept functions from Int to Eff
-- and just Effs...
-- Make a sum type of both cases and pattern match?

-- Why makeLoop cannot use log?
makeLoop :: forall e. Array (Eff e Unit) -> Int -> Eff e Unit
makeLoop effs t = do
  _ <- sequence_ effs
  -- _ <- log (show t)
  setAnimationFrameBehaviour $ makeLoop effs (t+1)
