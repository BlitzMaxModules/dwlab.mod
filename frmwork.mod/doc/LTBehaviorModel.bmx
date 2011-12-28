SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const BallsQuanity:Int = 20
	Const Bricks:Int = 1
	
	Field World:LTWorld = LTWorld.FromFile( "jellys.lw" )
	Field Layer:LTLayer
	Field TileMap:LTTileMap
	Field SelectedSprite:LTSprite
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	Field BumpingWalls:TBumpingWalls = New TBumpingWalls
	Field PushFromWalls:TPushFromWalls = New TPushFromWalls
	Field DestroyBullet:TDestroyBullet = New TDestroyBullet
	Field HurtingCollision:THurtingCollision = New THurtingCollision
	
	Method Init()
		L_InitGraphics()
		InitLevel()
	End Method
	
	Method InitLevel()
		LoadAndInitLayer( Layer, LTLayer( World.FindShape( "Level" ) ) )
		TileMap = LTTileMap( Layer.FindShape( "Field" ) )
	End Method
	
	Method Logic()
		L_CurrentCamera.JumpTo( TileMap )
		If MouseHit( 1 ) Then SelectedSprite = L_Cursor.FirstCollidedSpriteOfLayer( Layer )
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		If SelectedSprite Then
			SelectedSprite.ShowModels( 100 )
			SelectedSprite.DrawUsingVisualizer( MarchingAnts )
		End If
		ShowDebugInfo()
	End Method
End Type



Type TGameObject Extends LTVectorSprite
	Field OnLand:TOnLand = New TOnLand
	Field Gravity:TGravity = New TGravity
	Field JumpingAnimation:LTAnimationModel
	Field FallingAnimation:LTAnimationModel
	
	Field Health:Double = 100.0
End Type



Type TJelly Extends TGameObject
	Const JumpingAnimationSpeed:Double = 0.2
	Const FiringAnimationSpeed:Double = 0.1
	Const WalkingAnimationSpeed:Double = 0.2
	Const IdleAnimationSpeed:Double = 0.4
	Const MinAttack:Double = 7.0
	Const MaxAttack:Double = 15.0
	
	Const JumpingPause:Double = JumpingAnimationSpeed * 2.0
	Const BulletPause:Double = FiringAnimationSpeed * 5.0
	
		
	Method Init()
		AttachModel( Gravity )

		Local AnimationStack:LTModelStack = New LTModelStack
		AttachModel( AnimationStack )
		
		JumpingAnimation = LTAnimationModel.Create( False, JumpingAnimationSpeed, 8, 8 )
		FallingAnimation = LTAnimationModel.Create( True, JumpingAnimationSpeed, 3, 13, True )
		Local FiringAnimation:LTAnimationModel = LTAnimationModel.Create( False, FiringAnimationSpeed, 8, 16 )
		
		Local HorizontalMovement:THorizontalMovement = THorizontalMovement.Create( Example.BumpingWalls )
				
		Local Jumping:String = GetParameter( "jumping" )
		If Jumping Then
			Local Parameters:String[] = Jumping.Split( "-" )
			Local WaitingForJump:LTRandomWaitingModel = LTRandomWaitingModel.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( WaitingForJump )
			
			Local OnLandCondition:LTIsModelActivated = LTIsModelActivated.Create( OnLand )
			WaitingForJump.NextModels.AddLast( OnLandCondition )
			
			Local AnimationActive:LTIsModelActivated = LTIsModelActivated.Create( FiringAnimation )
			OnLandCondition.TrueModels.AddLast( AnimationActive )
			OnLandCondition.FalseModels.AddLast( WaitingForJump )
			
			AnimationActive.TrueModels.AddLast( WaitingForJump )
			AnimationActive.FalseModels.AddLast( LTModelActivator.Create( JumpingAnimation ) )
			AnimationActive.FalseModels.AddLast( LTModelDeactivator.Create( HorizontalMovement ) )
			AnimationActive.FalseModels.AddLast( LTModelDeactivator.Create( Gravity ) )
			
			JumpingAnimation.NextModels.AddLast( LTModelActivator.Create( FallingAnimation ) )
			
			Parameters = GetParameter( "jumping_strength" ).Split( "-" )
			Local PauseBeforeJump:LTFixedWaitingModel = LTFixedWaitingModel.Create( JumpingPause )
			PauseBeforeJump.NextModels.AddLast( TJump.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() ) )
			PauseBeforeJump.NextModels.AddLast( LTModelActivator.Create( HorizontalMovement ) )
			PauseBeforeJump.NextModels.AddLast( LTModelActivator.Create( Gravity ) )
			PauseBeforeJump.NextModels.AddLast( WaitingForJump )
			AnimationActive.FalseModels.AddLast( PauseBeforeJump )
			
			AnimationStack.Add( JumpingAnimation, False )
		End If
		
		AnimationStack.Add( FallingAnimation )
		
		Local Firing:String = GetParameter( "firing" )
		If Firing Then
			Local Parameters:String[] = Firing.Split( "-" )
			Local WaitingForFire:LTRandomWaitingModel = LTRandomWaitingModel.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( WaitingForFire )
			
			Local OnLandCondition:LTIsModelActivated = LTIsModelActivated.Create( OnLand )
			WaitingForFire.NextModels.AddLast( OnLandCondition )
			
			Local AnimationActive:LTIsModelActivated = LTIsModelActivated.Create( JumpingAnimation )
			OnLandCondition.TrueModels.AddLast( AnimationActive )
			OnLandCondition.FalseModels.AddLast( WaitingForFire )
			
			AnimationActive.TrueModels.AddLast( WaitingForFire )
			AnimationActive.FalseModels.AddLast( LTModelActivator.Create( FiringAnimation ) )
			AnimationActive.FalseModels.AddLast( LTModelDeactivator.Create( HorizontalMovement ) )

			FiringAnimation.NextModels.AddLast( LTModelActivator.Create( HorizontalMovement ) )
			
			Parameters = GetParameter( "firing_speed" ).Split( "-" )
			Local PauseBeforeBullet:LTFixedWaitingModel = LTFixedWaitingModel.Create( BulletPause )
			PauseBeforeBullet.NextModels.AddLast( TCreateBullet.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() ) )
			PauseBeforeBullet.NextModels.AddLast( WaitingForFire )
			AnimationActive.FalseModels.AddLast( PauseBeforeBullet )
			
			AnimationStack.Add( FiringAnimation, False )
		End If
		
		Local MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, WalkingAnimationSpeed, 3, 3, True )
		Local Moving:String = GetParameter( "moving" )
		If Moving Then
			Local Parameters:String[] = GetParameter( "moving" ).Split( "-" )
			DX :* Rnd( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( HorizontalMovement )
			AnimationStack.Add( MovementAnimation )
		End If
		
		AttachModel( LTModelDeactivator.Create( OnLand, True ) )
		
		AttachModel( TVerticalMovement.Create( False ) )
		
		Local StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, IdleAnimationSpeed, 3, 0, True )
		AnimationStack.Add( StandingAnimation )
	End Method
End Type



Type TAwPossum Extends TGameObject
	Const JumpingAnimationSpeed:Double = 0.2
	Const WalkingAnimationSpeed:Double = 0.2
	Const IdleAnimationSpeed:Double = 0.4
	
	Const JumpingPause:Double = JumpingAnimationSpeed
	Const JumpingStrength:Double = 6.0
	Const WalkingSpeed:Double = 5.0
	
	Const MinAttack:Double = 20.0
	Const MaxAttack:Double = 35.0
	
	Const KnockOutPeriod:Double = 0.3
	Const ImmortalPeriod:Double = 1.5
	Const KnockOutStrength:Double = 2.0
	
	Field MovementAnimation:LTAnimationModel
	Field HurtingAnimation:LTAnimationModel
	Field MovementControl:TMovementControl = New TMovementControl
	
	Field MoveLeftKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Left ) )
	Field MoveRightKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Right ) )
	Field JumpKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Up ) )
	Field HitKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Space ) )
	
	Method Init()
		AttachModel( Gravity )

		Local AnimationStack:LTModelStack = New LTModelStack
		AttachModel( AnimationStack )
		
		HurtingAnimation = LTAnimationModel.Create( False, KnockOutPeriod, 1, 14 )
		AnimationStack.Add( HurtingAnimation, False )
		
		JumpingAnimation = LTAnimationModel.Create( False, JumpingAnimationSpeed, 3, 8 )
		AnimationStack.Add( JumpingAnimation )
		
		FallingAnimation = LTAnimationModel.Create( True, JumpingAnimationSpeed, 1, 10 )
		JumpingAnimation.NextModels.AddLast( LTModelActivator.Create( FallingAnimation ) )
		AnimationStack.Add( FallingAnimation )

		MovementAnimation = LTAnimationModel.Create( True, WalkingAnimationSpeed, 4, 4 )
		AnimationStack.Add( MovementAnimation )

		Local IsGravityActive:LTIsModelActivated = LTIsModelActivated.Create( Gravity )
		AttachModel( IsGravityActive )
		
		AttachModel( MovementControl )
		
		Local JumpKeyDown:LTIsButtonActionDown = LTIsButtonActionDown.Create( JumpKey )
		AttachModel( JumpKeyDown )
		JumpKeyDown.FalseModels.AddLast( JumpKeyDown )
		
		Local OnLandCondition:LTIsModelActivated = LTIsModelActivated.Create( OnLand )
		JumpKeyDown.TrueModels.AddLast( OnLandCondition )
		
		OnLandCondition.TrueModels.AddLast( LTModelActivator.Create( JumpingAnimation ) )
		OnLandCondition.TrueModels.AddLast( LTModelDeactivator.Create( Gravity ) )
		OnLandCondition.FalseModels.AddLast( JumpKeyDown )
		
		Local PauseBeforeJump:LTFixedWaitingModel = LTFixedWaitingModel.Create( JumpingPause )
		PauseBeforeJump.NextModels.AddLast( TJump.Create( JumpingStrength, JumpingStrength ) )
		PauseBeforeJump.NextModels.AddLast( LTModelActivator.Create( Gravity ) )
		PauseBeforeJump.NextModels.AddLast( JumpKeyDown )
		OnLandCondition.TrueModels.AddLast( PauseBeforeJump )
		
		AnimationStack.Add( JumpingAnimation, False )
		
		AttachModel( THorizontalMovement.Create( Example.PushFromWalls ) )
		
		AttachModel( LTModelDeactivator.Create( OnLand, True ) )
		
		AttachModel( TVerticalMovement.Create( True ) )
		
		Local StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, IdleAnimationSpeed, 4, 0, True )
		AnimationStack.Add( StandingAnimation )
	End Method
	
	Method Act()
		CollisionsWithLayer( Example.Layer, Example.HurtingCollision )
		Super.Act()
	End Method
End Type



Type TOnLand Extends LTBehaviorModel
End Type



Type TGravity Extends LTBehaviorModel
	Const Gravity:Double = 8.0
	
	Method ApplyTo( Shape:LTShape )
		LTVectorSprite( Shape ).DY :+ L_PerSecond( Gravity )
	End Method
End Type



Type THorizontalMovement Extends LTBehaviorModel
	Field CollisionHandler:LTSpriteAndTileCollisionHandler

	Function Create:THorizontalMovement( CollisionHandler:LTSpriteAndTileCollisionHandler )
		Local HorizontalMovement:THorizontalMovement = New THorizontalMovement
		HorizontalMovement.CollisionHandler = CollisionHandler
		Return HorizontalMovement
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( Sprite.DX, 0 )
		Sprite.CollisionsWithTileMap( Example.TileMap, CollisionHandler )
	End Method
	
	Method Info:String( Shape:LTShape )
		Return L_TrimDouble( LTVectorSprite( Shape ).DX )
	End Method
End Type



Type TBumpingWalls Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		Sprite.PushFromTile( TileMap, TileX, TileY )
		LTVectorSprite( Sprite ).DX :* -1
		Sprite.Visualizer.XScale :* -1
	End Method
End Type



Type TPushFromWalls Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		If TileMap.GetTile( TileX, TileY ) = Example.Bricks Then Sprite.PushFromTile( TileMap, TileX, TileY )
	End Method
End Type



Type TVerticalMovement Extends LTBehaviorModel
	Field Handler:TVerticalCollisionHandler = New TVerticalCollisionHandler

	Function Create:TVerticalMovement( ForPlayer:Int )
		Local VerticalMovement:TVerticalMovement = New TVerticalMovement
		VerticalMovement.Handler.ForPlayer = ForPlayer
		Return VerticalMovement
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( 0, Sprite.DY )
		Sprite.CollisionsWithTileMap( Example.TileMap, Handler )
	End Method
	
	Method Info:String( Shape:LTShape )
		Return L_TrimDouble( LTVectorSprite( Shape ).DY )
	End Method
End Type



Type TVerticalCollisionHandler Extends LTSpriteAndTileCollisionHandler
	Field ForPlayer:Int
	
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		If ForPlayer Then If TileMap.GetTile( TileX, TileY ) <> Example.Bricks Then Return
		Local GameObject:TGameObject = TGameObject( Sprite )
		GameObject.PushFromTile( TileMap, TileX, TileY )
		If GameObject.DY > 0 Then
			GameObject.OnLand.ActivateModel( Sprite )
			GameObject.FallingAnimation.DeactivateModel( Sprite )
			GameObject.JumpingAnimation.DeactivateModel( Sprite )
		End If
		GameObject.DY = 0
	End Method
End Type



Type TJump Extends LTBehaviorModel
	Field FromStrength:Double, ToStrength:Double
	
	Function Create:TJump( FromStrength:Double, ToStrength:Double )
		Local Jump:TJump = New TJump
		Jump.FromStrength = FromStrength
		Jump.ToStrength = ToStrength
		Return Jump
	End Function
	
	Method ApplyTo( Shape:LTShape )
		LTVectorSprite( Shape ).DY = -Rnd( FromStrength, ToStrength )
		Remove( Shape )
	End Method
End Type



Type TCreateBullet Extends LTBehaviorModel
	Field FromSpeed:Double, ToSpeed:Double
	
	Function Create:TCreateBullet( FromSpeed:Double, ToSpeed:Double )
		Local CreateBullet:TCreateBullet = New TCreateBullet
		CreateBullet.FromSpeed = FromSpeed
		CreateBullet.ToSpeed = ToSpeed
		Return CreateBullet
	End Function
	
	Method ApplyTo( Shape:LTShape )
		TBullet.Create( LTVectorSprite( Shape ), Rnd( FromSpeed, ToSpeed ) )
		Remove( Shape )
	End Method
End Type



Type TBullet Extends LTVectorSprite
	Const MinAttack:Double = 5.0
	Const MaxAttack:Double = 10.0
	
	Function Create( Jelly:LTVectorSprite, Speed:Double )
		Local Bullet:TBullet = New TBullet
		Bullet.SetCoords( Jelly.X + Sgn( Jelly.DX ) * Jelly.Width * 2.2, Jelly.Y - 0.15 * Jelly.Height )
		Bullet.SetSize( 0.45 * Jelly.Width, 0.45 * Jelly.Width )
		Bullet.ShapeType = LTSprite.Oval
		Bullet.DX = Sgn( Jelly.DX ) * Speed
		Bullet.Visualizer.SetVisualizerScale( 12, 4 )
		Bullet.Visualizer.Image = Jelly.Visualizer.Image
		Bullet.Frame = 6
		Example.Layer.AddLast( Bullet )
	End Function
	
	Method Act()
		MoveForward()
		CollisionsWithTileMap( Example.TileMap, Example.DestroyBullet )
	End Method
End Type



Type TDestroyBullet Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		If TileMap.GetTile( TileX, TileY ) = Example.Bricks Then Example.Layer.Remove( Sprite )
	End Method
End Type



Type TMovementControl Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		Local AwPossum:TAwPossum = TAwPossum( Shape )
		If AwPossum.Gravity.Active Then
			If AwPossum.MoveLeftKey.IsDown() Then
				AwPossum.SetFacing( LTSprite.LeftFacing )
				AwPossum.DX = -AwPossum.WalkingSpeed
			ElseIf AwPossum.MoveRightKey.IsDown() Then
				AwPossum.SetFacing( LTSprite.RightFacing )
				AwPossum.DX = AwPossum.WalkingSpeed
			Else
				AwPossum.DX = 0
			End If
		Else
			AwPossum.DX = 0
		End If
		
		If AwPossum.DX And AwPossum.OnLand.Active Then
			AwPossum.MovementAnimation.ActivateModel( Shape )
		Else
			AwPossum.MovementAnimation.DeactivateModel( Shape )
		End If
	End Method
End Type




Type THurtingCollision Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		If Sprite1.FindModel( "TImmortality" ) Then Return
		Local Damage:Double = 0
		If TJelly( Sprite2 ) Then Damage = Rnd( TJelly.MinAttack, TJelly.MaxAttack )
		If TBullet( Sprite2 ) Then
			Damage = Rnd( TBullet.MinAttack, TBullet.MaxAttack )
			Example.Layer.Remove( Sprite2 )
		End If
		If Damage Then
			Local AwPossum:TAwPossum = TAwPossum( Sprite1 )
			AwPossum.Health :- Damage
			If AwPossum.Health > 0.0 Then
				Sprite1.AttachModel( New TImmortality )
				Sprite1.AttachModel( New TKnockOut )
			Else
			End If
		End If
	End Method
End Type



Type TImmortality Extends LTFixedWaitingModel
	Const BlinkingSpeed:Double = 0.05
	
	Method Activate( Shape:LTShape )
		Period = TAwPossum.ImmortalPeriod
	End Method
	
	Method ApplyTo( Shape:LTShape )
		Shape.Visible = Floor( L_CurrentProject.Time / BlinkingSpeed ) Mod 2
		Super.ApplyTo( Shape )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Shape.Visible = True
	End Method
End Type



Type TKnockOut Extends LTFixedWaitingModel
	Method Activate( Shape:LTShape )
		Local AwPossum:TAwPossum = TAwPossum( Shape )
		Period = AwPossum.KnockOutPeriod
		AwPossum.DX = -AwPossum.GetFacing() * AwPossum.KnockOutStrength
		AwPossum.MovementControl.DeactivateModel( Shape )
		AwPossum.HurtingAnimation.ActivateModel( Shape )
	End Method
	
	Method ApplyTo( Shape:LTShape )
		LTVectorSprite( Shape ).DX :* 0.9
		Super.ApplyTo( Shape )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Local AwPossum:TAwPossum = TAwPossum( Shape )
		AwPossum.HurtingAnimation.DeactivateModel( Shape )
		AwPossum.MovementControl.ActivateModel( Shape )
	End Method
End Type