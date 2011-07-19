'
' Huge isometric maze - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TWall Extends LTSprite
End Type



Type TFloor Extends LTSprite
End Type



Type TZombie Extends LTAngularSprite
	Field Speed:Double
	Field AnimationSpeed:Double

	Field Destination:LTSprite = New LTSprite
	Field Collided:Int
	
	
	
	Method Init()
		X :+ Rnd( 0.25, -0.25 )
		Y :+ Rnd( 0.25, -0.25 )
		Angle = Rnd( 360.0 )
		Speed = Rnd( 1.0, 2.0 )
		AnimationSpeed = 0.2 / Speed
	End Method
	
	
	
	Method Act()
		Move( Speed * Cos( Angle ), 0.5 * Speed * Sin( Angle ) )
		Collided = False
		CollisionsWithSpriteMap( Game.Objects )
		If Not Collided Then Animate( Game, AnimationSpeed, 8, 8 * ( ( 4.0 + L_Round( Angle / 45.0 ) ) Mod 8 ) )
	End Method
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		If Not TFloor( Sprite ) Then
			PushFromSprite( Sprite )
			Angle = Rnd( 360.0 )
			Collided = True
		End If
	End Method
End Type



Type TActingRegion Extends LTSprite
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		Sprite.Act()
	End Method
End Type