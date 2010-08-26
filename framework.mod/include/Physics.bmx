'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function L_PushCircleWithCircle( Circle1:LTCircle, Circle2:LTCircle )
	Local DX:Float = Circle1.X - Circle2.X
	Local DY:Float = Circle1.Y - Circle2.Y
	Local K:Float = 0.5 * ( Circle1.Diameter + Circle2.Diameter ) / Sqr( DX * DX + DY * DY ) - 1.0
	
	Local MassSum:Float = Circle1.Mass + Circle2.Mass
	Local K1:Float, K2:Float
	If MassSum Then
		K1 = K * ( Circle2.Mass / MassSum )
		K2 = K * ( Circle1.Mass / MassSum )
	Else
		K1 = K * 0.5
		K2 = K * 0.5
	End If
	
	'debugstop
	
	Circle1.X :+ K1 * DX
	Circle1.Y :+ K1 * DY
	Circle2.X :- K2 * DX
	Circle2.Y :- K2 * DY
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
	
	Local MassSum:Float = Rectangle.Mass + Circle.Mass
	Local K1:Float, K2:Float
	
	If MassSum Then
		K1 = Circle.Mass / MassSum
		K2 = Rectangle.Mass / MassSum
	Else
		K1 = 0.5
		K2 = 0.5
	End If
	
	'debugstop
	
	Rectangle.X :+ K1 * DX
	Rectangle.Y :+ K1 * DY
	Circle.X :- K2 * DX
	Circle.Y :- K2 * DY
End Function





Function L_PushRectangleWithRectangle( Rectangle1:LTRectangle, Rectangle2:LTRectangle )
	Local DX:Float = 0.5 * ( Rectangle1.XSize + Rectangle2.XSize ) - Abs( Rectangle1.X - Rectangle2.X )
	Local DY:Float = 0.5 * ( Rectangle1.YSize + Rectangle2.YSize ) - Abs( Rectangle1.Y - Rectangle2.Y )
	
	Local MassSum:Float = Rectangle2.Mass + Rectangle1.Mass
	Local K1:Float = 0.5
	Local K2:Float = 0.5		
	If MassSum Then
		K1 = Rectangle2.Mass / MassSum
		K2 = Rectangle1.Mass / MassSum
	End If
	
	'debugstop
	If DX < DY Then
		Rectangle1.X :+ K1 * DX * Sgn( Rectangle1.X - Rectangle2.X )
		Rectangle2.X :- K2 * DX * Sgn( Rectangle1.X - Rectangle2.X )
	Else
		Rectangle1.Y :+ K1 * DY * Sgn( Rectangle1.Y - Rectangle2.Y )
		Rectangle2.Y :- K2 * DY * Sgn( Rectangle1.Y - Rectangle2.Y )
	End If
End Function