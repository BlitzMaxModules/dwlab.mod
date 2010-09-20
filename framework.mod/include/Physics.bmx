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

Function L_PushCircleWithCircle( Circle1:LTActor, Circle2:LTActor, Mass1:Float, Mass2:Float )
	Local DX:Float = Circle1.X - Circle2.X
	Local DY:Float = Circle1.Y - Circle2.Y
	Local K:Float = 0.5 * ( Circle1.XSize + Circle2.XSize ) / Sqr( DX * DX + DY * DY ) - 1.0
	
	L_Separate( Circle1, Circle2, K * DX, K * DY, Mass1, Mass2 )
End Function





Function L_PushCircleWithRectangle( Circle:LTActor, Rectangle:LTActor, Mass1:Float, Mass2:Float )
	Local DX:Float, DY:Float
	
	If Circle.X > Rectangle.X - 0.5 * Rectangle.XSize And Circle.X < Rectangle.X + 0.5 * Rectangle.XSize Then
		DY = ( 0.5 * ( Rectangle.YSize + Circle.XSize ) - Abs( Rectangle.Y - Circle.Y ) ) * Sgn( Rectangle.Y - Circle.Y )
	ElseIf Circle.Y > Rectangle.Y - 0.5 * Rectangle.YSize And Circle.Y < Rectangle.Y + 0.5 * Rectangle.YSize Then
		DX = ( 0.5 * ( Rectangle.XSize + Circle.XSize ) - Abs( Rectangle.X - Circle.X ) ) * Sgn( Rectangle.X - Circle.X )
	Else
		Local PX:Float = Rectangle.X + 0.5 * Rectangle.XSize * Sgn( Circle.X - Rectangle.X )
		Local PY:Float = Rectangle.Y + 0.5 * Rectangle.YSize * Sgn( Circle.Y - Rectangle.Y )
		Local K:Float = 1.0 - 0.5 * Circle.XSize / Sqr( ( Circle.X - PX ) * ( Circle.X - PX ) + ( Circle.Y - PY ) * ( Circle.Y - PY ) )
		DX = ( Circle.X - PX ) * K
		DY = ( Circle.Y - PY ) * K
	End If
	
	L_Separate( Rectangle, Circle, DX, DY, Mass2, Mass1 )
End Function





Function L_PushRectangleWithRectangle( Rectangle1:LTActor, Rectangle2:LTActor, Mass1:Float, Mass2:Float )
	Local DX:Float = 0.5 * ( Rectangle1.XSize + Rectangle2.XSize ) - Abs( Rectangle1.X - Rectangle2.X )
	Local DY:Float = 0.5 * ( Rectangle1.YSize + Rectangle2.YSize ) - Abs( Rectangle1.Y - Rectangle2.Y )
	
	If DX < DY Then
		L_Separate( Rectangle1, Rectangle2, DX * Sgn( Rectangle1.X - Rectangle2.X ), 0, Mass1, Mass2 )
	Else
		L_Separate( Rectangle1, Rectangle2, 0, DY * Sgn( Rectangle1.Y - Rectangle2.Y ), Mass1, Mass2 )
	End If
End Function




Function L_Separate( Pivot1:LTActor, Pivot2:LTActor, DX:Float, DY:Float, Mass1:Float, Mass2:Float )
	'debugstop
	Local K1:Float, K2:Float
	
	If Mass1 < 0 then
		If Mass2 < 0 Then
			Return
		End If
		Mass1 = 1.0
		Mass2 = 0.0
	ElseIf Mass2 < 0 Then
		Mass1 = 0.0
		Mass2 = 1.0		
	End If
	
	Local MassSum:Float = Mass1 + Mass2
	If MassSum Then
		K1 = Mass2 / MassSum
		K2 = Mass1 / MassSum
	Else
		K1 = 0.5
		K2 = 0.5
	End If
	
	Pivot1.AlterCoords( K1 * DX, K1 * DY )
	Pivot2.AlterCoords( -K2 * DX, -K2 * DY )
	
	'If Pivot1.CollidesWith( Pivot2 ) Then debugstop
End Function