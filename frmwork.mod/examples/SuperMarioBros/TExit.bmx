'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TExit Extends LTVectorSprite
	Method Act()
		If Overlaps( Game.Mario ) And ( DX <> 0.0 Or ( Game.Mario.OnLand And KeyDown( Key_Down ) ) ) Then
			Game.ToExit = Self
			Game.Mario.LimitByWindow( X, Y, Width, Height )
			Game.Mario.AnimationStartingTime = Game.Time
			Game.Mario.DX = DX
			Game.Mario.DY = DY
			Game.Mario.Mode = Game.Mario.Exiting
			PlaySound( Game.Pipe )
		End If
	End Method
End Type