'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTCollisionMap Extends LTMap
	Field Sprites:TList[ , ]
	Field XScale:Double = 1.0, YScale:Double = 1.0
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
	
	
	
	Method SetMapScale( NewXScale:Double, NewYScale:Double )
		XScale = NewXScale
		YScale = NewYScale
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		If Visible Then
			Local MapX1:Int = Floor( ( L_CurrentCamera.X - 0.5 * L_CurrentCamera.Width - Border ) / XScale )
			Local MapY1:Int = Floor( ( L_CurrentCamera.Y - 0.5 * L_CurrentCamera.Height - Border ) / YScale )
			Local MapX2:Int = Floor( ( L_CurrentCamera.X + 0.5 * L_CurrentCamera.Width - L_Inaccuracy + Border ) / XScale )
			Local MapY2:Int = Floor( ( L_CurrentCamera.Y + 0.5 * L_CurrentCamera.Height - L_Inaccuracy + Border ) / YScale )
			
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
	
	Method InsertSprite( Sprite:LTSprite, ChangeCollisionMapField:Int = True )
		Select Sprite.ShapeType
			Case LTSprite.Pivot
				Sprites[ Int( Sprite.X / XScale ) & XMask, Int( Sprite.Y / YScale ) & YMask ].AddLast( Sprite )
			Default
				Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / XScale )
				Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / YScale )
				Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - 0.000001 ) / XScale )
				Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - 0.000001 ) / YScale )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						Sprites[ X & XMask, Y & YMask ].AddFirst( Sprite )
					Next
				Next
		End Select
		If ChangeCollisionMapField Then Sprite.CollisionMap = Self
	End Method
	
	
	
	Method RemoveSprite( Sprite:LTSprite, ChangeCollisionMapField:Int = True )
		Select Sprite.ShapeType
			Case LTSprite.Pivot
				Sprites[ Int( Sprite.X / XScale ) & XMask, Int( Sprite.Y / YScale ) & YMask ].Remove( Sprite )
			Default
				Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / XScale )
				Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / YScale )
				Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - 0.000001 ) / XScale )
				Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - 0.000001 ) / YScale )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						Sprites[ X & XMask, Y & YMask ].Remove( Sprite )
					Next
				Next
		End Select
		If ChangeCollisionMapField Then Sprite.CollisionMap = Null
	End Method
	
	' ==================== Collisions ===================
	
	Function Create:LTCollisionMap( XQuantity:Int, YQuantity:Int, XScale:Double = 1.0, YScale:Double = 1.0 )
		Local Map:LTCollisionMap = New LTCollisionMap
		Map.SetResolution( XQuantity, YQuantity )
		Map.XScale = XScale
		Map.YScale = YScale
		Return Map
	End Function
	
	
	
	Function CreateForShape:LTCollisionMap( Shape:LTShape, Scale:Double = 1.0 )
		Return Create( L_ToPowerOf2( Shape.Width / Scale ), L_ToPowerOf2( Shape.Height / Scale ), Scale, Scale )
	End Function
End Type