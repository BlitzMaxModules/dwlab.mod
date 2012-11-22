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
	Field S:Double, S2:Double
	
	Global ServiceLine:LTLine = New LTLine
	
	
	
	Function FromPoints:LTLine( X1:Double, Y1:Double, X2:Double, Y2:Double, Line:LTLine = Null )
		?debug
		If X1 = X2 And Y1 = Y2 Then L_Error( "Line cannot be formed from two equal points" )
		?
		
		If Not Line Then Line = New LTLine
		Line.UsePoints( X1, Y1, X2, Y2 )
		Return Line
	End Function
	
	
	
	Function FromPivots:LTLine( Pivot1:LTShape, Pivot2:LTShape, Line:LTLine = Null )
		?debug
		If Pivot1.X = Pivot2.X And Pivot1.Y = Pivot2.Y Then L_Error( "Line cannot be formed from two equal pivots" )
		?
		
		If Not Line Then Line = New LTLine
		Line.UsePivots( Pivot1, Pivot2 )
		Return Line
	End Function
	
	
	
	Method UsePoints( X1:Double, Y1:Double, X2:Double, Y2:Double )
		A = Y2 - Y1
		B = X1 - X2
		C = -A * X1 - B * Y1
		CalculateS()
	End Method
	
	
	
	Method UsePivots( Pivot1:LTShape, Pivot2:LTShape )
		A = Pivot2.Y - Pivot1.Y
		B = Pivot1.X - Pivot2.X
		C = -A * Pivot1.X - B * Pivot1.Y
		CalculateS()
	End Method
	
	
	
	Method CalculateS:Double()
		S2 = A * A + B * B
		S = Sqr( S2 )
	End Method	
	
	
	Method GetX:Double( Y:Double )
		Return ( -B * Y - C ) / A
	End Method
	
	
	
	Method GetY:Double( X:Double )
		Return ( -A * X - C ) / B
	End Method
	
	
	
	Method DistanceTo:Double( Shape:LTShape )
		Return Abs( A * Shape.X + B * Shape.Y ) / S
	End Method
	
	
	
	Method DistanceToPoint:Double( PointX:Double, PointY:Double )
		Return Abs( A * PointX + B * PointY ) / S
	End Method
	
	
	
	Method PivotProjection:LTSprite( Pivot:LTSprite, Projection:LTSprite = Null )
		If Not Projection Then Projection = LTSprite.FromShapeType()
		Projection.Y = ( ( A * Pivot.Y - B * Pivot.X ) * A - C * B ) / S2
		Projection.X = ( -C - B * Projection.Y ) / A
		Return Projection
	End Method
	
	
	
	Method IntersectionWithLine:LTSprite( Line:LTLine, Pivot:LTSprite = Null )
		If Not Pivot Then Pivot = LTSprite.FromShapeType()
		Local K:Double = B * Line.A - A * Line.B
		If K = 0.0 Then Return Null
		Pivot.Y = ( Line.C * A - C * Line.A ) / K
		Pivot.X = ( C - B * Pivot.Y ) / A
		Return Pivot
	End Method
	
	
	
	Method IntersectionWithLineSegment:LTSprite( LSPivot1:LTSprite, LSPivot2:LTSprite, Pivot:LTSprite = Null )
		If PivotOrientation( LSPivot1 ) <> PivotOrientation( LSPivot2 ) Then
			FromPivots( LSPivot1, LSPivot2, ServiceLine )
			Return IntersectionWithLine( ServiceLine, Pivot )
		End If
	End Method
	
	
	
	Method PointOrientation:Int( X:Double, Y:Double )
		Return Sgn( A * X + B * Y + C )
	End Method
	
	
	
	Method PivotOrientation:Int( Pivot:LTShape )
		Return Sgn( A * Pivot.X + B * Pivot.Y + C )
	End Method
	
	
	
	Method CollisionPointsWithCircle:Int( Circle:LTSprite, Pivot1:LTSprite, Pivot2:LTSprite )
		Local D:Double = A * Circle.X + B * Circle.Y + C
		Local K:Double = 0.25 * Circle.Width * Circle.Width * S2 - D * D
		If K < 0 Then Return False
		K = Sqr( K ) * A
		Pivot1.Y = ( -B * D - K ) / S2 + Circle.Y
		Pivot1.X = GetX( Pivot1.Y )
		Pivot2.Y = ( -B * D + K ) / S2 + Circle.Y
		Pivot2.X = GetX( Pivot2.Y )
		Return True
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