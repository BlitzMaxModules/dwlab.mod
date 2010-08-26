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

Type LTTileMap Extends LTRectangle
	Field Frame:Int[ , ] = New Int[ 1, 1 ]

	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingTileMap( Self )
	End Method
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingTileMap( Self )
	End Method
	
	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		?debug
		L_Assert( NewXQuantity > 0, "TileMap resoluton must be more than 0" )
		L_Assert( NewYQuantity > 0, "TileMap resoluton must be more than 0" )
		?
		
		Frame = New Int[ NewXQuantity, NewYQuantity ]
	End Method
	
	
	
	Method GetXQuantity:Int()
		Return Frame.Dimensions()[ 0 ]
	End Method
	
	
	
	Method GetYQuantity:Int()
		Return Frame.Dimensions()[ 1 ]
	End Method
	
	
	
	Method GetXMask:Int()
		If L_IsPowerOf2( GetXQuantity() ) Then Return GetXQuantity() - 1
	End Method
	
	
	
	Method GetYMask:Int()
		If L_IsPowerOf2( GetYQuantity() ) Then Return GetYQuantity() - 1
	End Method
	
	' ==================== Manipulations ====================	
	
	Method Stretch:LTTileMap( XMultiplier:Int, YMultiplier:Int )
		Local XQuantity:Int = GetXQuantity()
		Local YQuantity:Int = GetYQuantity()
		Local NewArray:Int[ XQuantity * XMultiplier, YQuantity * YMultiplier ]
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				For Local XX:Int = 0 Until XMultiplier
					For Local YY:Int = 0 Until YMultiplier
						NewArray[ X * XMultiplier + XX, Y * YMultiplier + YY ] = Frame[ X, Y ]
					Next
				Next
			Next
		Next
		Frame = NewArray
	End Method

		
	
	Method EnframeBy( Tileset:LTTileset )
		Local TileType:Int[] = Tileset.TileType

		Local XQuantity:Int = GetXQuantity()
		Local YQuantity:Int = GetYQuantity()
		Local XMask:Int = GetXMask() 
		Local YMask:Int = GetYMask()
		Local Wrapped:Int = XMask And YMask
		
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				For Local N:Int = 0 Until Tileset.TileQuantity
					If TileType[ N ] = TileType[ Frame[ X, Y ] ] And Tileset.TileRules[ N ] Then
						Local Passed:Int = True
						For Local Rule:LTTileRule = Eachin Tileset.TileRules[ N ]
							If Wrapped Then
								If TileType[ Frame[ ( X + Rule.DX ) & XMask, ( Y + Rule.DY ) & YMask ] ] <> Rule.TileType Then
									Passed = False
									Exit
								End If
							Else
								If TileType[ Frame[ L_Wrap( X + Rule.DX, XQuantity ), L_Wrap( Y + Rule.DY, YQuantity ) ] ] <> Rule.TileType Then
									Passed = False
									Exit
								End If
							End If
						Next
						
						If Passed Then
							Frame[ X, Y ] = N
							Exit
						End If
					End If
				Next
			Next
		Next
	End Method
End Type