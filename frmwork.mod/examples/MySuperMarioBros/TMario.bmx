'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMario Extends LTVectorSprite
	Method Act()
		If KeyDown( Key_Left ) Then Move( -5.0, 0 )
		If KeyDown( Key_Right ) Then Move( 5.0, 0 )
		
		LimitHorizontallyWith( Game.Layer.Bounds )
		
		L_CurrentCamera.JumpTo( Self )
		L_CurrentCamera.LimitWith( Game.Layer.Bounds )
	End Method
End Type