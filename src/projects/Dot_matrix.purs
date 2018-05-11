module Projects.DotMatrix 
  (create, update, Project, getProjectObjects)
where

-- Todo Plane & Plane interpolation from 4 points (only 3 really needed)
-- Interpolate looks like an abstraction over n points
-- given 2 points, gives you a line, given 3+ gives you a surface

import Prelude
import Data.Array (fromFoldable)
import Data.Traversable (traverse, traverse_)
import Data.Int
-- Custom Algebra
import Point as P
import Line as L
import Square as SQ
import Transform as T
import Interpolate as Interpolate
import Scene as Scene

-- ThreePS bindings
import Three (createGeometry, createVector3, pushVertices, updateVector3Position, forcePointsUpdate)
import Three.Types (ThreeT, Points, Scene, Vector3)
import Three.Scene (addToScene)
import Three.Objects.Points (createPoints)
import Three.PointsMaterial (createPointsMaterial)

-- Time
import Time.Loop (Time)


size = 1200.0
steps = 80

center = P.create (-size * 0.25) 0.0 (-size * 0.25)

a :: P.Point
a = P.create 0.0 0.0 0.0

b :: P.Point
b = P.create size 0.0 0.0

c :: P.Point
c = P.create 0.0 0.0 size

d :: P.Point
d = P.create size 0.0 size

sq1 :: SQ.Square
sq1 = SQ.createFromLines (L.create a b) (L.create c d)

sq1c = T.translateSquare sq1 center

sq1Points :: Array P.Point
sq1Points = fromFoldable $ Interpolate.interpolate sq1c steps


-- Reader Scene (updatable scene, time bound)

newtype Project = Project
  { objects :: Points
  , vectors :: Array Vector3 }

getProjectObjects :: Project -> Points
getProjectObjects (Project r) = r.objects

getProjectVectors :: Project -> Array Vector3
getProjectVectors (Project r) = r.vectors

-- Things that can be created on init
-- geometry
-- materials
-- vector3s
-- points

-- update shoud take all those and update positions only
-- Should a scene have State?, that way we can easily mutate a
-- scene state in a performant way.

-- update :: Time -> Scene -> ThreeT Scene
-- update t s = do
  -- a means of parsing a scene into runnable elements
  -- a way to apply values to elements
  -- a way to use calculations and apply those to positions

update :: Project -> Number -> ThreeT Unit
update as t = 
  let vs = getProjectVectors as
      g = getProjectObjects as
      pos = t
  in traverse_ (updateVector3Position pos) vs *> forcePointsUpdate g

-- TODO scene type should be ThreeT Scene
create :: forall e. ThreeT Project
create = do
  g <- createGeometry
  m <- createPointsMaterial
  -- this scene 'unparsing' will be done at the scene graph parsing level
  -- eventually
  vs <- traverse Scene.createVectorFromPoint sq1Points
  -- here we are mutating g in JS... then using the reference in createPoints g
  -- should we express that effect somehow?
  _ <- traverse_ (pushVertices g) vs
  p <- createPoints g m
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