'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTMenuButton Extends LTButton
	Method Draw( DrawingAlpha:Double = 1.0 )
		If Focus Then
			TextSize = 0.42
			TextColor.SetColorFromHex( "FFFFFF" )
		Else
			TextSize = 0.385
			TextColor.SetColorFromHex( "DFDFDF" )
		End If
		Super.Draw()
	End Method
End Type