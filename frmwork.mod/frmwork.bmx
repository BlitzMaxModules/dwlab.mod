'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Rem
bbdoc: Digital Wizard's Lab Framework
End Rem
Module dwlab.frmwork

ModuleInfo "Version: 1.0.3"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

ModuleInfo "History: &nbsp; &nbsp; "
ModuleInfo "History: v1.0.3.1 (19.07.11)"
ModuleInfo "History: &nbsp; &nbsp; Removed multiple collision reactions when executing CollisionsWithSpriteMap method."
ModuleInfo "History: v1.0.3 (18.07.11)"
ModuleInfo "History: &nbsp; &nbsp; Added Parallax() function."
ModuleInfo "History: &nbsp; &nbsp; Added sprite map clearing method."
ModuleInfo "History: &nbsp; &nbsp; Fixed bug in LTDoubleMap.ToNewImage() method."
ModuleInfo "History: v1.0.2.1 (07.07.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed bug of visualizer's DX/DY not saving/loading."
ModuleInfo "History: v1.0.2 (06.07.11)"
ModuleInfo "History: &nbsp; &nbsp; CollisionsWithSpriteMap() method now have Map parameter to add collided sprites to."
ModuleInfo "History: &nbsp; &nbsp; Added visualizer cloning method."
ModuleInfo "History: &nbsp; &nbsp; ImageVisualizer is merged with Visualizer."
ModuleInfo "History: &nbsp; &nbsp; Fixed bug in SetSize (old method cleared collision map)."
ModuleInfo "History: &nbsp; &nbsp; Collision maps are renamed to sprite maps."
ModuleInfo "History: &nbsp; &nbsp; Added sprite maps saving/loading method."
ModuleInfo "History: &nbsp; &nbsp; Added GetSprites() method."
ModuleInfo "History: v1.0.1.1 (05.07.11)"
ModuleInfo "History: &nbsp; &nbsp; ShowDebugInfo() method is now without parameters."
ModuleInfo "History: &nbsp; &nbsp; MoveUsingKeys() methods are now in LTShape and have velocity parameter."
ModuleInfo "History: &nbsp; &nbsp; Max2D drivers import is now inside framework."
ModuleInfo "History: v1.0.1 (04.07.11)"
ModuleInfo "History: &nbsp; &nbsp; Added sorting parameter to collision maps."
ModuleInfo "History: &nbsp; &nbsp; Border parameter of collision map is turned to 4 margin parameters."
ModuleInfo "History: &nbsp; &nbsp; Now setting all collision map margins to one value is possible by using SetBorder() method."
ModuleInfo "History: &nbsp; &nbsp; Visualizer's DX and DY parameters are now image-relative."
ModuleInfo "History: v1.0.0.1 (30.06.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed bug of ChopFilename() function under Mac."
ModuleInfo "History: v1.0 (28.06.11)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."

?win32
Import brl.d3d7max2d
?linux
Import brl.glmax2d
?macos
Import brl.glmax2d
?

Import brl.random
Import brl.reflection
Import brl.retro
Import brl.map
Import brl.max2d

Const L_Version:String = "1.0.3"

SeedRnd( MilliSecs() )

Include "include/LTObject.bmx"
Include "include/LTProject.bmx"
Include "include/LTShape.bmx"
Include "include/LTGroup.bmx"
Include "include/LTLayer.bmx"
Include "include/LTWorld.bmx"
Include "include/LTSprite.bmx"
Include "include/LTAngularSprite.bmx"
Include "include/LTVectorSprite.bmx"
Include "include/LTCamera.bmx"
Include "include/Collisions.bmx"
Include "include/Physics.bmx"
Include "include/LTMap.bmx"
Include "include/LTIntMap.bmx"
Include "include/LTTileMap.bmx"
Include "include/LTTileSet.bmx"
Include "include/LTDoubleMap.bmx"
Include "include/LTSpriteMap.bmx"
Include "include/LTLine.bmx"
Include "include/LTGraph.bmx"
Include "include/LTVisualizer.bmx"
Include "include/LTImage.bmx"
Include "include/LTAnimatedTileMapVisualizer.bmx"
Include "include/LTEmptyPrimitive.bmx"
Include "include/LTMarchingAnts.bmx"
Include "include/LTWindowedVisualizer.bmx"
Include "include/LTDebugVisualizer.bmx"
Include "include/LTBehaviorModel.bmx"
Include "include/LTFixedJoint.bmx"
Include "include/LTRevoluteJoint.bmx"
Include "include/LTAlign.bmx"
Include "include/LTText.bmx"
Include "include/LTPath.bmx"
Include "include/LTDrag.bmx"
Include "include/LTAction.bmx"
Include "include/LTPause.bmx"
Include "include/XML.bmx"
Include "include/Service.bmx"





Function L_Error( Text:String )
  Notify( Text, True )
  DebugStop
  End
End Function