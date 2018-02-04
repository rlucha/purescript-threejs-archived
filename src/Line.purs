module Line where
import Prelude
import Point
import Data.Int (toNumber)
import Data.Array ((..), zip)
import Data.Tuple

type Steps = Int

interpolate :: Number -> Number -> Steps -> Array Number
interpolate a b s = 
  let inc = (b - a) / toNumber s
  in map (\x -> a + inc * toNumber x) $ 0..s -- \[x_n = x_i + \frac{x_f - x_i}{s} n\]

interpolateLine :: Point -> Point -> Steps -> Array Point
interpolateLine (Point a) (Point b) s =
  let ai = interpolate a.x b.x s
      bi = interpolate a.y b.y s
      ri = zip ai bi
    in map (\(Tuple a b) -> Point {x:a, y:b}) $ ri

-- map (\x -> toNumber x + 0.2) $ 0..10


-- data Line = Line (List Point)




-- -- interpolateLine :: Point -> Point -> Steps -> List Point
-- -- interpolateLine a b s = 