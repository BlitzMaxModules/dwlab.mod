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

Function L_PivotWithPivot:Int( Pivot1X:Float, Pivot1Y:Float, Pivot2X:Float, Pivot2Y:Float )
	If Pivot1X = Pivot2X And Pivot1Y = Pivot2Y Then Return True
End Function



Function L_PivotWithCircle:Int( PivotX:Float, PivotY:Float, CircleX:Float, CircleY:Float, CircleDiameter:Float )
	If ( PivotX - CircleX ) * ( PivotX - CircleX ) + ( PivotY - CircleY ) * ( PivotY - CircleY ) < 0.25 * CircleDiameter * CircleDiameter Then Return True
End Function



Function L_PivotWithRectangle:Int( PivotX:Float, PivotY:Float, RectangleX:Float, RectangleY:Float, RectangleXSize:Float, RectangleYSize:Float )
	If 2.0 * Abs( PivotX - RectangleX ) < RectangleXSize And 2.0 * Abs( PivotY - RectangleY ) < RectangleYSize Then Return True
End Function



Function L_CircleWithCircle:Int( Circle1X:Float, Circle1Y:Float, Circle1Diameter:Float, Circle2X:Float, Circle2Y:Float, Circle2Diameter:Float )
	If 4.0 * ( ( Circle2X - Circle1X ) * ( Circle2X - Circle1X ) + ( Circle2Y - Circle1Y ) * ( Circle2Y - Circle1Y ) ) < ( Circle2Diameter + Circle1Diameter ) * ( Circle2Diameter + Circle1Diameter ) Then Return True
End Function



Function L_CircleWithRectangle:Int( CircleX:Float, CircleY:Float, CircleDiameter:Float, RectangleX:Float, RectangleY:Float, RectangleXSize:Float, RectangleYSize:Float )
	If ( RectangleX - RectangleXSize * 0.5 <= CircleX And CircleX <= RectangleX + RectangleXSize * 0.5 ) Or ( RectangleY - RectangleYSize * 0.5 <= CircleY And CircleY <= RectangleY + RectangleYSize * 0.5 ) Then
		If 2.0 * Abs( CircleX - RectangleX ) < CircleDiameter + RectangleXSize And 2.0 * Abs( CircleY - RectangleY ) < CircleDiameter + RectangleYSize Then Return True
	Else
		Local DX:Float = Abs( RectangleX - CircleX ) - 0.5 * RectangleXSize
		Local DY:Float = Abs( RectangleY - CircleY ) - 0.5 * RectangleYSize
		If 4.0 * ( DX * DX + DY * DY ) < CircleDiameter * CircleDiameter Then Return True
	End If
End Function



Function L_RectangleWithRectangle:Int( Rectangle1X:Float, Rectangle1Y:Float, Rectangle1XSize:Float, Rectangle1YSize:Float, Rectangle2X:Float, Rectangle2Y:Float, Rectangle2XSize:Float, Rectangle2YSize:Float )
	If 2.0 * Abs( Rectangle1X - Rectangle2X ) < Rectangle1XSize + Rectangle2XSize And 2.0 * Abs( Rectangle1Y - Rectangle2Y ) < Rectangle1YSize + Rectangle2YSize Then Return True
End Function



Function L_CircleWithLine:Int( CircleX:Float, CircleY:Float, CircleDiameter:Float, LineX1:Float, LineY1:Float, LineX2:Float, LineY2:Float )
	Local A:Float = LineY2 - LineY1
	Local B:Float = LineX1 - LineX2
	Local C1:Float = -A * LineX1 - B * LineY1
	Local AABB:Float = A * A + B * B
	Local D:Float = Abs( A * CircleX + B * CircleY + C1 ) / AABB
	If D < 0.5 * CircleDiameter Then
		If L_PivotWithCircle( LineX1, LineY1, CircleX, CircleY, CircleDiameter ) Then Return True
		If L_PivotWithCircle( LineX2, LineY2, CircleX, CircleY, CircleDiameter ) Then Return True
		Local C2:Float = A * CircleY - B * CircleX
		Local X0:Float = -( A * C1 + B * C2 ) / AABB
		Local Y0:Float = ( A * C2 - B * C1 ) / AABB
		If LineX1 <> LineX2 Then
			If Min( LineX1, LineX2 ) <= X0 And X0 <= Max( LineX1, LineX2 ) Then Return True
		Else
			If Min( LineY1, LineY2 ) <= Y0 And Y0 <= Max( LineY1, LineY2 ) Then Return True
		End If
	End If
End Function