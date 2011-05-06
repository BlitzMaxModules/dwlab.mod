'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TGoomba.bmx"
Include "TKoopaTroopa.bmx"

Type TEnemy Extends TMovingObject
	Field Mode:Int = Normal
	
	Const Normal:Int = 0
	Const Falling:Int = 1
	
	Const FlatPeriod:Float = 1.0
	Const KickStrength:Float = -6.0
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		PushFromSprite( Sprite )
		Bump( CollisionType )
	End Method
	
	
	
	Method Act()
		If Mode <= Falling Then DY :+ L_DeltaTime * Game.Gravity
		If Mode = Normal Then
			Animate( Game, 0.3, 2 )
			Super.Act()
		ElseIf Mode = Falling Then
			Move( DX, DY )
			RemoveIfOutside()
		End If
	End Method
	
	
	
	Method Stomp()
	End Method
	
	
	
	Method Kick()
		DY = KickStrength
		Visualizer.YScale = -1.0
		
		Mode = Falling
		PlaySound( Game.Kick )
		Game.MovingObjects.RemoveSprite( Self )
	End Method
End Type