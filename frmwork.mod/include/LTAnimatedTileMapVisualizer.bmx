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
	
	
	
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, Width:Double, Height:Double, TileX:Int, TileY:Int )
		Local TileSet:LTTileSet =Tilemap.TileSet
		Local TileValue:Int = TileNum[ TileMap.Value[ TileX, TileY ] ]
		If TileValue = TileSet.EmptyTile Then Return
		
		Local Image:TImage = TileSet.Image.BMaxImage
		If Not Image Then Return
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		
		Local Visualizer:LTVisualizer = TileMap.Visualizer
		SetScale( Width / ImageWidth( Image ), Height / ImageHeight( Image ) )
		
		DrawImage( Image, SX + Visualizer.DX * Width, SY + Visualizer.DY * Height, TileValue )
		
		?debug
		L_TilesDisplayed :+ 1
		?
	End Method
End Type