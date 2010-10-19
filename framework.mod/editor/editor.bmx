'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Field Window:TGadget
	Field Canvas:TGadget
	
	Field SnapToGrid:TGadget
	Field ShowGrid:TGadget
	
	Field World:LTWorld = New LTWorld
	Field WorldFilename:String
	
	Field Cursor:LTActor = New LTActor
	Field Pan:TPan = New TPan
	Field Z:Int
	
	
	
	Const MenuNew:Int = 1
	Const MenuOpen:Int = 2
	Const MenuSave:Int = 3
	Const MenuSaveAs:Int = 4
	Const MenuImportTiles:Int = 5
	Const MenuImportTilemap:Int = 6
	Const MenuImportObject:Int = 7
	Const MenuExit:Int = 8
	Const MenuSnapToGrid:Int = 9
	Const MenuShowGrid:Int = 10
	Const MenuGridSettings:Int = 11
	Const MenuTilemapSettings:Int = 12
	
	
	Method Init()
		Window  = CreateWindow( "", 0, 0, 100, 100 )
		MaximizeWindow( Window )
		Canvas = CreateCanvas( 0, 0, ClientWidth( Window ), ClientHeight( Window ), Window )
		Enablepolledinput( Canvas )
		SetGraphics( CanvasGraphics( Canvas ) )
		InitCamera()
		
		
		Local FileMenu:TGadget = CreateMenu( "File", 0, WindowMenu( Window ) )
		CreateMenu( "New", MenuNew, FileMenu )
		CreateMenu( "Open...", MenuOpen, FileMenu )
		CreateMenu( "Save...", MenuSave, FileMenu )
		CreateMenu( "Save as...", MenuSaveAs, FileMenu )
		CreateMenu( "", 0, FileMenu )
		CreateMenu( "Import tiles", MenuImportTiles, FileMenu )
		CreateMenu( "Import tilemap", MenuImportTilemap, FileMenu )
		CreateMenu( "Import object", MenuImportObject, FileMenu )
		CreateMenu( "", 0, FileMenu )
		CreateMenu( "Exit", MenuExit, FileMenu )
		
		Local EditMenu:TGadget = CreateMenu( "Edit", 0, WindowMenu( Window ) )
		SnapToGrid = CreateMenu( "Snap to grid", MenuSnapToGrid, EditMenu )
		ShowGrid = CreateMenu( "Show grid", MenuShowGrid, EditMenu )
		CreateMenu( "", 0, EditMenu )
		CreateMenu( "Grid settings", MenuGridSettings, EditMenu )
		CreateMenu( "Tilemap settings", MenuTilemapSettings, EditMenu )
		
		UpdateWindowMenu( Window )
		SetClsColor( 255, 255, 255 )
	End Method
	
	
	
	Method Logic()
		PollEvent()
		Select EventID()
			Case Event_MouseWheel
				Z :+ EventData()
				'debugstop
			Case Event_WindowClose
				ExitEditor()
			Case Event_MenuAction
				Select EventData()
					Case MenuOpen
						Local Filename:String = RequestFile( "Select world file to open...", "DWLab world XML file:xml" )
						If Filename Then 
							WorldFilename = Filename
							World = LTWorld( L_LoadFromFile( Filename ) )
						End If
					Case MenuSave
						If Not WorldFilename Then WorldFilename = RequestFile( "Select world file name to save...", "DWLab world XML file:xml", True )
						If WorldFilename Then World.SaveToFile( WorldFilename )
					Case MenuSaveAs
						WorldFilename = RequestFile( "Select world file name to save...", "DWLab world XML file:xml", True )
						If WorldFilename Then World.SaveToFile( WorldFilename )
					Case MenuImportTilemap
						Local TileXSize:Int, TileYSize:Int
						ChooseTileSize( TileXSize, TileYSize )
						
						Local Filename:String = RequestFile( "Select tilemap file to process...", "Image files:png,jpg,bmp" )
						Local Tilemap:TPixmap = LoadPixmap( Filename )
						If Not Tilemap Then
							Notify( "Cannot load tilemap." )
						Else
							Local TilemapXSize:Int = PixmapWidth( Tilemap )
							Local TilemapYSize:Int = PixmapHeight( Tilemap )
							
							If TilemapXSize Mod TileXSize = 0 And TilemapYSize Mod TileYSize = 0 Then
								ImportTilemap( TileXSize, TileYSize, Tilemap )
							Else
								Notify( "Tilemap size must be divideable by tile size." )
							End If
						End If
					Case MenuSnapToGrid
						ToggleMenu( SnapToGrid )
					Case MenuShowGrid
						ToggleMenu( ShowGrid )
					Case MenuExit
						ExitEditor()
				End Select
		End Select
		
		Cursor.SetMouseCoords()
		Pan.Execute()
		Local NewD:Float = 1.0 * L_ScreenXSize / 32 * ( 1.1 ^ MouseZ() )
		L_CurrentCamera.AlterCameraMagnification( NewD, NewD )
		
		If World.Tilemap Then L_CurrentCamera.LimitWith( World.Tilemap )
	End Method
	
	
	
	Method Render()
		Cls
		If World.Tilemap Then World.Tilemap.Draw()
		SetColor( 0, 0, 0 )
		DrawText( MouseZ() , 0, 0 )
		SetColor( 255, 255, 255 )
	End Method
	
	
	
	Method ToggleMenu( Menu:TGadget )
		If MenuChecked( Menu ) Then
			UnCheckMenu( Menu )
		Else
			CheckMenu( Menu )
		End If
		UpdateWindowMenu( Window )
	End Method
	
	
	
	Method ChooseTileSize( XSize:Int Var, YSize:Int Var )
		Local Settings:TGadget =CreateWindow( "Choose tile size:", 0, 0, 144, 157, Desktop(), WINDOW_TITLEBAR )
		CreateLabel( "Height:", 7, 10, 40, 16, Settings, 0 )
		Local XSizeField:TGadget = CreateTextField( 48, 8, 40, 20, Settings )
		SetGadgetText( XSizeField, "16" )
		CreateLabel( "Width:", 8, 35, 40, 16, Settings, 0 )
		Local YSizeField:TGadget = CreateTextField( 48, 32, 40, 20, Settings )
		SetGadgetText( YSizeField, "16" )
		CreateLabel( "pixels", 93, 10, 31, 16, Settings, 0 )
		CreateLabel( "pixels", 93, 34, 31, 16, Settings, 0 )
		Local OKButton:TGadget = CreateButton( "OK", 32, 64, 72, 24, Settings )
		Local CancelButton:TGadget = CreateButton( "Cancel", 32, 96, 72, 24, Settings )
		
		Repeat
			WaitEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case OKButton
							XSize = TextFieldText( XSizeField ).ToInt()
							YSize = TextFieldText( YSizeField ).ToInt()
							
							If XSize < 0 And YSize < 0 Then
								Notify( "Tile size must be more than 0", True )
							Else
								Exit
							End If
						Case CancelButton
							XSize = 0
							YSize = 0
							Exit
					End Select
			End Select
		Forever
		
		FreeGadget( Settings )
	End Method
	
	
	
	Method ImportTilemap( TileXSize:Int, TileYSize:Int, Tilemap:TPixmap )
		Local TilemapXSize:Int = PixmapWidth( Tilemap )
		Local TilemapYSize:Int = PixmapHeight( Tilemap )
		
		Local TileXQuantity:Int = TilemapXSize / TileXSize
		Local TileYQuantity:Int = TilemapYSize / TileYSize
		
		Local Filename:String = RequestFile( "Select file to save tiles image to...", "png", True )
		If Not Filename Then Return
		
		World.TileMap = New LTTileMap
		World.TileMap.FrameMap = New LTIntMap
		World.TileMap.FrameMap.SetResolution( TileXQuantity, TileYQuantity )
		World.TileMap.X = 0.5 * TileXQuantity
		World.TileMap.Y = 0.5 * TileYQuantity
		World.TileMap.XSize = TileXQuantity
		World.TileMap.YSize = TileYQuantity
		
		Local Tiles:TList = New TList
		For Local Y:Int = 0 Until TileYQuantity
			For Local X:Int = 0 Until TileXQuantity
				Local Pixmap:TPixmap = Tilemap.Window( X * TileXSize, Y * TileYSize, TileXSize, TileYSize )
				
				Local N:Int = 0
				For Local Tile:TPixmap = Eachin Tiles
					If ComparePixmaps( Pixmap, Tile ) Then Exit
					N :+ 1
				Next
				If N = Tiles.Count() Then Tiles.AddLast( Pixmap )
				
				World.TileMap.FrameMap.Value[ X, Y ] = N
			Next
		Next
		
		Local TilesQuantity:Int = Tiles.Count()
		Local TilesPixmap:TPixmap = CreatePixmap( TileXSize * 16, TileYSize * Ceil( 1.0 * TilesQuantity / 16 ), PixmapFormat( Tilemap ) )
		Local N:Int = 0
		For Local Tile:TPixmap = Eachin Tiles
			TilesPixmap.Paste( Tile, ( N Mod 16 ) * TileXSize, Floor( 1.0 * N / 16.0 ) * TileYSize )
			N :+ 1
		Next
		
		SavePixmapPNG( TilesPixmap, Filename )
		World.Tilemap.Visualizer = LTImageVisualizer.FromFile( Filename, 16, Ceil( 1.0 * TilesQuantity / 16 ) )
	End Method
	
	
	
	Method ExitEditor()
		End
	End Method
End Type




	
Function ComparePixmaps:Int( Pixmap1:TPixmap, Pixmap2:TPixmap )
	For Local Y:Int = 0 Until PixmapHeight( Pixmap1 )
		For Local X:Int = 0 Until PixmapWidth( Pixmap1 )
			If ReadPixel( Pixmap1, X, Y ) <> ReadPixel( Pixmap2, X, Y ) Then Return False
		Next
	Next
	Return True
End Function





Type TPan Extends LTDrag
	Field CursorX:Float
	Field CursorY:Float
	
	
	
	Method DragKey:Int()
		If MouseDown( 3 ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		CursorX = Editor.Cursor.X
		CursorY = Editor.Cursor.Y
	End Method
	
	
	
	Method Dragging()
		L_CurrentCamera.X = CursorX - ( MouseX() - L_CurrentCamera.Viewport.X ) / L_CurrentCamera.XK
		L_CurrentCamera.Y = CursorY - ( MouseY() - L_CurrentCamera.Viewport.Y ) / L_CurrentCamera.YK
		L_CurrentCamera.Update()
	End Method
End Type