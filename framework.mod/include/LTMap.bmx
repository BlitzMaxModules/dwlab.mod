'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTFloatMap.bmx"
Include "LTIntMap.bmx"
Include "LTCollisionMap.bmx"
Include "LTShapeMap.bmx"

Type LTMap Extends LTObject
	Field XQuantity:Int, YQuantity:Int
	Field XMask:Int, YMask:Int
	
	
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		?debug
		L_Assert( NewXQuantity > 0 And NewYQuantity > 0, "Map resoluton must be more than 0" )
		?
		
		XQuantity = NewXQuantity
		YQuantity = NewYQuantity
		If L_IsPowerOf2( XQuantity ) And L_IsPowerOf2( YQuantity ) Then
			XMask = XQuantity - 1
			YMask = YQuantity - 1
		Else 
			XMask = 0
			YMask = 0
		End If
	End Method
	
	
	
	Method Stretch:LTMap( XMultiplier:Int, YMultiplier:Int )
	End Method
End Type