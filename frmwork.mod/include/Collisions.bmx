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
Global L_Pivot3:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
Global L_Pivot4:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
Global L_Oval1:LTSprite = LTSprite.FromShapeType( LTSprite.Oval )
Global L_Oval2:LTSprite = LTSprite.FromShapeType( LTSprite.Oval )
Global L_Rectangle:LTSprite = LTSprite.FromShapeType( LTSprite.Rectangle )
Global L_Triangle:LTSprite = LTSprite.FromShapeType( LTSprite.TopLeftTriangle )
Global L_Line:LTLine = New LTLine

' ------------------------------------------------ Collision ---------------------------------------------------

Type LTCollision
	Function PivotWithPivot:Int( Pivot1:LTSprite, Pivot2:LTSprite )
		If Pivot1.Distance2To( Pivot2 ) < L_Inaccuracy * L_Inaccuracy Then Return True
	End Function
	
	
	
	Function PivotWithOval:Int( Pivot:LTSprite, Oval:LTSprite )
		Oval.ToCircle( Pivot, L_Oval1 )
		Local Radius:Double = 0.5 * L_Oval1.Width + L_Inaccuracy
		If Pivot.Distance2To( L_Oval1 ) < Radius * Radius Then Return True
	End Function
	
	
	
	Function PivotWithRectangle:Int( Pivot:LTSprite, Rectangle:LTSprite )
		If 2.0 * Abs( Pivot.X - Rectangle.X ) < Rectangle.Width - L_Inaccuracy And 2.0 * Abs( Pivot.Y - Rectangle.Y ) < Rectangle.Height - L_Inaccuracy Then Return True
	End Function
	
	
	
	Function PivotWithTriangle:Int( Pivot:LTSprite, Triangle:LTSprite )
		If PivotWithRectangle( Pivot, Triangle ) Then
			Triangle.GetHypotenuse( L_Line )
			Triangle.GetRightAnglePivot( L_Pivot1 )
			If L_Line.PivotOrientation( Pivot ) = L_Line.PivotOrientation( L_Pivot1 ) Then Return True
		End If
	End Function
	
	
	
	Function PivotWithLine:Int( Pivot:LTSprite, LineSegment:LTLineSegment )
		
	End Function
	
	
	
	Function OvalWithOval:Int( Oval1:LTSprite, Oval2:LTSprite )
		Oval1 = Oval1.ToCircle( Oval2, L_Oval1 )
		Oval2 = Oval2.ToCircle( Oval1, L_Oval2 )
		If 4.0 * ( ( Oval2.X - Oval1.X ) * ( Oval2.X - Oval1.X ) + ( Oval2.Y - Oval1.Y ) * ( Oval2.Y - Oval1.Y ) ) < ( Oval2.Width + Oval1.Width ) * ( Oval2.Width + Oval1.Width ) - L_Inaccuracy Then Return True
	End Function
	
	
	
	Function OvalWithRectangle:Int( Oval:LTSprite, Rectangle:LTSprite )
		Oval = Oval.ToCircle( Rectangle, L_Oval1 )
		If ( Rectangle.X - Rectangle.Width * 0.5 <= Oval.X And Oval.X <= Rectangle.X + Rectangle.Width * 0.5 ) Or ( Rectangle.Y - Rectangle.Height * 0.5 <= Oval.Y And Oval.Y <= Rectangle.Y + Rectangle.Height * 0.5 ) Then
			If 2.0 * Abs( Oval.X - Rectangle.X ) < Oval.Width + Rectangle.Width - L_Inaccuracy And 2.0 * Abs( Oval.Y - Rectangle.Y ) < Oval.Width + Rectangle.Height - L_Inaccuracy Then Return True
		Else
			Local DX:Double = Abs( Rectangle.X - Oval.X ) - 0.5 * Rectangle.Width
			Local DY:Double = Abs( Rectangle.Y - Oval.Y ) - 0.5 * Rectangle.Height
			If 4.0 * ( DX * DX + DY * DY ) < Oval.Width * Oval.Width - L_Inaccuracy Then Return True
		End If
	End Function
	
	
	
	Function OvalWithLine:Int( Oval:LTSprite, LineSegment:LTLineSegment )
		Local Pivot1:LTSprite = LineSegment.Pivot[ 0 ]
		Local Pivot2:LTSprite = LineSegment.Pivot[ 1 ]
		L_Oval1.X = 0.5 * ( Pivot1.X + Pivot2.X )
		L_Oval1.Y = 0.5 * ( Pivot1.Y + Pivot2.Y )
		L_Oval1.Width = 0.5 * Pivot1.DistanceTo( Pivot2 ) + L_Inaccuracy
		If OvalWithOval( Oval, L_Oval1 ) Then
			LineSegment.ToLine( L_Line )
			Oval.ToCircleUsingLine( L_Line, L_Oval2 )
			If L_Line.DistanceTo( Oval ) < 0.5 * Max( Oval.Width, Oval.Height ) Then
				L_Line.PivotProjection( Oval, L_Pivot1 )
				If PivotWithOval( L_Pivot1, L_Oval1 ) And L_Pivot1.DistanceTo( L_Oval2 ) < L_Oval1.Width - L_Inaccuracy Then Return True
			End If
		End If
	End Function
	
	
	
	Function OvalWithTriangle:Int( Oval:LTSprite, Triangle:LTSprite )
		If OvalWithRectangle( Oval, Triangle ) Then
			Triangle.GetHypotenuse( L_Line )
			Oval.ToCircleUsingLine( L_Line )
			Triangle.GetRightAnglePivot( L_Pivot1 )
			If L_Line.PivotOrientation( Oval ) = L_Line.PivotOrientation( L_Pivot1 ) Then Return True
			If L_Line.DistanceTo( Oval ) < Oval.Width Then
				L_Line.PivotProjection( Oval, L_Pivot2 )
				If PivotWithRectangle( L_Pivot2, Triangle ) Then Return True
			End If
		End If
	End Function
	
	
	
	Function RectangleWithRectangle:Int( Rectangle1:LTSprite, Rectangle2:LTSprite )
		If 2.0 * Abs( Rectangle1.X - Rectangle2.X ) < Rectangle1.Width + Rectangle2.Width - L_Inaccuracy And 2.0 * Abs( Rectangle1.Y - Rectangle2.Y ) < Rectangle1.Height + Rectangle2.Height - L_Inaccuracy Then Return True
	End Function
	
	
	
	Function RectangleWithTriangle:Int( Rectangle:LTSprite, Triangle:LTSprite )
		If RectangleWithRectangle( Rectangle, Triangle ) Then
			Triangle.GetHypotenuse( L_Line )
			Triangle.GetRightAnglePivot( L_Pivot1 )
			If L_Line.PivotOrientation( Rectangle ) = L_Line.PivotOrientation( L_Pivot1 ) Then Return True
			
			Local LeftX:Double, TopY:Double, RightX:Double, BottomY:Double
			Rectangle.GetBounds( LeftX, TopY, RightX, BottomY )
			Local O:Int = L_Line.PointOrientation( LeftX, TopY )
			If O <> L_Line.PointOrientation( RightX, TopY ) Then Return True
			If O <> L_Line.PointOrientation( LeftX, BottomY ) Then Return True
			If O <> L_Line.PointOrientation( RightX, BottomY ) Then Return True
		End If
	End Function
	
	
	
	Function RectangleWithLine:Int( Rectangle:LTSprite, LineSegment:LTLineSegment )
		
	End Function
	
	
	
	Function TriangleWithTriangle:Int( Triangle1:LTSprite, Triangle2:LTSprite )
		If RectangleWithRectangle( Triangle1, Triangle2 ) Then
			Triangle1.GetRightAnglePivot( L_Pivot3 )
			Triangle2.GetRightAnglePivot( L_Pivot4 )
			
			If Triangle1.ShapeType = LTSprite.TopLeftTriangle Or Triangle1.ShapeType = LTSprite.TopLeftTriangle Then
				Triangle1.GetBounds( L_Pivot1.X, L_Pivot1.Y, L_Pivot2.X, L_Pivot2.Y )
			Else
				Triangle1.GetBounds( L_Pivot1.X, L_Pivot2.Y, L_Pivot2.X, L_Pivot1.Y )
			End If
			
			Triangle1.GetHypotenuse( L_Line )
			If PivotWithRectangle( L_Pivot1, Triangle2 ) Then If L_Line.PivotOrientation( L_Pivot4 ) = L_Line.PivotOrientation( L_Pivot1 ) Then Return True
			If PivotWithRectangle( L_Pivot2, Triangle2 ) Then If L_Line.PivotOrientation( L_Pivot4 ) = L_Line.PivotOrientation( L_Pivot2 ) Then Return True
			If PivotWithRectangle( L_Pivot3, Triangle2 ) Then If L_Line.PivotOrientation( L_Pivot4 ) = L_Line.PivotOrientation( L_Pivot3 ) Then Return True
			
			If Triangle2.ShapeType = LTSprite.TopLeftTriangle Or Triangle2.ShapeType = LTSprite.TopLeftTriangle Then
				Triangle2.GetBounds( L_Pivot1.X, L_Pivot1.Y, L_Pivot2.X, L_Pivot2.Y )
			Else
				Triangle2.GetBounds( L_Pivot1.X, L_Pivot2.Y, L_Pivot2.X, L_Pivot1.Y )
			End If
			
			Triangle2.GetHypotenuse( L_Line )
			If PivotWithRectangle( L_Pivot1, Triangle1 ) Then If L_Line.PivotOrientation( L_Pivot3 ) = L_Line.PivotOrientation( L_Pivot1 ) Then Return True
			If PivotWithRectangle( L_Pivot2, Triangle1 ) Then If L_Line.PivotOrientation( L_Pivot3 ) = L_Line.PivotOrientation( L_Pivot2 ) Then Return True
			If PivotWithRectangle( L_Pivot4, Triangle1 ) Then If L_Line.PivotOrientation( L_Pivot3 ) = L_Line.PivotOrientation( L_Pivot4 ) Then Return True
		End If
	End Function
	
	
	
	Function TriangleWithLine:Int( Triangle1:LTSprite, LineSegment:LTLineSegment )
		
	End Function
	
	
	
	Function RasterWithRaster:Int( Raster1:LTSprite, Raster2:LTSprite )
		Local Visualizer1:LTVisualizer = Raster1.Visualizer
		Local Visualizer2:LTVisualizer = Raster2.Visualizer
		Local Image1:LTImage = Visualizer1.Image
		Local Image2:LTImage = Visualizer2.Image
		If Not Image1 Or Not Image2 Then Return False
		If Raster1.Angle = 0 And Raster2.Angle =0 And Raster1.Width * Image2.Width() = Raster2.Width * Image2.Width() And ..
				Raster1.Height * Image2.Height() = Raster2.Height * Image2.Height() Then
			Local XScale:Double = Image1.Width() / Raster1.Width
			Local YScale:Double = Image1.Height() / Raster1.Height
			Return ImagesCollide( Image1.BMaxImage, Raster1.X * XScale, Raster1.Y * YScale, Raster1.Frame, ..
					Image2.BMaxImage, Raster2.X * XScale, Raster2.Y * YScale, Raster2.Frame )
		Else
			Local XScale1:Double = Image1.Width() / Raster1.Width
			Local YScale1:Double = Image1.Height() / Raster1.Height
			Local XScale2:Double = Image2.Width() / Raster2.Width
			Local YScale2:Double = Image2.Height() / Raster2.Height
			Local XScale:Double = Max( XScale1, XScale2 )
			Local YScale:Double = Max( YScale1, YScale2 )
			Return ImagesCollide2( Image1.BMaxImage, Raster1.X * XScale, Raster1.Y * YScale, Raster1.Frame, Raster1.Angle, ..
					XScale / Image1.Width(), YScale1 / Image1.Height(), Image2.BMaxImage, Raster2.X * XScale, Raster2.Y * YScale, ..
					Raster2.Frame, Raster2.Angle, XScale / Image2.Width(), YScale2 / Image1.Height() )
		End If
	End Function
End Type
	
' ------------------------------------------------ Overlapping ---------------------------------------------------

Type LTOverlap
	Function CircleAndPivot:Int( Circle:LTSprite, Pivot:LTSprite )
		Local DX:Double = Circle.X - Pivot.X
		Local DY:Double = Circle.Y - Pivot.Y
		If 4.0 * ( DX * DX + DY * DY ) <= Circle.Width * Circle.Width Then Return True
	End Function
	
	
	
	Function CircleAndOval:Int( Circle:LTSprite, Oval:LTSprite )
		If Oval.Width = Oval.Height Then Return CircleAndCircle( Circle, Oval )
		
		If Oval.Width > Oval.Height Then
			Local DWidth:Double = Oval.Width - Oval.Height
			L_Oval1.X = Oval.X - DWidth
			L_Oval1.Y = Oval.Y
			L_Oval1.Width = Oval.Height
			If Not CircleAndCircle( Circle, L_Oval1 ) Then Return False
			L_Oval1.X = Oval.X + DWidth
		Else
			Local DHeight:Double = Oval.Height - Oval.Width
			L_Oval1.X = Oval.X
			L_Oval1.Y = Oval.Y - DHeight
			L_Oval1.Width = Oval.Width
			If Not CircleAndCircle( Circle, L_Oval1 ) Then Return False
			L_Oval1.Y = Oval.Y + DHeight
		End If
		Return CircleAndCircle( Circle, L_Oval1 )
	End Function
	
	
	
	Function CircleAndCircle:Int( Circle1:LTSprite, Circle2:LTSprite )
		Local DX:Double = Circle1.X - Circle2.X
		Local DY:Double = Circle1.Y - Circle2.Y
		Local Diameters:Double = Circle1.Width + Circle2.Width
		If 4.0 * ( DX * DX + DY * DY ) <= Diameters * Diameters Then Return True
	End Function
	
	
	
	Function CircleAndRectangle:Int( Circle:LTSprite, Rectangle:LTSprite )
		If RectangleAndRectangle( Circle, Rectangle ) Then
			Local LeftX:Double, TopY:Double, RightX:Double, BottomY:Double
			Rectangle.GetBounds( LeftX, TopY, RightX, BottomY )
			L_Pivot1.X = LeftX
			L_Pivot1.Y = TopY
			If Not CircleAndPivot( Circle, L_Pivot1 ) Then Return False
			L_Pivot1.X = RightX
			If Not CircleAndPivot( Circle, L_Pivot1 ) Then Return False
			L_Pivot1.Y = BottomY
			If Not CircleAndPivot( Circle, L_Pivot1 ) Then Return False
			L_Pivot1.X = LeftX
			If CircleAndPivot( Circle, L_Pivot1 ) Then Return True
		End If
	End Function
	
	
	
	Function RectangleAndPivot:Int( Rectangle:LTSprite, Pivot:LTSprite )
		If ( Rectangle.X - 0.5 * Rectangle.Width <= Pivot.X ) And ( Rectangle.Y - 0.5 * Rectangle.Height <= Pivot.Y ) And ..
				( Rectangle.X + 0.5 * Rectangle.Width >= Pivot.X ) And ( Rectangle.Y + 0.5 * Rectangle.Height >= Pivot.Y ) Then Return True
	End Function
	
	
	
	Function RectangleAndRectangle:Int( Rectangle1:LTSprite, Rectangle2:LTSprite )
		If ( Rectangle1.X - 0.5 * Rectangle1.Width <= Rectangle2.X - 0.5 * Rectangle2.Width ) And ( Rectangle1.Y - 0.5 * Rectangle1.Height <= Rectangle2.Y - 0.5 * Rectangle2.Height ) And ..
			( Rectangle1.X + 0.5 * Rectangle1.Width >= Rectangle2.X + 0.5 * Rectangle2.Width ) And ( Rectangle1.Y + 0.5 * Rectangle1.Height >= Rectangle2.Y + 0.5 * Rectangle2.Height ) Then Return True
	End Function
End Type
