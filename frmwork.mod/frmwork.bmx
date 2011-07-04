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

ModuleInfo "History: v1.0.1 (04.07.11) Added sorting parameter to collision maps. Visualizer's DX and DY parameters are now image-relative."
ModuleInfo "History: v1.0.0.1 (30.06.11) Fixed bug of ChopFilename function under Mac."
ModuleInfo "History: v1.0 (28.06.11) Initial release"

ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

Import brl.random
Import brl.reflection
Import brl.retro
Import brl.map
Import brl.max2d

SeedRnd( MilliSecs() )

Const L_Version:String = "0.13.3"

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
Include "include/LTCollisionMap.bmx"
Include "include/LTLine.bmx"
Include "include/LTGraph.bmx"
Include "include/LTVisualizer.bmx"
Include "include/LTImageVisualizer.bmx"
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