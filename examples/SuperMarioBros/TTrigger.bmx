'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TTrigger Extends LTVectorSprite
	Method Act()
		If CollidesWithSprite( L_CurrentCamera ) Then
			Local Group:String = GetParameter( "group" )
			For Local Sprite:LTVectorSprite = Eachin Game.MovingObjects
				If Sprite.GetParameter( "group" ) = Group Then
					Sprite.DX = Abs( Sprite.DX ) * Sgn( Game.Mario.X - Sprite.X )
					Sprite.Active = True
				End If
			Next
			Game.Level.Remove( Self )
		End If
	End Method
End Type