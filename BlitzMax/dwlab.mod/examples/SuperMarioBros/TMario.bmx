Type TMario Extends LTVectorSprite
	Global Collisions:Int
	
	Global Jumping:TJumping = New TJumping
	
	Global JumpingAnimation:LTAnimationModel = LTAnimationModel.Create( False, 1, 1, 4 )
	Global SlidingAnimation:LTAnimationModel = LTAnimationModel.Create( False, 1, 1, 5 )
	Global MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, 0.2, 1, 1 )
	Global StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, 1, 1, 0 )
   
    Method Init()
       AttachModel( LTHorizontalMovementModel.Instance )
       AttachModel( LTTileMapCollisionModel.Create( Game.Tilemap, TMarioCollidedWithWall.Instance ) )
       AttachModel( LTVerticalMovementModel.Instance )
       AttachModel( LTTileMapCollisionModel.Create( Game.Tilemap, TMarioCollidedWithFloor.Instance ) )
       AttachModel( TGravity.Instance )
       AttachModel( New TMoving )
	   AttachModel( Jumping )
	   
	   Local AnimationStack:LTModelStack = New LTModelStack
	   AttachModel( AnimationStack )
	   AnimationStack.Add( JumpingAnimation, False )
	   AnimationStack.Add( SlidingAnimation, False )
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
		LTVectorSprite( Sprite ).DX = 0
	End Method
End Type



Type TMarioCollidedWithFloor Extends LTSpriteAndTileCollisionHandler
	Global Instance:TMarioCollidedWithFloor = New TMarioCollidedWithFloor
	
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		Sprite.PushFromTile( TileMap, TileX, TileY )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
		If VectorSprite.DY >= 0 Then
			TMario.Jumping.ActivateModel( Sprite )
			TMario.JumpingAnimation.DeactivateModel( Sprite )
		End If
		VectorSprite.DY = 0
	End Method
End Type



Type TMoving Extends LTBehaviorModel
 Const Acceleration:Double = 20.0
   Const AnimationSpeed:Double = 1.5
   Const MaxWalkingSpeed:Double = 7.0
   Const MaxRunningSpeed:Double = 20.0
   Const Friction:Double = 40.0
   Const Speed:Double = 5.0
   
    Field Frame:Double
	
   Method ApplyTo( Shape:LTShape )
       Local VectorSprite:LTVectorSprite = LTVectorSprite( Shape )
        Local Direction:Double = Sgn( VectorSprite.DX )
       Local Force:Double = 0.0
       If KeyDown( Key_Left ) Then Force = -1.0
       If KeyDown( Key_Right ) Then Force = 1.0

	   TMario.SlidingAnimation.DeactivateModel( VectorSprite )
        If Force <> Direction And Direction Then
           Frame = 0.0
           If Force Then TMario.SlidingAnimation.ActivateModel( VectorSprite )
           If Abs( VectorSprite.DX ) < Game.PerSecond( Friction ) Then
               VectorSprite.DX = 0
           Else
               VectorSprite.DX :- Direction * Game.PerSecond( Friction )
           End If
       ElseIf Force Then
           Local MaxSpeed:Double = MaxWalkingSpeed
           If KeyDown( Key_S ) Then MaxSpeed = MaxRunningSpeed
           if Abs( VectorSprite.DX ) < MaxSpeed Then VectorSprite.DX :+ Force * Game.PerSecond( Acceleration )
           Frame :+ Game.PerSecond( VectorSprite.DX ) * AnimationSpeed
           TMario.MovementAnimation.FrameStart = Floor( Frame - Floor( Frame / 3.0 ) * 3.0 ) + 1
       End If
	   
	   If Force Then
			TMario.MovementAnimation.ActivateModel( Shape )
			VectorSprite.SetFacing( Force )
		Else
			TMario.MovementAnimation.DeactivateModel( Shape )
	   End If
   End Method
   
   Method Deactivate( Shape:LTShape )
       LTVectorSprite( Shape ).DX = 0.0
   End Method
End Type



Type TJumping Extends LTBehaviorModel
   Const Strength:Double = -17.0

   Method ApplyTo( Shape:LTShape )
		If KeyDown( Key_A ) Then
			LTVectorSprite( Shape ).DY = Strength
			TMario.JumpingAnimation.ActivateModel( Shape )
		End If
	End Method
End Type