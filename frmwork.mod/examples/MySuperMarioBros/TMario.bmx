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
	
	Field OnLand:Int
	Field Combo:Int = TScore.s100
	


	Method Init()
		AttachModel( New TCollisions )
		AttachModel( New TGravity )
		AttachModel( New TMoving )
		AttachModel( New TWalkingAnimation )
		AttachModel( New TJumping )
	End Method
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		If TGoomba( Sprite ) Then
			If BottomY() < Sprite.Y Then
				Sprite.AttachModel( New TStomped )
				TScore.FromSprite( Sprite, Combo )
				If Combo < TScore.s400 Then Combo :+ 1
				DY = HopStrength
			Else
				AttachModel( New TDying )
			End If
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, Shape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		If CollisionType = Vertical Then
			If DY > 0 Then
				OnLand = True
				Combo = TScore.s100
			Else
				Local TileNum:Int = TileMap.GetTile( TileX, TileY )
				Select TileNum
					Case TTiles.QuestionBlock, TTiles.Bricks, TTiles.MushroomBlock, TTiles.Mushroom1UPBlock, TTiles.CoinsBlock, TTiles.StarmanBlock, TTiles.ShadyBricks
						TBlock.FromTile( TileX, TileY, TileNum )
				End Select
			End If
			DY = 0
		End If
	End Method
	
	

	Method Act()
		Super.Act()
		
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