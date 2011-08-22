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