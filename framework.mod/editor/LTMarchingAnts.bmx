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
	Method DrawUsingActor( Actor:LTActor )
		SetColor( 255.0 * Red, 255.0 * Green, 255.0 * Blue )
		SetAlpha( Alpha )
		
		Local SX:Float, SY:Float, SWidth:Float, SHeight:Float
		L_CurrentCamera.FieldToScreen( Actor.X, Actor.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Actor.Width * XScale, Actor.Height * YScale, SWidth, SHeight )
		
		DrawMARect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, L_Round( SWidth ), L_Round( SHeight ) )
		
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Function DrawMARect( X:Float, Y:Float, Width:Float, Height:Float )
		Local Pos:Int = Int( Millisecs() / 100 ) Mod 8
		
		If Width Then
			Local LinePixmap:TPixmap = CreatePixmap( Width, 1, PF_RGBA8888 )
			For Local XX:Int = 0 Until Width
				LinePixmap.WritePixel( XX, 0, $FF000000 + $FFFFFF * ( Pos >= 4 ) )
				Pos = ( Pos + 1 ) Mod 8
			Next
			DrawPixmap( LinePixmap, X, Y )
			DrawPixmap( LinePixmap, X, Y + Height - 1 )
		End If

		If Height Then
			Local LinePixmap:TPixmap = CreatePixmap( 1, Height, PF_RGBA8888 )
			For Local YY:Int = 0 Until Height
				LinePixmap.WritePixel( 0, YY, $FF000000 + $FFFFFF * ( Pos >= 4 ) )
				Pos = ( Pos + 1 ) Mod 8
			Next
			DrawPixmap( LinePixmap, X, Y )
			DrawPixmap( LinePixmap, X + Width - 1, Y )
		End If
	End Function
End Type