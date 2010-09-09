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
	
	
	
	Method DrawUsingActor( Actor:LTActor )
		SetColor( 255.0 * R, 255.0 * G, 255.0 * B )
		SetAlpha( Alpha )
		SetProperLineWidth()
		
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Actor.X, Actor.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Actor.XSize * XScale, Actor.YSize * YScale, SXSize, SYSize )
		L_DrawEmptyRect( SX - 0.5 * SXSize, SY - 0.5 * SYSize, SXSize, SYSize )
		
		SetLineWidth( 1.0 )
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
		SetColor( 255.0 * R, 255.0 * G, 255.0 * B )
		SetAlpha( Alpha )
		SetProperLineWidth()
		
		Local SX1:Float, SY1:Float, SX2:Float, SY2:Float
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y, SX2, SY2 )
		DrawLine( SX1, SY1, SX2, SY2 )
		
		SetLineWidth( 1.0 )
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method SetProperLineWidth()
		If Scaling Then
			SetLineWidth( L_CurrentCamera.DistScreenToField( LineWidth ) )
		Else
			SetLineWidth( LineWidth )
		End If
	End Method
End Type