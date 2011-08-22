Type TCursor Extends LTSprite
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		If MouseHit( 1 ) Then
			If TileNum = TVisualizer.Empty Then
				
			ElseIf TileNum <> TVisualizer.Void Then
				If Game.Selected Then Game.Selected.RemoveModel( "TSelected" )
				Game.Selected = TSelected.Create( TileX, TileY )
			End If
		End If
	End Method
End Type