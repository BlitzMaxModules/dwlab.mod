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

Function PrintImageToCanvas:Int( Image:TImage, Canvas:TGadget, XCells:Int = 0, YCells:Int = 0, Frame:Int = -1, SelectFrame:Int = True, TileSet:LTTileSet = Null )
	SetGraphics( CanvasGraphics( Canvas ) )
	SetBlend( AlphaBlend )
	Cls
	
	If Image Then
		Local Modifier:Double = Min( 1.0 * GraphicsWidth() / ImageWidth( Image ), 1.0 * GraphicsWidth() / ImageHeight( Image ) )
		Local Width:Double = Modifier * ImageWidth( Image )
		Local Height:Double = Modifier * ImageHeight( Image )
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
			
			If TileSet Then
				SetAlpha( 0.5 )
				For Local Y:Int = 0 Until YCells
					For Local X:Int = 0 Until XCells
						Local Shape:LTShape = TileSet.CollisionShape[ X + Y * XCells ]
						If Shape Then
							Local XX:Double = DX + Width * X / XCells
							Local YY:Double = DY + Height * Y / YCells
							Local Sprite:LTSprite = LTSprite( Shape )
							If Sprite Then
								DrawCollisionSprite( Sprite, XX, YY, Width / XCells, Height / YCells )
							Else
								For Sprite = Eachin LTLayer( Shape )
									DrawCollisionSprite( Sprite, XX, YY, Width / XCells, Height / YCells )
								Next
							End If
						End If
					Next
				Next
				SetAlpha( 1.0 )
			End If
			
			SetColor( 255, 255, 255 )
			
			If Frame >= 0 Then
				Local X:Int = Width * ( Frame Mod XCells ) / XCells
				Local Y:Int = Height * Floor( Frame / XCells ) / YCells
				LTMarchingAnts.DrawMARect( DX + X, DY + Y, Width / XCells + 1, Height / YCells + 1 )
				
				If MouseX() >= DX And MouseX() < DX + Width And MouseY() >= DY And MouseY() < DY + Height Then
					If SelectFrame Then
						Local SelectedFrame:Int = Floor( ( MouseX() - DX ) * XCells / Width ) + Floor( ( MouseY() - DY ) * YCells / Height ) * XCells
						If MouseDown( 1 ) Then
							Frame = SelectedFrame
						ElseIf MouseDown( 2 ) Then
							Frame2 = SelectedFrame
						End If
					End If
				End If
			End If
		End If
	End If
	
	Flip( False )
	'EndGraphics
	SetGraphics( CanvasGraphics( Editor.MainCanvas ) )

	Return Frame
End Function





Function DrawCollisionSprite( Sprite:LTSprite, X:Double, Y:Double, Width:Double, Height:Double )
	LTSpriteHandler.HandlersArray[ Sprite.ShapeType.GetNum() ].DrawShape( Sprite, Sprite, X + Width * Sprite.X, ..
			Y + Height * Sprite.Y, Width * Sprite.Width, Height * Sprite.Height )
End Function