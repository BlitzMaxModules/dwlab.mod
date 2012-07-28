ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"
ModuleInfo "History: v1.0 (16.07.12)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."
import brl.blitz
import dwlab.frmwork
import dwlab.box2d
LTBox2DPhysics^brl.blitz.Object{
Objects:brl.linkedlist.TList&=mem:p("_dwlab_physics2d_LTBox2DPhysics_Objects")
Box2DWorld:dwlab.box2d.b2World&=mem:p("_dwlab_physics2d_LTBox2DPhysics_Box2DWorld")
-New%()="_dwlab_physics2d_LTBox2DPhysics_New"
-Delete%()="_dwlab_physics2d_LTBox2DPhysics_Delete"
-InitWorld%(World:dwlab.frmwork.LTLayer)="_dwlab_physics2d_LTBox2DPhysics_InitWorld"
-ProcessLayer%(Layer:dwlab.frmwork.LTLayer)="_dwlab_physics2d_LTBox2DPhysics_ProcessLayer"
}="dwlab_physics2d_LTBox2DPhysics"
LTBox2DSprite^dwlab.frmwork.LTVectorSprite{
Pivot1:dwlab.frmwork.LTSprite&=mem:p("_dwlab_physics2d_LTBox2DSprite_Pivot1")
Pivot2:dwlab.frmwork.LTSprite&=mem:p("_dwlab_physics2d_LTBox2DSprite_Pivot2")
Pivot3:dwlab.frmwork.LTSprite&=mem:p("_dwlab_physics2d_LTBox2DSprite_Pivot3")
CircleDefinition:dwlab.box2d.b2CircleDef&=mem:p("_dwlab_physics2d_LTBox2DSprite_CircleDefinition")
PolygonDefinition:dwlab.box2d.b2PolygonDef&=mem:p("_dwlab_physics2d_LTBox2DSprite_PolygonDefinition")
.Body:dwlab.box2d.b2Body&
.ListLink:brl.linkedlist.TLink&
-New%()="_dwlab_physics2d_LTBox2DSprite_New"
-Delete%()="_dwlab_physics2d_LTBox2DSprite_Delete"
-Init%()="_dwlab_physics2d_LTBox2DSprite_Init"
+PivotToVertex:dwlab.box2d.b2Vec2(Pivot:dwlab.frmwork.LTSprite)="_dwlab_physics2d_LTBox2DSprite_PivotToVertex"
-AttachToBody%(ShapeDefinition:dwlab.box2d.b2ShapeDef,Friction#,Density#,Restitution#)="_dwlab_physics2d_LTBox2DSprite_AttachToBody"
-SetCoords%(NewX!,NewY!)="_dwlab_physics2d_LTBox2DSprite_SetCoords"
-Update%()="_dwlab_physics2d_LTBox2DSprite_Update"
-Destroy%()="_dwlab_physics2d_LTBox2DSprite_Destroy"
}="dwlab_physics2d_LTBox2DSprite"
