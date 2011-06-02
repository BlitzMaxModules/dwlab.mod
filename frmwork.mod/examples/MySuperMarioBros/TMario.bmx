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

	Const Standing:Int = 0
	Const Jumping:Int = 4
	Const Sliding:Int = 5
	Const Firing:Int = 6
	Const Dying:Int = 6
	Const Sitting:Int = 7
	Const SlidingDown:Int = 8
	
	Field OnLand:Int
	


	Method Init()
		AttachModel( New TCollisions )
		AttachModel( New TGravity )
		AttachModel( New TMoving )
		AttachModel( New TWalkingAnimation )
		AttachModel( New TJumping )
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, Shape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		If CollisionType = Vertical Then
			If DY > 0 Then OnLand = True
			DY = 0
		End If
	End Method
	
	

	Method Act()
		Super.Act()
		
		LimitHorizontallyWith( Game.Layer.Bounds )
		
		L_CurrentCamera.JumpTo( Self )
		L_CurrentCamera.LimitWith( Game.Layer.Bounds )
		
		OnLand = False
	End Method
End Type





Type TMoving Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		Local Mario:TMario = TMario( Sprite )
		Mario.DX = 0
		If KeyDown( Key_Left ) Then
			Mario.DX = -5.0
			Mario.Visualizer.XScale = -1.5
			Mario.ActivateModel( "TWalkingAnimation" )
		ElseIf KeyDown( Key_Right ) Then
			Mario.DX = 5.0
			Mario.Visualizer.XScale = 1.5
			Mario.ActivateModel( "TWalkingAnimation" )
		Else
			If Mario.OnLand Then Mario.Frame = TMario.Standing
			Mario.DeactivateModel( "TWalkingAnimation" )
		EndIf
	End Method
End Type





Type TJumping Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		Local Mario:TMario = TMario( Sprite )
		If KeyDown( Key_A ) And Mario.OnLand Then
			Mario.DY = TMario.JumpStrength
			Mario.Frame = TMario.Jumping
		End If
	End Method
End Type





Type TWalkingAnimation Extends LTBehaviorModel
	Field StartingTime:Float
	
	
	
	Method Activate( Sprite:LTSprite )
		StartingTime = Game.Time
	End Method
	

	
	Method ApplyTo( Sprite:LTSprite )
		Local Mario:TMario = TMario( Sprite )
		If Mario.OnLand Then Mario.Animate( Game, TMario.WalkingAnimationSpeed, 3, 1, StartingTime )
	End Method
End Type