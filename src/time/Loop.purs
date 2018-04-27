module Time.Loop where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

foreign import setAnimationFrameBehaviour 
  :: forall eff. (Eff eff) Unit -> (Eff eff) Unit

showInt :: forall e. Int -> Int
showInt n = n + 1

showIntMil :: forall e. Int -> Int
showIntMil n = n + 1000

showTimesTwo :: Int -> Int
showTimesTwo n = n * 2

makeLoop :: forall e b c. Array (Int -> Int) -> Int -> (Eff (console :: CONSOLE | e)) Unit
makeLoop fns n = do
  c <- pure $ fns <*> [n]
  _ <- log $ show c
  setAnimationFrameBehaviour $ makeLoop fns (n+1)

-- Parallel, non dependant executions and <<< dependant composition
initLoop :: forall e. Eff (console :: CONSOLE | e) Unit
initLoop = makeLoop [showInt, showTimesTwo <<< showIntMil] 0

