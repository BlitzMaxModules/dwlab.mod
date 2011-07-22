'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function L_WedgingValuesOfOvalAndOval( Oval1X:Double, Oval1Y:Double, Oval1Width:Double, Oval1Height:Double, Oval2X:Double, Oval2Y:Double, Oval2Width:Double, Oval2Height:Double, DX:Double Var, DY:Double Var )
	Local Oval1Diameter:Double, Oval2Diameter:Double
	If Oval1Width = Oval1Height Then
		Oval1Diameter = Oval1Width
	Else
		Oval1Diameter = L_GetOvalDiameter( Oval1X, Oval1Y, Oval1Width, Oval1Height, Oval2X, Oval2Y )
	End If
	If Oval2Width = Oval2Height Then
		Oval2Diameter = Oval2Width
	Else
		Oval2Diameter = L_GetOvalDiameter( Oval2X, Oval2Y, Oval2Width, Oval2Height, Oval2X, Oval2Y )
	End If
	DX = Oval1X - Oval2X
	DY = Oval1Y - Oval2Y
	Local K:Double = 0.5 * ( Oval1Diameter + Oval2Diameter ) / Sqr( DX * DX + DY * DY ) - 1.0
	DX :* K
	DY :* K
End Function





Function L_WedgingValuesOfOvalAndRectangle( OvalX:Double, OvalY:Double, OvalWidth:Double, OvalHeight:Double, ..
RectangleX:Double, RectangleY:Double, RectangleWidth:Double, RectangleHeight:Double, DX:Double Var, DY:Double Var )
	Local OvalDiameter:Double
	If OvalWidth = OvalHeight Then
		OvalDiameter = OvalWidth
	Else
		OvalDiameter = L_GetOvalDiameter( OvalX, OvalY, OvalWidth, OvalHeight, RectangleX, RectangleY )
	End If
	If OvalX > RectangleX - 0.5 * RectangleWidth And OvalX < RectangleX + 0.5 * RectangleWidth Then
		DY = ( 0.5 * ( RectangleHeight + OvalDiameter ) - Abs( RectangleY - OvalY ) ) * Sgn( OvalY - RectangleY )
	ElseIf OvalY > RectangleY - 0.5 * RectangleHeight And OvalY < RectangleY + 0.5 * RectangleHeight Then
		DX = ( 0.5 * ( RectangleWidth + OvalDiameter ) - Abs( RectangleX - OvalX ) ) * Sgn( OvalX - RectangleX )
	Else
		Local PX:Double = RectangleX + 0.5 * RectangleWidth * Sgn( OvalX - RectangleX )
		Local PY:Double = RectangleY + 0.5 * RectangleHeight * Sgn( OvalY - RectangleY )
		Local K:Double = 1.0 - 0.5 * OvalDiameter / Sqr( ( OvalX - PX ) * ( OvalX - PX ) + ( OvalY - PY ) * ( OvalY - PY ) )
		DX = ( PX - OvalX ) * K
		DY = ( PY - OvalY ) * K
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
	
	IF K1 <> 0.0 Then Pivot1.AlterCoords( K1 * DX, K1 * DY )
	IF K2 <> 0.0 Then Pivot2.AlterCoords( -K2 * DX, -K2 * DY )
	
	'If Pivot1.CollidesWith( Pivot2 ) Then debugstop
End Function