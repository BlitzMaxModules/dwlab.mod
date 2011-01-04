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
	
	Method InsertActor( Actor:LTActor )
		Select Actor.Shape
			Case L_Pivot
				Objects[ Int( Actor.X / XScale ) & XMask, Int( Actor.Y / YScale ) & YMask ].AddLast( Actor )
			Default
				Local MapX1:Int = Floor( ( Actor.X - 0.5 * Actor.Width ) / XScale )
				Local MapY1:Int = Floor( ( Actor.Y - 0.5 * Actor.Height ) / YScale )
				Local MapX2:Int = Floor( ( Actor.X + 0.5 * Actor.Width - 0.000001 ) / XScale )
				Local MapY2:Int = Floor( ( Actor.Y + 0.5 * Actor.Height - 0.000001 ) / YScale )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						Objects[ X & XMask, Y & YMask ].AddFirst( Actor )
					Next
				Next
		End Select
		Actor.CollisionMap = Self
	End Method
	
	
	
	Method RemoveActor( Actor:LTActor )
		Select Actor.Shape
			Case L_Pivot
				Objects[ Int( Actor.X / XScale ) & XMask, Int( Actor.Y / YScale ) & YMask ].Remove( Actor )
			Default
				Local MapX1:Int = Floor( ( Actor.X - 0.5 * Actor.Width ) / XScale )
				Local MapY1:Int = Floor( ( Actor.Y - 0.5 * Actor.Height ) / YScale )
				Local MapX2:Int = Floor( ( Actor.X + 0.5 * Actor.Width - 0.000001 ) / XScale )
				Local MapY2:Int = Floor( ( Actor.Y + 0.5 * Actor.Height - 0.000001 ) / YScale )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						Objects[ X & XMask, Y & YMask ].Remove( Actor )
					Next
				Next
		End Select
	End Method
	
	' ==================== Collisions ===================
	
	Method CollisionsWithActor( Actor:LTActor )
		Select Actor.Shape
			Case L_Pivot
				For Local Obj:LTActiveObject = Eachin Objects[ Int( Actor.X / XScale ) & XMask, Int( Actor.Y / YScale ) & YMask ]
					If Obj = Actor Then Continue
					If Obj.CollidesWithActor( Actor ) Then Actor.HandleCollisionWith( Obj )
				Next
			Default
				Local MapX1:Int = Floor( ( Actor.X - 0.5 * Actor.Width ) / XScale )
				Local MapY1:Int = Floor( ( Actor.Y - 0.5 * Actor.Height ) / YScale )
				Local MapX2:Int = Floor( ( Actor.X + 0.5 * Actor.Width - 0.000001 ) / XScale )
				Local MapY2:Int = Floor( ( Actor.Y + 0.5 * Actor.Height - 0.000001 ) / YScale )
				
				For Local Y:Int = MapY1 To MapY2
					For Local X:Int = MapX1 To MapX2
						For Local Obj:LTActiveObject = Eachin Objects[ X & XMask, Y & YMask ]
							If Obj = Actor Then Continue
							If Obj.CollidesWithActor( Actor ) Then Actor.HandleCollisionWith( Obj )
						Next
					Next
				Next
		End Select
	End Method
End Type