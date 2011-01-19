'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type TAngleArrow Extends LTVisualizer
	Method DrawUsingSprite( Sprite:LTSprite )
		Editor.ShapeVisualizer.ApplyColor()

		Local SX1:Float, SY1:Float, SWidth:Float, SHeight:Float
		L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX1, SY1 )
		L_CurrentCamera.SizeFieldToScreen( Sprite.Width, Sprite.Height, SWidth, SHeight )
		Local Size:Float = Max( SWidth, SHeight )
		Local SX2:Float = SX1 + Cos( Sprite.Angle ) * Size
		Local SY2:Float = SY1 + Sin( Sprite.Angle ) * Size
		DrawLine( SX1, SY1, SX2, SY2 )
		For Local D:Float = -135 To 135 Step 270
			DrawLine( SX2, SY2, SX2 + 5.0 * Cos( Sprite.Angle + D ), SY2 + 5.0 * Sin( Sprite.Angle + D ) )
		Next
		
		SetColor( 255, 255, 255 )
	End Method
End Type