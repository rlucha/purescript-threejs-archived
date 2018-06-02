module Timeline 
  ( create
  , Frame
  ) where
  
import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Unsafe (unsafeCoerceEff)
import DOM (DOM)
import Data.Traversable (traverse_)
import Three.Types (THREE)
-- This doesn't scale, we cannot use it from the outside without passing the type
-- Maybe we do this fully polymorphic on efects?
type MainEff a = ∀ e. Eff (three :: THREE, dom :: DOM, console :: CONSOLE | e) a

foreign import setAnimationFrameBehaviour :: ∀ e. (Eff e) Unit -> Eff e Unit
foreign import unsafeGetGlobalValue :: ∀ e. String -> Eff e Int

type Frame = Int

runBehaviours :: ∀ e. Frame -> Array (Frame -> Eff e Unit) -> Eff e Unit
runBehaviours fr bs = traverse_ (\b -> b fr) bs

-- nextFrame :: ∀ e. Frame -> Eff (console :: CONSOLE | e) Frame
-- nextFrame t = do
--   val <- unsafeGetGlobalValue "cFrame"
--   -- log $ "Current increment: " <> show val
--   pure $ val

nextFrame :: ∀ e. Frame -> Eff (console :: CONSOLE | e) Frame
nextFrame t = pure $ t + 1

-- Lift an effect to a row of effects
-- Export increment frame function to be used from the outside world
create :: ∀ e
   . Array (Frame -> Eff e Unit)
  -> Frame
  -> MainEff Unit
create bs fr = do 
    nfr <- nextFrame fr
    -- log $ "Current frame : " <> show nfr
    -- unsafeCoerceEff forces a closed eff row into an open one
    unsafeCoerceEff $ runBehaviours nfr bs
    setAnimationFrameBehaviour $ create bs nfr
