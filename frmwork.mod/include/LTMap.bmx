'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Common object for maps
about: Map is object with 2d array.
End Rem
Type LTMap Extends LTShape
	Rem
	bbdoc: Dimensions of the array
	End Rem
	Field XQuantity:Int, YQuantity:Int
	
	Field XMask:Int, YMask:Int, Masked:Int
	
	
	
	Rem
	bbdoc: Sets resolution of the map.
	about: For some objects resolutions which are powers of 2 are necessary or will work faster.
	End Rem
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
	
	
	
	Rem
	bbdoc: Wrapping first index.
	returns: Wrapped first index of the map
	about: Wrapping means to keep index in the dimension limits.
	For example, if you will wrap index "5" for map with resolution ( 4x4 ) it will be keeped in 0...3 interval and turned to 1 as 5 + 4 * ( -1 ) = 1.
	If you wrap index "-2" for the same map, you will get 2 as -2 + 4 * 1 = 2.
	Index "
	End Rem
	Method WrapX:Int( Value:Int )
		Return Value - XQuantity * Floor( 1.0 * Value / XQuantity )
	End Method
	
	
	Rem
	bbdoc: Wrapping second map index.
	returns: Wrapped second index of the map.
	about: See #WrapX.
	End Rem
	Method WrapY:Int( Value:Int )
		Return Value - YQuantity * Floor( 1.0 * Value / YQuantity )
	End Method
	
	
	
	Rem
	bbdoc: Stretches the map by integer values.
	End Rem
	Method Stretch:LTMap( XMultiplier:Int, YMultiplier:Int )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )

		XMLObject.ManageIntAttribute( "xquantity", XQuantity )
		XMLObject.ManageIntAttribute( "yquantity", YQuantity )
		
		If L_XMLMode = L_XMLGet Then SetResolution( XQuantity, YQuantity )
	End Method
End Type