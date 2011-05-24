'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTAnimatedTileMapVisualizer Extends LTImageVisualizer
	Field TileNum:Int[]
	
	
	
	Method DrawTile( FrameMap:LTIntMap, X:Float, Y:Float, TileX:Int, TileY:Int )
		Local Value:Int = TileNum[ FrameMap.Value[ TileX, TileY ] ]
		If Value > 0 Then Drawimage( Image.BMaxImage, X, Y, Value )
	End Method
End Type