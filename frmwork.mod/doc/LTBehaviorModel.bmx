SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const BallsQuanity:Int = 20
	
	Field World:LTWorld = LTWorld.FromFile( "jellys.lw" )
	Field Layer:LTLayer
	Field TileMap:LTTileMap
	
	Method Init()
		L_InitGraphics()
		InitLevel()
	End Method
	
	Method InitLevel()
		LoadAndInitLayer( Layer, LTLayer( World.FindShape( "Level" ) ) )
		TileMap = LTTileMap( Layer.FindShape( "Field" ) )
	End Method
	
	Method Logic()
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
	End Method
End Type



Type TJelly Extends LTVectorSprite
	Const JumpingSpeed:Double
	Const IdleSpeed:Double
	Const WalkingSpeed:Double

	Method Init()
		Local OnLand:TOnLand = New TOnLand
		
		Local AnimationStack:LTModelStack = New LTModelStack
		AttachModel( AnimationStack )
		
		Local JumpingAnimation:LTBehaviorModel = LTAnimationModel.Create( False, JumpingSpeed, 8, 8 )
		Local Jumping:String = GetParameter( "jumping" )
		If Jumping Then
			Local Parameters:String[] = Jumping.Split( "-" )
			Local WaitingForJump:LTRandomWaitingModel = LTRandomWaitingModel.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( WaitingForJump )
			
			Local OnLandCondition:LTIsModelActivated = LTIsModelActivated.Create( OnLand )
			WaitingForJump.NextModels.AddLast( OnLandCondition )
			
			Local AnimationActive:LTIsModelActivated = LTIsModelActivated.Create( JumpingAnimation )
			OnLandCondition.TrueModels.AddLast( AnimationActive )
			OnLandCondition.FalseModels.AddLast( WaitingForJump )
			
			AnimationActive.FalseModels.AddLast( JumpingAnimation )
			AnimationActive.FalseModels.AddLast( LTModelDeactivator.Create( HorizontalMovement ) )
			
			Local PauseBeforeJump:LTFixedWaitingModel = LTFixedWaitingModel.Create( JumpingPause )
			PauseBeforeJump.NextModels.AddLast( TJump.Create( WaitingForJump ) )
			AnimationActive.FalseModels.AddLast( PauseBeforeJump )
		End If
		
		Local HorizontalMovement:LTHorizontalMovement = New LTHorizontalMovement
		Local MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, WalkingSpeed, 3, 3, True )
		Local Moving:String = GetParameter( "moving" )
		If Moving Then
			HorizontalMovement.Speed = Moving.ToDouble()
			AttachModel( HorizontalMovement )
			AnimationStack.Models.AddLast( MovementAnimation )
		End If
	
		Local StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, IdleSpeed, 0, 3, True )
		AnimationStack.Models.AddLast( StandingAnimation )
	End Method

	Method Act()
		CollisionsWithGroup( Example.Layer )
		
		OnLand = False
		Sprite.Move( 0, DY )
		CollisionsWithTileMap( Exmple.TileMap, Vertical )
	End Method
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
		If CollisionType = Vertical Then
			If DY > 0 Then OnLand = True
			DY = 0
		End If
	End Method
End Type



Type TOnLand Extends LTBehaviorModel
End Type



Type THorizontalMovement  Extends LTBehaviorModel
	Field Speed:Double
End Type



Type TGravity Extends LTBehaviorModel
	Const Gravity:Double = 8.0
	
	Method ApplyTo( Shape:LTShape )
		DY :+ L_PerSecond( Gravity )
	End Method
End Type




Type TBullet Extends LTSprite
	Method Act()
		MoveForward()
		CollisionsWithTileMap( Example.TileMap )
	End Method
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
		Example.Layer.Remove( Self )
	End Method
End Type



Type TMoving Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		Shape.Move( Shape.DX, 0 )
	End Method
End Type



Type TJumping Extends LTBehaviorModel
	Field LastJumpTime:Double
	Field Period:Double
	Field JumpStrength:Double
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTSprite = TBall( Shape )
		If Sprite.OnLand Then If LastJumpTime + Period < Example.Time Then Sprite.DY = -JumpStrength
	End Method
End Type



Type THazardous Extends LTBehaviorModel
	Const Push:Double = 2.0

	Method HandleCollisionWithSprite( Sprite1:LTSprite, Sprite2:LTSprite, CollisionType:Int )
		Sprite2.AttachModel( new LTHurt )
		Sprite2.DirectTo( Sprite1 )
		Sprite2.ReverseDirection()
	End Method
EndType



Type THurt Extends LTTemporaryModel
	Method Init( Shape:LTShape )
		TBall( Shape ).Health :- 1
	End Method
End Type