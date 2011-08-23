Type TCursor Extends LTSprite
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		If MouseHit( 1 ) Then
			'DebugStop
			If Game.Selected Then Game.Selected.Remove( Null )
			If TileNum = TVisualizer.Empty Then
				If Not Game.Selected Then Return
				TMoveAlongPath.Create( Game.TileMapPathFinder.FindPath( Game.Selected.X, Game.Selected.Y, TileX, TileY ) )
			ElseIf TileNum <> TVisualizer.Void Then
				Game.Selected = TSelected.Create( TileX, TileY )
			End If
		ElseIf MouseHit( 2 ) And Game.Selected Then
			If Game.Selected Then Game.Selected.Remove( Null )
			If Abs( Game.Selected.X - TileX ) + Abs( Game.Selected.Y - TileY ) = 1 Then
				TMoveBall.Create( Game.Selected.X, Game.Selected.Y, TileX - Game.Selected.X, TileY - Game.Selected.Y )
				TMoveBall.Create( TileX, TileY, Game.Selected.X - TileX, Game.Selected.Y - TileY )
			End If
		End If
	End Method
End Type