'
' Masked images smoother Digital Wizard's Lab tool
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
SuperStrict

Framework brl.basic
import brl.pixmap
import brl.system
import brl.pngloader

Local FileName:String = RequestFile( "Select file to process", "PNG files:png" )
Local Pixmap:TPixmap = LoadPixmap( FileName )
If PixmapFormat( Pixmap ) = PF_RGBA8888 Then 
	Local Width:Int = PixmapWidth( Pixmap )
	Local Height:Int = PixmapHeight( Pixmap )
	For Local Y:Int = 0 Until Height
		For Local X:Int = 0 Until Width
			If ReadPixel( Pixmap, X, Y ) & $FF000000 Then Continue
			
			Local Quantity:Int = 0
			Local Red:Int = 0
			Local Green:Int = 0
			Local Blue:Int = 0
			For Local DY:Int = -1 To 1
				If Y + DY < 0 Or Y + DY >= Height Then Continue
				
				For Local DX:Int = -1 To 1
					If X + DX < 0 Or X + DX >= Width Then Continue
				
					Local Pixel:Int = ReadPixel( Pixmap, X + DX, Y + DY )
					If Pixel & $FF000000 Then
						Blue :+ ( Pixel & $FF0000 ) Shr 16
						Green :+ ( Pixel & $FF00 ) Shr 8
						Red :+ ( Pixel & $FF )
						Quantity :+ 1
					End If
				Next
			Next
			
			If Quantity Then WritePixel( Pixmap, X, Y, Int( 0.5 + Red / Quantity ) + ( Int( 0.5 + Green / Quantity ) Shl 8 ) + ( Int( 0.5 + Blue / Quantity ) Shl 16 ) )
		Next
	Next
	
	SavePixmapPNG( Pixmap, FileName )
Else
	Notify( "Format not supported or there's no alpha channel" )
End If