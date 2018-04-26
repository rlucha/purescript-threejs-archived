module Time.Loop where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

type Time = Number

-- requestAnimationFrame returns an Effectfull computation of type and return a Unit
foreign import setAnimationFrameBehaviour :: forall eff b c. (b -> c) -> (Eff eff) Unit

showNumber :: forall e. Time -> Eff (console :: CONSOLE | e) Unit
showNumber n = log (show n)

showFoo :: forall e. Time -> Eff (console :: CONSOLE | e) Unit
showFoo n = log "Foo"

negateTime :: Time -> Time
negateTime t = t * 0.0

mainLoop :: forall eff. Array (Time -> Eff eff Unit) -> Time -> Array ((Eff eff) Unit)
mainLoop flist n = map (\f -> f n) flist

initLoop :: forall eff. Array (Time -> (Eff eff) Unit) -> Eff eff Unit
initLoop flist = setAnimationFrameBehaviour $ mainLoop flist


-- main :: forall a. Eff a Unit
-- main = setAnimationFrameBehaviour $ mainLoop flist
--   where flist = [showNumber <<< negateTime, showFoo] 

-- TODO use it as a library (needs some kind of mutable reference to hold all returned values ... maybe?)