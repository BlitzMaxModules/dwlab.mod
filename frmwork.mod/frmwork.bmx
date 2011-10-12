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

ModuleInfo "Version: 1.3.2"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

ModuleInfo "History: &nbsp; &nbsp; "
ModuleInfo "History: v1.3.2.1 (12.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed bug with adding multiple equal keys to button action."
ModuleInfo "History: v1.3.2 (07.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Added possibility to bind multiple buttons to the button action."
ModuleInfo "History: v1.3.1 (07.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Added SetSizeAs() method to the LTShape."
ModuleInfo "History: v1.3 (06.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Implemented controllers system."
ModuleInfo "History: &nbsp; &nbsp; Added Contour() and SetAsViewport() methods to the LTShape."
ModuleInfo "History: &nbsp; &nbsp; FindShapeWithParameter() parameters are rearranged."
ModuleInfo "History: v1.2.7 (03.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Added PrintText() method to the LTShape."
ModuleInfo "History: &nbsp; &nbsp; Fixed bug in LTCamera.SetCameraViewport() method."
ModuleInfo "History: v1.2.6 (02.10.11)"
ModuleInfo "History: &nbsp; &nbsp; LTSprite is merged with LTSprite and LTVectorSprite is cleaned of unuseful code."
ModuleInfo "History: v1.2.5 (29.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Added ApplyColor(), Lighten() and Darken() methods to the LTCamera."
ModuleInfo "History: v1.2.4.1 (26.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed bug of wrong displaying of non-scaled sprite."
ModuleInfo "History: v1.2.4 (22.09.11)"
ModuleInfo "History: &nbsp; &nbsp; LTRasterFrameVisualizer is deprecated, LTRasterFrame derived from LTImage created instead."
ModuleInfo "History: v1.2.3.1 (19.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed parameter cloning bug."
ModuleInfo "History: &nbsp; &nbsp; Fixed bug of Time variable of LTProject not initialized."
ModuleInfo "History: v1.2.3 (14.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Added possibility to search for shapes inside layers' sprite maps."
ModuleInfo "History: &nbsp; &nbsp; Added Range parameter to the pathfinder."
ModuleInfo "History: v1.2.2 (13.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Added ShowModels() debugging method to shape."
ModuleInfo "History: v1.2.1 (12.09.11)"
ModuleInfo "History: &nbsp; &nbsp; TileX and TileY which are passing to visualizer's DrawTile() method are now not wrapped (wrapped inside the method)."
ModuleInfo "History: &nbsp; &nbsp; Fixed bug in DebugVisualizer shape displaying."
ModuleInfo "History: v1.2 (11.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Added parameters list to the shapes."
ModuleInfo "History: &nbsp; &nbsp; Object Name parameter is deprecated."
ModuleInfo "History: &nbsp; &nbsp; Framework modules are structurized."
ModuleInfo "History: v1.1.5 (09.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Added FirstPosition() and LastPosition() methods to tilemap position class for path finding."
ModuleInfo "History: &nbsp; &nbsp; Added RemoveSame() method for LTBehaviorModel."
ModuleInfo "History: v1.1.4.1 (06.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed bug of displaying layers with another visualizer."
ModuleInfo "History: v1.1.4 (02.09.11)"
ModuleInfo "History: &nbsp; &nbsp; Added 'mixed' flag to layers."
ModuleInfo "History: &nbsp; &nbsp; Fixed glitches of tilemap pathfinder."
ModuleInfo "History: v1.1.3 (01.09.11)"
ModuleInfo "History: &nbsp; &nbsp; MoveTowards() method is moved to LTShape and have now Velocity parameter."
ModuleInfo "History: &nbsp; &nbsp; Added MoveTowardsPoint() method to LTShape."
ModuleInfo "History: v1.1.2 (31.08.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed bug of sprite map displaying by isometric camera."
ModuleInfo "History: &nbsp; &nbsp; Implemented sprite map loading within layer and cloning."
ModuleInfo "History: &nbsp; &nbsp; Added sprites list field to sprite map."
ModuleInfo "History: &nbsp; &nbsp; Fixed bugs of collision shapes displaying."
ModuleInfo "History: v1.1.1 (30.08.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed isometric objects displaying (now displaying image is tied to rectangle escribed circum object parallelogram)."
ModuleInfo "History: &nbsp; &nbsp; Fixed non-scaled objects displaying."
ModuleInfo "History: &nbsp; &nbsp; Tilemap displaying method now supports different tile displaying orders and displays wrapped tilemaps correctly."
ModuleInfo "History: &nbsp; &nbsp; Isomeric and orthogonal tilemap displaying methods are merged (note for custom tilemap visualizers)."
ModuleInfo "History: &nbsp; &nbsp; Added margins to the tile map."
ModuleInfo "History: v1.1 (28.08.11)"
ModuleInfo "History: &nbsp; &nbsp; Finished isometric camera implementation."
ModuleInfo "History: &nbsp; &nbsp; Implemented isometric shape displaying."
ModuleInfo "History: &nbsp; &nbsp; MoveUsingKeys() method now works correctly with isometric cameras."
ModuleInfo "History: &nbsp; &nbsp; Added class for tilemap pathfinding and raster frame visualizer."
ModuleInfo "History: v1.0.7 (26.08.11)"
ModuleInfo "History: &nbsp; &nbsp; Added isometric camera support to marching ants rectangle."
ModuleInfo "History: &nbsp; &nbsp; Added camera and incbin parametes to the world class."
ModuleInfo "History: v1.0.6 (24.08.11)"
ModuleInfo "History: &nbsp; &nbsp; Implemented incbin support."
ModuleInfo "History: v1.0.5 (03.08.11)"
ModuleInfo "History: &nbsp; &nbsp; Partially implemented isometric cameras."
ModuleInfo "History: &nbsp; &nbsp; Added camera saving/loading method."
ModuleInfo "History: &nbsp; &nbsp; Added pivot mode to sprite maps."
ModuleInfo "History: &nbsp; &nbsp; Added Flipping flag to the LTProject."
ModuleInfo "History: &nbsp; &nbsp; EmptyTile parameter was moved from LTTIleMap to LTTileSet."
ModuleInfo "History: v1.0.4.1 (01.08.11)"
ModuleInfo "History: &nbsp; &nbsp; Removed support for different axis magnification."
ModuleInfo "History: &nbsp; &nbsp; Added camera field into the LTWorld."
ModuleInfo "History: v1.0.4 (22.07.11)"
ModuleInfo "History: &nbsp; &nbsp; Added full support of Oval shape type (replaced Circle)."
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
Import brl.d3d9max2d
?Not win32
Import brl.glmax2d
?

Import brl.random
Import brl.reflection
Import brl.retro
Import brl.map
Import brl.max2d

Const L_Version:String = "1.3.2"

SeedRnd( MilliSecs() )

Include "include\LTObject.bmx"
Include "include\LTProject.bmx"
Include "include\LTShape.bmx"
Include "include\LTBehaviorModel.bmx"
Include "include\LTFont.bmx"
Include "include\Controllers.bmx"
Include "include\LTDrag.bmx"
Include "include\LTAction.bmx"
Include "include\XML.bmx"
Include "include\Service.bmx"





Function L_Error( Text:String )
  Notify( Text, True )
  DebugStop
  End
End Function




Global L_Incbin:String = ""

Function L_SetIncbin( Value:Int )
	If Value Then L_Incbin = "incbin::" Else L_Incbin = ""
End Function