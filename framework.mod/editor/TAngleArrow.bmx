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

		Local SX1:Float, SY1:Float, SWidth:Float, SHeight:Float, Angle:Float
		L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX1, SY1 )
		L_CurrentCamera.SizeFieldToScreen( Sprite.Width, Sprite.Height, SWidth, SHeight )
		Local Size:Float = Max( SWidth, SHeight )
		Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
		If AngularSprite Then
			Angle = AngularSprite.Angle
		Else
			Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
			If VectorSprite Then
				Angle = ATan2( VectorSprite.DY, VectorSprite.DX )
			Else
				Size = 0
			End If
		End If
		
		If Size Then
			Local SX2:Float = SX1 + Cos( Angle ) * Size
			Local SY2:Float = SY1 + Sin( Angle ) * Size
			DrawLine( SX1, SY1, SX2, SY2 )
			For Local D:Float = -135 To 135 Step 270
				DrawLine( SX2, SY2, SX2 + 5.0 * Cos( Angle + D ), SY2 + 5.0 * Sin( Angle + D ) )
			Next
		End If
		
		SetColor( 255, 255, 255 )
	End Method
End Type