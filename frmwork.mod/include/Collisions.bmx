'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

' Collision handlers, functions and detection modules

Rem
bbdoc: Constant for dealing with inaccuracy of double type operations.
End Rem
Const L_Inaccuracy:Double = 0.000001

' ------------------------------------------------ Handlers ---------------------------------------------------

Rem
bbdoc: Sprite collision handling class.
about: Sprite collision check method with specified collision handler will execute this handler's method on collision one sprite with another.

See also: #Active example
End Rem
Type LTSpriteCollisionHandler Extends LTObject
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
	End Method
End Type



Rem
bbdoc: Sprite and tile collision handling class.
about: Collision check method with specified collision handler will execute this handler's method on collision sprite with tile.

See also: #Active example
End Rem
Type LTSpriteAndTileCollisionHandler Extends LTObject
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
	End Method
End Type



Rem
bbdoc: Sprite and line collision handling class.
about: Collision check method with specified collision handler will execute this handler's method on collision sprite with line.

See also: #Active example
End Rem
Type LTSpriteAndLineCollisionHandler Extends LTObject
	Method HandleCollision( Sprite:LTSprite, Line:LTLineSegment )
	End Method
End Type

' ------------------------------------------------ Service sprites ---------------------------------------------------

Global L_Pivot1:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
Global L_Pivot2:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
Global L_Oval1:LTSprite = LTSprite.FromShapeType( LTSprite.Oval )
Global L_Oval2:LTSprite = LTSprite.FromShapeType( LTSprite.Oval )
Global L_Rectangle1:LTSprite = LTSprite.FromShapeType( LTSprite.Rectangle )
Global L_Rectangle2:LTSprite = LTSprite.FromShapeType( LTSprite.Rectangle )
Global L_Triangle1:LTSprite = LTSprite.FromShapeType( LTSprite.TopLeftTriangle )
Global L_Triangle2:LTSprite = LTSprite.FromShapeType( LTSprite.TopLeftTriangle )
Global L_Line:LTLine = New LTLine

' ------------------------------------------------ Collision ---------------------------------------------------

Function L_PivotWithPivot:Int( Pivot1:LTSprite, Pivot2:LTSprite )
	If Pivot1.X = Pivot2.X And Pivot1.Y = Pivot2.Y Then Return True
End Function



Function L_PivotWithOval:Int( Pivot:LTSprite, Oval:LTSprite )
	Oval = Oval.ToCircle( L_Oval1, Pivot )
	If ( Pivot.X - Oval.X ) * ( Pivot.X - Oval.X ) + ( Pivot.Y - Oval.Y ) * ( Pivot.Y - Oval.Y ) < 0.25 * Oval.Width * Oval.Width Then Return True
End Function



Function L_PivotWithRectangle:Int( Pivot:LTSprite, Rectangle:LTSprite )
	If 2.0 * Abs( Pivot.X - Rectangle.X ) < Rectangle.Width - L_Inaccuracy And 2.0 * Abs( Pivot.Y - Rectangle.Y ) < Rectangle.Height - L_Inaccuracy Then Return True
End Function



Function L_PivotWithTriangle:Int( Pivot:LTSprite, Triangle:LTSprite )
	If L_PivotWithRectangle( Pivot, Triangle ) Then
		Local Line:LTLine
		Select Triangle.ShapeType
			Case LTSprite.TopLeftTriangle, LTSprite.BottomRightTriangle
				Line = LTLine.FromPoints( Triangle.X, Triangle.Y, Triangle.X + Triangle.Width, Triangle.Y + Triangle.Height )
			Case LTSprite.TopRightTriangle, LTSprite.BottomLeftTriangle
				Line = LTLine.FromPoints( Triangle.X, Triangle.Y, Triangle.X - Triangle.Width, Triangle.Y + Triangle.Height )
		End Select
		If Line.DistanceTo( Pivot ) > L_Inaccuracy Then Return True
	End If
End Function



Function L_OvalWithOval:Int( Oval1:LTSprite, Oval2:LTSprite )
	Oval1 = Oval1.ToCircle( L_Oval1, Oval2 )
	Oval2 = Oval2.ToCircle( L_Oval2, Oval1 )
	If 4.0 * ( ( Oval2.X - Oval1.X ) * ( Oval2.X - Oval1.X ) + ( Oval2.Y - Oval1.Y ) * ( Oval2.Y - Oval1.Y ) ) < ( Oval2.Width + Oval1.Width ) * ( Oval2.Width + Oval1.Width ) - L_Inaccuracy Then Return True
End Function



Function L_OvalWithRectangle:Int( Oval:LTSprite, Rectangle:LTSprite )
	Oval = Oval.ToCircle( L_Oval1, Rectangle )
	If ( Rectangle.X - Rectangle.Width * 0.5 <= Oval.X And Oval.X <= Rectangle.X + Rectangle.Width * 0.5 ) Or ( Rectangle.Y - Rectangle.Height * 0.5 <= Oval.Y And Oval.Y <= Rectangle.Y + Rectangle.Height * 0.5 ) Then
		If 2.0 * Abs( Oval.X - Rectangle.X ) < Oval.Width + Rectangle.Width - L_Inaccuracy And 2.0 * Abs( Oval.Y - Rectangle.Y ) < Oval.Width + Rectangle.Height - L_Inaccuracy Then Return True
	Else
		Local DX:Double = Abs( Rectangle.X - Oval.X ) - 0.5 * Rectangle.Width
		Local DY:Double = Abs( Rectangle.Y - Oval.Y ) - 0.5 * Rectangle.Height
		If 4.0 * ( DX * DX + DY * DY ) < Oval.Width * Oval.Width - L_Inaccuracy Then Return True
	End If
End Function



Function L_OvalWithLine:Int( Oval:LTSprite, LineSegment:LTLineSegment )
	Local Pivot1:LTSprite = Line.Pivot[ 0 ]
	Local Pivot2:LTSprite = Line.Pivot[ 1 ]
	L_Oval1.X = 0.5 * ( Pivot1.X + Pivot2.X )
	L_Oval1.Y = 0.5 * ( Pivot1.Y + Pivot2.Y )
	L_Oval1.Width = 0.5 * Pivot1.DistanceTo( Pivot2 ) + L_Inaccuracy
	If L_OvalWithOval( Oval, L_Oval1 ) Then
		Line:LTLine = LineSegment.ToLine()
		If Line.DistanceTo( Oval ) < 0.5 * Max( Oval.Width, Oval.Height ) Then
			Line.PivotProjection( Oval, L_Pivot1 )
			Oval.ToCircle( L_Oval2, L_Pivot1 )
			If L_PivotWithOval( L_Pivot1, L_Oval1 ) And L_Pivot1.DistanceTo( L_Oval2 ) < L_Oval1.Width - L_Inaccuracy Then Return True
		End If
	End If
End Function



Function L_OvalWithTriangle:Int( Oval:LTSprite, Triangle:LTSprite )
	Oval.ToCircle( L_Oval1, Triangle )
	If L_OvalWithRectangle( Oval, Triangle ) Then
		
	End If
End Function



Function L_RectangleWithRectangle:Int( Rectangle1:LTSprite, Rectangle2:LTSprite )
	If 2.0 * Abs( Rectangle1.X - Rectangle2.X ) < Rectangle1.Width + Rectangle2.Width - L_Inaccuracy And 2.0 * Abs( Rectangle1.Y - Rectangle2.Y ) < Rectangle1.Height + Rectangle2.Height - L_Inaccuracy Then Return True
End Function



Function L_RectangleWithTriangle:Int( Rectangle:LTSprite, Triangle:LTSprite )
End Function



Function L_TriangleWithTriangle:Int( Triangle1:LTSprite, Triangle2:LTSprite )
End Function

' ------------------------------------------------ Overlapping ---------------------------------------------------

Function L_OvalOverlapsPivot:Int( Oval:LTSprite, Pivot:LTSprite )
	Oval = Oval.ToCircle( L_Oval1, Pivot )
	If 4.0 * ( ( Oval.X - Pivot.X ) * ( Oval.X - Pivot.X ) + ( Oval.Y - Pivot.Y ) * ( Oval.Y - Pivot.Y ) ) <= Oval.Width * Oval.Width Then Return True
End Function



Function L_OvalOverlapsOval:Int( Oval1:LTSprite, Oval2:LTSprite )
	Oval1 = Oval1.ToCircle( L_Oval1, Oval2 )
	Oval2 = Oval2.ToCircle( L_Oval2, Oval1 )
	If 4.0 * ( ( Oval1.X - Oval2.X ) * ( Oval1.X - Oval2.X ) + ( Oval1.Y - Oval2.Y ) * ( Oval1.Y - Oval2.Y ) ) <= ( Oval1.Width - Oval2.Width ) * ( Oval1.Width - Oval2.Width ) Then Return True
End Function



Function L_OvalOverlapsRectangle:Int( Oval:LTSprite, Rectangle:LTSprite )
	If L_RectangleOverlapsRectangle( Oval, Rectangle ) Then
		Local LeftX:Double = Rectangle.LeftX()
		Local TopY:Double = Rectangle.TopY()
		Local RightX:Double = Rectangle.RightX()
		Local BottomY:Double = Rectangle.BottomY()
		L_Pivot1.X = LeftX
		L_Pivot1.Y = TopY
		If Not L_OvalOverlapsPivot( Oval, L_Pivot1 ) Then Return False
		L_Pivot1.X = RightX
		If Not L_OvalOverlapsPivot( Oval, L_Pivot1 ) Then Return False
		L_Pivot1.Y = BottomY
		If Not L_OvalOverlapsPivot( Oval, L_Pivot1 ) Then Return False
		L_Pivot1.X = LeftX
		If L_OvalOverlapsPivot( Oval, L_Pivot1 ) Then Return True
	End If
End Function



Function L_RectangleOverlapsPivot:Int( Rectangle:LTSprite, Pivot:LTSprite )
	If ( Rectangle.X - 0.5 * Rectangle.Width <= Pivot.X ) And ( Rectangle.Y - 0.5 * Rectangle.Height <= Pivot.Y ) And ..
			( Rectangle.X + 0.5 * Rectangle.Width >= Pivot.X ) And ( Rectangle.Y + 0.5 * Rectangle.Height >= Pivot.Y ) Then Return True
End Function



Function L_RectangleOverlapsRectangle:Int( Rectangle1:LTSprite, Rectangle2:LTSprite )
	If ( Rectangle1.X - 0.5 * Rectangle1.Width <= Rectangle2.X - 0.5 * Rectangle2.Width ) And ( Rectangle1.Y - 0.5 * Rectangle1.Height <= Rectangle2.Y - 0.5 * Rectangle2.Height ) And ..
		( Rectangle1.X + 0.5 * Rectangle1.Width >= Rectangle2.X + 0.5 * Rectangle2.Width ) And ( Rectangle1.Y + 0.5 * Rectangle1.Height >= Rectangle2.Y + 0.5 * Rectangle2.Height ) Then Return True
End Function
