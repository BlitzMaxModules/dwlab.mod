'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

' Collision functions and detection modules

Function L_PivotWithPivot:Int( Pivot1:LTActor, Pivot2:LTActor )
	If Pivot1.X = Pivot2.X And Pivot1.Y = Pivot2.Y Then Return True
End Function



Function L_PivotWithCircle:Int( Pivot:LTActor, Circle:LTActor )
	If ( Pivot.X - Circle.X ) * ( Pivot.X - Circle.X ) + ( Pivot.Y - Circle.Y ) * ( Pivot.Y - Circle.Y ) < 0.25 * Circle.XSize * Circle.XSize Then Return True
End Function



Function L_PivotWithRectangle:Int( Pivot:LTActor, Rectangle:LTActor )
	If 2.0 * Abs( Pivot.X - Rectangle.X ) < Rectangle.XSize And 2.0 * Abs( Pivot.Y - Rectangle.Y ) < Rectangle.YSize Then Return True
End Function



Function L_CircleWithCircle:Int( Circle1:LTActor, Circle2:LTActor )
	If 2.0 * Sqr( ( Circle2.X - Circle1.X ) * ( Circle2.X - Circle1.X ) + ( Circle2.Y - Circle1.Y ) * ( Circle2.Y - Circle1.Y ) ) < Circle2.XSize + Circle1.XSize Then Return True
End Function



Function L_CircleWithRectangle:Int( Circle:LTActor, Rectangle:LTActor )
	If ( Rectangle.X - Rectangle.XSize * 0.5 <= Circle.X And Circle.X <= Rectangle.X + Rectangle.XSize * 0.5 ) Or ( Rectangle.Y - Rectangle.YSize * 0.5 <= Circle.Y And Circle.Y <= Rectangle.Y + Rectangle.YSize * 0.5 ) Then
		If 2.0 * Abs( Circle.X - Rectangle.X ) < Circle.XSize + Rectangle.XSize And 2.0 * Abs( Circle.Y - Rectangle.Y ) < Circle.XSize + Rectangle.YSize Then Return True
	Else
		Local DX:Float = Abs( Rectangle.X - Circle.X ) - 0.5 * Rectangle.XSize
		Local DY:Float = Abs( Rectangle.Y - Circle.Y ) - 0.5 * Rectangle.YSize
		If Sqr( DX * DX + DY * DY ) < 0.5 * Circle.XSize Then Return True
	End If
End Function



Function L_RectangleWithRectangle:Int( Rectangle1:LTActor, Rectangle2:LTActor )
	If 2.0 * Abs( Rectangle1.X - Rectangle2.X ) < Rectangle1.XSize + Rectangle2.XSize And 2.0 * Abs( Rectangle1.Y - Rectangle2.Y ) < Rectangle1.YSize + Rectangle2.YSize Then Return True
End Function



Function L_CircleWithLine:Int( Circle:LTActor, Line:LTLine )
	Local X1:Float = Line.Pivot[ 0 ].X
	Local Y1:Float = Line.Pivot[ 0 ].Y
	Local X2:Float = Line.Pivot[ 1 ].X
	Local Y2:Float = Line.Pivot[ 1 ].Y
	Local A:Float = Y2 - Y1
	Local B:Float = X1 - X2
	Local C1:Float = -A * X1 - B * Y1
	Local AABB:Float = A * A + B * B
	Local D:Float = Abs( A * Circle.X + B * Circle.Y + C1 ) / AABB
	If D < 0.5 * Circle.XSize Then
		If L_PivotWithCircle( Line.Pivot[ 0 ], Circle ) Then Return True
		If L_PivotWithCircle( Line.Pivot[ 1 ], Circle ) Then Return True
		Local C2:Float = A * Circle.Y - B * Circle.X
		Local X0:Float = -( A * C1 + B * C2 ) / AABB
		Local Y0:Float = ( A * C2 - B * C1 ) / AABB
		If X1 <> X2 Then
			If Min( X1, X2 ) <= X0 And X0 <= Max( X1, X2 ) Then Return True
		Else
			If Min( Y1, Y2 ) <= Y0 And Y0 <= Max( Y1, Y2 ) Then Return True
		End If
	End If
End Function