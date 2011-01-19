Include "TGoomba.bmx"
Include "TKoopaTroopa.bmx"

Type LTMovingObject Extends LTSprite
	Field Gravity:Float
	
	
	
	Method HandleCollisionWith( Obj:LTActiveObject, CollisionType:Int )
		If LTEnemy( Obj ) Then
			If CollisionType = L_Left Or CollisionType = L_Right Then 
				SetDX( -GetDX() )
				Visualizer.XScale = -Visualizer.XScale
			End If
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		If CollisionType = L_Left Or CollisionType = L_Right Then 
			SetDX( -GetDX() )
			Visualizer.XScale = -Visualizer.XScale
		End If
	End Method
	
	
	
	Method Act()
		MoveForward()
	End Method
End Type