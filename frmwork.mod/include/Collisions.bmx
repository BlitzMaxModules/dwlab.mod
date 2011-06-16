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

Const L_Inaccuracy:Double = 0.000001

Function L_PivotWithPivot:Int( Pivot1X:Double, Pivot1Y:Double, Pivot2X:Double, Pivot2Y:Double )
	If Pivot1X = Pivot2X And Pivot1Y = Pivot2Y Then Return True
End Function



Function L_PivotWithCircle:Int( PivotX:Double, PivotY:Double, CircleX:Double, CircleY:Double, CircleDiameter:Double )
	If ( PivotX - CircleX ) * ( PivotX - CircleX ) + ( PivotY - CircleY ) * ( PivotY - CircleY ) < 0.25 * CircleDiameter * CircleDiameter Then Return True
End Function



Function L_PivotWithRectangle:Int( PivotX:Double, PivotY:Double, RectangleX:Double, RectangleY:Double, RectangleWidth:Double, RectangleHeight:Double )
	If 2.0 * Abs( PivotX - RectangleX ) < RectangleWidth - L_Inaccuracy And 2.0 * Abs( PivotY - RectangleY ) < RectangleHeight - L_Inaccuracy Then Return True
End Function



Function L_CircleWithCircle:Int( Circle1X:Double, Circle1Y:Double, Circle1Diameter:Double, Circle2X:Double, Circle2Y:Double, Circle2Diameter:Double )
	If 4.0 * ( ( Circle2X - Circle1X ) * ( Circle2X - Circle1X ) + ( Circle2Y - Circle1Y ) * ( Circle2Y - Circle1Y ) ) < ( Circle2Diameter + Circle1Diameter ) * ( Circle2Diameter + Circle1Diameter ) - L_Inaccuracy Then Return True
End Function



Function L_CircleWithRectangle:Int( CircleX:Double, CircleY:Double, CircleDiameter:Double, RectangleX:Double, RectangleY:Double, RectangleWidth:Double, RectangleHeight:Double )
	If ( RectangleX - RectangleWidth * 0.5 <= CircleX And CircleX <= RectangleX + RectangleWidth * 0.5 ) Or ( RectangleY - RectangleHeight * 0.5 <= CircleY And CircleY <= RectangleY + RectangleHeight * 0.5 ) Then
		If 2.0 * Abs( CircleX - RectangleX ) < CircleDiameter + RectangleWidth - L_Inaccuracy And 2.0 * Abs( CircleY - RectangleY ) < CircleDiameter + RectangleHeight - L_Inaccuracy Then Return True
	Else
		Local DX:Double = Abs( RectangleX - CircleX ) - 0.5 * RectangleWidth
		Local DY:Double = Abs( RectangleY - CircleY ) - 0.5 * RectangleHeight
		If 4.0 * ( DX * DX + DY * DY ) < CircleDiameter * CircleDiameter - L_Inaccuracy Then Return True
	End If
End Function



Function L_RectangleWithRectangle:Int( Rectangle1X:Double, Rectangle1Y:Double, Rectangle1Width:Double, Rectangle1Height:Double, Rectangle2X:Double, Rectangle2Y:Double, Rectangle2Width:Double, Rectangle2Height:Double )
	If 2.0 * Abs( Rectangle1X - Rectangle2X ) < Rectangle1Width + Rectangle2Width - L_Inaccuracy And 2.0 * Abs( Rectangle1Y - Rectangle2Y ) < Rectangle1Height + Rectangle2Height - L_Inaccuracy Then Return True
End Function



Function L_CircleWithLine:Int( CircleX:Double, CircleY:Double, CircleDiameter:Double, LineX1:Double, LineY1:Double, LineX2:Double, LineY2:Double )
	Local A:Double = LineY2 - LineY1
	Local B:Double = LineX1 - LineX2
	Local C1:Double = -A * LineX1 - B * LineY1
	Local AABB:Double = A * A + B * B
	Local D:Double = Abs( A * CircleX + B * CircleY + C1 ) / AABB
	If D < 0.5 * CircleDiameter Then
		If L_PivotWithCircle( LineX1, LineY1, CircleX, CircleY, CircleDiameter ) Then Return True
		If L_PivotWithCircle( LineX2, LineY2, CircleX, CircleY, CircleDiameter ) Then Return True
		Local C2:Double = A * CircleY - B * CircleX
		Local X0:Double = -( A * C1 + B * C2 ) / AABB
		Local Y0:Double = ( A * C2 - B * C1 ) / AABB
		If LineX1 <> LineX2 Then
			If Min( LineX1, LineX2 ) <= X0 And X0 <= Max( LineX1, LineX2 ) Then Return True
		Else
			If Min( LineY1, LineY2 ) <= Y0 And Y0 <= Max( LineY1, LineY2 ) Then Return True
		End If
	End If
End Function



Function L_CircleOverlapsCircle:Int( Circle1X:Double, Circle1Y:Double, Circle1Diameter:Double, Circle2X:Double, Circle2Y:Double, Circle2Diameter:Double )
	If 4.0 * ( ( Circle1X - Circle2X ) * ( Circle1X - Circle2X ) + ( Circle1Y - Circle2Y ) * ( Circle1Y - Circle2Y ) ) <= ( Circle1Diameter - Circle2Diameter ) * ( Circle1Diameter - Circle2Diameter ) Then Return True
End Function



Function L_RectangleOverlapsRectangle:Int( Rectangle1X:Double, Rectangle1Y:Double, Rectangle1Width:Double, Rectangle1Height:Double, Rectangle2X:Double, Rectangle2Y:Double, Rectangle2Width:Double, Rectangle2Height:Double )
	If ( Rectangle1X - 0.5 * Rectangle1Width <= Rectangle2X - 0.5 * Rectangle2Width ) And ( Rectangle1Y - 0.5 * Rectangle1Height <= Rectangle2Y - 0.5 * Rectangle2Height ) And ..
		( Rectangle1X + 0.5 * Rectangle1Width >= Rectangle2X + 0.5 * Rectangle2Width ) And ( Rectangle1Y + 0.5 * Rectangle1Height >= Rectangle2Y + 0.5 * Rectangle2Height ) Then Return True
End Function