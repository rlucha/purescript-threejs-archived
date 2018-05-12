module Projects.DotMatrix 
  (create, update, Project, getProjectObjects)
where

-- Todo Plane & Plane interpolation from 4 points (only 3 really needed)
-- Interpolate looks like an abstraction over n points
-- given 2 points, gives you a line, given 3+ gives you a surface

import Prelude
import Data.Array (fromFoldable)
import Data.Traversable (traverse, traverse_)

import Pure3.Point as P
import Pure3.Line as L
import Pure3.Square as SQ
import Pure3.Transform as T
import Pure3.Interpolate as Interpolate
import Pure3.Scene as Scene

import Three (createGeometry, forcePointsUpdate, pushVertices, updateVector3Position)
import Three.Types (Points, ThreeT, Vector3)
import Three.Objects.Points (createPoints)
import Three.Materials.PointsMaterial (createPointsMaterial)

size :: Number
size = 1200.0
steps :: Int
steps = 80

center :: P.Point
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

sq1c :: SQ.Square
sq1c = T.translateSquare sq1 center

sq1Points :: Array P.Point
sq1Points = fromFoldable $ Interpolate.interpolate sq1c steps

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

update :: Project -> Number -> ThreeT Unit
update p t = 
  let vs = getProjectVectors p
      g = getProjectObjects p
      pos = t
  in traverse_ (updateVector3Position pos) vs *> forcePointsUpdate g

create :: ThreeT Project
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