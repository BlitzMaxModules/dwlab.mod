'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Import dwlab.frmwork

PackPNG( "Explo", 2, 0, 39, 8 )

Function PackPNG( Header:String, Digits:Int, FromNum:Int, ToNum:Int, FramesInRow:Int )
	Local Quantity:Int = ToNum - FromNum + 1
	Local Pixmaps:TPixmap[] = New TPixmap[ Quantity ]
	For Local Num:Int = 0 Until Quantity
		Pixmaps[ Num ] = LoadPixmap( Header + L_FirstZeroes( Num + FromNum, Digits ) + ".png" )
	Next
	Local Width:Int = PixmapWidth( Pixmaps[ 0 ] )
	Local Height:Int = PixmapHeight( Pixmaps[ 0 ] )
	Local BigPixmap:TPixmap = CreatePixmap( Width * FramesInRow, Height * Ceil( 1.0 * Quantity / FramesinRow ), PixmapFormat( Pixmaps[ 0 ] ) )
	For Local Num:Int = 0 Until Quantity
		BigPixmap.Paste( Pixmaps[ Num ], Width * ( Num Mod FramesinRow ), Height * Floor( 1.0 * Num / FramesInRow ) )
	Next
	SavePixmapPNG( BigPixmap, Header + ".png", 9 )
End Function