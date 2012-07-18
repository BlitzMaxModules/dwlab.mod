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
-Delete%()="_dwlab_physics2d_LTBox2DPhysics_Delete"
}="dwlab_physics2d_LTBox2DPhysics"
