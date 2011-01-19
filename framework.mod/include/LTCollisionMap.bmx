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
	Field Objects:TList[ , ]
	Field XScale:Float = 1.0, YScale:Float = 1.0
	
	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		Super.SetResolution( NewXQuantity, NewYQuantity )
		
		?debug
		L_Assert( Masked, "Map resoluton must be power of 2" )
		?
		
		Objects = New TList[ NewXQuantity, NewYQuantity ]
		For Local Y:Int = 0 Until NewYQuantity
			For Local X:Int = 0 Until NewXQuantity
				Objects[ X, Y ] = New TList
			Next
		Next
	End Method
	
	
	
	Method SetMapScale( NewXScale:Float, NewYScale:Float )
		XScale = NewXScale
		YScale = NewYScale
	End Method
	
	' ==================== Insert / remove objects ====================
	
	Method InsertSprite( Sprite:LTSprite )
		Select Sprite.Shape
			Case L_Pivot
				Objects[ Int( Sprite.X / XScale ) & XMask, Int( Sprite.Y / YScale ) & YMask ].AddLast( Sprite )
			Default
				Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / XScale )
				Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / YScale )
				Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - 0.000001 ) / XScale )
				Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - 0.000001 ) / YScale )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						Objects[ X & XMask, Y & YMask ].AddFirst( Sprite )
					Next
				Next
		End Select
		Sprite.CollisionMap = Self
	End Method
	
	
	
	Method RemoveSprite( Sprite:LTSprite )
		Select Sprite.Shape
			Case L_Pivot
				Objects[ Int( Sprite.X / XScale ) & XMask, Int( Sprite.Y / YScale ) & YMask ].Remove( Sprite )
			Default
				Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / XScale )
				Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / YScale )
				Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - 0.000001 ) / XScale )
				Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - 0.000001 ) / YScale )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						Objects[ X & XMask, Y & YMask ].Remove( Sprite )
					Next
				Next
		End Select
	End Method
	
	' ==================== Collisions ===================
	
	Method CollisionsWithList( List:LTList )
		For Local Sprite:LTSprite = Eachin List
			CollisionsWithSprite( Sprite )
		Next
	End Method
	
	
	
	Method CollisionsWithSprite( Sprite:LTSprite )
		Select Sprite.Shape
			Case L_Pivot
				For Local Obj:LTActiveObject = Eachin Objects[ Int( Sprite.X / XScale ) & XMask, Int( Sprite.Y / YScale ) & YMask ]
					If Obj = Sprite Then Continue
					If Obj.CollidesWithSprite( Sprite ) Then Sprite.HandleCollisionWith( Obj, Obj.GetCollisionType( Sprite ) )
				Next
			Default
				Local MapX1:Int = Floor( ( Sprite.X - 0.5 * Sprite.Width ) / XScale )
				Local MapY1:Int = Floor( ( Sprite.Y - 0.5 * Sprite.Height ) / YScale )
				Local MapX2:Int = Floor( ( Sprite.X + 0.5 * Sprite.Width - 0.000001 ) / XScale )
				Local MapY2:Int = Floor( ( Sprite.Y + 0.5 * Sprite.Height - 0.000001 ) / YScale )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						For Local Obj:LTActiveObject = Eachin Objects[ X & XMask, Y & YMask ]
							If Obj = Sprite Then Continue
							If Obj.CollidesWithSprite( Sprite ) Then Sprite.HandleCollisionWith( Obj, Obj.GetCollisionType( Sprite ) )
						Next
					Next
				Next
		End Select
	End Method
	
	
	
	Method Create:LTCollisionMap( XQuantity:Int, YQuantity:Int )
		Local Map:LTCollisionMap = New LTCollisionMap
		Map.SetResolution( XQuantity, YQuantity )
		Return Map
	End Method
End Type