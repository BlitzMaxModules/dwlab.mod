'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: This visualizer provides simple tile animation mechanism.
End Rem
Type LTAnimatedTileMapVisualizer Extends LTVisualizer
	Rem
	bbdoc: Array of destination tile indexes which will override real file indexes of tilemap.
	End Rem
	Field TileNum:Int[]
	
	
	
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, TileX:Int, TileY:Int )
		?debug
		L_TilesDisplayed :+ 1
		?
		
		Local Value:Int = TileNum[ TileMap.Value[ TileX, TileY ] ]
		If Value <> Tilemap.EmptyTile Then Drawimage( TileMap.TileSet.Image.BMaxImage, X, Y, Value )
	End Method
End Type