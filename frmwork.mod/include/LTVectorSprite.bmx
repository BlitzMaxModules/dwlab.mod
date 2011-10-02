'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
	
Rem
bbdoc: Vector sprite has horizontal and vertical velocities forming velocity vector.
about: Handy for projects with gravity, platformers for example.

See also: #LTSprite
End Rem
Type LTVectorSprite Extends LTSprite
	Rem
	bbdoc: Horizontal velocity of the sprite.
	End Rem
	Field DX:Double
	
	Rem
	bbdoc: Vertical velocity of the sprite.
	End Rem
	Field DY:Double
	
	
	
	Method GetClassTitle:String()
		Return "Vector sprite"
	End Method
	
	
	
	Method Init()
		DX = Cos( Angle ) * Velocity
		DY = Sin( Angle ) * Velocity
	End Method

	
	
	Method MoveForward()
		SetCoords( X + DX * L_DeltaTime, Y + DY * L_DeltaTime )
	End Method
End Type