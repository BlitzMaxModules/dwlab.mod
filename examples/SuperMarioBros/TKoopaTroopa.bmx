'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TKoopaTroopa Extends TEnemy
	Const Shell:Int = 2
	
	Const ShellSpeed:Double = 15.0
	
	
	Method Init()
		AttachModel( New TEnemyWalkingAnimation )
		AttachModel( New TCollisions )
		AttachModel( New TGravity )
		AttachModel( New TBumpingTiles )
		AttachModel( New TBumpingSprites )
		AttachModel( New TRemoveIfOutside )
		Super.Init()
	End Method
	
	
	
	Method Stomp()
		Game.Stomp.Play()
		If FindModel( "TShell" ) Then
			If DX = 0.0 Then
				DX = ShellSpeed * Sgn( X - Game.Mario.X )
			Else
				DX = 0.0
			End If
		Else
			AttachModel( New TShell )
		End If
	End Method
End Type





Type TShell Extends LTBehaviorModel
	Method Activate( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Frame = TKoopaTroopa.Shell
		Sprite.DX = 0.0
		Sprite.DeactivateModel( "TEnemyWalkingAnimation" )
		Sprite.DeactivateModel( "TBumpingSprites" )
	End Method
	
	
	
	Method HandleCollisionWithSprite( Sprite1:LTSprite, Sprite2:LTSprite, CollisionType:Int )
		If TEnemy( Sprite2 ) Then
			TEnemy( Sprite2 ).AttachModel( New TKicked )
		Elseif TMario( Sprite2 )
			TMario( Sprite2 ).Damage()
		End If
	End Method
End Type