Include "TMario.bmx"
Include "TGoomba.bmx"
Include "TKoopaTroopa.bmx"
Include "TMushroom.bmx"

Type LTMovingObject Extends LTSprite
	Field DX:Float, DY:Float
	
	
	
	Method HandleCollisionWith( Obj:LTShape, CollisionType:Int )
		DX = -DX
		Visualizer.XScale = -Visualizer.XScale
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		If CollisionType = L_Left Or CollisionType = L_Right Then 
			DX = -DX
			Visualizer.XScale = -Visualizer.XScale
		Else
			DY = 0.0
		End If
	End Method
	
	
	
	Method Act()
		Move( DX, 0.0 )
		DY :+ L_DeltaTime * 32.0
	End Method
End Type