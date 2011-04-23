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

Type LTMap Extends LTObject
	Field XQuantity:Int, YQuantity:Int
	Field XMask:Int, YMask:Int, Masked:Int
	
	
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		?debug
		If NewXQuantity <= 0 Or NewYQuantity <= 0 Then L_Error( "Map resoluton must be more than 0" )
		?
		
		XQuantity = NewXQuantity
		YQuantity = NewYQuantity
		If L_IsPowerOf2( XQuantity ) And L_IsPowerOf2( YQuantity ) Then
			XMask = XQuantity - 1
			YMask = YQuantity - 1
			Masked = 1
		Else 
			XMask = 0
			YMask = 0
			Masked = 0
		End If
	End Method
	
	
	
	Method WrapX:Int( Value:Int )
		Return Value - XQuantity * Floor( 1.0 * Value / XQuantity )
	End Method
	
	
	
	Method WrapY:Int( Value:Int )
		Return Value - YQuantity * Floor( 1.0 * Value / YQuantity )
	End Method
	
	
	
	Method Stretch:LTMap( XMultiplier:Int, YMultiplier:Int )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )

		XMLObject.ManageIntAttribute( "xquantity", XQuantity )
		XMLObject.ManageIntAttribute( "yquantity", YQuantity )
		
		If L_XMLMode = L_XMLGet Then SetResolution( XQuantity, YQuantity )
	End Method
End Type