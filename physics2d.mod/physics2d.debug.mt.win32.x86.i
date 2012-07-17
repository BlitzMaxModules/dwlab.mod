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
World:b2World&=mem:p("_dwlab_physics2d_LTBox2DPhysics_World")
-New%()="_dwlab_physics2d_LTBox2DPhysics_New"
}="dwlab_physics2d_LTBox2DPhysics"
LTBox2DSprite^LTVectorSprite{
.Body:b2Body&
.ListLink:TLink&
-New%()="_dwlab_physics2d_LTBox2DSprite_New"
-Init%()="_dwlab_physics2d_LTBox2DSprite_Init"
-AttachShape%(Shape:b2Shape)="_dwlab_physics2d_LTBox2DSprite_AttachShape"
-SetCoords%(NewX!,NewY!)="_dwlab_physics2d_LTBox2DSprite_SetCoords"
-Update%()="_dwlab_physics2d_LTBox2DSprite_Update"
-Destroy%()="_dwlab_physics2d_LTBox2DSprite_Destroy"
}="dwlab_physics2d_LTBox2DSprite"
