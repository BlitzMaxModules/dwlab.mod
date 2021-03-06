'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTRay Extends LTShapeType
	Method GetNum:Int()
		Return 3
	End Method
	
	Method GetName:String()
		Return "Ray"
	End Method
End Type

LTShapeType.Register( LTSprite.Ray )