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
		
		SWidth = L_Round( SWidth )
		SHeight = L_Round( SHeight )
		Local Pos:Int = Int( Millisecs() / 100 ) Mod 8
		
		If SWidth Then
			Local LinePixmap:TPixmap = CreatePixmap( SWidth, 1, PF_RGBA8888 )
			For Local XX:Int = 0 Until SWidth
				LinePixmap.WritePixel( XX, 0, $FF000000 + $FFFFFF * ( Pos >= 4 ) )
				Pos = ( Pos + 1 ) Mod 8
			Next
			DrawPixmap( LinePixmap, SX - 0.5 * SWidth, SY - 0.5 * SHeight )
			DrawPixmap( LinePixmap, SX - 0.5 * SWidth, SY + 0.5 * SHeight )
		End If

		If SHeight Then
			Local LinePixmap:TPixmap = CreatePixmap( 1, SHeight, PF_RGBA8888 )
			For Local YY:Int = 0 Until SHeight
				LinePixmap.WritePixel( 0, YY, $FF000000 + $FFFFFF * ( Pos >= 4 ) )
				Pos = ( Pos + 1 ) Mod 8
			Next
			DrawPixmap( LinePixmap, SX - 0.5 * SWidth, SY - 0.5 * SHeight )
			DrawPixmap( LinePixmap, SX + 0.5 * SWidth, SY - 0.5 * SHeight )
		End If
		
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
End Type