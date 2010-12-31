'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTTileSet.bmx"

Type LTIntMap Extends LTMap
	Field Value:Int[ , ] = New Int[ 1, 1 ]
	
	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		XQuantity = NewXQuantity
		YQuantity = NewYQuantity
		Super.SetResolution( XQuantity, YQuantity )
		Value = New Int[ XQuantity, YQuantity ]
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
	End Method

		
	
	Method EnframeBy( Tileset:LTTileset )
		Local TileType:Int[] = Tileset.TileType

		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				For Local N:Int = 0 Until Tileset.TileQuantity
					If TileType[ N ] = TileType[ Value[ X, Y ] ] And Tileset.TileRules[ N ] Then
						Local Passed:Int = True
						For Local Rule:LTTileRule = Eachin Tileset.TileRules[ N ]
							If Masked Then
								If TileType[ Value[ ( X + Rule.DX ) & XMask, ( Y + Rule.DY ) & YMask ] ] <> Rule.TileType Then
									Passed = False
									Exit
								End If
							Else
								If TileType[ Value[ WrapX( X + Rule.DX ), WrapY( Y + Rule.DY ) ] ] <> Rule.TileType Then
									Passed = False
									Exit
								End If
							End If
						Next
						
						If Passed Then
							Value[ X, Y ] = N
							Exit
						End If
					End If
				Next
			Next
		Next
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		If L_XMLMode = L_XMLGet Then
			Value = New Int[ XQuantity, YQuantity ]
			Local Y:Int = 0
			For Local XMLRow:LTXMLObject = Eachin XMLObject.Children
				Local ArrayData:String = XMLRow.GetAttribute( "data" ) + ","
				Local X:Int = 0
				Local Comma:Int = -1
				Local LastArraySymbol:Int = Len( ArrayData ) - 1
				While Comma < LastArraySymbol
					Local NextComma:Int = ArrayData.Find( ",", Comma + 1 )
					Value[ X, Y ] = ArrayData[ Comma + 1..NextComma ].ToInt()
					Comma = NextComma
					X :+ 1
				Wend
				Y :+ 1
			Next
		Else
			For Local Y:Int = 0 Until YQuantity
				Local XMLRow:LTXMLObject = New LTXMLObject
				XMLRow.Name = "Row"
				Local ArrayData:String = ""
				For Local X:Int = 0 Until XQuantity
					ArrayData :+ "," + Value[ X, Y ]
				Next
				XMLRow.SetAttribute( "data", ArrayData[ 1.. ] )
				XMLObject.Children.AddLast( XMLRow )
			Next
		End If
	End Method
End Type