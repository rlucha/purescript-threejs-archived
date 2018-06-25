module Timeline 
  ( create
  , Frame
  ) where
  
import Prelude

import Effect
import Effect.Class.Console as Console
import Data.Traversable (traverse_)
-- This doesn't scale, we cannot use it from the outside without passing the type
-- Maybe we do this fully polymorphic on efects?

foreign import setAnimationFrameBehaviour :: Effect Unit -> Effect Unit
foreign import unsafeGetGlobalValue :: String -> Effect Int

type Frame = Int

runBehaviours :: Frame -> Array (Frame -> Effect  Unit) -> Effect  Unit
runBehaviours fr bs = traverse_ (\b -> b fr) bs

-- nextFrame :: ∀ e. Frame -> Eff (console :: CONSOLE | e) Frame
-- nextFrame t = do
--   val <- unsafeGetGlobalValue "cFrame"
--   -- log $ "Current increment: " <> show val
--   pure $ val

nextFrame :: ∀ e. Frame -> Effect  Frame
nextFrame t = pure $ t + 1

-- Lift an effect to a row of effects
-- Export increment frame function to be used from the outside world
create :: ∀ e
   . Array (Frame -> Effect  Unit)
  -> Frame
  -> Effect  Unit
create bs fr = do 
    nfr <- nextFrame fr
    -- log $ "Current frame : " <> show nfr
    -- unsafeCoerceEff forces a closed eff row into an open one
    -- Moving to Effect, not needed anymore
    runBehaviours nfr bs
    setAnimationFrameBehaviour $ create bs nfr
