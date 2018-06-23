module Projects.FrameBound.Projection where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Except (runExcept)
import Data.Array (concat)
import Data.Either (Either(..))
import Data.Foldable (maximum, minimum)
import Data.Foreign (ForeignError)
import Data.Foreign.Generic (decodeJSON)
import Data.List.Types (NonEmptyList)
import Data.Maybe (fromMaybe)
import Data.Newtype (unwrap)
import Projects.FrameBound.MapLoader as MapLoader
import Projects.FrameBound.Types (Building(..), Coords(..), unBuilding)

calculateProjection :: Array Building -> {x :: Number, z :: Number} -- Use Point
calculateProjection buildings = 
  let buildings' = concat (unBuilding <$> buildings)
      xs = _.x <$> buildings'
      zs = _.z <$> buildings'
      maxX = fromMaybe 0.0 (maximum xs)
      maxZ = fromMaybe 0.0 (maximum zs)
      minX = fromMaybe 0.0 (minimum xs)
      minZ = fromMaybe 0.0 (minimum zs)
      center = {x: (maxX + minX) / 2.0, z: (maxZ + minZ) / 2.0}
      -- scale = fromMaybe 0.0 $ maxX <> maxZ
  in center

doBuildings 
  :: forall e
  .  (Either (NonEmptyList ForeignError) (Array Building)) 
  -> Array Building
doBuildings b = case b of 
  Right f -> f
  -- Do not return a fake Building on error, handle upwards
  Left _ -> [Building { coordinates: [Coords {x: 0.0, y:0.0, z:0.0}]}]

loadBuildingsData 
  :: forall e.
  Eff (| e) 
    (Either 
      (NonEmptyList ForeignError) 
      (Array Building))
loadBuildingsData = do
  map <- MapLoader.loadMap
  pure $ runExcept (decodeJSON map :: _ (Array Building))

test :: ∀ e. Eff (|e) {x :: Number, z :: Number}
test = do
  buildingsData <- loadBuildingsData
  let buildings =  doBuildings buildingsData
  pure $ calculateProjection buildings 