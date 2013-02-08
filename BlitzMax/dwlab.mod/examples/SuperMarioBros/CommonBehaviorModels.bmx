Type THorizontalMovement Extends LTBehaviorModel
	Field SpriteCollisionHandler:LTSpriteCollisionHandler
	Field TileCollisionHandler:LTSpriteAndTileCollisionHandler
	
	Function Create:THorizontalMovement( SpriteCollisionHandler:LTSpriteCollisionHandler, TileCollisionHandler:LTSpriteAndTileCollisionHandler )
		Local Movement:THorizontalMovement = New THorizontalMovement
		Movement.SpriteCollisionHandler = SpriteCollisionHandler
		Movement.TileCollisionHandler = TileCollisionHandler
		Return Movement
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( Sprite.DX, 0.0 )
		'If SpriteCollisionHandler Then Sprite.CollisionsWithSpriteMap( Game.MovingObjects, SpriteCollisionHandler )
		If TileCollisionHandler Then Sprite.CollisionsWithTilemap( Game.Tilemap, TileCollisionHandler )
	End Method
End Type



Type TVerticalMovement Extends LTBehaviorModel
	Field SpriteCollisionHandler:LTSpriteCollisionHandler
	Field TileCollisionHandler:LTSpriteAndTileCollisionHandler
	
	Function Create:TVerticalMovement( SpriteCollisionHandler:LTSpriteCollisionHandler, TileCollisionHandler:LTSpriteAndTileCollisionHandler )
		Local Movement:TVerticalMovement = New TVerticalMovement
		Movement.SpriteCollisionHandler = SpriteCollisionHandler
		Movement.TileCollisionHandler = TileCollisionHandler
		Return Movement
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( 0.0, Sprite.DY )
		'If SpriteCollisionHandler Then Sprite.CollisionsWithSpriteMap( Game.MovingObjects, SpriteCollisionHandler )
		If TileCollisionHandler Then Sprite.CollisionsWithTilemap( Game.Tilemap, TileCollisionHandler )
	End Method
End Type



Type TGravity Extends LTBehaviorModel
   Method ApplyTo( Shape:LTShape )
       LTVectorSprite( Shape ).DY :+ Game.PerSecond( Game.Gravity )
   End Method
End Type