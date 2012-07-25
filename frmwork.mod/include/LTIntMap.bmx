'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTTileMap.bmx"

Rem
bbdoc: IntMap is basically a 2d int array.
End Rem
Type LTIntMap Extends LTMap
	Field Value:Int[ , ]
	
	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		?debug
		If NewXQuantity <= 0 And NewYQuantity <= 0 Then L_Error( "Map resoluton must be more than 0" )
		?
		
		Local NewValue:Int[ , ] = New Int[ NewXQuantity, NewYQuantity ]
		If Value Then
			For Local Y:Int = 0 Until Min( YQuantity, NewYQuantity )
				For Local X:Int = 0 Until Min( XQuantity, NewXQuantity )
					NewValue[ X, Y ] = Value[ X, Y ]
				Next
			Next
		End If
		Value = NewValue
		Super.SetResolution( NewXQuantity, NewYQuantity )
	End Method
	
	' ==================== Loading / saving ====================	
	
	Function FromFile:LTIntMap( Filename:String )
		Local Map:LTIntMap = New LTIntMap
		Local File:TStream = ReadFile( Filename )
		Local XQuantity:Int = ReadInt( File )
		Local YQuantity:Int = ReadInt( File )
		Map.SetResolution( XQuantity, YQuantity )
		
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				Map.Value[ X, Y ] = ReadInt( File )
			Next
		Next
		
		CloseFile( File )
		Return Map
	End Function
	
	' ==================== Manipulations ====================	
	
	Method Stretch:LTIntMap( XMultiplier:Int, YMultiplier:Int )
		Local NewArray:Int[ XQuantity * XMultiplier, YQuantity * YMultiplier ]
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				For Local XX:Int = 0 Until XMultiplier
					For Local YY:Int = 0 Until YMultiplier
						NewArray[ X * XMultiplier + XX, Y * YMultiplier + YY ] = Value[ X, Y ]
					Next
				Next
			Next
		Next
		Value = NewArray
		Super.SetResolution( XQuantity * XMultiplier, YQuantity * YMultiplier )
	End Method
End Type