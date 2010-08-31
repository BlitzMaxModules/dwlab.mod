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
		?debug
		L_Assert( L_IsPowerOf2( NewXQuantity ) And L_IsPowerOf2( NewYQuantity ) , "Map resoluton must be power of 2" )
		?
		
		Super.SetResolution( NewXQuantity, NewYQuantity )
		
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
	
	Method InsertPivot( Pivot:LTPivot )
		Objects[ Int( Pivot.X / XScale ) & XMask, Int( Pivot.Y / YScale ) & YMask ].AddLast( Pivot )
	End Method
	
	
	
	Method InsertCircle( Circle:LTCircle )
		Local Radius:Float = 0.5 * Circle.Diameter
		Local MapX1:Int = Floor( ( Circle.X - Radius ) / XScale )
		Local MapY1:Int = Floor( ( Circle.Y - Radius ) / YScale )
		Local MapX2:Int = Floor( ( Circle.X + Radius ) / XScale )
		Local MapY2:Int = Floor( ( Circle.Y + Radius ) / YScale )
		
		For Local Y:Int = MapY1 To MapY2
			For Local X:Int = MapX1 To MapX2
				Objects[ X & XMask, Y & YMask ].AddLast( Circle )
			Next
		Next
	End Method
	
	
	
	Method InsertRectangle( Rectangle:LTRectangle )
		Local MapX1:Int = Floor( ( Rectangle.X - 0.5 * Rectangle.XSize ) / XScale )
		Local MapY1:Int = Floor( ( Rectangle.Y - 0.5 * Rectangle.YSize ) / YScale )
		Local MapX2:Int = Floor( ( Rectangle.X + 0.5 * Rectangle.XSize ) / XScale )
		Local MapY2:Int = Floor( ( Rectangle.Y + 0.5 * Rectangle.YSize ) / YScale )
		
		For Local Y:Int = MapY1 To MapY2
			For Local X:Int = MapX1 To MapX2
				Objects[ X & XMask, Y & YMask ].AddLast( Rectangle )
			Next
		Next
	End Method
	
	
	
	Method RemovePivot( Pivot:LTPivot )
		Objects[ Int( Pivot.X / XScale ) & XMask, Int( Pivot.Y / YScale ) & YMask ].Remove( Pivot )
	End Method
	
	
	
	Method RemoveCircle( Circle:LTCircle )
		Local Radius:Float = 0.5 * Circle.Diameter
		Local MapX1:Int = Floor( ( Circle.X - Radius ) / XScale )
		Local MapY1:Int = Floor( ( Circle.Y - Radius ) / YScale )
		Local MapX2:Int = Floor( ( Circle.X + Radius ) / XScale )
		Local MapY2:Int = Floor( ( Circle.Y + Radius ) / YScale )
		
		For Local Y:Int = MapY1 To MapY2
			For Local X:Int = MapX1 To MapX2
				Objects[ X & XMask, Y & YMask ].Remove( Circle )
			Next
		Next
	End Method
	
	
	
	Method RemoveRectangle( Rectangle:LTRectangle )
		Local MapX1:Int = Floor( ( Rectangle.X - 0.5 * Rectangle.XSize ) / XScale )
		Local MapY1:Int = Floor( ( Rectangle.Y - 0.5 * Rectangle.YSize ) / YScale )
		Local MapX2:Int = Floor( ( Rectangle.X + 0.5 * Rectangle.XSize ) / XScale )
		Local MapY2:Int = Floor( ( Rectangle.Y + 0.5 * Rectangle.YSize ) / YScale )
		
		For Local Y:Int = MapY1 To MapY2
			For Local X:Int = MapX1 To MapX2
				Objects[ X & XMask, Y & YMask ].Remove( Rectangle )
			Next
		Next
	End Method
	
	' ==================== Collisions ===================
	
	Method CollisionsWithPivot( Pivot:LTPivot )
		For Local Shape:LTShape = Eachin Objects[ Int( Pivot.X / XScale ) & XMask, Int( Pivot.Y / YScale ) & YMask ]
			If Shape.CollidesWithPivot( Pivot ) Then Pivot.HandleCollision( Shape )
		Next
	End Method
	
	
	
	Method CollisionsWithCircle( Circle:LTCircle )
		Local Radius:Float = 0.5 * Circle.Diameter
		Local MapX1:Int = Floor( ( Circle.X - Radius ) / XScale )
		Local MapY1:Int = Floor( ( Circle.Y - Radius ) / YScale )
		Local MapX2:Int = Floor( ( Circle.X + Radius ) / XScale )
		Local MapY2:Int = Floor( ( Circle.Y + Radius ) / YScale )
		
		For Local Y:Int = MapY1 To MapY2
			For Local X:Int = MapX1 To MapX2
				For Local Shape:LTShape = Eachin Objects[ X & XMask, Y & YMask ]
					If Shape.CollidesWithCircle( Circle ) Then Circle.HandleCollision( Shape )
				Next
			Next
		Next
	End Method
	
	
	
	Method CollisionsWithRectangle( Rectangle:LTRectangle )
		Local MapX1:Int = Floor( ( Rectangle.X - 0.5 * Rectangle.XSize ) / XScale )
		Local MapY1:Int = Floor( ( Rectangle.Y - 0.5 * Rectangle.YSize ) / YScale )
		Local MapX2:Int = Floor( ( Rectangle.X + 0.5 * Rectangle.XSize ) / XScale )
		Local MapY2:Int = Floor( ( Rectangle.Y + 0.5 * Rectangle.YSize ) / YScale )
		
		For Local Y:Int = MapY1 To MapY2
			For Local X:Int = MapX1 To MapX2
				For Local Shape:LTShape = Eachin Objects[ X & XMask, Y & YMask ]
					If Shape.CollidesWithRectangle( Rectangle ) Then Rectangle.HandleCollision( Shape )
				Next
			Next
		Next
	End Method
End Type