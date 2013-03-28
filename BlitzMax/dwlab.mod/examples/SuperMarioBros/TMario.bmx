Type TMario Extends LTVectorSprite
	Global Collisions:Int
	
	Global Jumping:TJumping = New TJumping
	
	Global DyingAnimation:LTAnimationModel = LTAnimationModel.Create( False, 1, 1, 6 )
	Global JumpingAnimation:LTAnimationModel = LTAnimationModel.Create( False, 1, 1, 4 )
	Global SlidingAnimation:LTAnimationModel = LTAnimationModel.Create( False, 1, 1, 5 )
	Global MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, 0.2, 1, 1 )
	Global StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, 1, 1, 0 )
   
    Method Init()
       AttachModel( New LTHorizontalMovementModel )
       AttachModel( LTTileMapCollisionModel.Create( Game.Tilemap, TMarioCollidedWithWall.Instance ) )
       AttachModel( New LTVerticalMovementModel )
       AttachModel( LTTileMapCollisionModel.Create( Game.Tilemap, TMarioCollidedWithFloor.Instance ) )
       AttachModel( LTSpriteMapCollisionModel.Create( Game.MovingObjects, TMarioCollidedWithSprite.Instance ) )
       AttachModel( New TGravity )
       AttachModel( New TMoving )
	   AttachModel( Jumping )
	   
	   Local AnimationStack:LTModelStack = New LTModelStack
	   AttachModel( AnimationStack )
	   AnimationStack.Add( DyingAnimation, False )
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
	   
	   If TopY() > Game.Tilemap.BottomY() And Not FindModel( "TDying" ) Then AttachModel( TDying.Create( True ) )
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



Type TMarioCollidedWithSprite Extends LTSpriteCollisionHandler
	Const HopStrength:Double = -4.0
	
	Global Instance:TMarioCollidedWithSprite = New TMarioCollidedWithSprite
	
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
        If TGoomba( Sprite2 ) Then
           If Sprite1.BottomY() < Sprite2.Y Then
               Sprite2.AttachModel( New TStomped )
               LTVectorSprite( Sprite1 ).DY = HopStrength
               TScore.FromSprite( Sprite2, TScore.s100 )
           Else
               Sprite1.AttachModel( TDying.Create( False ) )
           End If
       End If
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



Type TDying Extends LTBehaviorModel
   Const Period:Double = 3.5
   
   Field Chasm:Int
   Field StartingTime:Double
   
   Function Create:TDying( Chasm:Int )
       Local Dying:TDying = New TDying
       Dying.Chasm = Chasm
       Return Dying
   End Function
   
   Method Activate( Shape:LTShape )
       Local Mario:TMario = TMario( Shape )
	   Mario.DeactivateModel( "LTTileMapCollisionModel" )
	   Mario.DeactivateModel( "LTSpriteMapCollisionModel" )
       Mario.DeactivateModel( "TMoving" )
       Mario.DeactivateModel( "TJumping" )
	   
       Mario.DX = 0.0
       If Not Chasm Then
           Mario.DY = TJumping.Strength
           TMario.DyingAnimation.ActivateModel( Mario )
       End If
       
	   L_Music.ClearMusic()
	   L_Music.Add( "dying" )
	   L_Music.Start()
       StartingTime = Game.Time
   End Method
   
   Method ApplyTo( Shape:LTShape )
       If Game.Time > StartingTime + Period Then Game.InitLevel()
   End Method
End Type