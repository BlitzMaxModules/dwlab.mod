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

Global RealPathsForImages:TMap = New TMap
	
Function SpriteImageProperties:Int( Sprite:LTActor )
	Local EditWindow:TGadget = CreateWindow( "Sprite type properties", 0.5 * ClientWidth( Desktop() ) - 252, 0.5 * ClientHeight( Desktop() ) - 320, 505, 639, Editor.Window, WINDOW_TITLEBAR|WINDOW_RESIZABLE )
	CreateLabel( "Horizontal cells:", 180, 8, 75, 16, EditWindow, 0 )
	Local XCellsTextField:TGadget = CreateTextField( 260, 5, 56, 20, EditWindow )
	CreateLabel( "Vertical cells:", 180, 32, 62, 16, EditWindow, 0 )
	Local YCellsTextField:TGadget = CreateTextField( 260, 29, 56, 20, EditWindow )
	Local ImageCanvas:TGadget = CreateCanvas( 8, 56, 480, 480, EditWindow )
	Local LoadImageButton:TGadget = CreateButton( "Load image", 180, 544, 136, 24, EditWindow, BUTTON_PUSH )
	Local OkButton:TGadget = CreateButton( "OK", 180, 576, 64, 24, EditWindow, BUTTON_PUSH )
	Local CancelButton:TGadget = CreateButton( "Cancel", 252, 576, 64, 24, EditWindow, BUTTON_PUSH )

	Local Image:TImage
	Local Filename:String = ""
	Local Frame:Int = Sprite.Frame
	Local SpriteImage:LTImage = LTImageVisualizer( Sprite.Visualizer ).Image
	
	If SpriteImage Then
		Image = LoadImage( SpriteImage.Filename )
		Filename = SpriteImage.Filename
		SetGadgetText( XCellsTextField, SpriteImage.XCells )
		SetGadgetText( YCellsTextField, SpriteImage.YCells )
	Else
		SetGadgetText( XCellsTextField, 1 )
		SetGadgetText( YCellsTextField, 1 )
	End If
	
	ActivateGadget( ImageCanvas )
	DisablePolledInput()
	EnablePolledInput( ImageCanvas )
	
	Repeat
		Local XCells:Int = TextFieldText( XCellsTextField ).ToInt()
		Local YCells:Int = TextFieldText( YCellsTextField ).ToInt()
		
		SetGraphics( CanvasGraphics( ImageCanvas ) )
		Cls
		
		If Image Then
			SetScale( 1.0 * GraphicsWidth() / Image.Width, 1.0 * GraphicsWidth() / Image.Height )
			DrawImage( Image, 0, 0 )
			SetScale( 1.0, 1.0 )
			
			if XCells > 0 And YCells > 0 Then
				If Frame >= XCells * YCells Then Frame = XCells * YCells - 1
				
				SetColor( 255, 0, 255 )
				For Local X:Int = 0 Until XCells
					Local XX:Int = 480.0 * X / XCells
					DrawLine( XX, 0, XX, 480 )
				Next
				For Local Y:Int = 0 Until YCells
					Local YY:Int = 480.0 * Y / YCells
					DrawLine( 0, YY, 480, YY )
				Next
				
				Local Col:Int = ( Int( Millisecs() / 100 ) Mod 2 ) * 255
				SetColor( Col, Col, Col )
				Local X:Int = 480.0 * ( Frame Mod XCells ) / XCells
				Local Y:Int = 480.0 * Floor( Frame / XCells ) / YCells
				LTMarchingAnts.DrawMARect( X, Y, 480.0 / XCells + 1, 480.0 / YCells + 1 )
				
				SetColor( 255, 255, 255 )
			End If
		End If
		
		Flip
		SetGraphics( CanvasGraphics( Editor.MainCanvas ) )
		
		PollEvent()
		
		If MouseDown( 1 ) Then
			If MouseX() >= 0 And MouseX() < 480 And MouseY() >= 0 And MouseY() < 480 Then
				Frame = Floor( MouseX() * XCells / 480.0 ) + Floor( MouseY() * YCells / 480.0 ) * XCells
			End If
		End If
		
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case LoadImageButton
						Filename = RequestFile( "Select image..., ". "Image files:png,jpg,bmp" )
						Filename = ChopFilename( Filename )
						If Filename Then Image = LoadImage( Filename ) Else Image = Null
					Case OKButton
						If Image Then
							If XCells > 0 And YCells > 0 Then
								If Image.Width Mod XCells = 0 And Image.Height Mod YCells = 0 Then
									LTImageVisualizer( Sprite.Visualizer ).Image = LoadImageFromFile( Filename, XCells, YCells )
									Sprite.Frame = Frame
									Editor.SetChanged()
									FreeGadget( EditWindow )
									Return True
								Else
									Notify( "Image sizes must be divideable by tile cells quantity", True )
								End If
							Else
								Notify( "Tile cells quantity must be more than 0", True )
							End If
						Else
							Notify( "Image required", True )
						End If
					Case CancelButton
						Exit
				End Select
			Case Event_WindowClose
				Exit
		End Select
	Forever
	FreeGadget( EditWindow )
	Return False
End Function
	
	
	
Function LoadImageFromFile:LTImage( Filename:String, XCells:Int, YCells:Int )
	Local Image:LTImage = LTImage.FromFile( Filename, XCells, YCells )
	InitImage( Image )
	Return Image
End Function



Function InitImage( Image:LTImage )
	Local Filename:String = Image.Filename 
	RealPathsForImages.Insert( Image, RealPath( Filename ) )
	Local TilesetFilename:String = Filename[ ..Len( Filename ) - 3 ] + "xml"
	If FileType( TilesetFilename ) = 1 Then 
		Local Tileset:LTTileset = LTTileset( L_LoadFromFile( TilesetFilename ) )
		TilesetMap.Insert( Image, Tileset )
		Tileset.Init()
	End If
End Function