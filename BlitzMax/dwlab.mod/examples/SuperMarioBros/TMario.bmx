Type TMario Extends LTVectorSprite
	Global Collisions:Int
	
	Global Jumping:TJumping = New TJumping
	
	Global JumpingAnimation:LTAnimationModel = LTAnimationModel.Create( False, 1, 1, 4 )
	Global MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, 0.2, 3, 1 )
	Global StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, 1, 1, 0 )
	
    Method Init()
       AttachModel( New LTHorizontalMovementModel )
       AttachModel( LTTileMapCollisionModel.Create( Game.Tilemap, TMarioCollidedWithWall.Instance ) )
       AttachModel( New LTVerticalMovementModel )
       AttachModel( LTTileMapCollisionModel.Create( Game.Tilemap, TMarioCollidedWithFloor.Instance ) )
       AttachModel( New TGravity )
       AttachModel( New TMoving )
	   AttachModel( Jumping )
	   
	   Local AnimationStack:LTModelStack = New LTModelStack
	   AttachModel( AnimationStack )
	   AnimationStack.Add( JumpingAnimation, False )
	   AnimationStack.Add( MovementAnimation, False )
	   AnimationStack.Add( StandingAnimation )
	End Method
   
   Method Act()
		Jumping.DeactivateModel( Self )
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
		TMarioCollidedWithWall.Instance.HandleCollision( Sprite, TileMap, TileX, TileY, CollisionSprite )
		Local Mario:TMario = TMario( Sprite )
		If Mario.DY >= 0 Then
			TMario.Jumping.ActivateModel( Sprite )
			TMario.JumpingAnimation.DeactivateModel( Sprite )
		End If
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
	   If VectorSprite.DX Then
			TMario.MovementAnimation.ActivateModel( Shape )
		Else
			TMario.MovementAnimation.DeactivateModel( Shape )
	   End If
   End Method
End Type



Type TJumping Extends LTBehaviorModel
   Const Strength:Double = -17.0

   Method ApplyTo( Shape:LTShape )
		If KeyDown( Key_A ) Then
			LTVectorSprite( Shape ).DY = Strength
			TMario( Shape ).JumpingAnimation.ActivateModel( Shape )
		End If
	End Method
End Type