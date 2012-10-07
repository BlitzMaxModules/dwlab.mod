'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TBar Extends LTSprite
	Field InitialWidth:Double

	Method Init()
		Super.Init()
		InitialWidth = Width
	End Method
	
	Method SetValue( Value:Double, TotalValue:Double )
		Local CornerX:Double = LeftX()
		If TotalValue Then SetWidth( InitialWidth * ( TotalValue - Value ) / TotalValue ) Else SetWidth( InitialWidth )
		SetCornerCoords( CornerX, TopY() )
	End Method
End Type
