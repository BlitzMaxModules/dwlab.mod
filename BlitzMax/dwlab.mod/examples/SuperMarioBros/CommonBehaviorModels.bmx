Type TGravity Extends LTBehaviorModel
	Global Instance:TGravity = New TGravity
	
   Method ApplyTo( Shape:LTShape )
       LTVectorSprite( Shape ).DY :+ Game.PerSecond( Game.Gravity )
   End Method
End Type



Type TCollisionWithWall Extends LTSpriteAndTileCollisionHandler
	Global Instance:TCollisionWithWall = New TCollisionWithWall
	
   Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
       Sprite.PushFromTile( TileMap, TileX, TileY )
       LTVectorSprite( Sprite ).DX :* -1
   End Method
End Type



Type TCollisionWithFloor Extends LTSpriteAndTileCollisionHandler
	Global Instance:TCollisionWithFloor = New TCollisionWithFloor
	
   Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
       Sprite.PushFromTile( TileMap, TileX, TileY )
       LTVectorSprite( Sprite ).DY = 0
   End Method
End Type



Type TSpritesHorizontalCollision Extends LTSpriteCollisionHandler
	Global Instance:TSpritesHorizontalCollision = New TSpritesHorizontalCollision
	
   Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
       Sprite1.PushFromSprite( Sprite2 )
       LTVectorSprite( Sprite1 ).DX :* -1
   End Method
End Type



Type TSpritesVerticalCollision Extends LTSpriteCollisionHandler
	Global Instance:TSpritesVerticalCollision = New TSpritesVerticalCollision
	
   Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
       Sprite1.PushFromSprite( Sprite2 )
   End Method
End Type