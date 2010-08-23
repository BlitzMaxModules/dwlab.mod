' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Global L_DefaultVisual:LTFilledPrimitive = New LTFilledPrimitive

Type LTFilledPrimitive Extends LTVisual
	Method DrawUsingPivot( Pivot:LTPivot )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Pivot.X, Pivot.Y, SX, SY )
		If VisualScale = 1.0 Then
			Plot( SX, SY )
		Else
			DrawOval( SX - VisualScale * 0.5, SY - VisualScale * 0.5, VisualScale, VisualScale )
		End If
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float, SDist:Float
		L_CurrentCamera.FieldToScreen( Circle.X, Circle.Y, SX, SY )
		SDist = L_CurrentCamera.DistFieldToScreen( Circle.Diameter ) * VisualScale
		DrawOval( SX - 0.5 * SDist, SY - 0.5 * SDist, SDist, SDist )
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X, Rectangle.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Rectangle.XSize * VisualScale, Rectangle.YSize * VisualScale, SXSize, SYSize )
		DrawRect( SX - 0.5 * SXSize, SY - 0.5 * SYSize, SXSize, SYSize )
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
		'debugstop
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX1:Float, SY1:Float, SX2:Float, SY2:Float
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y, SX2, SY2 )
		'If VisualScale = 0 Then
			DrawLine( SX1, SY1, SX2, SY2 )
		'Else
		'	Local Dist:Float = 
		'End If
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
End Type