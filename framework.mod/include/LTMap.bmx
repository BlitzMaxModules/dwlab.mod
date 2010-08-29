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

Type LTMap Extends LTObject
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
	End Method
	
	
	
	Method GetXQuantity:Int()
	End Method
	
	
	
	Method GetYQuantity:Int()
	End Method
	
	
	
	Method GetXMask:Int()
		If L_IsPowerOf2( GetXQuantity() ) Then Return GetXQuantity() - 1
	End Method
	
	
	
	Method GetYMask:Int()
		If L_IsPowerOf2( GetYQuantity() ) Then Return GetYQuantity() - 1
	End Method
	
	
	
	Method Stretch:LTMap( XMultiplier:Int, YMultiplier:Int )
	End Method
End Type