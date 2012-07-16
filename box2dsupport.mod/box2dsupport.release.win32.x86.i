ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"
ModuleInfo "History: v1.0 (16.07.12)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."
import brl.blitz
import dwlab.frmwork
import dwlab.box2d
LTBox2DSprite^LTVectorSprite{
.Body:b2Body&
.ListLink:TLink&
-New%()="_dwlab_box2dsupport_LTBox2DSprite_New"
-Delete%()="_dwlab_box2dsupport_LTBox2DSprite_Delete"
-Init%()="_dwlab_box2dsupport_LTBox2DSprite_Init"
-SetCoords%(NewX!,NewY!)="_dwlab_box2dsupport_LTBox2DSprite_SetCoords"
-Update%()="_dwlab_box2dsupport_LTBox2DSprite_Update"
-Destroy%()="_dwlab_box2dsupport_LTBox2DSprite_Destroy"
}="dwlab_box2dsupport_LTBox2DSprite"
Box2DObjects:TList&=mem:p("dwlab_box2dsupport_Box2DObjects")
