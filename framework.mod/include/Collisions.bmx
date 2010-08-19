' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

' Collision functions and detection modules

Function L_PivotWithPivot:Int( Piv1:LTPivot, Piv2:LTPivot )
	If Piv1.X = Piv2.X And Piv1.Y = Piv2.Y Then Return True
End Function



Function L_PivotWithCircle:Int( Piv:LTPivot, Circ:LTCircle )
	If 2.0 * Sqr( ( Piv.X - Circ.X ) * ( Piv.X - Circ.X ) + ( Piv.Y - Circ.Y ) * ( Piv.Y - Circ.Y ) ) < Circ.Diameter Then Return True
End Function



Function L_PivotWithRectangle:Int( Piv:LTPivot, Rectangle:LTRectangle )
	If 2.0 * Abs( Piv.X - Rectangle.X ) < Rectangle.XSize And 2.0 * Abs( Piv.Y - Rectangle.Y ) < Rectangle.YSize Then Return True
End Function



Function L_CircleWithCircle:Int( Circ1:LTCircle, Circ2:LTCircle )
	If 2.0 * Sqr( ( Circ2.X - Circ1.X ) * ( Circ2.X - Circ1.X ) + ( Circ2.Y - Circ1.Y ) * ( Circ2.Y - Circ1.Y ) ) < Circ2.Diameter + Circ1.Diameter Then Return True
End Function



Function L_CircleWithRectangle:Int( Circ:LTCircle, Rectangle:LTRectangle )
	If ( Rectangle.X - Rectangle.XSize * 0.5 <= Circ.X And Circ.X <= Rectangle.X + Rectangle.XSize * 0.5 ) Or ( Rectangle.Y - Rectangle.YSize * 0.5 <= Circ.Y And Circ.Y <= Rectangle.Y + Rectangle.YSize * 0.5 ) Then
		If 2.0 * Abs( Circ.X - Rectangle.X ) < Circ.Diameter + Rectangle.XSize And 2.0 * Abs( Circ.Y - Rectangle.Y ) < Circ.Diameter + Rectangle.YSize Then Return True
	Else
		Local DX:Float = Abs( Rectangle.X - Circ.X ) - 0.5 * Rectangle.XSize
		Local DY:Float = Abs( Rectangle.Y - Circ.Y ) - 0.5 * Rectangle.YSize
		If Sqr( DX * DX + DY * DY ) < 0.5 * Circ.Diameter Then Return True
	End If
End Function



Function L_RectangleWithRectangle:Int( Rectangle1:LTRectangle, Rectangle2:LTRectangle )
	If 2.0 * Abs( Rectangle1.X - Rectangle2.X ) < Rectangle1.XSize + Rectangle2.XSize And 2.0 * Abs( Rectangle1.Y - Rectangle2.Y ) < Rectangle1.YSize + Rectangle2.YSize Then Return True
End Function