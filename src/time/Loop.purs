module Time.Loop where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

foreign import setAnimationFrameBehaviour 
  :: forall eff. (Eff eff) Unit -> (Eff eff) Unit

makeLoop :: forall e b c. Array (Int -> Int) -> Int -> Eff (console :: CONSOLE | e) Unit
makeLoop fns n = do
  c <- pure $ fns <*> [n]
  _ <- log $ show c
  setAnimationFrameBehaviour $ makeLoop fns (n+1)
