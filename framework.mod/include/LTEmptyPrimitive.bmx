'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTEmptyPrimitive Extends LTVisual
	Field LineWidth:Float = 1.0
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Pivot.X, Pivot.Y, SX, SY )
		Local SDiameter:Float = L_CurrentCamera.DistScreenToField( VisualScale )
		
		DrawOval( SX - SDiameter * 0.5, SY - SDiameter * 0.5, SDiameter, SDiameter )
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		SetProperLineWidth()
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Circle.X, Circle.Y, SX, SY )
		Local SDiameter:Float = L_CurrentCamera.DistFieldToScreen( Circle.Diameter ) * VisualScale
		
		Local Segs:Int = Max( Int( 2.0 * SDiameter ), 12 ) & ~3
		Local X1:Float, Y1:Float, X2:Float, Y2:Float
		For Local N:Float = 0 To Segs
			Local Angle:Float = 360.0 / Segs * N
			X2 = SX + SDiameter * Cos( Angle )
			Y2 = SY + SDiameter * Sin( Angle )
			If N > 0 Then DrawLine( X1, Y1, X2, Y2 )
			X1 = X2
			Y1 = Y2
		Next
		
		SetLineWidth( 1.0 )
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		SetProperLineWidth()
		
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X, Rectangle.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Rectangle.XSize * VisualScale, Rectangle.YSize * VisualScale, SXSize, SYSize )
		L_DrawEmptyRect( SX - 0.5 * SXSize, SY - 0.5 * SYSize, SXSize, SYSize )
		
		SetLineWidth( 1.0 )
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		SetProperLineWidth()
		
		Local SX1:Float, SY1:Float, SX2:Float, SY2:Float
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y, SX2, SY2 )
		DrawLine( SX1, SY1, SX2, SY2 )
		
		SetLineWidth( 1.0 )
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method SetProperLineWidth()
		If NoScale Then
			SetLineWidth( LineWidth )
		Else
			SetLineWidth( L_CurrentCamera.DistScreenToField( LineWidth ) )
		End If
	End Method
End Type