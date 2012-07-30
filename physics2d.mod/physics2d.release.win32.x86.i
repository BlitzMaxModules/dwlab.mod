ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"
ModuleInfo "History: v1.0 (16.07.12)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."
import brl.blitz
import dwlab.frmwork
import dwlab.box2d
LTBox2DPhysics^Object{
Objects:TList&=mem:p("_dwlab_physics2d_LTBox2DPhysics_Objects")
Box2DWorld:b2World&=mem:p("_dwlab_physics2d_LTBox2DPhysics_Box2DWorld")
-New%()="_dwlab_physics2d_LTBox2DPhysics_New"
-Delete%()="_dwlab_physics2d_LTBox2DPhysics_Delete"
-InitWorld%(World:LTLayer)="_dwlab_physics2d_LTBox2DPhysics_InitWorld"
-ProcessLayer%(Layer:LTLayer)="_dwlab_physics2d_LTBox2DPhysics_ProcessLayer"
}="dwlab_physics2d_LTBox2DPhysics"
LTBox2DSprite^LTVectorSprite{
Pivot1:LTSprite&=mem:p("_dwlab_physics2d_LTBox2DSprite_Pivot1")
Pivot2:LTSprite&=mem:p("_dwlab_physics2d_LTBox2DSprite_Pivot2")
Pivot3:LTSprite&=mem:p("_dwlab_physics2d_LTBox2DSprite_Pivot3")
CircleDefinition:b2CircleDef&=mem:p("_dwlab_physics2d_LTBox2DSprite_CircleDefinition")
PolygonDefinition:b2PolygonDef&=mem:p("_dwlab_physics2d_LTBox2DSprite_PolygonDefinition")
.Body:b2Body&
.ListLink:TLink&
-New%()="_dwlab_physics2d_LTBox2DSprite_New"
-Delete%()="_dwlab_physics2d_LTBox2DSprite_Delete"
-Init%()="_dwlab_physics2d_LTBox2DSprite_Init"
+PivotToVertex:b2Vec2(Pivot:LTSprite)="_dwlab_physics2d_LTBox2DSprite_PivotToVertex"
-AttachToBody%(ShapeDefinition:b2ShapeDef,Friction#,Density#,Restitution#)="_dwlab_physics2d_LTBox2DSprite_AttachToBody"
-SetCoords%(NewX!,NewY!)="_dwlab_physics2d_LTBox2DSprite_SetCoords"
-Update%()="_dwlab_physics2d_LTBox2DSprite_Update"
-Destroy%()="_dwlab_physics2d_LTBox2DSprite_Destroy"
}="dwlab_physics2d_LTBox2DSprite"
