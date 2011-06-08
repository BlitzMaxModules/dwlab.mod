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

Function PrintImageToCanvas:Int( Image:TImage, Canvas:TGadget, XCells:Int, YCells:Int, Frame:Int = -1 )
	SetGraphics( CanvasGraphics( Canvas ) )
	Cls
	
	If Image Then
		Local Modifier:Float = Min( 1.0 * GraphicsWidth() / Image.Width, 1.0 * GraphicsWidth() / Image.Height )
		Local Width:Float = Modifier * Image.Width
		Local Height:Float = Modifier * Image.Height
		Local DX:Int = 0.5 * ( GraphicsWidth() - Width )
		Local DY:Int = 0.5 * ( GraphicsHeight() - Height )
		
		SetScale( Modifier, Modifier )
		DrawImage( Image, DX, DY )
		SetScale( 1.0, 1.0 )
		
		if XCells > 0 And YCells > 0 Then
			If Frame >= XCells * YCells Then Frame = XCells * YCells - 1
			
			SetColor( 255, 0, 255 )
			For Local X:Int = 0 To XCells
				Local XX:Int = Width * X / XCells
				DrawLine( DX + XX, DY, DX + XX, DY + Height )
			Next
			For Local Y:Int = 0 To YCells
				Local YY:Int = Height * Y / YCells
				DrawLine( DX, DY + YY, DX + Width, DY + YY )
			Next
			
			SetColor( 255, 255, 255 )
			
			If Frame >= 0 Then
				Local X:Int = Width * ( Frame Mod XCells ) / XCells
				Local Y:Int = Height * Floor( Frame / XCells ) / YCells
				LTMarchingAnts.DrawMARect( DX + X, DY + Y, Width / XCells + 1, Height / YCells + 1 )
				
				If MouseDown( 1 ) Then
					If MouseX() >= DX And MouseX() < DX + Width And MouseY() >= DY And MouseY() < DY + Width Then
						Frame = Floor( ( MouseX() - DX ) * XCells / Width ) + Floor( ( MouseY() - DY ) * YCells / Height ) * XCells
					End If
				End If
			End If
		End If
	End If
	
	Flip( False )
	
	Return Frame
End Function