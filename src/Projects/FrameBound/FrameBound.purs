module Projects.FrameBound
  -- (create, update)
where

-- import Prelude

-- import Data.Array as Array
-- import Projects.BaseProject as BaseProject
-- import Three as Three
-- import Three.Geometry.BoxGeometry as BoxGeometry
-- import Three.Materials.MeshPhongMaterial as MeshPhongMaterial
-- import Three.Object3D.Mesh as Object3D.Mesh
-- import Three.Types (Object3D, ThreeEff)

-- update = \_ -> "foo"

-- createBox :: ThreeEff Object3D
-- createBox = do
--   -- point <- Point.create 0.0 0.0 0.0
--   boxColor <- Three.createColor "0xff0000"
--   g <- BoxGeometry.create 10.0 10.0 10.0
--   m <- MeshPhongMaterial.create boxColor true
--   Object3D.Mesh.create g m

-- create :: ThreeEff BaseProject.Project
-- create = do
--   curves <- createBox
--   pure $ BaseProject.Project { objects: Array.concat [[curves]], vectors: [] }
