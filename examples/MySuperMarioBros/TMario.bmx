'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMario Extends LTVectorSprite
	Const FramesInRow:Int = 9
	Const JumpStrength:Float = -17.0
	Const WalkingAnimationSpeed:Float = 0.15
	Const HopStrength:Float = -4.0

	Const Standing:Int = 0
	Const Jumping:Int = 4
	Const Sliding:Int = 5
	Const Firing:Int = 6
	Const Dying:Int = 6
	Const Sitting:Int = 7
	Const SlidingDown:Int = 8
	
	Const Normal:Int = 0
	Const Fireable:Int = 4
	
	Field OnLand:Int
	Field Combo:Int = TScore.s100
	Field FrameShift:Int
	


	Method Init()
		AttachModel( New TCollisions )
		AttachModel( New TGravity )
		AttachModel( New TMoving )
		AttachModel( New TWalkingAnimation )
		AttachModel( New TJumping )
	End Method
	
	
	
	Method Draw()
		Super.Draw()
		'Local Y:Int = 100
		'For Local Model:LTBehaviorModel = Eachin BehaviorModels
			'DrawText( TTypeID.ForObject( Model ).Name() + ", " + Model.Active, 0, Y )
			'Y :+ 16
		'Next
	End Method
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		If TBonus( Sprite ) Then
			Game.Level.Remove( Sprite )
			Game.MovingObjects.RemoveSprite( Sprite )
			TBonus( Sprite ).Collect()
		Else If TGoomba( Sprite ) Then
			If FindModel( "TInvulnerable" ) Then
				Sprite.AttachModel( New TKicked )
			ElseIf BottomY() < Sprite.Y Then
				If DY > 0.0 Then
					Sprite.AttachModel( New TStomped )
					TScore.FromSprite( Sprite, Combo )
					If Combo < TScore.s400 Then Combo :+ 1
					DY = HopStrength
				End If
			Else
				Damage()
			End If
		End If
	End Method
	
	
	
	Method Damage()
		If Not FindModel( "TInvisible" ) Then
			If FindModel( "TBig" ) Then
				If Not FindModel( "TShrinking" ) Then AttachModel( New TShrinking )
			Else
				AttachModel( New TDying )
			End If
		End If		
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, Shape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		If TileNum = TTIles.Coin Then
			TileMap.SetTile( TileX, TileY, TTiles.DarkEmptyBlock )
			Game.Coins :+ 1
			Game.CoinFlip.Play()
		Else
			PushFromTile( TileMap, TileX, TileY )
			If CollisionType = Vertical Then
				If DY >= 0 Then
					OnLand = True
					Combo = TScore.s100
				Else
					Select TileNum
						Case TTiles.QuestionBlock, TTiles.MushroomBlock, TTiles.Mushroom1UPBlock, TTiles.CoinsBlock, TTiles.StarmanBlock
							TBlock.FromTile( TileX, TileY, TileNum )
						Case TTiles.Bricks, TTiles.ShadyBricks
							Local Model:LTBehaviorModel = FindModel( "TBig" )
							If Model Then
								Model.HandleCollisionWithTile( Self, TileMap, Shape, TileX, TileY, CollisionType )
							Else
								TBlock.FromTile( TileX, TileY, TileNum )
							End If
					End Select
				End If
				DY = 0
			End If
		End If		
	End Method
	
	

	Method Act()
		Super.Act()
		
		Frame = ( Frame Mod FramesInRow ) + FrameShift * FramesInRow

		LimitHorizontallyWith( Game.Level.Bounds )
		
		L_CurrentCamera.JumpTo( Self )
		L_CurrentCamera.LimitWith( Game.Level.Bounds )
		
		OnLand = False
	End Method
End Type





Type TMoving Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		Local Mario:TMario = TMario( Shape )
		Mario.DX = 0
		If KeyDown( Key_Left ) Then
			Mario.DX = -5.0
			Mario.Visualizer.XScale = -1.0
			Mario.ActivateModel( "TWalkingAnimation" )
		ElseIf KeyDown( Key_Right ) Then
			Mario.DX = 5.0
			Mario.Visualizer.XScale = 1.0
			Mario.ActivateModel( "TWalkingAnimation" )
		Else
			If Mario.OnLand Then Mario.Frame = TMario.Standing
			Mario.DeactivateModel( "TWalkingAnimation" )
		EndIf
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		TMario( Shape ).DX = 0.0
	End Method
End Type





Type TJumping Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		Local Mario:TMario = TMario( Shape )
		If KeyDown( Key_A ) And Mario.OnLand Then
			Mario.DY = TMario.JumpStrength
			Mario.Frame = TMario.Jumping
			Game.Jump.Play()
		End If
	End Method
End Type





Type TWalkingAnimation Extends LTBehaviorModel
	Field StartingTime:Float
	
	
	
	Method Activate( Shape:LTShape )
		StartingTime = Game.Time
	End Method
	

	
	Method ApplyTo( Shape:LTShape )
		Local Mario:TMario = TMario( Shape )
		If Mario.OnLand Then Mario.Animate( Game, TMario.WalkingAnimationSpeed, 3, 1, StartingTime )
	End Method
End Type





Type TDying Extends LTBehaviorModel
	Method Activate( Shape:LTShape )
		Local Mario:TMario = TMario( Shape )
		TCollisions( Mario.FindModel( "TCollisions" ) ).SetCollisions( False, False )
		Mario.DeactivateModel( "TMoving" )
		Mario.DeactivateModel( "TWalkingAnimation" )
		Mario.DeactivateModel( "TJumping" )
		Mario.DX = 0.0
		Mario.DY = TMario.JumpStrength
		Mario.Frame = TMario.Dying
		
		Game.MusicChannel.Stop()
		Game.MusicChannel = Game.MarioDie.Play()
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		If Not Game.MusicChannel.Playing() Then Game.InitLevel()
	End Method
End Type





Type TGrowing Extends LTBehaviorModel
	Const Speed:Float = 0.08
	Const Phases:Int = 10
	
	Field StartingTime:Float

	

	Method Init( Shape:LTShape )
		Shape.DeactivateAllModels()
		Game.Level.Active = False
		Local Sprite:LTSprite = LTSprite( Shape )
		Sprite.AlterCoords( 0.0, -0.5 )
		Sprite.SetSize( 1.0, 2.0 )
		Sprite.Visualizer.SetImage( Game.Growth )
		Sprite.Frame = 0
		PlaySound( Game.Powerup )
		StartingTime = Game.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).Animate( Game, Speed, , , StartingTime, True )
		If Game.Time > StartingTime + Phases * Speed Then Remove( Shape )
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Shape.ActivateAllModels()
		Game.Level.Active = True
		Shape.Visualizer.SetImage( Game.SuperMario )
		Shape.AttachModel( New TBig )
	End Method
End Type





Type TBig Extends LTBehaviorModel
	Method HandleCollisionWithTile( Sprite:LTSprite, TileMap:LTTileMap, TileShape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		If TileNum = TTiles.Bricks Or TileNum = TTiles.ShadyBricks Then TBricks.FromTile( TileX, TileY, TileNum )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		If KeyDown( Key_Down ) Then If Not Shape.FindModel( "TSitting" ) Then Shape.AttachModel( New TSitting )
	End Method
End Type





Type TShrinking Extends TGrowing
	Method Init( Shape:LTShape )
		Shape.DeactivateAllModels()
		Game.Level.Active = False
		Local Sprite:LTSprite = LTSprite( Shape )
		Sprite.Visualizer.SetImage( Game.Growth )
		Sprite.Frame = 0
		PlaySound( Game.Pipe )
		StartingTime = Game.Time
		Shape.AttachModel( New TInvisible )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).Animate( Game, Speed, , , StartingTime - 2.0 * Speed, True )
		If Game.Time > StartingTime + Phases * Speed Then Remove( Shape )
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Shape.RemoveModel( "TSitting" )
		Shape.ActivateAllModels()
		Game.Level.Active = True
		Shape.SetSize( 1.0, 1.0 )
		Shape.AlterCoords( 0.0, 0.5 )
		Shape.Visualizer.SetImage( Game.SmallMario )
		Shape.RemoveModel( "TBig" )
	End Method
End Type





Type TInvisible Extends LTBehaviorModel
	Const Period:Float = 2.0
	Const BlinkingSpeed:Float = 0.05

	Field StartingTime:Float
	
	
	
	Method Activate( Shape:LTShape )
		StartingTime = Game.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Shape.Visible = Floor( Game.Time / BlinkingSpeed ) Mod 2
		If Game.Time > StartingTime + Period Then Remove( Shape )
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Shape.Visible = True
	End Method
End Type





Type TSitting Extends LTBehaviorModel
	Method Activate( Shape:LTShape )
		Shape.SetSize( 1.0, 1.0 )
		Shape.AlterCoords( 0, 0.5 )
		Shape.Visualizer.DY = -0.5
		Shape.Visualizer.YScale = 2.0
		Shape.DeactivateModel( "TMoving" )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).Frame = TMario.Sitting
		If Not KeyDown( Key_Down ) Then Remove( Shape )
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Shape.AlterCoords( 0, -0.5 )
		Shape.SetSize( 1.0, 2.0 )
		Shape.Visualizer.DY = 0.0
		Shape.Visualizer.YScale = 1.0
		Shape.ActivateModel( "TMoving" )
	End Method
End Type





Type TFlashing Extends LTBehaviorModel
	Const AnimationSpeed:Float = 0.05
	Const Period:Float = 0.8
	
	Field StartingTime:Float

	
	
	Method Init( Shape:LTShape )
		Shape.DeactivateAllModels()
		Game.Level.Active = False
		PlaySound( Game.Powerup )
		StartingTime = Game.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local Mario:TMario = TMario( Shape )
		Mario.FrameShift = 2 + ( Floor( Game.Time / AnimationSpeed ) Mod 3 )
		If Game.Time > StartingTime + Period Then Remove( Shape )
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Shape.ActivateAllModels()
		Game.Level.Active = True
		TMario( Shape ).FrameShift = TMario.Fireable
	End Method
End Type





Type TInvulnerable Extends LTBehaviorModel
	Const AnimationSpeed:Float = 0.05
	Const Period:Float = 13.0
	Const FadingAnimationSpeed:Float = 0.1
	Const FadingPeriod:Float = 2.0
	
	Field StartingTime:Float
	Field Fading:Int

	
	
	Method Activate( Shape:LTShape )
		Game.MusicChannel.Stop()
		Game.MusicChannel = Game.Invulnerability.Play()
		StartingTime = Game.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local Mario:TMario = TMario( Shape )
		If Game.Time < StartingTime + Period Then
			Mario.FrameShift = 1 + ( Floor( Game.Time / AnimationSpeed ) Mod 3 )
		ElseIf Game.Time < StartingTime + Period + FadingPeriod Then
			If Not Fading Then
				Game.MusicChannel.Stop()
				Game.MusicChannel = Game.MusicIntro.Play()
				Fading = True
			End If
			Mario.FrameShift = 1 + ( Floor( Game.Time / FadingAnimationSpeed ) Mod 3 )
		Else
			Remove( Shape )
		End If
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		TMario( Shape ).FrameShift = TMario.Normal
	End Method
End Type