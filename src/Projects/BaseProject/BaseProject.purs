module Projects.BaseProject where

import Prelude  
import Pure3.Point as P
import Three (createVector3)
import Three.Types (Object3D, Object3D_, ThreeEff, Vector3)
import Three.Object3D (unwrap) as Object3D

newtype Project = Project
  { objects :: Array Object3D
  , vectors :: Array Vector3 }

getProjectObjects :: Project -> Array Object3D
getProjectObjects (Project r) = r.objects

getProjectVectors :: Project -> Array Vector3
getProjectVectors (Project r) = r.vectors

exportProjectObjects :: Project -> Array Object3D_
exportProjectObjects (Project r) = Object3D.unwrap <$> r.objects

createVectorFromPoint :: P.Point -> ThreeEff Vector3
createVectorFromPoint (P.Point {x, y, z}) = createVector3 x y z
