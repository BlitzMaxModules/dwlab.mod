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

Function L_WedgingValuesOfCircleAndCircle( Circle1X:Float, Circle1Y:Float, Circle1Diameter:Float, ..
Circle2X:Float, Circle2Y:Float, Circle2Diameter:Float, DX:Float Var, DY:Float Var )
	DX = Circle1X - Circle2X
	DY = Circle1Y - Circle2Y
	Local K:Float = 0.5 * ( Circle1Diameter + Circle2Diameter ) / Sqr( DX * DX + DY * DY ) - 1.0
	DX :* K
	DY :* K
End Function





Function L_WedgingValuesOfCircleAndRectangle( CircleX:Float, CircleY:Float, CircleDiameter:Float, ..
RectangleX:Float, RectangleY:Float, RectangleXSize:Float, RectangleYSize:Float, DX:Float Var, DY:Float Var )
	If CircleX > RectangleX - 0.5 * RectangleXSize And CircleX < RectangleX + 0.5 * RectangleXSize Then
		DY = ( 0.5 * ( RectangleYSize + CircleDiameter ) - Abs( RectangleY - CircleY ) ) * Sgn( CircleY - RectangleY )
	ElseIf CircleY > RectangleY - 0.5 * RectangleYSize And CircleY < RectangleY + 0.5 * RectangleYSize Then
		DX = ( 0.5 * ( RectangleXSize + CircleDiameter ) - Abs( RectangleX - CircleX ) ) * Sgn( CircleX - RectangleX )
	Else
		Local PX:Float = RectangleX + 0.5 * RectangleXSize * Sgn( CircleX - RectangleX )
		Local PY:Float = RectangleY + 0.5 * RectangleYSize * Sgn( CircleY - RectangleY )
		Local K:Float = 1.0 - 0.5 * CircleDiameter / Sqr( ( CircleX - PX ) * ( CircleX - PX ) + ( CircleY - PY ) * ( CircleY - PY ) )
		DX = ( PX - CircleX ) * K
		DY = ( PY - CircleY ) * K
	End If
End Function





Function L_WedgingValuesOfRectangleAndRectangle( Rectangle1X:Float, Rectangle1Y:Float, Rectangle1XSize:Float, Rectangle1YSize:Float, ..
Rectangle2X:Float, Rectangle2Y:Float, Rectangle2XSize:Float, Rectangle2YSize:Float, DX:Float Var, DY:Float Var )
	DX = 0.5 * ( Rectangle1XSize + Rectangle2XSize ) - Abs( Rectangle1X - Rectangle2X )
	DY = 0.5 * ( Rectangle1YSize + Rectangle2YSize ) - Abs( Rectangle1Y - Rectangle2Y )
	
	If DX < DY Then
		DX :* Sgn( Rectangle1X - Rectangle2X )
		DY = 0
	Else
		DX = 0
		DY :* Sgn( Rectangle1Y - Rectangle2Y )
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