Type TMario Extends LTVectorSprite
Field OnLand:Int
	
    Method Init()
        AttachModel( THorizontalMovement.Create( Null, TMarioCollidedWithWall.Instance) )
		AttachModel( TVerticalMovement.Create( Null, TMarioCollidedWithFloor.Instance ) )
       AttachModel( New TGravity )
     AttachModel( New TMoving )
     AttachModel( New TJumping )
	End Method
   
   Method Act()
        OnLand = False
     Super.Act()
       
       LimitHorizontallyWith( Game.Level.Bounds )
       
       L_CurrentCamera.JumpTo( Self )
       L_CurrentCamera.LimitWith( Game.Level.Bounds )
   End Method
End Type



Type TMarioCollidedWithWall Extends LTSpriteAndTileCollisionHandler
	Global Instance:TMarioCollidedWithWall = New TMarioCollidedWithWall
	
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		Sprite.PushFromTile( TileMap, TileX, TileY )
	End Method
End Type



Type TMarioCollidedWithFloor Extends LTSpriteAndTileCollisionHandler
	Global Instance:TMarioCollidedWithFloor = New TMarioCollidedWithFloor
	
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		Instance.HandleCollision( Sprite, TileMap, TileX, TileY, CollisionSprite )
		Local Mario:TMario = TMario( Sprite )
		If Mario.DY >= 0 Then Mario.OnLand = True
		Mario.DY = 0
	End Method
End Type



Type TMoving Extends LTBehaviorModel
   Const Speed:Double = 5.0

   Method ApplyTo( Shape:LTShape )
       Local VectorSprite:LTVectorSprite = LTVectorSprite( Shape )
       VectorSprite.DX = 0
       If KeyDown( Key_Left ) Then VectorSprite.DX = -Speed
       If KeyDown( Key_Right ) Then VectorSprite.DX = Speed
   End Method
End Type



Type TJumping Extends LTBehaviorModel
   Const Strength:Double = -17.0

   Method ApplyTo( Shape:LTShape )
        Local Mario:TMario = TMario( Shape )
       If KeyDown( Key_A ) And Mario.OnLand Then Mario.DY = Strength
	End Method
End Type