'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_Lines:LTLine[] = New LTLine[ 2 ]
Global L_Pivots:LTSprite[] = New LTSprite[ 4 ]
For Local N:Int = 0 To 3
	If N < 2 Then L_Lines[ N ] = New LTLine
	L_Pivots[ N ] = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
Next

Type LTWedge
	Function PivotAndOval( Pivot:LTSprite, Oval:LTSprite, DX:Double Var, DY:Double Var )
		Oval = Oval.ToCircle( Pivot, L_Oval1 )
		Local K:Double = 0.5 * Oval.Width / Oval.DistanceTo( Pivot ) - 1.0
		DX = ( Pivot.X - Oval.X ) * K
		DY = ( Pivot.Y - Oval.Y ) * K
	End Function



	Function PivotAndRectangle( Pivot:LTSprite, Rectangle:LTSprite, DX:Double Var, DY:Double Var )
		if Abs( Pivot.Y - Rectangle.Y ) * Rectangle.Width >= Abs( Pivot.X - Rectangle.X ) * Rectangle.Height Then
			DY = Rectangle.Y + 0.5 * Rectangle.Height * Sgn( Pivot.Y - Rectangle.Y ) - Pivot.Y
		Else
			DX = Rectangle.X + 0.5 * Rectangle.Width * Sgn( Pivot.X - Rectangle.X ) - Pivot.X
		End If
	End Function
	
	
	
	Function TriangleAsRectangle:Int( Pivot:LTSprite, Triangle:LTSprite )
		Triangle.GetOtherVertices( L_Pivot1, L_Pivot2 )
		Triangle.GetRightAngleVertex( L_Pivot3 )
		Triangle.GetHypotenuse( L_Line )
		LTLine.FromPivots( L_Pivot1, LTSprite.GetMedium( L_Pivot2, L_Pivot3, L_Pivot4 ), L_Lines[ 0 ] )
		LTLine.FromPivots( L_Pivot2, LTSprite.GetMedium( L_Pivot1, L_Pivot3, L_Pivot4 ), L_Lines[ 1 ] )
		For Local LineNum:Int = 0 To 1
			If L_Lines[ LineNum ].PivotOrientation( Pivot ) = L_Lines[ LineNum ].PivotOrientation( L_Pivot3 ) Then Return True
		Next
	End Function
	
	
	
	Function PivotAndTriangle( Pivot:LTSprite, Triangle:LTSprite, DX:Double Var, DY:Double Var )
		If TriangleAsRectangle( Pivot, Triangle ) Then
			PivotAndRectangle( Pivot, Triangle, DX, DY )
		Else
			DY = L_Line.GetY( Pivot.X ) - Pivot.Y
		End If
	End Function
	
	
	
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
			L_Pivot4.X = Rectangle.X + 0.5 * Rectangle.Width * Sgn( Oval.X - Rectangle.X )
			L_Pivot4.Y = Rectangle.Y + 0.5 * Rectangle.Height * Sgn( Oval.Y - Rectangle.Y )
			Oval = Oval.ToCircle( L_Pivot4, L_Oval1 )
			Local K:Double = 1.0 - 0.5 * Oval.Width / Oval.DistanceTo( L_Pivot4 )
			DX = ( L_Pivot4.X - Oval.X ) * K
			DY = ( L_Pivot4.Y - Oval.Y ) * K
		End If
	End Function
	
	
	
	Function OvalAndTriangle( Oval:LTSprite, Triangle:LTSprite, DX:Double Var, DY:Double Var )
		If TriangleAsRectangle( Oval, Triangle ) Then
			OvalAndRectangle( Oval, Triangle, DX, DY )
		Else
			L_Oval1 = Oval.ToCircle( L_Pivot3, L_Oval1 )
			Local VDistance:Double = 0.5 * L_Distance( Triangle.Width, Triangle.Height ) * L_Oval1.Width / Triangle.Width
			Local DHeight:Double = 0.5 * ( Oval.Height - L_Oval1.Height )
			Local DDX:Double = 0.5 * L_Oval1.Width / VDistance * L_Cathetus( VDistance, 0.5 * L_Oval1.Width )
			Local Dir:Int = -1
			If Triangle.ShapeType = LTSprite.BottomLeftTriangle Or Triangle.ShapeType = LTSprite.BottomRightTriangle Then Dir = 1
			If Triangle.ShapeType = LTSprite.TopRightTriangle Or Triangle.ShapeType = LTSprite.BottomRightTriangle Then DDX = -DDX
			If L_Oval1.X < Triangle.LeftX() + DDX Then
				DY = L_Pivot1.Y - Dir * L_Cathetus( L_Oval1.Width * 0.5, L_Oval1.X - L_Pivot1.X ) - L_Oval1.Y
			ElseIf L_Oval1.X > Triangle.RightX() + DDX Then
				DY = L_Pivot2.Y - Dir * L_Cathetus( L_Oval1.Width * 0.5, L_Oval1.X - L_Pivot2.X ) - L_Oval1.Y
			Else
				DY = L_Line.GetY( L_Oval1.X ) - Dir * ( VDistance + DHeight ) - Oval.Y
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
				DY = Min( L_Line.GetY( X ), Triangle.BottomY() ) - Rectangle.TopY()
			Else
				DY = Max( L_Line.GetY( X ), Triangle.TopY() ) - Rectangle.BottomY()
			End If
		End If
	End Function
	
	
	
	Function TriangleAsRectangle2:Int( Triangle1:LTSprite, Triangle2:LTSprite )
		Triangle1.GetOtherVertices( L_Pivot1, L_Pivot2 )
		Triangle1.GetRightAngleVertex( L_Pivot3 )
		Triangle1.GetHypotenuse( L_Line )
		LTLine.FromPivots( L_Pivot1, LTSprite.GetMedium( L_Pivot2, L_Pivot3, L_Pivot4 ), L_Lines[ 0 ] )
		LTLine.FromPivots( L_Pivot2, LTSprite.GetMedium( L_Pivot1, L_Pivot3, L_Pivot4 ), L_Lines[ 1 ] )
		Triangle2.GetOtherVertices( L_Pivots[ 0 ], L_Pivots[ 1 ] )
		Triangle2.GetRightAngleVertex( L_Pivots[ 2 ] )
		For Local LineNum:Int = 0 To 1
			Local O:Int = L_Lines[ LineNum ].PivotOrientation( L_Pivot3 )
			For Local PivotNum:Int = 0 To 2
				If L_Lines[ LineNum ].PivotOrientation( L_Pivots[ PivotNum ] ) = O Then Return True
			Next
		Next
	End Function
	
	
	
	Function TriangleAndTriangle( Triangle1:LTSprite, Triangle2:LTSprite, DX:Double Var, DY:Double Var )
		If TriangleAsRectangle2( Triangle2, Triangle1 ) Then
			RectangleAndTriangle( Triangle2, Triangle1, DX, DY )
			DX = -DX
			DY = -DY
		ElseIf TriangleAsRectangle2( Triangle1, Triangle2 ) Then
			RectangleAndTriangle( Triangle1, Triangle2, DX, DY )
		Else
		End If
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