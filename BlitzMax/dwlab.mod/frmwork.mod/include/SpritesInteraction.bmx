'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTPivotWithOval Extends LTInteraction
	Global Instance:LTPivotWithOval = New LTPivotWithOval

	Method SpritesCollide:Int( Pivot:LTSprite, Oval:LTSprite )
		Oval = Oval.ToCircle( Pivot, ServiceOval1 )
		Local Radius:Double = 0.5 * Oval.Width - L_Inaccuracy
		If Pivot.Distance2To( Oval ) < Radius * Radius Then Return True
	End Method
	
	Method WedgeOffSprites( Pivot:LTSprite, Oval:LTSprite, DX:Double Var, DY:Double Var )
		Oval = Oval.ToCircle( Pivot, ServiceOval1 )
		Local K:Double = 0.5 * Oval.Width / Oval.DistanceTo( Pivot ) - 1.0
		DX = ( Pivot.X - Oval.X ) * K
		DY = ( Pivot.Y - Oval.Y ) * K
	End Method
End Type

LTInteraction.RegisterSpritesInteraction( LTSprite.Pivot, LTSprite.Oval, LTPivotWithOval.Instance )


	
Type LTPivotWithRectangle Extends LTInteraction
	Global Instance:LTPivotWithRectangle = New LTPivotWithRectangle
	
	Method SpritesCollide:Int( Pivot:LTSprite, Rectangle:LTSprite )
		If 2.0 * Abs( Pivot.X - Rectangle.X ) < Rectangle.Width - L_Inaccuracy And 2.0 * Abs( Pivot.Y - Rectangle.Y ) < Rectangle.Height - L_Inaccuracy Then Return True
	End Method
	
	Method WedgeOffSprites( Pivot:LTSprite, Rectangle:LTSprite, DX:Double Var, DY:Double Var )
		if Abs( Pivot.Y - Rectangle.Y ) * Rectangle.Width >= Abs( Pivot.X - Rectangle.X ) * Rectangle.Height Then
			DY = Rectangle.Y + 0.5 * Rectangle.Height * Sgn( Pivot.Y - Rectangle.Y ) - Pivot.Y
		Else
			DX = Rectangle.X + 0.5 * Rectangle.Width * Sgn( Pivot.X - Rectangle.X ) - Pivot.X
		End If
	End Method
End Type

LTInteraction.RegisterSpritesInteraction( LTSprite.Pivot, LTSprite.Rectangle, LTPivotWithRectangle.Instance )
	


Type LTPivotWithTriangle Extends LTInteraction
	Global Instance:LTPivotWithTriangle = New LTPivotWithTriangle
	
	Method SpritesCollide:Int( Pivot:LTSprite, Triangle:LTSprite )
		If LTPivotWithRectangle.Instance.SpritesCollide( Pivot, Triangle ) Then
			Triangle.GetHypotenuse( ServiceLine1 )
			Triangle.GetRightAngleVertex( ServicePivot1 )
			If ServiceLine1.PivotOrientation( Pivot ) = ServiceLine1.PivotOrientation( ServicePivot1 ) Then Return True
		End If
	End Method
	
	Method WedgeOffSprites( Pivot:LTSprite, Triangle:LTSprite, DX:Double Var, DY:Double Var )
		DY = ServiceLines[ 0 ].GetY( Pivot.X ) - Pivot.Y
		
		Local DX1:Double, DY1:Double
		LTPivotWithRectangle.Instance.WedgeOffSprites( Pivot, Triangle, DX1, DY1 )
		If L_Distance2( DX1, DY1 ) < DY * DY Then
			DX = DX1
			DY = DY1
		End If
	End Method
End Type



Type LTOvalWithPivot Extends LTInteraction
	Global Instance:LTOvalWithPivot = New LTOvalWithPivot
	
	Method SpriteOverlapsSprite:Int( Circle:LTSprite, Pivot:LTSprite )
		If 4.0 * Circle.Distance2To( Pivot ) <= Circle.Width * Circle.Width Then Return True
	End Method
End Type

LTInteraction.RegisterSpritesInteraction( LTSprite.Oval, LTSprite.Pivot, LTOvalWithPivot.Instance )


	
Type LTOvalWithOval Extends LTInteraction
	Global Instance:LTOvalWithOval = New LTOvalWithOval
	
	Method SpritesCollide:Int( Oval1:LTSprite, Oval2:LTSprite )
		Oval1 = Oval1.ToCircle( Oval2, ServiceOval1 )
		Oval2 = Oval2.ToCircle( Oval1, ServiceOval2 )
		Local Radiuses:Double = 0.5 * ( Oval1.Width + Oval2.Width ) - L_Inaccuracy
		If Oval1.Distance2To( Oval2 ) < Radiuses * Radiuses Then Return True
	End Method
	
	Method SpriteOverlapsSprite:Int( Circle:LTSprite, Oval:LTSprite )
		If Oval.Width = Oval.Height Then Return CircleAndCircle( Circle, ServiceOval1 )
		
		If Oval.Width > Oval.Height Then
			Local DWidth:Double = Oval.Width - Oval.Height
			ServiceOval1.X = Oval.X - DWidth
			ServiceOval1.Y = Oval.Y
			ServiceOval1.Width = Oval.Height
			If Not CircleAndCircle( Circle, ServiceOval1 ) Then Return False
			ServiceOval1.X = Oval.X + DWidth
		Else
			Local DHeight:Double = Oval.Height - Oval.Width
			ServiceOval1.X = Oval.X
			ServiceOval1.Y = Oval.Y - DHeight
			ServiceOval1.Width = Oval.Width
			If Not CircleAndCircle( Circle, ServiceOval1 ) Then Return False
			ServiceOval1.Y = Oval.Y + DHeight
		End If
		Return CircleAndCircle( Circle, ServiceOval1 )
	End Method
	
	Method CircleAndCircle:Int( Circle1:LTSprite, Circle2:LTSprite )
		Local Diameters:Double = Circle1.Width + Circle2.Width
		If 4.0 * Circle1.Distance2To( Circle2 ) <= Diameters * Diameters Then Return True
	End Method
	
	Method WedgeOffSprites( Oval1:LTSprite, Oval2:LTSprite, DX:Double Var, DY:Double Var )
		Oval1 = Oval1.ToCircle( Oval2, ServiceOval1 )
		Oval2 = Oval2.ToCircle( Oval1, ServiceOval2  )
		Local K:Double = 0.5 * ( Oval1.Width + Oval2.Width ) / Oval1.DistanceTo( Oval2 ) - 1.0
		DX = ( Oval1.X - Oval2.X ) * K
		DY = ( Oval1.Y - Oval2.Y ) * K
	End Method
End Type

LTInteraction.RegisterSpritesInteraction( LTSprite.Oval, LTSprite.Oval, LTOvalWithOval.Instance )

	
	
Type LTOvalWithRectangle Extends LTInteraction
	Global Instance:LTOvalWithRectangle = New LTOvalWithRectangle
	
	Method SpritesCollide:Int( Oval:LTSprite, Rectangle:LTSprite )
		Oval = Oval.ToCircle( Rectangle, ServiceOval1 )
		If ( Rectangle.X - Rectangle.Width * 0.5 <= Oval.X And Oval.X <= Rectangle.X + Rectangle.Width * 0.5 ) Or ( Rectangle.Y - Rectangle.Height * 0.5 <= Oval.Y And Oval.Y <= Rectangle.Y + Rectangle.Height * 0.5 ) Then
			If 2.0 * Abs( Oval.X - Rectangle.X ) < Oval.Width + Rectangle.Width - L_Inaccuracy And 2.0 * Abs( Oval.Y - Rectangle.Y ) < Oval.Width + Rectangle.Height - L_Inaccuracy Then Return True
		Else
			Local DX:Double = Abs( Rectangle.X - Oval.X ) - 0.5 * Rectangle.Width
			Local DY:Double = Abs( Rectangle.Y - Oval.Y ) - 0.5 * Rectangle.Height
			Local Radius:Double = 0.5 * Oval.Width - L_Inaccuracy
			If DX * DX + DY * DY < Radius * Radius Then Return True
		End If
	End Method
	
	Method SpriteOverlapsSprite:Int( Circle:LTSprite, Rectangle:LTSprite )
		If LTRectangleWithRectangle.Instance.SpriteOverlapsSprite( Circle, Rectangle ) Then
			Local LeftX:Double, TopY:Double, RightX:Double, BottomY:Double
			Rectangle.GetBounds( LeftX, TopY, RightX, BottomY )
			ServicePivot1.X = LeftX
			ServicePivot1.Y = TopY
			If Not LTOvalWithPivot.Instance.SpriteOverlapsSprite( Circle, ServicePivot1 ) Then Return False
			ServicePivot1.X = RightX
			If Not LTOvalWithPivot.Instance.SpriteOverlapsSprite( Circle, ServicePivot1 ) Then Return False
			ServicePivot1.Y = BottomY
			If Not LTOvalWithPivot.Instance.SpriteOverlapsSprite( Circle, ServicePivot1 ) Then Return False
			ServicePivot1.X = LeftX
			If LTOvalWithPivot.Instance.SpriteOverlapsSprite( Circle, ServicePivot1 ) Then Return True
		End If
	End Method

	Method WedgeOffSprites( Oval:LTSprite, Rectangle:LTSprite, DX:Double Var, DY:Double Var )
		Local A:Int = ( Abs( Oval.Y - Rectangle.Y ) * Rectangle.Width >= Abs( Oval.X - Rectangle.X ) * Rectangle.Height )
		If ( Oval.X > Rectangle.LeftX() And Oval.X < Rectangle.RightX() ) And A Then
			DX = 0
			DY = ( 0.5 * ( Rectangle.Height + Oval.Height ) - Abs( Rectangle.Y - Oval.Y ) ) * Sgn( Oval.Y - Rectangle.Y )
		ElseIf Oval.Y > Rectangle.TopY() And Oval.Y < Rectangle.BottomY() And Not A Then
			DX = ( 0.5 * ( Rectangle.Width + Oval.Width ) - Abs( Rectangle.X - Oval.X ) ) * Sgn( Oval.X - Rectangle.X )
			DY = 0
		Else
			ServicePivots[ 0 ].X = Rectangle.X + 0.5 * Rectangle.Width * Sgn( Oval.X - Rectangle.X )
			ServicePivots[ 0 ].Y = Rectangle.Y + 0.5 * Rectangle.Height * Sgn( Oval.Y - Rectangle.Y )
			Oval = Oval.ToCircle( ServicePivots[ 0 ], ServiceOval1 )
			Local K:Double = 1.0 - 0.5 * Oval.Width / Oval.DistanceTo( ServicePivots[ 0 ] )
			DX = ( ServicePivots[ 0 ].X - Oval.X ) * K
			DY = ( ServicePivots[ 0 ].Y - Oval.Y ) * K
		End If
	End Method
End Type	

LTInteraction.RegisterSpritesInteraction( LTSprite.Oval, LTSprite.Rectangle, LTOvalWithRectangle.Instance )



Type LTOvalWithRay Extends LTInteraction
	Global Instance:LTOvalWithRay = New LTOvalWithRay
	
	Method SpritesCollide:Int( Oval:LTSprite, Ray:LTSprite )
		Ray.ToLine( ServiceLine1 )
		Oval.ToCircleUsingLine( ServiceLine1, ServiceOval1 )
		If ServiceLine1.CollisionPointsWithCircle( ServiceOval1, ServicePivot1, ServicePivot2 ) Then
			If Ray.HasPivot( ServicePivot1 ) Then Return True
			If Ray.HasPivot( ServicePivot2 ) Then Return True
		End If
		If LTPivotWithOval.Instance.SpritesCollide( Ray, Oval ) Then Return True
	End Method
End Type	

LTInteraction.RegisterSpritesInteraction( LTSprite.Oval, LTSprite.Ray, LTOvalWithRay.Instance )

	
	
Type LTOvalWithTriangle Extends LTInteraction
	Global Instance:LTOvalWithTriangle = New LTOvalWithTriangle
	
	Method SpritesCollide:Int( Oval:LTSprite, Triangle:LTSprite )
		If LTOvalWithRectangle.Instance.SpritesCollide( Oval, Triangle ) Then
			Triangle.GetHypotenuse( ServiceLine1 )
			Oval = Oval.ToCircleUsingLine( ServiceLine1, ServiceOval1 )
			Triangle.GetRightAngleVertex( ServicePivot1 )
			If ServiceLine1.PivotOrientation( Oval ) = ServiceLine1.PivotOrientation( ServicePivot1 ) Then Return True
			If Not ServiceLine1.CollisionPointsWithCircle( Oval, ServicePivot1, ServicePivot2 ) Then Return False
			If LTPivotWithRectangle.Instance.SpritesCollide( ServicePivot1, Triangle ) Or ..
					LTPivotWithRectangle.Instance.SpritesCollide( ServicePivot2, Triangle ) Then Return True
		End If
	End Method
	
	Method SpriteOverlapsSprite:Int( Circle:LTSprite, Triangle:LTSprite )
		Triangle.GetRightAngleVertex( ServicePivot1 )
		If Not LTOvalWithPivot.Instance.SpriteOverlapsSprite( Circle, ServicePivot1 ) Then Return False
		Triangle.GetOtherVertices( ServicePivot1, ServicePivot2 )
		If Not LTOvalWithPivot.Instance.SpriteOverlapsSprite( Circle, ServicePivot1 ) Then Return False
		If Not LTOvalWithPivot.Instance.SpriteOverlapsSprite( Circle, ServicePivot2 ) Then Return False
		Return True
	End Method
	
	Method WedgeOffSprites( Oval:LTSprite, Triangle:LTSprite, DX:Double Var, DY:Double Var )
		Triangle.GetRightAngleVertex( ServicePivots[ 2 ] )
		Triangle.GetOtherVertices( ServicePivots[ 0 ], ServicePivots[ 1 ] )
		ServiceOval1 = Oval.ToCircle( ServicePivots[ 2 ], ServiceOval1 )
		Local VDistance:Double = 0.5 * L_Distance( Triangle.Width, Triangle.Height ) * ServiceOval1.Width / Triangle.Width
		Local DHeight:Double = 0.5 * ( Oval.Height - ServiceOval1.Height )
		Local DDX:Double = 0.5 * ServiceOval1.Width / VDistance * L_Cathetus( VDistance, 0.5 * ServiceOval1.Width )
		Local Dir:Int = -1
		Local TriangleNum:Int = Triangle.ShapeType.GetNum()
		If TriangleNum = LTSprite.BottomLeftTriangle.GetNum() Or TriangleNum = LTSprite.BottomRightTriangle.GetNum() Then Dir = 1
		If TriangleNum = LTSprite.TopRightTriangle.GetNum() Or TriangleNum = LTSprite.BottomRightTriangle.GetNum() Then DDX = -DDX
		If ServiceOval1.X < Triangle.LeftX() + DDX Then
			DY = ServicePivots[ 0 ].Y - Dir * L_Cathetus( ServiceOval1.Width * 0.5, ServiceOval1.X - ServicePivots[ 0 ].X ) - ServiceOval1.Y
		ElseIf ServiceOval1.X > Triangle.RightX() + DDX Then
			DY = ServicePivots[ 1 ].Y - Dir * L_Cathetus( ServiceOval1.Width * 0.5, ServiceOval1.X - ServicePivots[ 1 ].X ) - ServiceOval1.Y
		Else
			DY = ServiceLines[ 0 ].GetY( ServiceOval1.X ) - Dir * ( VDistance + DHeight ) - Oval.Y
		End If
	
		Local DX1:Double, DY1:Double
		LTOvalWithRectangle.Instance.WedgeOffSprites( Oval, Triangle, DX1, DY1 )
		If L_Distance2( DX1, DY1 ) < DY * DY Then
			DX = DX1
			DY = DY1
		End If
	End Method
End Type



Type LTRectangleWithPivot Extends LTInteraction
	Global Instance:LTRectangleWithPivot = New LTRectangleWithPivot
	
	Method SpriteOverlapsSprite:Int( Circle:LTSprite, Pivot:LTSprite )
		If 4.0 * Circle.Distance2To( Pivot ) <= Circle.Width * Circle.Width Then Return True
	End Method
End Type

LTInteraction.RegisterSpritesInteraction( LTSprite.Rectangle, LTSprite.Pivot, LTRectangleWithPivot.Instance )
LTInteraction.RegisterSpritesInteraction( LTSprite.Rectangle, LTSprite.Oval, LTRectangleWithRectangle.Instance )



Type LTRectangleWithRectangle Extends LTInteraction
	Global Instance:LTRectangleWithRectangle = New LTRectangleWithRectangle
	
	Method SpritesCollide:Int( Rectangle1:LTSprite, Rectangle2:LTSprite )
		If 2.0 * Abs( Rectangle1.X - Rectangle2.X ) < Rectangle1.Width + Rectangle2.Width - ..
				L_Inaccuracy And 2.0 * Abs( Rectangle1.Y - Rectangle2.Y ) < Rectangle1.Height + Rectangle2.Height - L_Inaccuracy Then Return True
	End Method
	
	Method SpriteOverlapsSprite:Int( Rectangle1:LTSprite, Rectangle2:LTSprite )
		If ( Rectangle1.X - 0.5 * Rectangle1.Width <= Rectangle2.X - 0.5 * Rectangle2.Width ) And ( Rectangle1.Y - 0.5 * Rectangle1.Height <= Rectangle2.Y - 0.5 * Rectangle2.Height ) And ..
			( Rectangle1.X + 0.5 * Rectangle1.Width >= Rectangle2.X + 0.5 * Rectangle2.Width ) And ( Rectangle1.Y + 0.5 * Rectangle1.Height >= Rectangle2.Y + 0.5 * Rectangle2.Height ) Then Return True
	End Method
	
	Method WedgeOffSprites( Rectangle1:LTSprite, Rectangle2:LTSprite, DX:Double Var, DY:Double Var )
		DX = 0.5 * ( Rectangle1.Width + Rectangle2.Width ) - Abs( Rectangle1.X - Rectangle2.X )
		DY = 0.5 * ( Rectangle1.Height + Rectangle2.Height ) - Abs( Rectangle1.Y - Rectangle2.Y )
		
		If DX < DY Then
			DX :* Sgn( Rectangle1.X - Rectangle2.X )
			DY = 0
		Else
			DX = 0
			DY :* Sgn( Rectangle1.Y - Rectangle2.Y )
		End If
	End Method
End Type	

LTInteraction.RegisterSpritesInteraction( LTSprite.Rectangle, LTSprite.Rectangle, LTRectangleWithRectangle.Instance )


	
Type LTRectangleWithRay Extends LTInteraction
	Global Instance:LTRectangleWithRay = New LTRectangleWithRay
	
	Method SpritesCollide:Int( Rectangle:LTSprite, Ray:LTSprite )
		Rectangle.GetBounds( ServicePivots[ 0 ].X, ServicePivots[ 0 ].Y, ServicePivots[ 2 ].X, ServicePivots[ 2 ].Y )
		Rectangle.GetBounds( ServicePivots[ 1 ].X, ServicePivots[ 3 ].Y, ServicePivots[ 3 ].X, ServicePivots[ 1 ].Y )
		For Local N:Int = 0 To 3
			If LTRayInteraction.Instance.SpriteCollidesWithLineSegment( Ray, ServicePivots[ N ], ServicePivots[ ( N + 1 ) Mod 4 ] ) Then Return True
		Next
	End Method
End Type

LTInteraction.RegisterSpritesInteraction( LTSprite.Rectangle, LTSprite.Ray, LTRectangleWithRay.Instance )



Type LTRectangleWithTriangle Extends LTInteraction
	Global Instance:LTRectangleWithTriangle = New LTRectangleWithTriangle
	
	Method SpritesCollide:Int( Rectangle:LTSprite, Triangle:LTSprite )
		If LTRectangleWithRectangle.Instance.SpritesCollide( Rectangle, Triangle ) Then
			Triangle.GetHypotenuse( ServiceLine1 )
			Triangle.GetRightAngleVertex( ServicePivot1 )
			If ServiceLine1.PivotOrientation( Rectangle ) = ServiceLine1.PivotOrientation( ServicePivot1 ) Then Return True
			Local LeftX:Double, TopY:Double, RightX:Double, BottomY:Double
			Rectangle.GetBounds( LeftX, TopY, RightX, BottomY )
			Local O:Int = ServiceLine1.PointOrientation( LeftX, TopY )
			If O <> ServiceLine1.PointOrientation( RightX, TopY ) Then Return True
			If O <> ServiceLine1.PointOrientation( LeftX, BottomY ) Then Return True
			If O <> ServiceLine1.PointOrientation( RightX, BottomY ) Then Return True
		End If
	End Method
	
	Method WedgeOffSprites( Rectangle:LTSprite, Triangle:LTSprite, DX:Double Var, DY:Double Var )
		Local X:Double
		If Triangle.ShapeType.GetNum() = LTSprite.TopLeftTriangle.GetNum() Or Triangle.ShapeType.GetNum() = LTSprite.BottomLeftTriangle.GetNum() Then
			X = Rectangle.LeftX()
		Else
			X = Rectangle.RightX()
		End If

		Triangle.GetHypotenuse( ServiceLines[ 0 ] )
		If Triangle.ShapeType.GetNum() = LTSprite.TopLeftTriangle.GetNum() Or Triangle.ShapeType.GetNum() = LTSprite.TopRightTriangle.GetNum() Then
			DY = Min( ServiceLines[ 0 ].GetY( X ), Triangle.BottomY() ) - Rectangle.TopY()
		Else
			DY = Max( ServiceLines[ 0 ].GetY( X ), Triangle.TopY() ) - Rectangle.BottomY()
		End If
		
		Local DX1:Double, DY1:Double
		LTRectangleWithRectangle.Instance.WedgeOffSprites( Rectangle, Triangle, DX1, DY1 )
		If L_Distance2( DX1, DY1 ) < DY * DY Then
			DX = DX1
			DY = DY1
		End If
	End Method
End Type



Type LTRayWithTriangle Extends LTInteraction
	Global Instance:LTRayWithTriangle = New LTRayWithTriangle
	
	Method SpritesCollide:Int( Ray:LTSprite, Triangle:LTSprite )
		Triangle.GetOtherVertices( ServicePivots[ 0 ], ServicePivots[ 1 ] )
		Triangle.GetRightAngleVertex( ServicePivots[ 2 ] )
		For Local N:Int = 0 To 2
			If LTRayInteraction.Instance.SpriteCollidesWithLineSegment( Ray, ServicePivots[ N ], ServicePivots[ ( N + 1 ) Mod 3 ] ) Then Return True
		Next
	End Method
End Type


	
Type LTRayWithRay Extends LTInteraction
	Global Instance:LTRayWithRay = New LTRayWithRay
	
	Method SpritesCollide:Int( Ray1:LTSprite, Ray2:LTSprite )
		Ray1.ToLine( ServiceLine1 )
		Ray2.ToLine( ServiceLine2 )
		ServiceLine1.IntersectionWithLine( ServiceLine2, ServicePivot1 )
		If Not Ray1.HasPivot( ServicePivot1 ) Then Return False
		If Ray2.HasPivot( ServicePivot1 ) Then Return True
	End Method
End Type

LTInteraction.RegisterSpritesInteraction( LTSprite.Ray, LTSprite.Ray, LTRayWithRay.Instance )


	
Type LTTriangleWithTriangle Extends LTInteraction
	Global Instance:LTTriangleWithTriangle = New LTTriangleWithTriangle
	
	Method SpritesCollide:Int( Triangle1:LTSprite, Triangle2:LTSprite )
		If LTRectangleWithRectangle.Instance.SpritesCollide( Triangle1, Triangle2 ) Then
			Triangle1.GetRightAngleVertex( ServicePivot3 )
			Triangle2.GetRightAngleVertex( ServicePivot4 )
			
			Triangle1.GetOtherVertices( ServicePivot1, ServicePivot2 )
			Triangle2.GetHypotenuse( ServiceLine1 )
			Local O1:Int = ServiceLine1.PivotOrientation( ServicePivot4 )
			If LTPivotWithRectangle.Instance.SpritesCollide( ServicePivot1, Triangle2 ) Then If O1 = ServiceLine1.PivotOrientation( ServicePivot1 ) Then Return True
			If LTPivotWithRectangle.Instance.SpritesCollide( ServicePivot2, Triangle2 ) Then If O1 = ServiceLine1.PivotOrientation( ServicePivot2 ) Then Return True
			If LTPivotWithRectangle.Instance.SpritesCollide( ServicePivot3, Triangle2 ) Then If O1 = ServiceLine1.PivotOrientation( ServicePivot3 ) Then Return True
			Local O3:Int = ( ServiceLine1.PivotOrientation( ServicePivot3 ) <> ServiceLine1.PivotOrientation( ServicePivot1 ) )
			
			Triangle2.GetOtherVertices( ServicePivots[ 0 ], ServicePivots[ 1 ] )
			Triangle1.GetHypotenuse( ServiceLine1 )
			Local O2:Int = ServiceLine1.PivotOrientation( ServicePivot3 )
			If LTPivotWithRectangle.Instance.SpritesCollide( ServicePivots[ 0 ], Triangle1 ) Then If O2 = ServiceLine1.PivotOrientation( ServicePivots[ 0 ] ) Then Return True
			If LTPivotWithRectangle.Instance.SpritesCollide( ServicePivots[ 1 ], Triangle1 ) Then If O2 = ServiceLine1.PivotOrientation( ServicePivots[ 1 ] ) Then Return True
			If LTPivotWithRectangle.Instance.SpritesCollide( ServicePivot4, Triangle1 ) Then If O2 = ServiceLine1.PivotOrientation( ServicePivot4 ) Then Return True
			
			If LineSegmentCollidesWithLineSegment( ServicePivot1, ServicePivot2, ServicePivots[ 0 ], ServicePivots[ 1 ] ) Then Return True
			if O3 Then If ServiceLine1.PivotOrientation( ServicePivot4 ) <> ServiceLine1.PivotOrientation( ServicePivots[ 0 ] ) Then Return True
		End If
	End Method
	
	Method WedgeOffSprites( Triangle1:LTSprite, Triangle2:LTSprite, DX:Double Var, DY:Double Var )
		Local DX1:Double, DY1:Double
		LTRectangleWithTriangle.Instance.WedgeOffSprites( Triangle1, Triangle2, DX1, DY1 )
		Local D1:Double = L_Distance2( DX1, DY1 )
		
		Local DX2:Double, DY2:Double
		LTRectangleWithTriangle.Instance.WedgeOffSprites( Triangle2, Triangle1, DX2, DY2 )
		Local D2:Double = L_Distance2( DX2, DY2 )
		
		Repeat
			Local Triangle2ShapeTypeNum:Int = Triangle2.ShapeType.GetNum()
			Select Triangle1.ShapeType
				Case LTSprite.TopLeftTriangle
					if Triangle2ShapeTypeNum <> LTSprite.BottomRightTriangle.GetNum() Then Exit
				Case LTSprite.TopRightTriangle
					if Triangle2ShapeTypeNum <> LTSprite.BottomLeftTriangle.GetNum() Then Exit
				Case LTSprite.BottomLeftTriangle
					if Triangle2ShapeTypeNum <> LTSprite.TopRightTriangle.GetNum() Then Exit
				Case LTSprite.BottomRightTriangle
					if Triangle2ShapeTypeNum <> LTSprite.TopLeftTriangle.GetNum() Then Exit
			End Select
		
			Local DY3:Double = 0
			PopAngle( Triangle1, Triangle2, DY3 )
			PopAngle( Triangle2, Triangle1, DY3 )
			If DY3 = 0 Then Exit
			
			Local DY32:Double = DY3 * DY3
			If DY32 < D1 And DY32 < D2 Then
				Triangle1.GetRightAngleVertex( ServicePivots[ 0 ] )
				Triangle2.GetRightAngleVertex( ServicePivots[ 1 ] )
				DX = 0
				DY = DY3 * Sgn( ServicePivots[ 0 ].Y - ServicePivots[ 1 ].Y )
				Return
			Else
				Exit
			End If
		Forever
		
		If D1 < D2 Then
			DX = DX1
			DY = DY1
		Else
			DX = -DX2
			DY = -DY2
		End If
	End Method
End Type



Type LTRasterWithRaster Extends LTInteraction
	Global Instance:LTRasterWithRaster = New LTRasterWithRaster
	
	Method SpritesCollide:Int( Raster1:LTSprite, Raster2:LTSprite )
		Local Visualizer1:LTVisualizer = Raster1.Visualizer
		Local Visualizer2:LTVisualizer = Raster2.Visualizer
		Local Image1:LTImage = Visualizer1.Image
		Local Image2:LTImage = Visualizer2.Image
		If Not Image1 Or Not Image2 Then Return False
		If Raster1.Angle = 0 And Raster2.Angle = 0 And Raster1.Width * Image2.Width() = Raster2.Width * Image2.Width() And ..
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
					XScale / XScale1, YScale / YScale1, Image2.BMaxImage, Raster2.X * XScale, Raster2.Y * YScale, ..
					Raster2.Frame, Raster2.Angle, XScale / XScale2, YScale / YScale2 )
		End If
	End Method
End Type

LTInteraction.RegisterSpritesInteraction( LTSprite.Raster, LTSprite.Raster, LTRasterWithRaster.Instance )