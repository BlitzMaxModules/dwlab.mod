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
			Local Num:String = GetNamePart( 2 )
			For Local Sprite:LTSprite = Eachin Game.MainLayer
				If Sprite.GetNamePart( 2 ) = Num Then Sprite.Active = True
			Next
			Game.MainLayer.Remove( Self )
		End If
	End Method
End Type