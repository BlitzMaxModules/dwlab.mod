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
bbdoc: Collision map is a structure which can contain sprites, draw and perform collision checks between them and other shapes.
about: Operations like drawing and checking collision between large groups of sprites will be faster with use of collision maps.
End Rem
Type LTSpriteMap Extends LTMap
	Field Sprites:TList[ , ]
	
	Rem
	bbdoc: Width of collision map cell in units.
	about: See also: #SetCellSize
	End Rem
	Field CellWidth:Double = 1.0
	
	Rem
	bbdoc: Height of collision map cell in units.
	about: See also: #SetCellSize
	End Rem
	Field CellHeight:Double = 1.0
	
	Rem
	bbdoc: Margins for drawing collision map in units.
	about: When drawing collision map, margins define the size of rectangular frame around camera's rectangle in which objects will be also drawn.
	Will be handy if you draw collision map with objects with XScale / YScale parameters greater than 1.0.
	End Rem
	Field LeftMargin:Double, RightMargin:Double
	Field TopMargin:Double, BottomMargin:Double
	
	Rem
	bbdoc: Flag which defines will be the collision map sorted by sprite Y coordinates.
	about: False by default.
	End Rem
	Field Sorted:Int = False
	
	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		Super.SetResolution( NewXQuantity, NewYQuantity )
		
		?debug
		If Not Masked Then L_Error( "Map resoluton must be power of 2" )
		?
		
		Sprites = New TList[ NewXQuantity, NewYQuantity ]
		For Local Y:Int = 0 Until NewYQuantity
			For Local X:Int = 0 Until NewXQuantity
				Sprites[ X, Y ] = New TList
			Next
		Next
	End Method
	
	
	
	Rem
	bbdoc: Sets cell size of collision map.
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
	
	
	
	Rem
	bbdoc: Returns all sprite map sprites.
	returns: TMap object with each sprite map sprite as key.
	End Rem
	Method GetSprites:TMap()
		Local Map:TMap = New TMap
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				For Local Sprite:LTSprite = Eachin Sprites[ X, Y ]
					Map.Insert( Sprite, Null )
				Next
			Next
		Next
		Return Map
	End Method
	
	' ==================== Drawing ===================	
	
	Rem
	bbdoc: Draws all objects of collision map which are in cells under camera's rectangle plus margins.
	End Rem
	Method Draw()
		DrawUsingVisualizer( Null )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		If Visible Then
			Local MapX1:Int = Floor( ( L_CurrentCamera.X - 0.5 * L_CurrentCamera.Width - LeftMargin ) / CellWidth )
			Local MapY1:Int = Floor( ( L_CurrentCamera.Y - 0.5 * L_CurrentCamera.Height - TopMargin ) / CellHeight )
			Local MapX2:Int = Floor( ( L_CurrentCamera.X + 0.5 * L_CurrentCamera.Width - L_Inaccuracy + RightMargin ) / CellWidth )
			Local MapY2:Int = Floor( ( L_CurrentCamera.Y + 0.5 * L_CurrentCamera.Height - L_Inaccuracy + BottomMargin ) / CellHeight )
			
			Local SpriteMap:TMap = New TMap
			
			Local XLink:TLink[]
			If Sorted Then XLink = New TLink[ MapX2 - MapX1 + 1 ]
			
			For Local Y:Int = MapY1 To MapY2
				Local MaskedY:Int = Y & YMask
				Local MaxY:Double = ( Y + 1 ) * CellHeight
				If Sorted Then
					For Local X:Int = MapX1 To MapX2
						XLink[ X - MapX1 ] = Sprites[ X & XMask, MaskedY ].FirstLink()
					Next
					
					Repeat
						Local MinY:Double
						Local StoredX:Int
						Local StoredLink:TLink = Null
						For Local X:Int = 0 To MapX2 - MapX1
							Local Link:TLink = XLink[ X ]
							if Not Link Then Continue
							Local Sprite:LTSprite = LTSprite( Link.Value() )
							If Sprite.Y >= MaxY Then Continue
							If Not StoredLink Or Sprite.Y < MinY Then
								MinY = Sprite.Y
								StoredX = X
								StoredLink = Link
							End If
						Next
						If Not StoredLink Then Exit
						
						Local Sprite:LTSprite = LTSprite( StoredLink.Value() )
						If Not SpriteMap.Contains( Sprite ) Then
							If Vis Then
								Vis.DrawUsingSprite( Sprite )
							Else
								Sprite.Draw()
							End If
							SpriteMap.Insert( Sprite, Null )
						End If
						
						XLink[ StoredX ] = StoredLink.NextLink()
					Forever
				Else
					For Local X:Int = MapX1 To MapX2
						For Local Sprite:LTSprite = Eachin Sprites[ X & XMask, MaskedY ]
							If Not SpriteMap.Contains( Sprite ) Then
								If Vis Then
									Vis.DrawUsingSprite( Sprite )
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
	bbdoc: Inserts a sprite into collision map.
	about: Pivot insertion works faster.
	
	See also: #RemoveSprite
	End Rem
	Method InsertSprite( Sprite:LTSprite, ChangeSpriteMapField:Int = True )
		Select Sprite.ShapeType
			Case LTSprite.Pivot
				If Sorted Then
					InsertSpriteTo( Sprite, Int( Sprite.X / CellWidth ) & XMask, Int( Sprite.Y / CellHeight ) & YMask )
				Else
					Sprites[ Int( Sprite.X / CellWidth ) & XMask, Int( Sprite.Y / CellHeight ) & YMask ].AddFirst( Sprite )
				End If
			Default
				Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / CellWidth )
				Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / CellHeight )
				Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - 0.000001 ) / CellWidth )
				Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - 0.000001 ) / CellHeight )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						If Sorted Then
							InsertSpriteTo( Sprite, X & XMask, Y & YMask )
						Else
							Sprites[ X & XMask, Y & YMask ].AddFirst( Sprite )
						End If
					Next
				Next
		End Select
		If ChangeSpriteMapField Then Sprite.SpriteMap = Self
	End Method
	
	
	
	Method InsertSpriteTo( Sprite:LTSprite, MapX:Int, MapY:Int )
		Local List:TList = Sprites[ MapX, MapY ]
		Local Link:TLink = List.FirstLink()
		Repeat
			If Not Link Then
				List.AddLast( Sprite )
				Exit
			End If
			
			Local ListSprite:LTSprite = LTSprite( Link.Value() )
			If Sprite.Y < ListSprite.Y Then
				List.InsertBeforeLink( Sprite, Link )
				Exit
			End If
			
			Link = Link.NextLink()
		Forever
	End Method
	
	
	
	Rem
	bbdoc: Removes a sprite into collision map.
	about: Pivot removal works faster.
	
	See also: #InsertSprite
	End Rem
	Method RemoveSprite( Sprite:LTSprite, ChangeSpriteMapField:Int = True )
		Select Sprite.ShapeType
			Case LTSprite.Pivot
				Sprites[ Int( Sprite.X / CellWidth ) & XMask, Int( Sprite.Y / CellHeight ) & YMask ].Remove( Sprite )
			Default
				Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / CellWidth )
				Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / CellHeight )
				Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - 0.000001 ) / CellWidth )
				Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - 0.000001 ) / CellHeight )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						Sprites[ X & XMask, Y & YMask ].Remove( Sprite )
					Next
				Next
		End Select
		If ChangeSpriteMapField Then Sprite.SpriteMap = Null
	End Method
	
	' ==================== Collisions ===================
	
	Rem
	bbdoc: Creates collision map.
	about: You should specify cell quantities and size.
	
	See also: #CreateForShape
	End Rem
	Function Create:LTSpriteMap( XQuantity:Int, YQuantity:Int, CellWidth:Double = 1.0, CellHeight:Double = 1.0, Sorted:Int = False )
		Local Map:LTSpriteMap = New LTSpriteMap
		Map.SetResolution( XQuantity, YQuantity )
		Map.CellWidth = CellWidth
		Map.CellHeight = CellHeight
		Map.Sorted = Sorted
		Return Map
	End Function
	
	
	
	Rem
	bbdoc: Creates collision map using existing shape.
	about: Collision map with size not less than shape size will be created. You can specify cell size either.
	Use this function ob layer bounds or layer tilemap which are covers all level to maximize performance.
	End Rem
	Function CreateForShape:LTSpriteMap( Shape:LTShape, CellSize:Double = 1.0, Sorted:Int = False )
		Return Create( L_ToPowerOf2( Shape.Width / CellSize ), L_ToPowerOf2( Shape.Height / CellSize ), CellSize, CellSize, Sorted )
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageDoubleAttribute( "cell-width", CellWidth )
		XMLObject.ManageDoubleAttribute( "cell-height", CellHeight )
		XMLObject.ManageDoubleAttribute( "left-margin", LeftMargin )
		XMLObject.ManageDoubleAttribute( "right-margin", RightMargin )
		XMLObject.ManageDoubleAttribute( "top-margin", TopMargin )
		XMLObject.ManageDoubleAttribute( "bottom-margin", BottomMargin )
		XMLObject.ManageIntAttribute( "sorted", Sorted )
		
		If L_XMLMode = L_XMLGet Then
			For Local SpriteXMLObject:LTXMLObject = Eachin XMLObject.Children
				InsertSprite( LTSprite( SpriteXMLObject.ManageObject( Null ) ) )
			Next
		Else
			Local Map:TMap = GetSprites()
			For Local Sprite:LTSprite = Eachin Map.Keys()
				Local NewXMLObject:LTXMLObject = New LTXMLObject
				NewXMLObject.ManageObject( Sprite )
				XMLObject.Children.AddLast( NewXMLObject )
			Next
		End If
	End Method
End Type