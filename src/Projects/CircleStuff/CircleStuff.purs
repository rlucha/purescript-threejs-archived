module Projects.CircleStuff 
  (create, update, Project, getProjectObjects)
where

-- Todo Plane & Plane interpolation from 4 points (only 3 really needed)
-- Interpolate looks like an abstraction over n points
-- given 2 points, gives you a line, given 3+ gives you a surface

import Prelude
import Data.Int (toNumber)
import Data.List (List, (..), concat)
import Data.Array (fromFoldable)
import Data.Traversable (traverse, traverse_)
import Math (cos, sin) as Math

import Pure3.Point as P
import Pure3.Line as L
import Pure3.Circle as C
import Pure3.Transform as T
import Pure3.Interpolate as Interpolate
import Pure3.Scene as Scene

import Three (createGeometry, forcePointsUpdate, pushVertices, updateVector3Position, getVector3Position)
import Three.Types (Points, ThreeEff, Vector3)
import Three.Objects.Points (createPoints) as Objects.Points
import Projects.Sealike.SeaMaterial (createSeaMaterial)

-- Project config, maybe move to Record
radius = 100.0    
steps = 120
amplitude = 0.005
speed = 6.0

centers :: List P.Point
centers = (\n -> P.create 0.0 0.0 (n*5.0)) <<< toNumber <$> -5..5

-- aoid using a lambda here using applicative? problem is radius is not in a context
circles :: List C.Circle
circles = (\c -> C.create c radius) <$> centers

sq1Points :: List P.Point 
sq1Points = concat $ (\c -> Interpolate.interpolate c steps) <$> circles

newtype Project = Project
  { objects :: Points
  , vectors :: List Vector3 }

getProjectObjects :: Project -> Points
getProjectObjects (Project r) = r.objects

getProjectVectors :: Project -> List Vector3
getProjectVectors (Project r) = r.vectors

-- Things that can be created on init
-- geometry
-- materials
-- vector3s
-- points

-- update shoud take all those and update positions only
-- Should a scene have State?, that way we can easily mutate a
-- scene state in a performant way.

updateVector :: Number -> Vector3 -> ThreeEff Unit
updateVector t v = do
  vpos <- getVector3Position v
  -- we need some initial position to use it as a reference point for
  -- incremental changes
  -- reader monad here?
  let delta = (vpos.x / vpos.y)
      waveOutX = vpos.x + (vpos.x * (Math.cos (t * speed)) * (amplitude * (vpos.z * 0.25) ))
      waveOutY = vpos.y + (vpos.y * (Math.sin (t * speed)) * (amplitude * (vpos.z * 0.25) ))
  updateVector3Position waveOutX waveOutY vpos.z v

update :: Project -> Number -> ThreeEff Unit
update p t = 
  let vs  = getProjectVectors p
      g   = getProjectObjects p
  in traverse_ (updateVector t) vs *> forcePointsUpdate g

create :: ThreeEff Project
create = do
  g <- createGeometry
  m <- createSeaMaterial
  -- this scene 'unparsing' will be done at the scene graph parsing level
  -- eventually
  vs <- traverse Scene.createVectorFromPoint sq1Points
  -- here we are mutating g in JS... then using the reference in createPoints g
  -- should we express that effect somehow? 
  _ <- traverse_ (pushVertices g) vs
  p <- Objects.Points.createPoints g m
  pure $ Project { objects: p, vectors: vs }

-- Explain why traverse works and pure fmap does not
-- traverse actually executes the effects , pure fmap does not...
-- traverese evaluates m b becase it needs to lift the value our of m to create t of m
-- fmap just needs to put b into f, without actually extracting the value
  -- _ <- traverse (pushVertices g) vs
  -- _ <- pure $ (pushVertices g) <$> vs


-- Scene now will use ThreeJS directly instead of just coordinate manipulation

-- var dotGeometry = new Geometry();
-- var dotMaterial = new PointsMaterial( { size: 1, sizeAttenuation: false } );    
-- dotGeometry.vertices.push(new Vector3(x, y, z));
-- var dot = new Points(dotGeometry, dotMaterial);
-- scene.add(dot)

-- Make Scene not require empty lines to be created
-- scene = Scene.create
--   { points: sq1Points
--   , lines: []
--   , squares: []
--   , meshes: []
--   }
