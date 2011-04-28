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
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		Local Mario:TMario = TMario( Sprite )
		If Mario Then
			Game.Over = True
			Mario.Frame = 6
			Mario.DY = -16.0
			Game.MusicChannel.Stop()
			Game.MusicChannel = Game.MarioDie.Play()
		End If
		
		PushFromSprite( Sprite )
		Bump( CollisionType )
	End Method
	
	
	
	Method Act()
		Animate( Game, 0.3, 2 )
		DY :+ L_DeltaTime * 32.0
		Super.Act()
	End Method
End Type