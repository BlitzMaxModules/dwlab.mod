'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_Line2:LTLine = New LTLine 
Global L_Line3:LTLine = New LTLine 

Type LTWedge
	Function OvalAndOval( Oval1:LTSprite, Oval2:LTSprite, DX:Double Var, DY:Double Var )
		Oval1 = Oval1.ToCircle( Oval2, L_Oval1 )
		Oval2 = Oval2.ToCircle( Oval1, L_Oval2  )
		Local K:Double = 0.5 * ( Oval1.Width + Oval2.Width ) / Oval1.DistanceTo( Oval2 ) - 1.0
		DX = ( Oval1.X - Oval2.X ) * K
		DY = ( Oval1.Y - Oval2.Y ) * K
	End Function



	Function OvalAndRectangle( Oval:LTSprite, Rectangle:LTSprite, DX:Double Var, DY:Double Var )
		Local A:Int = ( Abs( Oval.Y - Rectangle.Y ) * Rectangle.Width >= Abs( Oval.X - Rectangle.X ) * Rectangle.Height )
		If ( Oval.X > Rectangle.LeftX() And Oval.X < Rectangle.RightX() ) And A Then
			DX = 0
			DY = ( 0.5 * ( Rectangle.Height + Oval.Height ) - Abs( Rectangle.Y - Oval.Y ) ) * Sgn( Oval.Y - Rectangle.Y )
		ElseIf Oval.Y > Rectangle.TopY() And Oval.Y < Rectangle.BottomY() And Not A Then
			DX = ( 0.5 * ( Rectangle.Width + Oval.Width ) - Abs( Rectangle.X - Oval.X ) ) * Sgn( Oval.X - Rectangle.X )
			DY = 0
		Else
			L_Pivot1.X:Double = Rectangle.X + 0.5 * Rectangle.Width * Sgn( Oval.X - Rectangle.X )
			L_Pivot1.Y:Double = Rectangle.Y + 0.5 * Rectangle.Height * Sgn( Oval.Y - Rectangle.Y )
			Oval = Oval.ToCircle( L_Pivot1, L_Oval1 )
			Local K:Double = 1.0 - 0.5 * Oval.Width / Oval.DistanceTo( L_Pivot1 )
			DX = ( L_Pivot1.X - Oval.X ) * K
			DY = ( L_Pivot1.Y - Oval.Y ) * K
		End If
	End Function
	
	
	
	Function TriangleAsRectangle:Int( Pivot:LTSprite, Triangle:LTSprite )
		Triangle.GetOtherVertices( L_Pivot1, L_Pivot2 )
		Triangle.GetRightAngleVertex( L_Pivot3 )
		Triangle.GetHypotenuse( L_Line )
		LTLine.FromPivots( L_Pivot1, LTSprite.GetMedium( L_Pivot2, L_Pivot3, L_Pivot4 ), L_Line2 )
		LTLine.FromPivots( L_Pivot2, LTSprite.GetMedium( L_Pivot1, L_Pivot3, L_Pivot4 ), L_Line3 )
		If L_Line2.PivotOrientation( Pivot ) = L_Line2.PivotOrientation( L_Pivot3 ) Then Return True
		If L_Line3.PivotOrientation( Pivot ) = L_Line3.PivotOrientation( L_Pivot3 ) Then Return True
	End Function
	
	
	
	Function OvalAndTriangle( Oval:LTSprite, Triangle:LTSprite, DX:Double Var, DY:Double Var )
		If TriangleAsRectangle( Oval, Triangle ) Then
			OvalAndRectangle( Oval, Triangle, DX, DY )
		Else
			L_Oval1 = Oval.ToCircle( L_Pivot3, L_Oval1 )
			DX = 0
			DY = 0.5 * ( L_Distance( Triangle.Width, Triangle.Height ) * L_Oval1.Width / Triangle.Width + Oval.Height - L_Oval1.Height )
			If Triangle.ShapeType = LTSprite.BottomLeftTriangle Or Triangle.ShapeType = LTSprite.BottomRightTriangle Then
				DY = L_Line.GetY( L_Oval1.X ) - DY - Oval.Y
			Else
				DY = L_Line.GetY( L_Oval1.X ) + DY - Oval.Y
			End If
		End If
	End Function
	
	
	
	Function RectangleAndRectangle( Rectangle1:LTSprite, Rectangle2:LTSprite, DX:Double Var, DY:Double Var )
		DX = 0.5 * ( Rectangle1.Width + Rectangle2.Width ) - Abs( Rectangle1.X - Rectangle2.X )
		DY = 0.5 * ( Rectangle1.Height + Rectangle2.Height ) - Abs( Rectangle1.Y - Rectangle2.Y )
		
		If DX < DY Then
			DX :* Sgn( Rectangle1.X - Rectangle2.X )
			DY = 0
		Else
			DX = 0
			DY :* Sgn( Rectangle1.Y - Rectangle2.Y )
		End If
	End Function
	
	
	
	Function RectangleAndTriangle( Rectangle:LTSprite, Triangle:LTSprite, DX:Double Var, DY:Double Var )
		If TriangleAsRectangle( Rectangle, Triangle ) Then
			RectangleAndRectangle( Rectangle, Triangle, DX, DY )
		Else
			Local X:Double
			If Triangle.ShapeType = LTSprite.TopLeftTriangle Or Triangle.ShapeType = LTSprite.BottomLeftTriangle Then
				X = Rectangle.LeftX()
			Else
				X = Rectangle.RightX()
			End If
			DX = 0
			If Triangle.ShapeType = LTSprite.TopLeftTriangle Or Triangle.ShapeType = LTSprite.TopRightTriangle
				DY = Max( L_Line.GetY( X ), Triangle.TopY() ) - Rectangle.TopY()
			Else
				DY = Min( L_Line.GetY( X ), Triangle.BottomY() ) - Rectangle.BottomY()
			End If
		End If
	End Function
	
	
	
	Function TriangleAndTriangle( Triangle1:LTSprite, Triangle2:LTSprite, DX:Double Var, DY:Double Var )
		
	End Function
	
	
	
	Function Separate( Pivot1:LTSprite, Pivot2:LTSprite, DX:Double, DY:Double, Pivot1MovingResistance:Double, Pivot2MovingResistance:Double )
		Local K1:Double, K2:Double
		
		If Pivot1MovingResistance < 0 then
			If Pivot2MovingResistance < 0 Then
				Return
			End If
			Pivot1MovingResistance = 1.0
			Pivot1MovingResistance = 0.0
		ElseIf Pivot2MovingResistance < 0 Then
			Pivot1MovingResistance = 0.0
			Pivot2MovingResistance = 1.0		
		End If
		
		Local MovingResistanceSum:Double = Pivot1MovingResistance + Pivot2MovingResistance
		If MovingResistanceSum Then
			K1 = Pivot2MovingResistance / MovingResistanceSum
			K2 = Pivot1MovingResistance / MovingResistanceSum
		Else
			K1 = 0.5
			K2 = 0.5
		End If
		
		IF K1 <> 0.0 Then Pivot1.AlterCoords( K1 * DX, K1 * DY )
		IF K2 <> 0.0 Then Pivot2.AlterCoords( -K2 * DX, -K2 * DY )
	End Function
End Type