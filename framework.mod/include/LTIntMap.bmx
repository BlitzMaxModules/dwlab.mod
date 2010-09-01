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
		Super.SetResolution( NewXQuantity, NewYQuantity )
		Value = New Int[ NewXQuantity, NewYQuantity ]
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
							If XMask Then
								If TileType[ Value[ ( X + Rule.DX ) & XMask, ( Y + Rule.DY ) & YMask ] ] <> Rule.TileType Then
									Passed = False
									Exit
								End If
							Else
								If TileType[ Value[ L_Wrap( X + Rule.DX, XQuantity ), L_Wrap( Y + Rule.DY, YQuantity ) ] ] <> Rule.TileType Then
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
End Type