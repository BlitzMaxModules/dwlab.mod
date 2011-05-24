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
	
	Const ShellSpeed:Float = 15.0
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		If Mode = Shell Then
			If DX <> 0.0 And TEnemy( Sprite ) Then TEnemy( Sprite ).Kick()
		Else
			PushFromSprite( Sprite )
			Bump( CollisionType )
		End If
	End Method

	
	
	Method Bump( CollisionType:Int )
		If CollisionType = Horizontal Then
			DX = -DX
			Visualizer.XScale = -Visualizer.XScale
			If Mode = Shell Then PlaySound( Game.Bump )
		Else
			DY = 0.0
		End If
	End Method

	
	
	Method Push()
		If Mode = Shell And DX = 0.0 Then
			Stomp()
		Else
			Game.Mario.Damage()
		End If
	End Method
	
	

	Method Stomp()
		If Mode = Normal Then
			Frame = 2
			DX = 0.0
			Mode = Shell
		ElseIf Mode = Shell Then
			If DX = 0.0 Then
				DX = ShellSpeed * Sgn( X - Game.Mario.X )
				Move( DX, 0 )
			Else
				DX = 0.0
			End If
		End If
	End Method
End Type