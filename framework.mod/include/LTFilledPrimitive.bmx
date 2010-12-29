'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_DefaultVisualizer:LTFilledPrimitive = New LTFilledPrimitive

Type LTFilledPrimitive Extends LTVisualizer
	Method DrawUsingActor( Actor:LTActor )
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha( Alpha )
		
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Actor.X, Actor.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Actor.XSize * XScale, Actor.YSize * YScale, SXSize, SYSize )
		
		Select Actor.Shape
			Case L_Pivot
				DrawOval( SX - 2, SY - 2, 5, 5 )
			Case L_Circle
				DrawOval( SX - 0.5 * SXSize, SY - 0.5 * SYSize, SXSize, SYSize )
			Case L_Rectangle
				DrawRect( SX - 0.5 * SXSize, SY - 0.5 * SYSize, SXSize, SYSize )
		End Select
		
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha( Alpha )
		
		Local SX1:Float, SY1:Float, SX2:Float, SY2:Float
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y, SX2, SY2 )
		
		DrawLine( SX1, SY1, SX2, SY2 )
		
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
End Type