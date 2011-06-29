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
Type LTCollisionMap Extends LTMap
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
	bbdoc: Border for drawing collision map in units.
	about: When drawing collision map, border defines the size of rectangular frame around camera's rectangle in which objects will be also drawn.
	Will be handy if you draw collision map with objects with XScale / YSclae parameters greater than 1.0.
	End Rem
	Field Border:Double
	
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
	
	' ==================== Drawing ===================	
	
	Rem
	bbdoc: Draws all objects of collision map which are in cells under camera's rectangle and border aroud it.
	End Rem
	Method Draw()
		If Visible Then
			Local MapX1:Int = Floor( ( L_CurrentCamera.X - 0.5 * L_CurrentCamera.Width - Border ) / CellWidth )
			Local MapY1:Int = Floor( ( L_CurrentCamera.Y - 0.5 * L_CurrentCamera.Height - Border ) / CellHeight )
			Local MapX2:Int = Floor( ( L_CurrentCamera.X + 0.5 * L_CurrentCamera.Width - L_Inaccuracy + Border ) / CellWidth )
			Local MapY2:Int = Floor( ( L_CurrentCamera.Y + 0.5 * L_CurrentCamera.Height - L_Inaccuracy + Border ) / CellHeight )
			
			Local SpriteMap:TMap = New TMap
			
			For Local Y:Int = MapY1 To MapY2
				For Local X:Int = MapX1 To MapX2
					For Local Sprite:LTSprite = Eachin Sprites[ X & XMask, Y & YMask ]
						If Not SpriteMap.Contains( Sprite ) Then
							Sprite.Draw()
							SpriteMap.Insert( Sprite, Null )
						End If
					Next
				Next
			Next
		End If
	End Method
	
	' ==================== Insert / remove objects ====================
	
	Rem
	bbdoc: Inserts a sprite into collision map.
	about: Pivot insertion works faster.
	
	See also: #RemoveSprite
	End Rem
	Method InsertSprite( Sprite:LTSprite, ChangeCollisionMapField:Int = True )
		Select Sprite.ShapeType
			Case LTSprite.Pivot
				Sprites[ Int( Sprite.X / CellWidth ) & XMask, Int( Sprite.Y / CellHeight ) & YMask ].AddLast( Sprite )
			Default
				Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / CellWidth )
				Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / CellHeight )
				Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - 0.000001 ) / CellWidth )
				Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - 0.000001 ) / CellHeight )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						Sprites[ X & XMask, Y & YMask ].AddFirst( Sprite )
					Next
				Next
		End Select
		If ChangeCollisionMapField Then Sprite.CollisionMap = Self
	End Method
	
	
	
	Rem
	bbdoc: Removes a sprite into collision map.
	about: Pivot removal works faster.
	
	See also: #InsertSprite
	End Rem
	Method RemoveSprite( Sprite:LTSprite, ChangeCollisionMapField:Int = True )
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
		If ChangeCollisionMapField Then Sprite.CollisionMap = Null
	End Method
	
	' ==================== Collisions ===================
	
	Rem
	bbdoc: Creates collision map.
	about: You should specify cell quantities and size.
	
	See also: #CreateForShape
	End Rem
	Function Create:LTCollisionMap( XQuantity:Int, YQuantity:Int, CellWidth:Double = 1.0, CellHeight:Double = 1.0 )
		Local Map:LTCollisionMap = New LTCollisionMap
		Map.SetResolution( XQuantity, YQuantity )
		Map.CellWidth = CellWidth
		Map.CellHeight = CellHeight
		Return Map
	End Function
	
	
	
	Rem
	bbdoc: Creates collision map using existing shape.
	about: Collision map with size not less than shape size will be created. You can specify cell size either.
	Use this function ob layer bounds or layer tilemap which are covers all level to maximize performance.
	End Rem
	Function CreateForShape:LTCollisionMap( Shape:LTShape, CellSize:Double = 1.0 )
		Return Create( L_ToPowerOf2( Shape.Width / CellSize ), L_ToPowerOf2( Shape.Height / CellSize ), CellSize, CellSize )
	End Function
End Type