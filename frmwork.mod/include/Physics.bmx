'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function L_WedgingValuesOfCircleAndCircle( Circle1X:Double, Circle1Y:Double, Circle1Diameter:Double, ..
Circle2X:Double, Circle2Y:Double, Circle2Diameter:Double, DX:Double Var, DY:Double Var )
	DX = Circle1X - Circle2X
	DY = Circle1Y - Circle2Y
	Local K:Double = 0.5 * ( Circle1Diameter + Circle2Diameter ) / Sqr( DX * DX + DY * DY ) - 1.0
	DX :* K
	DY :* K
End Function





Function L_WedgingValuesOfCircleAndRectangle( CircleX:Double, CircleY:Double, CircleDiameter:Double, ..
RectangleX:Double, RectangleY:Double, RectangleWidth:Double, RectangleHeight:Double, DX:Double Var, DY:Double Var )
	If CircleX > RectangleX - 0.5 * RectangleWidth And CircleX < RectangleX + 0.5 * RectangleWidth Then
		DY = ( 0.5 * ( RectangleHeight + CircleDiameter ) - Abs( RectangleY - CircleY ) ) * Sgn( CircleY - RectangleY )
	ElseIf CircleY > RectangleY - 0.5 * RectangleHeight And CircleY < RectangleY + 0.5 * RectangleHeight Then
		DX = ( 0.5 * ( RectangleWidth + CircleDiameter ) - Abs( RectangleX - CircleX ) ) * Sgn( CircleX - RectangleX )
	Else
		Local PX:Double = RectangleX + 0.5 * RectangleWidth * Sgn( CircleX - RectangleX )
		Local PY:Double = RectangleY + 0.5 * RectangleHeight * Sgn( CircleY - RectangleY )
		Local K:Double = 1.0 - 0.5 * CircleDiameter / Sqr( ( CircleX - PX ) * ( CircleX - PX ) + ( CircleY - PY ) * ( CircleY - PY ) )
		DX = ( PX - CircleX ) * K
		DY = ( PY - CircleY ) * K
	End If
End Function





Function L_WedgingValuesOfRectangleAndRectangle( Rectangle1X:Double, Rectangle1Y:Double, Rectangle1Width:Double, Rectangle1Height:Double, ..
Rectangle2X:Double, Rectangle2Y:Double, Rectangle2Width:Double, Rectangle2Height:Double, DX:Double Var, DY:Double Var )
	DX = 0.5 * ( Rectangle1Width + Rectangle2Width ) - Abs( Rectangle1X - Rectangle2X )
	DY = 0.5 * ( Rectangle1Height + Rectangle2Height ) - Abs( Rectangle1Y - Rectangle2Y )
	
	If DX < DY Then
		DX :* Sgn( Rectangle1X - Rectangle2X )
		DY = 0
	Else
		DX = 0
		DY :* Sgn( Rectangle1Y - Rectangle2Y )
	End If
End Function





Function L_Separate( Pivot1:LTSprite, Pivot2:LTSprite, DX:Double, DY:Double, Mass1:Double, Mass2:Double )
	'debugstop
	Local K1:Double, K2:Double
	
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
	
	Local MassSum:Double = Mass1 + Mass2
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