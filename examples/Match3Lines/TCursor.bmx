Type TCursor Extends LTSprite
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		If TileNum = TVisualizer.Empty Then
		ElseIf TileNum <> TVisualizer.Void Then
			If Game.Selected Then
				Game.Selected.Deactivate( Game.Selected.Sprite )
			End If
		End If
	End Method
End Type