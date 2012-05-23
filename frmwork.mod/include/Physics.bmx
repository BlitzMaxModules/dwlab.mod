'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function L_WedgingValuesOfOvalAndOval( Oval1:LTSprite, Oval2:LTSprite, DX:Double Var, DY:Double Var )
	Oval1 = Oval1.ToCircle( L_Oval1, Oval2 )
	Oval2 = Oval2.ToCircle( L_Oval2, Oval1 )
	DX = Oval1.X - Oval2.X
	DY = Oval1.Y - Oval2.Y
	Local K:Double = 0.5 * ( Oval1.Width + Oval2.Width ) / Sqr( DX * DX + DY * DY ) - 1.0
	DX :* K
	DY :* K
End Function





Function L_WedgingValuesOfOvalAndRectangle( Oval:LTSprite, Rectangle:LTSprite, DX:Double Var, DY:Double Var )
	Oval = Oval.ToCircle( L_Oval1, Rectangle )
	If Oval.X > Rectangle.X - 0.5 * Rectangle.Width And Oval.X < Rectangle.X + 0.5 * Rectangle.Width Then
		DY = ( 0.5 * ( Rectangle.Height + Oval.Width ) - Abs( Rectangle.Y - Oval.Y ) ) * Sgn( Oval.Y - Rectangle.Y )
	ElseIf Oval.Y > Rectangle.Y - 0.5 * Rectangle.Height And Oval.Y < Rectangle.Y + 0.5 * Rectangle.Height Then
		DX = ( 0.5 * ( Rectangle.Width + Oval.Width ) - Abs( Rectangle.X - Oval.X ) ) * Sgn( Oval.X - Rectangle.X )
	Else
		Local PX:Double = Rectangle.X + 0.5 * Rectangle.Width * Sgn( Oval.X - Rectangle.X )
		Local PY:Double = Rectangle.Y + 0.5 * Rectangle.Height * Sgn( Oval.Y - Rectangle.Y )
		Local K:Double = 1.0 - 0.5 * Oval.Width / Sqr( ( Oval.X - PX ) * ( Oval.X - PX ) + ( Oval.Y - PY ) * ( Oval.Y - PY ) )
		DX = ( PX - Oval.X ) * K
		DY = ( PY - Oval.Y ) * K
	End If
End Function





Function L_WedgingValuesOfRectangleAndRectangle( Rectangle1:LTSprite, Rectangle2:LTSprite, DX:Double Var, DY:Double Var )
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





Function L_Separate( Pivot1:LTSprite, Pivot2:LTSprite, DX:Double, DY:Double, Pivot1MovingResistance:Double, Pivot2MovingResistance:Double )
	'debugstop
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
	
	'If Pivot1.CollidesWith( Pivot2 ) Then debugstop
End Function