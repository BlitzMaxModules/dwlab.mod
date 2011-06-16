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

Type LTMarchingAnts Extends LTVisualizer
	Method DrawUsingSprite( Sprite:LTSprite )
		SetColor( 255.0 * Red, 255.0 * Green, 255.0 * Blue )
		SetAlpha( Alpha )
		
		Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
		L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Sprite.Width * XScale, Sprite.Height * YScale, SWidth, SHeight )
		
		DrawMARect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, L_Round( SWidth ), L_Round( SHeight ) )
		
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Function DrawMARect( X:Double, Y:Double, Width:Double, Height:Double )
		Local Pos:Int = Int( Millisecs() / 100 ) Mod 8
		
		If Width Then
			Local LineImage:TImage = CreateImage( Width, 1 )
			Local LinePixmap:TPixmap = LockImage( LineImage )
			For Local XX:Int = 0 Until Width
				LinePixmap.WritePixel( XX, 0, $FF000000 + $FFFFFF * ( Pos >= 4 ) )
				Pos = ( Pos + 1 ) Mod 8
			Next
			UnlockImage( LineImage )
			SetScale( -1.0, 1.0 )
			DrawImage( LineImage, X + Width, Y )
			SetScale( 1.0, 1.0 )
			DrawImage( LineImage, X, Y + Height - 1 )
		End If

		If Height Then
			Local LineImage:TImage = CreateImage( 1, Height )
			Local LinePixmap:TPixmap = LockImage( LineImage )
			For Local YY:Int = 0 Until Height
				LinePixmap.WritePixel( 0, YY, $FF000000 + $FFFFFF * ( Pos >= 4 ) )
				Pos = ( Pos + 1 ) Mod 8
			Next
			UnlockImage( LineImage )
			DrawImage( LineImage, X, Y )
			SetScale( 1.0, -1.0 )
			DrawImage( LineImage, X + Width - 1, Y + Height )
			SetScale( 1.0, 1.0 )
		End If
	End Function
End Type