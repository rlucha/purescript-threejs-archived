module Scene where

import Prelude
import Point as P
import Line  as L
import Square (Square(..)) as S
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Array (concat)

import Three (createVector3)
import Three.Types (ThreeT, Vector3)

type Mesh = Array P.Point

data Scene = Scene 
  { points :: Array P.Point
  , lines ::  Array L.Line
  , squares :: Array S.Square
  , meshes :: Array Mesh
}

derive instance genScene :: Generic Scene _
instance showScene :: Show Scene where show = genericShow

-- Transforms an scene to a list of points and lines...
-- Reduces squares to lines
-- In the future shapes could carry representation information to
-- decide which interpolation/transform function to use
-- so we could represent an square as a list of lines or as a list of points
-- maybe even both?

-- for now we will represent an square as a list of 4 lines
-- so we need to create lines from the points of an square

createVectorFromPoint :: P.Point -> ThreeT Vector3
createVectorFromPoint (P.Point {x, y, z}) = createVector3 x y z

squareToLines :: S.Square -> Array L.Line
squareToLines (S.Square {a,b,c,d}) = 
  let lab = L.create a b
      lbd = L.create b d
      ldc = L.create d c
      lca = L.create c a
  in [lab, lbd, ldc, lca]

-- create parses the squares to lines, this should be a row type I think
create :: 
  { points :: Array P.Point
  , lines :: Array L.Line
  , squares :: Array S.Square
  , meshes ::  Array Mesh } -> Scene

create scene = 
  let squares' = map squareToLines scene.squares 
  in 
    Scene 
    { points: scene.points
    , lines: scene.lines <> concat squares'
    , squares: []
    , meshes: scene.meshes
    }

-- This is not needed anymore...
-- unfoldScene :: Scene -> { points :: Array Point, lines :: Array Line }
-- unfoldScene (Scene s) = s