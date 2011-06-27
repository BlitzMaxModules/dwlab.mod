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
bbdoc: Prolonging tiles flag.
about: Defines the method of recognizing tiles outside tilemap.
End Rem
Global L_ProlongTiles:Int = True

Rem
bbdoc: 
returns: 
about: 
End Rem
Type LTTileSet Extends LTObject
	Field Image:LTImage
	Field CollisionShape:LTShape[]
	Field BlockWidth:Int[]
	Field BlockHeight:Int[]
	Field Categories:TList = New TList
	Field TilesQuantity:Int
	Field TileCategory:Int[]
	
	
	
	Rem
	bbdoc: Updates tileset when tiles quantity was changed.
	about: Execute this method every time you change TilesQuantity parameter.
	End Rem
	Method RefreshTilesQuantity()
		If Not Image Then Return
		Local NewTilesQuantity:Int = Image.FramesQuantity()
		Local NewCollisionShape:LTShape[] = New LTShape[ NewTilesQuantity ]
		Local NewBlockWidth:Int[] = New Int[ NewTilesQuantity ]
		Local NewBlockHeight:Int[] = New Int[ NewTilesQuantity ]
		For Local N:Int = 0 Until Min( TilesQuantity, NewTilesQuantity )
			NewBlockWidth[ N ] = BlockWidth[ N ]
			NewBlockHeight[ N ] = BlockHeight[ N ]
			NewCollisionShape[ N ] = CollisionShape[ N ]
		Next
		BlockWidth = NewBlockWidth
		BlockHeight = NewBlockHeight
		CollisionShape = NewCollisionShape
		TilesQuantity = NewTilesQuantity
		Init()
	End Method
	
	
	
	Rem
	bbdoc: Enframes the tile of given tilemap with given coordinates.
	End Rem
	Method Enframe( TileMap:LTTileMap, X:Int, Y:Int )
		Local CatNum:Int = TileCategory[ TileMap.Value[ X, Y ] ]
		If CatNum < 0 Then Return
		Local Category:LTTileCategory = LTTileCategory( Categories.ValueAtIndex( CatNum ) )
		For Local Rule:LTTileRule = Eachin Category.TileRules
			If X Mod Rule.XDivider <> Rule.X Or Y Mod Rule.YDivider <> Rule.Y Then Continue
			
			Local Passed:Int = True
			For Local Pos:LTTilePos = Eachin Rule.TilePositions
				Local TileCategory:Int = GetTileCategory( TileMap, X + Pos.DX, Y + Pos.DY )
				if Pos.Category = -1 Then
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
				TileMap.Value[ X, Y ] = Rule.TileNums[ Rand( 0, Rule.TileNums.Dimensions()[ 0 ] - 1 ) ]
				Return
			End If
		Next
	End Method
	
	
	
	Method GetTileCategory:Int( TileMap:LTTileMap, X:Int, Y:Int )
		If TileMap.Wrapped Then
			If TileMap.Masked Then
				X = X & TileMap.XMask
				Y = Y & TileMap.YMask
			Else
				X = TileMap.WrapX( X )
				Y = TileMap.WrapY( Y )
			End If
		Else
			If L_ProlongTiles Then
				If X < 0 Then
					X = 0
				ElseIf X >= TileMap.XQuantity
					X = TileMap.XQuantity - 1
				End If
				
				If Y < 0 Then
					Y = 0
				ElseIf Y >= TileMap.YQuantity
					Y = TileMap.YQuantity - 1
				End If
			Else
				If X < 0 Or X >= TileMap.XQuantity Or Y < 0 Or Y >= TileMap.YQuantity Then Return -1
			End If
		End If
		Return TileCategory[ TileMap.Value[ X, Y ] ]
	End Method
	
	
	
	Rem
	bbdoc: Updates tileset.
	about: This method will be automatically executed after loading tileset. Also execute it after forming or changing tileset categories.
	End Rem
	Method Update()
		TileCategory = New Int[ TilesQuantity ]
		For Local N:Int = 0 Until TilesQuantity
			TileCategory[ N ] = -1
		Next
		
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
	
	
	
	Rem
	bbdoc: Creates tileset with given image.
	returns: Created tileset.
	End Rem
	Function Create:LTTileSet( Image:LTImage )
		Local TileSet:LTTileSet = New LTTileSet
		TileSet.Image = Image
		TileSet.RefreshTilesQuantity()
		Return TileSet
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Image = LTImage( XMLObject.ManageObjectField( "image", Image ) )
		XMLObject.ManageIntAttribute( "tiles-quantity", TilesQuantity )
		XMLObject.ManageIntArrayAttribute( "block-width", BlockWidth )
		XMLObject.ManageIntArrayAttribute( "block-height", BlockHeight )
		XMLObject.ManageChildList( Categories )
		
		If L_XMLMode = L_XMLGet Then
			CollisionShape = New LTShape[ TilesQuantity ]
			
			Local ArrayXMLObject:LTXMLObject = XMLObject.GetField( "collision-shapes" )
			If ArrayXMLObject Then
				Local N:Int = 0
				For Local ChildXMLObject:LTXMLObject = EachIn ArrayXMLObject.Children
					If ChildXMLObject.Name <> "null" Then CollisionShape[ N ] = LTShape( ChildXMLObject.ManageObject( Null ) )
					N :+ 1
				Next
			End If
			
			Init()
		Else
			Local ArrayXMLObject:LTXMLObject = New LTXMLObject
			ArrayXMLObject.Name = "ShapeArray"
			XMLObject.SetField( "collision-shapes", ArrayXMLObject )
			For Local N:Int = 0 Until CollisionShape.Dimensions()[ 0 ]
				Local NewXMLObject:LTXMLObject = New LTXMLObject
				If CollisionShape[ N ] Then
					NewXMLObject.ManageObject( CollisionShape[ N ] )
				Else
					NewXMLObject.Name = "Null"
				End If
				ArrayXMLObject.Children.AddLast( NewXMLObject )
			Next
		End If
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