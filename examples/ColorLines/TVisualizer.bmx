'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TVisualizer Extends LTVisualizer
	Const Empty:Int = 0
	Const Void:Int = 8

	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, TileX:Int, TileY:Int )
		?debug
		L_TilesDisplayed :+ 1
		?
		
		Local Value:Int = TileMap.Value[ TileX, TileY ]
		Local TileSet:LTTileSet =Tilemap.TileSet 
		If Value <> Void Then
			Drawimage( TileSet.Image.BMaxImage, X, Y, Empty )
			If Value <> Empty Then Drawimage( TileSet.Image.BMaxImage, X, Y, Value )
		End If
	End Method
End Type