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
bbdoc: Sprite map is a structure which can contain sprites, draw and perform collision checks between them and other shapes.
about: Operations like drawing and checking collision between large groups of sprites will be faster with use of collision maps.
End Rem
Type LTSpriteMap Extends LTMap
	Field Sprites:TMap = New TMap
	Field Lists:LTSprite[][ , ]
	Field ListSize:Int[ , ]

	Rem
	bbdoc: Width of sprite map cell in units.
	about: See also: #SetCellSize
	End Rem
	Field CellWidth:Double = 1.0
	
	Rem
	bbdoc: Height of sprite map cell in units.
	about: See also: #SetCellSize
	End Rem
	Field CellHeight:Double = 1.0
	
	Rem
	bbdoc: Margins for drawing sprite map in units.
	about: When drawing sprite map, margins define the size of rectangular frame around camera's rectangle in which objects will be also drawn.
	Will be handy if you draw sprite map with objects with XScale / YScale parameters greater than 1.0.
	End Rem
	Field LeftMargin:Double, RightMargin:Double, TopMargin:Double, BottomMargin:Double
	
	Rem
	bbdoc: Flag which defines will be the sprite map sorted by sprite Y coordinates.
	about: False by default.
	End Rem
	Field Sorted:Int = False
	
	Rem
	bbdoc: Flag which defines will be all objects recognized as pivots.
	about: False by default.
	End Rem
	Field PivotMode:Int = False
	
	Field InitialArraysSize:Int = 8
	
	
	
	Method WrapX:Int( Value:Int )
		Return Value & XMask
	End Method
	
	
	
	Method WrapY:Int( Value:Int )
		Return Value & YMask
	End Method
	
	
	
	Method GetClassTitle:String()
		Return "Sprite map"
	End Method
	
	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		Super.SetResolution( NewXQuantity, NewYQuantity )
		
		?debug
		If Not Masked Then L_Error( "Map resoluton must be power of 2" )
		?
		
		Lists = New LTSprite[][ NewXQuantity, NewYQuantity ]
		ListSize = New Int[ NewXQuantity, NewYQuantity ]
		For Local Y:Int = 0 Until NewYQuantity
			For Local X:Int = 0 Until NewXQuantity
				Lists[ X, Y ] = New LTSprite[ InitialArraysSize ]
			Next
		Next
	End Method
	
	
	
	Rem
	bbdoc: Sets cell size of sprite map.
	End Rem
	Method SetCellSize( NewCellWidth:Double, NewCellHeight:Double )
		CellWidth = NewCellWidth
		CellHeight = NewCellHeight
	End Method
	
	
	
	Rem
	bbdoc: Sets all margins to single value.
	End Rem
	Method SetBorder( Border:Double )
		SetMargins( Border, Border, Border, Border )
	End Method
	
	
	
	Rem
	bbdoc: Sets margins of the map.
	End Rem
	Method SetMargins( NewLeftMargin:Double, NewTopMargin:Double, NewRightMargin:Double, NewBottomMargin:Double )
		LeftMargin = NewLeftMargin
		TopMargin = NewTopMargin
		RightMargin = NewRightMargin
		BottomMargin = NewBottomMargin
	End Method
	
	
	
	'Deprecated
	Method GetSprites:TMap()
		Return Sprites
	End Method
	
	
	' ==================== Drawing ===================	
	
	Rem
	bbdoc: Draws all objects of sprite map which are in cells under camera's rectangle plus margins.
	End Rem
	Method Draw()
		DrawUsingVisualizer( Null )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		If Visible Then
			Local ScreenMinX:Double, ScreenMinY:Double, ScreenMaxX:Double, ScreenMaxY:Double
			L_GetEscribedRectangle( LeftMargin, TopMargin, RightMargin, BottomMargin, ScreenMinX, ScreenMinY, ScreenMaxX, ScreenMaxY )
			
			Local MapX1:Int = Floor( ScreenMinX / CellWidth )
			Local MapY1:Int = Floor( ScreenMinY / CellHeight )
			Local MapX2:Int = Floor( ScreenMaxX / CellWidth )
			Local MapY2:Int = Floor( ScreenMaxY / CellHeight )
			
			Local SpriteMap:TMap = New TMap
			
			Local XN:Int[]
			If Sorted Then XN = New Int[ MapX2 - MapX1 + 1 ]
			
			For Local Y:Int = MapY1 To MapY2
				Local MaskedY:Int = Y & YMask
				Local MaxY:Double = ( Y + 1 ) * CellHeight
				If Sorted Then
					Repeat
						Local MinY:Double
						Local StoredX:Int
						Local StoredSprite:LTSprite = Null
						For Local X:Int = 0 To MapX2 - MapX1
							Local MaskedX:Int = X & YMask
							Local N:Int = XN[ X ]
							if N >= ListSize[ MaskedX, MaskedY ] Then Continue
							Local Sprite:LTSprite = Lists[ MaskedX, MaskedY ][ N ]
							If Sprite.Y >= MaxY Then Continue
							If Not StoredSprite Or Sprite.Y < MinY Then
								MinY = Sprite.Y
								StoredX = X
								StoredSprite = Sprite
							End If
						Next
						If Not StoredSprite Then Exit
						
						If Not SpriteMap.Contains( StoredSprite ) Then
							If Vis Then
								Vis.DrawUsingSprite( StoredSprite )
							Else
								StoredSprite.Draw()
							End If
							SpriteMap.Insert( StoredSprite, Null )
						End If
						
						XN[ StoredX ] :+ 1
					Forever
				Else
					For Local X:Int = MapX1 To MapX2
						Local MaskedX:Int = X & XMask
						Local Array:LTSprite[] = Lists[ MaskedX, MaskedY ]
						For Local N:Int = 0 Until ListSize[ MaskedX, MaskedY ]
							Local Sprite:LTSprite = LTSprite( Array[ N ] )
							If Not SpriteMap.Contains( Sprite ) Then
								If Vis Then
									Sprite.DrawUsingVisualizer( Vis )
								Else
									Sprite.Draw()
								End If
								SpriteMap.Insert( Sprite, Null )
							End If
						Next
					Next
				End If
			Next
		End If
	End Method
		
	' ==================== Insert / remove objects ====================
	
	Rem
	bbdoc: Inserts a sprite into sprite map
	about: When PivotMode is set to True, insertion will be faster.
	
	See also: #RemoveSprite
	End Rem
	Method InsertSprite( Sprite:LTSprite, ChangeSpriteMapField:Int = True )
		Sprites.Insert( Sprite, Null )
		If PivotMode Then
			InsertSpriteIntoList( Sprite, Int( Sprite.X / CellWidth ) & XMask, Int( Sprite.Y / CellHeight ) & YMask )
		Else
			Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / CellWidth )
			Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / CellHeight )
			Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - L_Inaccuracy ) / CellWidth )
			Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - L_Inaccuracy ) / CellHeight )
			
			For Local Y:Int = MapY1 To MapY2
				For Local X:Int = MapX1 To MapX2
					InsertSpriteIntoList( Sprite, X & XMask, Y & YMask )
				Next
			Next
		End If
		If ChangeSpriteMapField Then Sprite.SpriteMap = Self
	End Method
	
	
	
	Method InsertSpriteIntoList( Sprite:LTSprite, MapX:Int, MapY:Int )
		Local Array:LTSprite[] = Lists[ MapX, MapY ]
		Local Size:Int = ListSize[ MapX, MapY ]
		If Array.Length = Size Then 
			Array = Array + Array
			Lists[ MapX, MapY ] = Array
		End If
		
		Array[ Size ] = Sprite
		If Sorted Then
			For Local N:Int = 0 Until Size
				If Sprite.Y < Array[ N ].Y Then
					For Local M:Int = Size - 1 To N Step -1
						Array[ M + 1 ] = Array[ M ]
					Next
					Array[ N ] = Sprite
					Exit
				End If
			Next
		End If
		
		ListSize[ MapX, MapY ] :+ 1
	End Method
	
	
	
	Rem
	bbdoc: Removes sprite from sprite map.
	about: When PivotMode is set to True, removal will be faster.
	
	See also: #InsertSprite
	End Rem
	Method RemoveSprite( Sprite:LTSprite, ChangeSpriteMapField:Int = True )
		Sprites.Remove( Sprite )
		If PivotMode Then
			RemoveSpriteFromList( Sprite, Int( Sprite.X / CellWidth ) & XMask, Int( Sprite.Y / CellHeight ) & YMask )
		Else
			Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / CellWidth )
			Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / CellHeight )
			Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - L_Inaccuracy ) / CellWidth )
			Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - L_Inaccuracy ) / CellHeight )
			
			For Local Y:Int = MapY1 To MapY2
				For Local X:Int = MapX1 To MapX2
					RemoveSpriteFromList( Sprite, X & XMask, Y & YMask )
				Next
			Next
		End If
		If ChangeSpriteMapField Then Sprite.SpriteMap = Null
	End Method
	
	
	
	Method RemoveSpriteFromList( Sprite:LTSprite, MapX:Int, MapY:Int )
		Local Array:LTSprite[] = Lists[ MapX, MapY ]
		Local Size:Int = ListSize[ MapX, MapY ]
		For Local N:Int = 0 Until Size
			If Array[ N ] = Sprite Then
				If Sorted Then
					For Local M:Int = N + 1 Until Size
						Array[ M - 1 ] = Array[ M ]
					Next
				Else
					Array[ N ] = Array[ Size - 1 ]
				End If
				ListSize[ MapX, MapY ] :- 1
				Return
			End If
		Next
	End Method
	
	
	Rem
	bbdoc: Clears sprite map.
	End Rem
	Method Clear()
		Sprites.Clear()
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				ListSize[ X, Y ] = 0
			Next
		Next
	End Method
	
	' ==================== Shape management ====================
	
	Method Load:LTShape()
		Local NewSpriteMap:LTSpriteMap = LTSpriteMap( LoadShape() )
		For Local ChildSprite:LTSprite = Eachin Sprites.Keys()
			NewSpriteMap.InsertSprite( LTSprite( ChildSprite.LoadShape() ) )
		Next
		Return NewSpriteMap
	End Method
	
	
	
	Method FindShapeWithParameterID:LTShape( ParameterName:String, ParameterValue:String, ShapeTypeID:TTypeID, IgnoreError:Int = False )
		For Local ChildShape:LTShape = EachIn Sprites.Keys()
			If Not ShapeTypeID Or TTypeId.ForObject( ChildShape ) = ShapeTypeID Then
				If Not ParameterName Or ChildShape.GetParameter( ParameterName ) = ParameterValue Then Return Self
			End If
			
			Local SpriteGroup:LTSpriteGroup = LTSpriteGroup( ChildShape )
			If SpriteGroup Then 
				Local Shape:LTShape = SpriteGroup.FindShapeWithParameterID( ParameterName, ParameterValue, ShapeTypeID, True )
				If Shape Then Return Shape
			End If
		Next
		
		Super.FindShapeWithParameterID( ParameterName, ParameterValue, ShapeTypeID, IgnoreError )
	End Method

		
	
	Method InsertBeforeShape:Int( Shape:LTShape = Null, ShapesList:TList = Null, BeforeShape:LTShape )
		If Sprites.Contains( BeforeShape ) Then
			Local Sprite:LTSprite = LTSprite( Shape )
			If Sprite Then InsertSprite( Sprite )
			If ShapesList Then
				For Local ListSprite:LTSprite =Eachin ShapesList
					InsertSprite( ListSprite )
				Next
			End If
		Else
			For Local SpriteGroup:LTSpriteGroup = Eachin Sprites.Keys()
				SpriteGroup.InsertBeforeShape( Shape, ShapesList, BeforeShape )
			Next
		End If
	End Method
	
	
	
	Method Remove( Shape:LTShape )
		Local Sprite:LTSprite = LTSprite( Shape )
		If Sprite Then
			RemoveSprite( Sprite )
			For Local SpriteGroup:LTSpriteGroup = Eachin Sprites.Keys()
				SpriteGroup.Remove( Sprite )
			Next
		End If
	End Method
	
	
	
	Method RemoveAllOfTypeID( TypeID:TTypeID )
		For Local KeyValue:TKeyValue = Eachin Sprites
			If TTypeId.ForObject( KeyValue.Key() ) = TypeID Then
				Local Sprite:LTSprite = LTSprite( KeyValue.Value() )
				RemoveSprite( Sprite )
			End If
			
			Local SpriteGroup:LTSpriteGroup = LTSpriteGroup( KeyValue.Value() )
			If SpriteGroup Then SpriteGroup.RemoveAllOfTypeID( TypeID )
		Next
	End Method
	
	' ==================== Other ===================	
	
	Method ObjectEnumerator:TNodeEnumerator()
		Return Sprites.Keys().ObjectEnumerator()
	End Method
	
	
	
	Method Init()
		For Local Sprite:LTSprite = Eachin Sprites.Keys()
			Sprite.Init()
		Next
	End Method

	
	
	Method Act()
		For Local Sprite:LTSprite = Eachin Sprites.Keys()
			Sprite.Act()
		Next
	End Method
	
	
	
	Method Update()
		For Local Obj:LTShape = Eachin Sprites.Keys()
			Obj.Update()
		Next
	End Method
	
	
	
	Rem
	bbdoc: Creates collision map.
	about: You should specify cell quantities and size.
	
	See also: #CreateForShape
	End Rem
	Function Create:LTSpriteMap( XQuantity:Int, YQuantity:Int, CellWidth:Double = 1.0, CellHeight:Double = 1.0, Sorted:Int = False, PivotMode:Int = False )
		Local Map:LTSpriteMap = New LTSpriteMap
		Map.SetResolution( XQuantity, YQuantity )
		Map.CellWidth = CellWidth
		Map.CellHeight = CellHeight
		Map.Sorted = Sorted
		Map.PivotMode = PivotMode
		Return Map
	End Function
	
	
	
	Method CopyTo( Shape:LTShape )
		CopyShapeTo( Shape )
		Local SpriteMap:LTSpriteMap = LTSpriteMap( Shape )
		
		?debug
		If Not SpriteMap Then L_Error( "Trying to copy sprite map ~q" + Shape.GetTitle() + "~q data to non-sprite-map" )
		?
		
		SpriteMap.SetResolution( XQuantity, YQuantity )
		SpriteMap.CellWidth = CellWidth
		SpriteMap.CellHeight = CellHeight
		SpriteMap.LeftMargin = LeftMargin
		SpriteMap.RightMargin = RightMargin
		SpriteMap.TopMargin = TopMargin
		SpriteMap.BottomMargin = BottomMargin
		SpriteMap.Sorted = Sorted
		SpriteMap.PivotMode = PivotMode
	End Method
	
	
	
	Method Clone:LTShape()
		Local NewSpriteMap:LTSpriteMap = New LTSpriteMap
		CopyTo( NewSpriteMap )
		For Local Sprite:LTSprite = Eachin Sprites
			NewSpriteMap.InsertSprite( Sprite )
		Next
		Return NewSpriteMap
	End Method
	
	
	
	Rem
	bbdoc: Creates collision map using existing shape.
	about: Collision map with size not less than shape size will be created. You can specify cell size either.
	Use this function ob layer bounds or layer tilemap which are covers all level to maximize performance.
	End Rem
	Function CreateForShape:LTSpriteMap( Shape:LTShape, CellSize:Double = 1.0, Sorted:Int = False )
		Return Create( L_ToPowerOf2( Shape.Width / CellSize ), L_ToPowerOf2( Shape.Height / CellSize ), CellSize, CellSize, Sorted )
	End Function
	
	
	
	Method ShowModels:Int( Y:Int = 0, Shift:String = "" )
		If BehaviorModels.IsEmpty() Then
			If Sprites.IsEmpty() Then Return Y
			DrawText( Shift + GetTitle() + ":", 0, Y )
	    	Y :+ 16
		Else
			Y = Super.ShowModels( Y, Shift )
		End If
		For Local Shape:LTShape = Eachin Sprites.Keys()
			Y = Shape.ShowModels( Y, Shift + " " )
		Next
		Return Y
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		XMLObject.ManageDoubleAttribute( "cell-width", CellWidth, 1.0 )
		XMLObject.ManageDoubleAttribute( "cell-height", CellHeight, 1.0 )
		XMLObject.ManageDoubleAttribute( "left-margin", LeftMargin )
		XMLObject.ManageDoubleAttribute( "right-margin", RightMargin )
		XMLObject.ManageDoubleAttribute( "top-margin", TopMargin )
		XMLObject.ManageDoubleAttribute( "bottom-margin", BottomMargin )
		XMLObject.ManageIntAttribute( "sorted", Sorted )
		XMLObject.ManageIntAttribute( "pivot-mode", PivotMode )
		XMLObject.ManageIntAttribute( "arrays-size", InitialArraysSize, 8 )
		
		Super.XMLIO( XMLObject )
		
		If L_XMLMode = L_XMLGet Then
			For Local SpriteXMLObject:LTXMLObject = Eachin XMLObject.Children
				InsertSprite( LTSprite( SpriteXMLObject.ManageObject( Null ) ) )
			Next
		Else
			For Local Sprite:LTSprite = Eachin Sprites.Keys()
				Local NewXMLObject:LTXMLObject = New LTXMLObject
				NewXMLObject.ManageObject( Sprite )
				XMLObject.Children.AddLast( NewXMLObject )
			Next
		End If
	End Method
End Type