'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: This visualizer draws contours of the shape.
End Rem
Type LTContourVisualizer Extends LTVisualizer
	Rem
	bbdoc: Width of contour lines.
	End Rem
	Field LineWidth:Double = 1.0
	Field DrawPivot1:Int = True
	Field DrawPivot2:Int = True
	Field PivotScale:Double = 1.0
	
	
	
	Rem
	bbdoc: Creates new contour visualizer using given RGB color components and transparency.
	returns: New visualizer.
	about: See also: #FromFile, #FromImage
	End Rem
	Function FromWidthAndRGBColor:LTContourVisualizer( Width:Double, Red:Double = 1.0, Green:Double = 1.0, Blue:Double = 1.0, Alpha:Double = 1.0, PivotScale:Double = 1.0 )
		Local Visualizer:LTContourVisualizer = New LTContourVisualizer
		Visualizer.SetColorFromRGB( Red, Green, Blue )
		Visualizer.Alpha = Alpha
		Visualizer.LineWidth = Width
		Visualizer.PivotScale = PivotScale
		Return Visualizer
	End Function
	
	
	
	Rem
	bbdoc: Creates new contour visualizer using given hexadecimal color representation and transparency.
	returns: New visualizer.
	about: See also: #FromFile, #FromImage
	End Rem
	Function FromWidthAndHexColor:LTContourVisualizer( Width:Double, HexColor:String = "FFFFFF", Alpha:Double = 1.0, PivotScale:Double = 1.0 )
		Local Visualizer:LTContourVisualizer = New LTContourVisualizer
		Visualizer.SetColorFromHex( HexColor )
		Visualizer.Alpha = Alpha
		Visualizer.LineWidth = Width
		Visualizer.PivotScale = PivotScale
		Return Visualizer
	End Function
	
		
	
	Method DrawUsingSprite( Sprite:LTSprite )
		If Not Sprite.Visible Then Return
		
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha( Alpha )
		SetProperLineWidth()
		
		Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
		L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Sprite.Width * XScale, Sprite.Height * YScale, SWidth, SHeight )
		L_DrawEmptyRect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
		
		SetLineWidth( 1.0 )
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLineSegment )
		If Not Line.Visible Then Return
		
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha( Alpha )
		SetProperLineWidth()
		
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y, SX2, SY2 )
		DrawLine( SX1, SY1, SX2, SY2 )
		
		Local Radius:Double = L_CurrentCamera.DistFieldToScreen( LineWidth ) * PivotScale
		If DrawPivot1 Then DrawOval( SX1 - 0.5 * Radius, SY1 - 0.5 * Radius, Radius, Radius )
		If DrawPivot2 Then DrawOval( SX2 - 0.5 * Radius, SY2 - 0.5 * Radius, Radius, Radius )
		
		SetLineWidth( 1.0 )
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method SetProperLineWidth()
		If Scaling Then
			SetLineWidth( L_CurrentCamera.DistFieldToScreen( LineWidth ) )
		Else
			SetLineWidth( LineWidth )
		End If
	End Method
End Type