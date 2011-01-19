Type TMario Extends LTSprite
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
	End Method
	
	
	
	Method Act()
		If KeyDown( Key_Left ) Then
			Visualizer.XScale = -1.0
			SetDX( -Abs( GetDX() ) )
			Mario.MoveForward()
		End If
		If KeyDown( Key_Right ) Then
			Visualizer.XScale = 1.0
			SetDX( Abs( GetDX() ) )
			Mario.MoveForward()
		End If
	End Method
End Type