'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_ProlongTiles:Int = True

Type LTTileset Extends LTObject
	Field Categories:TList = New TList
	Field TilesQuantity:Int
	Field TileCategory:Int[]
	Field BlockWidth:Int[]
	Field BlockHeight:Int[]
	
	
	
	Method Init()
		TileCategory = New Int[ TilesQuantity ]
		For Local N:Int = 0 Until TilesQuantity
			TileCategory[ N ] = -1
		Next
		
		Local OldDimension:Int = BlockWidth.Dimensions()[ 0 ]
		If OldDimension <> TilesQuantity Then
			Local NewWidth:Int[] = New Int[ TilesQuantity ]
			Local NewHeight:Int[] = New Int[ TilesQuantity ]
			For Local N:Int = 0 Until Min( OldDimension, TilesQuantity )
				NewWidth[ N ] = BlockWidth[ N ]
				NewHeight[ N ] = BlockHeight[ N ]
			Next
			BlockWidth = NewWidth
			BlockHeight = NewHeight
		End If
		
		Local CatNum:Int = 0
		For Local Category:LTTileCategory = Eachin Categories
			Category.Num = CatNum
			For Local Rule:LTTileRule = Eachin Category.TileRules
				For Local N:Int = 0 Until Rule.TileNums.Dimensions()[ 0 ]
					If Rule.TileNums[ N ] >= TilesQuantity Then Rule.TileNums[ N ] = TilesQuantity - 1
					TileCategory[ Rule.TileNums[ N ] ] = Category.Num
				Next
			Next
			CatNum :+ 1
		Next
		
		For Local Category:LTTileCategory = Eachin Categories
			For Local Rule:LTTileRule = Eachin Category.TileRules
				If Rule.X >= Rule.XDivider Then Rule.X = Rule.XDivider - 1
				If Rule.Y >= Rule.YDivider Then Rule.Y = Rule.YDivider - 1
				For Local Pos:LTTilePos = Eachin Rule.TilePositions
					If Pos.TileNum >= TilesQuantity Then Pos.TileNum = TilesQuantity - 1
					Pos.Category = TileCategory[ Pos.TileNum ]
				Next
			Next
		Next
	End Method
	
	
	
	Method Enframe( TileMap:LTTileMap, X:Int, Y:Int )
		Local CatNum:Int = TileCategory[ TileMap.FrameMap.Value[ X, Y ] ]
		If CatNum < 0 Then Return
		Local Category:LTTileCategory = LTTileCategory( Categories.ValueAtIndex( CatNum ) )
		For Local Rule:LTTileRule = Eachin Category.TileRules
			If X Mod Rule.XDivider <> Rule.X Or Y Mod Rule.YDivider <> Rule.Y Then Continue
			
			Local Passed:Int = True
			For Local Pos:LTTilePos = Eachin Rule.TilePositions
				Local TileCategory:Int = GetTileCategory( TileMap, X + Pos.DX, Y + Pos.DY )
				If Pos.Category = CatNum Then
					If TileCategory <> CatNum Then
						Passed = False
						Exit
					End If
				Elseif Pos.Category = -1 Then
					If TileCategory = CatNum Then
						Passed = False
						Exit
					End If				
				Else
					If TileCategory <> Pos.Category Then
						Passed = False
						Exit
					End If				
				End If
			Next
			
			If Passed Then
				TileMap.FrameMap.Value[ X, Y ] = Rule.TileNums[ Rand( 0, Rule.TileNums.Dimensions()[ 0 ] - 1 ) ]
				Return
			End If
		Next
	End Method
	
	
	
	Method GetTileCategory:Int( TileMap:LTTileMap, X:Int, Y:Int )
		Local FrameMap:LTIntMap = TileMap.FrameMap
		If TileMap.Wrapped Then
			If FrameMap.Masked Then
				X = X & FrameMap.XMask
				Y = Y & FrameMap.YMask
			Else
				X = FrameMap.WrapX( X )
				Y = FrameMap.WrapY( Y )
			End If
		Else
			If L_ProlongTiles Then
				If X < 0 Then
					X = 0
				ElseIf X >= FrameMap.XQuantity
					X = FrameMap.XQuantity - 1
				End If
				
				If Y < 0 Then
					Y = 0
				ElseIf Y >= FrameMap.YQuantity
					Y = FrameMap.YQuantity - 1
				End If
			Else
				If X < 0 Or X >= FrameMap.XQuantity Or Y < 0 Or Y >= FrameMap.YQuantity Then Return -1
			End If
		End If
		Return TileCategory[ FrameMap.Value[ X, Y ] ]
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "tiles-quantity", TilesQuantity )
		XMLObject.ManageIntArrayAttribute( "block-width", BlockWidth )
		XMLObject.ManageIntArrayAttribute( "block-height", BlockHeight )
		XMLObject.ManageChildList( Categories )
		if L_XMLMode = L_XMLGet Then Init()
	End Method
End Type



Type LTTileCategory Extends LTObject
	Field Num:Int
	Field TileRules:TList = New TList
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageChildList( TileRules )
	End Method
End Type



Type LTTileRule Extends LTObject
	Field TileNums:Int[]
	Field TilePositions:TList = New TList
	Field X:Int, Y:Int
	Field XDivider:Int = 1, YDivider:Int = 1
	
	
	
	Method TilesQuantity:Int()
		Return TileNums.Dimensions()[ 0 ]
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntArrayAttribute( "tilenums", TileNums )
		XMLObject.ManageIntAttribute( "x", X )
		XMLObject.ManageIntAttribute( "y", Y )
		XMLObject.ManageIntAttribute( "xdiv", XDivider, 1 )
		XMLObject.ManageIntAttribute( "ydiv", YDivider, 1 )
		XMLObject.ManageChildList( TilePositions )
	End Method
End Type



Type LTTilePos Extends LTObject
	Field DX:Int, DY:Int
	Field TileNum:Int
	Field Category:Int
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "dx", DX )
		XMLObject.ManageIntAttribute( "dy", DY )
		XMLObject.ManageIntAttribute( "tilenum", TileNum )
	End Method
End Type