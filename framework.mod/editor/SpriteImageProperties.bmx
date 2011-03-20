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
	
Function SpriteImageProperties:Int( Sprite:LTSprite )
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
				
				Local X:Int = Width * ( Frame Mod XCells ) / XCells
				Local Y:Int = Height * Floor( Frame / XCells ) / YCells
				LTMarchingAnts.DrawMARect( DX + X, DY + Y, Width / XCells + 1, Height / YCells + 1 )
			End If
			
			If MouseDown( 1 ) Then
				If MouseX() >= DX And MouseX() < DX + Width And MouseY() >= Dy And MouseY() < DY + Width Then
					Frame = Floor( ( MouseX() - DX ) * XCells / Width ) + Floor( ( MouseY() - DY ) * YCells / Height ) * XCells
				End If
			End If
		End If
		
		Flip
		SetGraphics( CanvasGraphics( Editor.MainCanvas ) )
		
		PollEvent()
		
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case LoadImageButton
						Filename = RequestFile( "Select image... ", "Image files:png,jpg,bmp" )
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
	Local TilesetFilename:String = Filename + ".lts"
	If FileType( TilesetFilename ) = 1 Then 
		Local Tileset:LTTileset = LTTileset( L_LoadFromFile( TilesetFilename ) )
		TilesetMap.Insert( Image, Tileset )
		Tileset.Init()
	End If
End Function