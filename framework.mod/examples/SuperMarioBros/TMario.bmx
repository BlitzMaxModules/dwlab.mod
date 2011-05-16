'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TFireball.bmx"

Type TMario Extends TMovingObject
	Field Mode:Int = Normal
	Field FrameShift:Int
	Field AnimationStartingTime:Float
	Field ModeStartingTime:Float
	Field OnLand:Int
	Field Big:Int = False
	Field Fireable:Int = False
	Field Invulnerable:Int = False
	Field Invisible:Int = False
	Field Combo:Int = 0
	Field OldFrame:Int
	Field FiringStartingTime:Float
	
	Const Normal:Int = 0
	Const Dying:Int = 1
	Const Growing:Int = 2
	Const Shrinking:Int = 3
	Const FireGaining:Int = 4
	
	Const FramesInRow:Int = 8
	Const GrowingSpeed:Float = 0.08
	Const JumpStrength:Float = -17.0
	Const MovingAnimationSpeed:Float = 0.15
	Const MovingSpeed:Float = 5.0
	Const InvisibilityPeriod:Float = 2.0
	Const BlinkingSpeed:Float = 0.05
	Const InvulnerabilityPeriod:Float = 10.0
	Const InvulnerabilityAnimationSpeed:Float = 0.05
	Const FireGainingAnimationSpeed:Float = 0.05
	Const FiringPeriod:Float = 0.2
	Const FiringAnimationPeriod:Float = 0.1
	
	
	
	Method Draw()
		If Invisible Then If Floor( Game.Time / BlinkingSpeed ) Mod 2 Then Return
		Super.Draw()
	End Method
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		If TBonus( Sprite ) Then
			TBonus( Sprite ).Collect()
			Game.MainLayer.Remove( Sprite )
			Game.MovingObjects.RemoveSprite( Sprite )
		ElseIf TEnemy( Sprite ) Then
			If Invulnerable Then
				TEnemy( Sprite ).Kick()
			Else
				If BottomY() < Sprite.Y Then
					TEnemy( Sprite ).Stomp()
				Else
					If Not Invisible Then Damage()
				End If
			End If
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		If CollisionType = Vertical Then
			If DY >= 0.0 Then 
				OnLand = True
				Combo = 0
			Else
				Local TileNum:Int = TileMap.FrameMap.Value[ TileX, TileY ]
				Select TileNum
					Case 9, 10, 11, 13, 16, 17, 18, 27
						TBlock.FromTile( TileX, TileY, TileNum )
				End Select
			End If
			DY = 0
		End If
		PushFromTile( TileMap, TileX, TileY )
	End Method
	
	
	
	Method Act()
		DY :+ L_DeltaTime * 32.0
		
		If Mode = Dying Then
			Move( 0, DY )
		Else
			If Invisible And Game.Time > ModeStartingTime + InvisibilityPeriod Then Invisible = False
			If Invulnerable Then
				FrameShift = FramesInRow * ( 1 + ( Floor( Game.Time / InvulnerabilityAnimationSpeed ) Mod 3 ) )
				If Game.Time > ModeStartingTime + InvulnerabilityPeriod Then
					Invulnerable = False
					If Fireable Then FrameShift = FramesInRow * 4 Else FrameShift = 0
					Game.MusicChannel.Stop()
					Game.MusicChannel = PlaySound( Game.Music1Intro )
				End If
			End If
			
			Local Direction:Float = 0.0
			If KeyDown( Key_Left ) Then Direction = -1.0
			If KeyDown( Key_Right ) Then Direction = 1.0
			
			If KeyDown( Key_A ) And OnLand Then
				Game.Jump.Play()
				DY = JumpStrength
				Frame = 4
			ElseIf Direction = 0.0 Then 
				
				Local DDX:Float = L_DeltaTime * 32.0
				If DDX < Abs( DX ) Then
					DX :- Sgn( DX ) * DDX
				Else
					DX = 0.0
				End If
				AnimationStartingTime = Game.Time
				If Frame Mod FramesInRow <> 6 Then If OnLand Then Frame = 0
			Else
				If Frame Mod FramesInRow <> 6 Then If OnLand Then Animate( Game, MovingAnimationSpeed, 3, 1 + FrameShift, AnimationStartingTime )
				If Sgn( DX ) = Direction Then
					Visualizer.XScale = Direction
					'DX :+ Direction * L_DeltaTime * 8.0
					'If Abs( DX ) > 10.0 Then DX = Sgn( DX ) * 10.0
					DX = Direction * MovingSpeed
				Else
					If OnLand Then Frame = 5
					DX :+ Direction * L_DeltaTime * Game.Gravity
				End If
				'Move( 5.0 * Direction, 0.0 )
			End If
			
			If Frame Mod FramesInRow = 6 Then If Game.Time > FiringStartingTime + FiringAnimationPeriod Then Frame = OldFrame
			
			If Fireable And KeyDown( Key_S ) And Game.Time > FiringStartingTime + FiringPeriod Then
					If Frame Mod FramesInRow <> 6 Then OldFrame = Frame
					Frame = 6
					FiringStartingTime = Game.Time
					PlaySound( Game.Firing )
					TFireball.Launch()
			End If
			
			Frame = FrameShift + ( Frame Mod FramesInRow )
			
			LimitLeftWith( Game.Tilemap )
			LimitRightWith( Game.Tilemap )
			
			L_CurrentCamera.JumpTo( Self )
			L_CurrentCamera.LimitWith( Game.Tilemap )
			
			OnLand = False
		
			Super.Act()
		End If		
	End Method
	
	
	
	Method PlayAnimation()
		If AnimationStartingTime + 10.0 * GrowingSpeed > Game.Time Then
			If Mode = FireGaining Then
				Frame = ( Frame Mod FramesInRow ) + FramesInRow *( 2 + ( Floor( Game.Time / FireGainingAnimationSpeed ) Mod 3 ) )
			Else
				Animate( Game, GrowingSpeed, , , AnimationStartingTime, True )
			End If
		Else
			Select Mode
				Case Growing
					Visualizer.SetImage( Game.SuperMario )
				Case Shrinking
					Y :+ 0.5
					Height = 1.0
					Visualizer.SetImage( Game.SmallMario )
					Frame = 0
					ModeStartingTime = Game.Time
				Case FireGaining
					Fireable = True
					FrameShift = FramesInRow * 4
			End Select
			Mode = Normal
		End If
	End Method
	
	
	
	Method SetGrowth()
		Y :- 0.5
		Height = 2.0
		Visualizer.SetImage( Game.Growth )
		Frame = 0
		Big = True
		Mode = Growing
		FrameShift = 0
		AnimationStartingTime = Game.Time
		PlaySound( Game.Powerup )
	End Method
	
	
	
	Method Damage()
		If Big Then
			Visualizer.SetImage( Game.Growth )
			Frame = 2
			Big = False
			Mode = Shrinking
			FrameShift = 0
			Fireable = False
			Invisible = True
			AnimationStartingTime = Game.Time - 2.0 * GrowingSpeed
			PlaySound( Game.Pipe )
		Else
			DY = JumpStrength
			Frame = 6
			Mode = Dying
			FrameShift = 0
			Game.MusicChannel.Stop()
			Game.MusicChannel = Game.MarioDie.Play()
		End If
	End Method
End Type