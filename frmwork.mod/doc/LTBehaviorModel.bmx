SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "jellys.lw"
Incbin "tileset.png"
Incbin "superjelly.png"
Incbin "awpossum.png"
Incbin "scheme1.png"
Incbin "scheme2.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const Bricks:Int = 1
	Const DeathPeriod:Double = 1.0
	
	Field World:LTWorld
	Field Layer:LTLayer
	Field TileMap:LTTileMap
	Field SelectedSprite:LTSprite
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	Field BumpingWalls:TBumpingWalls = New TBumpingWalls
	Field PushFromWalls:TPushFromWalls = New TPushFromWalls
	Field DestroyBullet:TDestroyBullet = New TDestroyBullet
	Field AwPossumHurtingCollision:TAwPossumHurtingCollision = New TAwPossumHurtingCollision
	Field AwPossumHitCollision:TAwPossumHitCollision = New TAwPossumHitCollision
	
	'Field HitArea:LTSprite
	Field Score:Int
	
	Method Init()
		L_SetIncbin( True )
	 	World = LTWorld.FromFile( "jellys.lw" )
	 	L_SetIncbin( False )
		
		L_InitGraphics()
		
		Repeat
			DrawImage( LoadImage( "incbin::scheme2.png" ), 0, 0 )
			Flip
		Until KeyHit( Key_Escape )
		
		Repeat
			DrawImage( LoadImage( "incbin::scheme1.png" ), 0, 0 )
			Flip
		Until KeyHit( Key_Escape )
		
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
		'If HitArea Then HitArea.Draw()
		ShowDebugInfo()
		L_PrintText( "Guide AwesomePossum to exit from maze using arrow and space keys", TileMap.RightX(), TileMap.TopY() - 12, LTAlign.ToRight, LTAlign.ToTop )
		L_PrintText( "You can view sprite behavior models by clicking left mouse button on it", TileMap.RightX(), TileMap.TopY() - 0.5, LTAlign.ToRight, LTAlign.ToTop )
		L_PrintText( "Score: " + L_FirstZeroes( Score, 6 ), TileMap.RightX() - 0.1, TileMap.BottomY() - 0.1, LTAlign.ToRight, LTAlign.ToBottom, True )
		L_PrintText( "LTBehaviorModel example", TileMap.X, TileMap.BottomY(), LTAlign.ToCenter, LTAlign.ToBottom )
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
	Const MinAttack:Double = 10.0
	Const MaxAttack:Double = 20.0
	Const HurtingTime:Double = 0.2
	
	Const JumpingPause:Double = JumpingAnimationSpeed * 2.0
	Const BulletPause:Double = FiringAnimationSpeed * 5.0
	
	Field Score:Int = 100

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
			
			Local OnLandCondition:LTIsModelActive = LTIsModelActive.Create( OnLand )
			WaitingForJump.NextModels.AddLast( OnLandCondition )
			
			Local AnimationActive:LTIsModelActive = LTIsModelActive.Create( FiringAnimation )
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
			Score :+ 200
		End If
		
		
		AnimationStack.Add( FallingAnimation )
		
		
		Local Firing:String = GetParameter( "firing" )
		If Firing Then
			Local Parameters:String[] = Firing.Split( "-" )
			Local WaitingForFire:LTRandomWaitingModel = LTRandomWaitingModel.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( WaitingForFire )
			
			Local OnLandCondition:LTIsModelActive = LTIsModelActive.Create( OnLand )
			WaitingForFire.NextModels.AddLast( OnLandCondition )
			
			Local AnimationActive:LTIsModelActive = LTIsModelActive.Create( JumpingAnimation )
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
			Score :+ 300
		End If
		
		Local MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, WalkingAnimationSpeed, 3, 3, True )
		Local Moving:String = GetParameter( "moving" )
		If Moving Then
			Local Parameters:String[] = GetParameter( "moving" ).Split( "-" )
			DX :* Rnd( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( HorizontalMovement )
			AnimationStack.Add( MovementAnimation )
			Score :+ 100
		End If
		
		
		AttachModel( LTModelDeactivator.Create( OnLand, True ) )
		AttachModel( TVerticalMovement.Create( False ) )
		
		
		Local StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, IdleAnimationSpeed, 3, 0, True )
		AnimationStack.Add( StandingAnimation )
		
		Local ScoreParameter:String = GetParameter( "score" )
		If ScoreParameter Then Score = ScoreParameter.ToInt()
		
		Local HealthParameter:String = GetParameter( "health" )
		If HealthParameter Then Health = HealthParameter.ToDouble()
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
	Const MinHealthGain:Double = 3.0
	Const MaxHealthGain:Double = 6.0
	
	Const KnockOutPeriod:Double = 0.3
	Const ImmortalPeriod:Double = 1.5
	Const HitPeriod:Double = 0.2
	Const KnockOutStrength:Double = 2.0
	Const HitPauseTime:Double = 0.5
	
	Field MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, WalkingAnimationSpeed, 4, 4 )
	Field HurtingAnimation:LTAnimationModel = LTAnimationModel.Create( False, KnockOutPeriod, 1, 14 )
	Field PunchingAnimation:LTAnimationModel = LTAnimationModel.Create( False, HitPeriod, 1, 15 )
	Field KickingAnimation:LTAnimationModel = LTAnimationModel.Create( False, HitPeriod, 1, 11 )
	
	Field MovementControl:TMovementControl = New TMovementControl
	Field HitPause:LTFixedWaitingModel = LTFixedWaitingModel.Create( HitPauseTime )
	
	Field MoveLeftKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Left ), "Move left" )
	Field MoveRightKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Right ), "Move right" )
	Field JumpKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Up ), "Jump" )
	Field HitKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Space ), "Hit" )
	
	Method Init()
		AttachModel( Gravity )

		
		Local AnimationStack:LTModelStack = New LTModelStack
		AttachModel( AnimationStack )
		
		AnimationStack.Add( HurtingAnimation, False )
		AnimationStack.Add( PunchingAnimation, False )
		AnimationStack.Add( KickingAnimation, False )
		
		JumpingAnimation = LTAnimationModel.Create( False, JumpingAnimationSpeed, 3, 8 )
		AnimationStack.Add( JumpingAnimation )
		
		FallingAnimation = LTAnimationModel.Create( True, JumpingAnimationSpeed, 1, 10 )
		JumpingAnimation.NextModels.AddLast( LTModelActivator.Create( FallingAnimation ) )
		AnimationStack.Add( FallingAnimation )

		AnimationStack.Add( MovementAnimation )

		
		AttachModel( MovementControl )
		
		
		Local JumpKeyDown:LTIsButtonActionDown = LTIsButtonActionDown.Create( JumpKey )
		AttachModel( JumpKeyDown )
		JumpKeyDown.FalseModels.AddLast( JumpKeyDown )
		
		Local OnLandCondition:LTIsModelActive = LTIsModelActive.Create( OnLand )
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

		
		Local HitKeyDown:LTIsButtonActionDown = LTIsButtonActionDown.Create( HitKey )
		AttachModel( HitKeyDown )
		HitKeyDown.FalseModels.AddLast( HitKeyDown )
		
		Local HitPauseCondition:LTIsModelActive = LTIsModelActive.Create( HitPause )
		HitPauseCondition.FalseModels.AddLast( HitPause )
		HitPauseCondition.TrueModels.AddLast( HitKeyDown )
		HitKeyDown.TrueModels.AddLast( HitPauseCondition )
				
		Local OnLandCondition2:LTIsModelActive = LTIsModelActive.Create( OnLand )
		OnLandCondition2.TrueModels.AddLast( LTModelActivator.Create( PunchingAnimation ) )
		OnLandCondition2.TrueModels.AddLast( THittingArea.Create2( True ) )
		OnLandCondition2.TrueModels.AddLast( HitKeyDown )
		OnLandCondition2.FalseModels.AddLast( LTModelActivator.Create( KickingAnimation ) )
		OnLandCondition2.FalseModels.AddLast( THittingArea.Create2( False ) )
		OnLandCondition2.FalseModels.AddLast( HitKeyDown )
		HitPauseCondition.FalseModels.AddLast( OnLandCondition2 )
		
		
		AttachModel( THorizontalMovement.Create( Example.PushFromWalls ) )
		
		
		AttachModel( LTModelDeactivator.Create( OnLand, True ) )
		AttachModel( TVerticalMovement.Create( True ) )
		
		
		Local StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, IdleAnimationSpeed, 4, 0, True )
		AnimationStack.Add( StandingAnimation )
	End Method
	
	Method Act()
		Super.Act()
		CollisionsWithLayer( Example.Layer, Example.AwPossumHurtingCollision )
		If X > Example.TileMap.RightX() Then Example.SwitchTo( New TRestart )
	End Method
	
	Method Draw()
		Super.Draw()
		L_DrawEmptyRect( 5, 580, 104, 15 )
		If Health >= 50.0 Then
			SetColor( ( 100.0 - Health ) * 255.0 / 50.0 , 255, 0 )
		Else
			SetColor( 255, Health * 255.0 / 50.0, 0 )
		End If
		DrawRect( 7, 582, Health, 11 )
		LTVisualizer.ResetColor()
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
	
	Field Collisions:Int = True
	
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
		If Collisions Then CollisionsWithTileMap( Example.TileMap, Example.DestroyBullet )
		Super.Act()
	End Method
	
	Function Disable( Sprite:LTSprite )
		Local Bullet:TBullet = TBullet( Sprite )
		if Bullet.Collisions Then 
			Bullet.AttachModel( New TDeath )
			Bullet.AttachModel( New TGravity )
			Bullet.ReverseDirection()
			Bullet.Collisions = False
			Bullet.DX :* 0.25
		End If
	End Function
End Type



Type TDestroyBullet Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		If TileMap.GetTile( TileX, TileY ) = Example.Bricks Then TBullet.Disable( Sprite )
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




Type TAwPossumHurtingCollision Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		If Sprite1.FindModel( "TImmortality" ) Then Return
		If Sprite2.FindModel( "TDeath" ) Then Return
		
		Local Damage:Double = 0
		If TJelly( Sprite2 ) Then Damage = Rnd( TJelly.MinAttack, TJelly.MaxAttack )
		Local Bullet:TBullet = TBullet( Sprite2 )
		If Bullet Then
			If Bullet.Collisions Then
				Damage = Rnd( TBullet.MinAttack, TBullet.MaxAttack ) * Sprite2.GetDiameter() / 0.45
				Example.Layer.Remove( Sprite2 )
			End If
		End If
		If Damage Then
			Local AwPossum:TAwPossum = TAwPossum( Sprite1 )
			AwPossum.Health :- Damage
			If AwPossum.Health > 0.0 Then
				Sprite1.AttachModel( New TImmortality )
				Sprite1.AttachModel( New TKnockOut )
			ElseIf Not Sprite1.FindModel( "TDeath" ) Then
				Sprite1.BehaviorModels.Clear()
				Sprite1.AttachModel( New TDeath )
			End If
		End If
	End Method
End Type



Type TImmortality Extends LTFixedWaitingModel
	Const BlinkingSpeed:Double = 0.05
	
	Method Init( Shape:LTShape )
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
	Method Init( Shape:LTShape )
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



Type THittingArea Extends LTFixedWaitingModel
	Field Area:LTSprite
	Field Punch:Int
	
	Function Create2:THittingArea( Punch:Int )
		Local Area:THittingArea = New THittingArea
		Area.Punch = Punch
		Return Area
	End Function
	
	Method Init( Shape:LTShape )
		Area = New LTSprite
		Area.ShapeType = LTSprite.Oval
		Area.SetDiameter( 0.3 )
		Period = TAwPossum.HitPeriod
		Example.AwPossumHitCollision.Collided = False
	End Method
	
	Method ApplyTo( Shape:LTShape )
		If Punch then
			Area.SetCoords( Shape.X + Shape.GetFacing() * 0.95, Shape.Y + 0.15 )
		Else
			Area.SetCoords( Shape.X + Shape.GetFacing() * 0.95, Shape.Y - 0.1 )
		End If
		'Example.HitArea = Area
		Area.CollisionsWithLayer( Example.Layer, Example.AwPossumHitCollision )
		If Example.AwPossumHitCollision.Collided Then Remove( Shape )
		Super.ApplyTo( Shape )
	End Method
	
	'Method Deactivate( Shape:LTShape )
	'	Example.HitArea = Null
	'End Method
End Type



Type TAwPossumHitCollision Extends LTSpriteCollisionHandler
	Field Collided:Int 
	
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Local Jelly:TJelly = TJelly( Sprite2 )
		If Jelly Then
			Jelly.Health :- Rnd( TAwPossum.MinAttack, TAwPossum.MaxAttack )
			If Jelly.Health > 0 Then
				Jelly.AttachModel( New TJellyHurt )
			ElseIf Not Jelly.FindModel( "TDeath" ) Then
				TScore.Create( Jelly, Jelly.Score )
				
				Local AwPossum:TAwPossum = TAwPossum( Example.Layer.FindShapeWithType( "TAwPossum" ) )
				AwPossum.Health = Min( AwPossum.Health + Rnd( TAwPossum.MinHealthGain, TAwPossum.MaxHealthGain ), 100.0 )
				
				Jelly.BehaviorModels.Clear()
				Jelly.AttachModel( New TDeath )
			End If
			Collided = True
		ElseIf TBullet( Sprite2 )
			If Not Sprite2.FindModel( "TDeath" ) Then
				TBullet.Disable( Sprite2 )
				TScore.Create( Sprite2, 50 )
			End If
		End If
	End Method
End Type



Type TJellyHurt Extends LTFixedWaitingModel
	Method Init( Shape:LTShape )
		Period = TJelly.HurtingTime
		Shape.DeactivateModel( "THorizontalMovement" )
	End Method

	Method ApplyTo( Shape:LTShape )
		Super.ApplyTo( Shape )
		Local Intensity:Double = ( L_CurrentProject.Time - StartingTime ) / Period
		If Intensity <= 1.0 Then Shape.Visualizer.SetColorFromRGB( 1.0, Intensity, Intensity )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Shape.ActivateModel( "THorizontalMovement" )
		Shape.Visualizer.SetColorFromHex( "FFFFFF" )
	End Method
End Type



Type TDeath Extends LTFixedWaitingModel
	Method Init( Shape:LTShape )
		Period = Example.DeathPeriod
	End Method

	Method ApplyTo( Shape:LTShape )
		Super.ApplyTo( Shape )
		Local Alpha:Double = 1.0 - ( L_CurrentProject.Time - StartingTime ) / Period
		If Alpha >= 0.0 Then Shape.Visualizer.Alpha = Alpha
	End Method
	
	Method Deactivate( Shape:LTShape )
		Example.Layer.Remove( Shape )
	End Method
End Type



Type TScore Extends LTSprite
	Const Speed:Double = 2.0
	Const Period:Double = 3.0
	
	Field Amount:Int
	Field StartingTime:Double
	
	Function Create( Sprite:LTSprite, Amount:Int )
		Local Score:TScore = New TScore
		Score.SetCoords( Sprite.X, Sprite.TopY() )
		Score.Amount = Amount
		Score.SetDiameter( 0 )
		Score.StartingTime = L_CurrentProject.Time
		Example.Score :+ Amount
		Example.Layer.AddLast( Score )
	End Function
	
	Method Act()
		Move( 0, -Speed )
		If L_CurrentProject.Time > StartingTime + Period Then Example.Layer.Remove( Self )
	End Method
	
	Method Draw()
		PrintText( "+" + Amount, , LTAlign.ToBottom, , , True )
	End Method
End Type



Type TRestart Extends LTProject
	Field StartingTime:Int = Millisecs()
	Field Initialized:Int
	
	Method Render()
		If Millisecs() < StartingTime + 2000 Then
			Example.Render()
			L_CurrentCamera.Darken( 0.0005 * ( Millisecs() - StartingTime ) )
		ElseIf Millisecs() < StartingTime + 4000
			If Not Initialized Then
				Example.InitLevel()
				Initialized = True
			End If
			Example.Render()
			L_CurrentCamera.Darken( 0.0005 * ( 4000 - Millisecs() + StartingTime ) )
		Else
			Exiting = True
		End If
	End Method
End Type