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

SuperStrict

import maxgui.win32maxguiex

include "../framework.bmx"
include "LTPan.bmx"
include "LTGrid.bmx"

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Field Window:TGadget
	Field Canvas:TGadget
	Field SpritesListBox:TGadget
	
	Field SnapToGrid:TGadget
	Field ShowGrid:TGadget
	Field EditTiles:TGadget
	Field EditSprites:TGadget
	Field Grid:LTGrid = New LTGrid
	
	Field World:LTWorld = New LTWorld
	Field WorldFilename:String
	
	Field Cursor:LTActor = New LTActor
	Field Pan:LTPan = New LTPan
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
	Const MenuEditTiles:Int = 13
	Const MenuEditSprites:Int = 14
	Const MenuAddSpriteType:Int = 15
	
	
	
	Method Init()
		Window  = CreateWindow( "", 0, 0, 640, 480 )
		MaximizeWindow( Window )
		Canvas = CreateCanvas( 0, 0, ClientWidth( Window ) - 200, ClientHeight( Window ), Window )
		SetGadgetLayout( Canvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		SpritesListBox = CreateListBox( ClientWidth( Window ) - 200, 0, 200, ClientHeight( Window ), Window )
		SetGadgetLayout( SpritesListBox, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Aligned )
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
		CreateMenu( "", 0, EditMenu )
		EditTiles = CreateMenu( "Edit tiles", MenuEditTiles, EditMenu )
		EditSprites = CreateMenu( "Edit sprites", MenuEditSprites, EditMenu )
		CreateMenu( "", 0, EditMenu )
		CreateMenu( "Add sprite type", MenuAddSpriteType, EditMenu )
		CheckMenu( EditSprites )
		
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
					Case MenuEditTiles
						CheckMenu( EditTiles )
						UnCheckMenu( EditSprites )
					Case MenuEditSprites
						UnCheckMenu( EditTiles )
						CheckMenu( EditSprites )
					Case MenuAddSpriteType
						Local SpriteType:LTSpriteType = New LTSpriteType
						If SpriteTypeProperties( SpriteType ) Then
							World.SpriteTypes.AddLast( SpriteType )
							RefreshSpriteTypeList()
						End If
					Case MenuExit
						ExitEditor()
				End Select
		End Select
		
		Cursor.SetMouseCoords()
		Pan.Execute()
		Local NewD:Float = 1.0 * GraphicsWidth() / 32.0 * ( 1.1 ^ MouseZ() )
		L_CurrentCamera.SetMagnification( NewD, NewD )
		
		If World.Tilemap Then L_CurrentCamera.LimitWith( World.Tilemap )
	End Method
	
	
	
	Method Render()
		Cls
		L_CurrentCamera.Viewport.X = 0.5 * Canvas.GetWidth()
		L_CurrentCamera.Viewport.Y = 0.5 * Canvas.GetHeight()
		L_CurrentCamera.Viewport.XSize = Canvas.GetWidth()
		L_CurrentCamera.Viewport.YSize = Canvas.GetHeight()
		World.Draw()
		if MenuChecked( ShowGrid ) Then Grid.Draw()
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
	
	
	
	Method SpriteTypeProperties:Int( SpriteType:LTSpriteType )
		Local EditWindow:TGadget = CreateWindow( "Sprite type properties", 0, 00, 161, 339, Desktop(), WINDOW_TITLEBAR|WINDOW_RESIZABLE )
		CreateLabel( "Name:", 8, 8, 40, 16, EditWindow, 0 )
		Local NameTextField:TGadget = CreateTextField( 48, 5, 96, 20, EditWindow )
		CreateLabel( "Horizontal cells:", 8, 32, 75, 16, EditWindow, 0 )
		Local XCellsTextField:TGadget = CreateTextField( 88, 29, 56, 20, EditWindow )
		CreateLabel( "Vertical cells:", 8, 56, 62, 16, EditWindow, 0 )
		Local YCellsTextField:TGadget = CreateTextField( 88, 53, 56, 20, EditWindow )
		CreateLabel( "Shape:", 8, 80, 40, 16, EditWindow, 0 )
		Local ShapeBox:TGadget = CreateComboBox( 50, 77, 94, 20, EditWindow )
		Local ImageCanvas:TGadget = CreateCanvas( 8, 104, 136, 136, EditWindow )
		Local LoadImageButton:TGadget = CreateButton( "Load image", 8, 248, 136, 24, EditWindow, BUTTON_PUSH )
		Local OkButton:TGadget = CreateButton( "OK", 8, 280, 64, 24, EditWindow, BUTTON_PUSH )
		Local CancelButton:TGadget = CreateButton( "Cancel", 80, 280, 64, 24, EditWindow, BUTTON_PUSH )

		AddGadgetItem( ShapeBox, "Pivot" )
		AddGadgetItem( ShapeBox, "Circle" )
		AddGadgetItem( ShapeBox, "Rectangle" )
		SelectGadgetItem( ShapeBox, L_Rectangle )
		
		SetGadgetText( NameTextField, SpriteType.TypeName )
		SetGadgetText( XCellsTextField, SpriteType.XCells )
		SetGadgetText( YCellsTextField, SpriteType.YCells )
	
		Local Image:TImage = SpriteType.BMaxImage
		Local Filename:String = ""
		
		Repeat
			Local XCells:Int = TextFieldText( XCellsTextField ).ToInt()
			Local YCells:Int = TextFieldText( YCellsTextField ).ToInt()
			
			If Image Then
				SetGraphics( CanvasGraphics( ImageCanvas ) )
				SetScale( 1.0 * GraphicsWidth() / Image.Width, 1.0 * GraphicsWidth() / Image.Height )
				DrawImage( Image, 0, 0 )
				SetScale( 1.0, 1.0 )
				
				if XCells > 0 And YCells > 0 Then
					If Image.Width Mod XCells = 0 And Image.Height Mod YCells = 0 Then
						SetColor( 255, 0, 255 )
						For Local X:Int = 0 Until XCells
							Local XX:Int = 136.0 * X / XCells
							DrawLine( XX, 0, XX, 136 )
						Next
						For Local Y:Int = 0 Until YCells
							Local YY:Int = 136.0 * Y / YCells
							DrawLine( 0, YY, 136, YY )
						Next
						SetColor( 255, 255, 255 )
					End If
				End If
				
				Flip
				SetGraphics( CanvasGraphics( Canvas ) )
			End If
			
			PollEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case LoadImageButton
							Filename = RequestFile( "Select image..., ". "Image files:png,jpg,bmp" )
							If Filename Then Image = LoadImage( Filename ) Else Image = Null
						Case OKButton
							If Image And Filename Then
								Local TypeName:String = TextFieldText( NameTextField )
								Local Shape:Int = SelectedGadgetItem( ShapeBox )
								
								If XCells > 0 And YCells > 0 Then
									If Image.Width Mod XCells = 0 And Image.Height Mod YCells = 0 Then
										SpriteType.TypeName = TypeName
										SpriteType.XCells = XCells
										SpriteType.YCells = YCells
										SpriteType.Shape = Shape
										SpriteType.Filename = Filename
										SpriteType.Init()
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
							FreeGadget( EditWindow )
							Return False
					End Select
			End Select
		Forever
		
	End Method
	
	
	
	Method RefreshSpriteTypeList()
		ClearGadgetItems( SpritesListBox )
		For Local SpriteType:LTSpriteType = Eachin World.SpriteTypes
			AddGadgetItem( SpritesListBox, SpriteType.TypeName )
		Next
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