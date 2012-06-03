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
bbdoc: Line is represented by A B and C values in Ax + Bx + C = 0 equation.
End Rem
Type LTLine Extends LTShape
	Field A:Double = 1.0, B:Double, C:Double
	Field S:Double
	
	
	
	Function FromPoints:LTLine( X1:Double, Y1:Double, X2:Double, Y2:Double, Line:LTLine = Null )
		?debug
		If X1 = X2 And Y1 = Y2 Then L_Error( "Line cannot be formed from two equal points" )
		?
		
		If Not Line Then Line = New LTLine
		Line.A = Y2 - Y1
		Line.B = X1 - X2
		Line.C = -Line.A * X1 - Line.B * Y1
		Line.CalculateS()
		Return Line
	End Function
	
	
	
	Function FromPivots:LTLine( Pivot1:LTShape, Pivot2:LTShape, Line:LTLine = Null )
		?debug
		If Pivot1.X = Pivot2.X And Pivot1.Y = Pivot2.Y Then L_Error( "Line cannot be formed from two equal pivots" )
		?
		
		If Not Line Then Line = New LTLine
		Line.A = Pivot2.Y - Pivot1.Y
		Line.B = Pivot1.X - Pivot2.X
		Line.C = -Line.A * Pivot1.X - Line.B * Pivot1.Y
		Line.CalculateS()
		Return Line
	End Function
	
	
	
	Method CalculateS:Double()
		S = Sqr( A * A + B * B )
	End Method
	
	
	
	Method DistanceTo:Double( Shape:LTShape )
		Return Abs( A * Shape.X + B * Shape.Y ) / S
	End Method
	
	
	
	Method DistanceToPoint:Double( PointX:Double, PointY:Double )
		Return Abs( A * PointX + B * PointY ) / S
	End Method
	
	
	
	Method PivotProjection:LTShape( Pivot:LTShape, Projection:LTShape = Null )
		If Not Projection Then Projection = New LTShape
		Projection.Y = ( ( A * Pivot.Y - B * Pivot.X ) * A - C * B ) / ( S * S )
		Projection.X = ( C - B * Pivot.Y ) / A
		Return Projection
	End Method
	
	
	
	Method IntersectionWith:LTShape( Line:LTLine, Pivot:LTShape = Null )
		If Not Pivot Then Pivot = New LTShape
		Pivot.Y = ( Line.C * A - C * Line.A ) / ( B * Line.A - A * Line.B )
		Pivot.X = ( C - B * Pivot.Y ) / A
		Return Pivot
	End Method
	
	
	
	Method PointOrientation:Int( X:Double, Y:Double )
		Return Sgn( A * X + B * Y + C )
	End Method
	
	
	
	Method PivotOrientation:Int( Pivot:LTShape )
		Return Sgn( A * Pivot.X + B * Pivot.Y + C )
	End Method
	
	
	
	Method Draw()
		Local LeftX:Double, TopY:Double, RightX:Double, BottomY:Double
		L_CurrentCamera.ScreenToField( L_CurrentCamera.Viewport.LeftX(), L_CurrentCamera.Viewport.TopY(), LeftX, TopY )
		L_CurrentCamera.ScreenToField( L_CurrentCamera.Viewport.RightX(), L_CurrentCamera.Viewport.BottomY(), RightX, BottomY )
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		If Abs( A ) <= Abs( B ) Then
			L_CurrentCamera.FieldToScreen( LeftX, ( -A * LeftX - C ) / B, SX1, SY1 )
			L_CurrentCamera.FieldToScreen( RightX, ( -A * RightX - C ) / B, SX2, SY2 )
		Else
			L_CurrentCamera.FieldToScreen( ( -B * TopY - C ) / A, TopY, SX1, SY1 )
			L_CurrentCamera.FieldToScreen( ( -B * BottomY - C ) / A, BottomY, SX2, SY2 )
		End If
		DrawLine( SX1, SY1, SX2, SY2 )
	End Method
End Type