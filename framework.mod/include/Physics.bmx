'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTJoint.bmx"

Function L_PushCircleWithCircle( Circle1:LTCircle, Circle2:LTCircle )
	Local DX:Float = Circle1.X - Circle2.X
	Local DY:Float = Circle1.Y - Circle2.Y
	Local K:Float = 0.5 * ( Circle1.Diameter + Circle2.Diameter ) / Sqr( DX * DX + DY * DY ) - 1.0
	
	L_Separate( Circle1, Circle2, K * DX, K * DY )
End Function





Function L_PushCircleWithRectangle( Circle:LTCircle, Rectangle:LTRectangle )
	Local DX:Float, DY:Float
	
	If Circle.X > Rectangle.X - 0.5 * Rectangle.XSize And Circle.X < Rectangle.X + 0.5 * Rectangle.XSize Then
		DY = ( 0.5 * ( Rectangle.YSize + Circle.Diameter ) - Abs( Rectangle.Y - Circle.Y ) ) * Sgn( Rectangle.Y - Circle.Y )
	ElseIf Circle.Y > Rectangle.Y - 0.5 * Rectangle.YSize And Circle.Y < Rectangle.Y + 0.5 * Rectangle.YSize Then
		DX = ( 0.5 * ( Rectangle.XSize + Circle.Diameter ) - Abs( Rectangle.X - Circle.X ) ) * Sgn( Rectangle.X - Circle.X )
	Else
		Local PX:Float = Rectangle.X + 0.5 * Rectangle.XSize * Sgn( Circle.X - Rectangle.X )
		Local PY:Float = Rectangle.Y + 0.5 * Rectangle.YSize * Sgn( Circle.Y - Rectangle.Y )
		Local K:Float = 1.0 - 0.5 * Circle.Diameter / Sqr( ( Circle.X - PX ) * ( Circle.X - PX ) + ( Circle.Y - PY ) * ( Circle.Y - PY ) )
		DX = ( Circle.X - PX ) * K
		DY = ( Circle.Y - PY ) * K
	End If
	
	L_Separate( Circle, Rectangle, DX, DY )
End Function





Function L_PushRectangleWithRectangle( Rectangle1:LTRectangle, Rectangle2:LTRectangle )
	Local DX:Float = 0.5 * ( Rectangle1.XSize + Rectangle2.XSize ) - Abs( Rectangle1.X - Rectangle2.X )
	Local DY:Float = 0.5 * ( Rectangle1.YSize + Rectangle2.YSize ) - Abs( Rectangle1.Y - Rectangle2.Y )
	
	If DX < DY Then
		L_Separate( Rectangle1, Rectangle2, DX * Sgn( Rectangle1.X - Rectangle2.X ), 0 )
	Else
		L_Separate( Rectangle1, Rectangle2, 0, DY * Sgn( Rectangle1.Y - Rectangle2.Y ) )
	End If
End Function





Function L_Separate( Pivot1:LTPivot, Pivot2:LTPivot, DX:Float, DY:Float )
	Local K1:Float, K2:Float
	Local MassSum:Float = Pivot1.Model.GetMass() + Pivot2.Model.GetMass()
	If MassSum Then
		K1 = Pivot1.Model.GetMass() / MassSum
		K2 = Pivot2.Model.GetMass() / MassSum
	Else
		K1 = 0.5
		K2 = 0.5
	End If
	
	Pivot1.X :+ K1 * DX
	Pivot1.Y :+ K1 * DY
	Pivot2.X :- K2 * DX
	Pivot2.Y :- K2 * DY
End Function