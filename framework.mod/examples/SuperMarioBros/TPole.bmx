'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TPole Extends LTVectorSprite
	Method Act()
		If CollidesWithSprite( Game.Mario ) Then
			TScore.FromSprite( Game.Mario, TScore.s100
		End If
	End Method
End Type