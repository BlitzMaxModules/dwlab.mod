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
include "LTCreateSprite.bmx"
include "LTModifySprite.bmx"
include "LTGrid.bmx"
include "LTMarchingAnts.bmx"

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Field Window:TGadget
	Field Canvas:TGadget
	Field SpriteTypesListBox:TGadget
	Field PagesListBox:TGadget
	
	Field SnapToGrid:TGadget
	Field ShowGrid:TGadget
	Field EditTilemap:TGadget
	Field EditSprites:TGadget
	Field Grid:LTGrid = New LTGrid
	Field Dragging:Int
	
	Field World:LTWorld = New LTWorld
	Field CurrentPage:LTPage
	Field CurrentSpriteType:LTSpriteType
	Field SelectedSprites:TList = New TList
	Field WorldFilename:String
	Field ModifiersImage:TImage
	Field Modifiers:TList = New TList
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	Field Cursor:LTActor = New LTActor
	Field Pan:LTPan = New LTPan
	Field CreateSprite:LTCreateSprite = New LTCreateSprite
	Field ModifySprite:LTModifySprite = New LTModifySprite
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
	Const MenuEditTilemap:Int = 13
	Const MenuEditSprites:Int = 14
	Const MenuAddSpriteType:Int = 15
	Const MenuAddPage:Int = 16
	
	
	
	Const Move:Int = 0
	Const ResizeHorizontally:Int = 1
	Const ResizeVertically:Int = 2
	Const Resize:Int = 3
	Const ResizeDiagonally1:Int = 4
	Const ResizeDiagonally2:Int = 5
	Const MirrorHorizontally:Int = 6
	Const MirrorVertically:Int = 7
	Const RotateBackward:Int = 8
	Const RotateForward:Int = 9
	
	
	
	Method Init()
		Window  = CreateWindow( "", 0, 0, 640, 480 )
		MaximizeWindow( Window )
		Canvas = CreateCanvas( 0, 0, ClientWidth( Window ) - 200, ClientHeight( Window ), Window )
		SetGadgetLayout( Canvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		SpriteTypesListBox = CreateListBox( ClientWidth( Window ) - 200, 0, 200, 0.5 * ClientHeight( Window ), Window )
		SetGadgetLayout( SpriteTypesListBox, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		PagesListBox = CreateListBox( ClientWidth( Window ) - 200, 0.5 * ClientHeight( Window ), 200, 0.5 * ClientHeight( Window ), Window )
		SetGadgetLayout( PagesListBox, Edge_Centered, Edge_Aligned, Edge_Relative, Edge_Aligned )
		
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
		ShowGrid = CreateMenu( "Show grid", MenuShowGrid, EditMenu )
		SnapToGrid = CreateMenu( "Snap to grid", MenuSnapToGrid, EditMenu )
		CreateMenu( "", 0, EditMenu )
		CreateMenu( "Grid settings", MenuGridSettings, EditMenu )
		CreateMenu( "Tilemap settings", MenuTilemapSettings, EditMenu )
		CreateMenu( "", 0, EditMenu )
		EditTilemap = CreateMenu( "Edit tilemap", MenuEditTilemap, EditMenu )
		EditSprites = CreateMenu( "Edit sprites", MenuEditSprites, EditMenu )
		CreateMenu( "", 0, EditMenu )
		CreateMenu( "Add page", MenuAddPage, EditMenu )
		CreateMenu( "Add sprite type", MenuAddSpriteType, EditMenu )
		CheckMenu( EditSprites )
		
		UpdateWindowMenu( Window )
		SetClsColor( 255, 255, 255 )
		
		ModifiersImage = LoadAnimImage( "modifiers.png", 16, 16, 0, 10 )
		MidHandleImage( ModifiersImage )
		
		AddPage( "Page 1" )
		
		If FileType( "editor.ini" ) = 1 Then
			Local IniFile:TStream = ReadFile( "editor.ini" )
			
			OpenWorld( ReadLine( IniFile ) )
			
			If ReadLine( IniFile ) = "ShowGrid" Then CheckMenu( ShowGrid )
			If ReadLine( IniFile ) = "SnapToGrid" Then CheckMenu( SnapToGrid )
			If ReadLine( IniFile ) = "EditSprites" Then CheckMenu( EditSprites ) Else CheckMenu( EditTilemap )
			
			CloseFile( IniFile )
		End If
	End Method
	
	
	
	Method AddPage( PageName:String )
		Local Page:LTPage = New LTPage
		Page.Name = PageName
		CurrentPage = Page
		World.Pages.AddLast( Page )
		RefreshPagesList()
	End Method
	
	
	
	Method OpenWorld( Filename:String )
		If Filename Then 
			If FileType( Filename ) = 0 Then Return
			WorldFilename = Filename
			World = LTWorld( L_LoadFromFile( Filename ) )
			CurrentPage = LTPage( World.Pages.First() )
			RefreshPagesList()
			RefreshSpriteTypesList()
		End If
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
						OpenWorld( RequestFile( "Select world file to open...", "DWLab world XML file:xml" ) )
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
					Case MenuEditTilemap
						CheckMenu( EditTilemap )
						UnCheckMenu( EditSprites )
					Case MenuEditSprites
						UnCheckMenu( EditTilemap )
						CheckMenu( EditSprites )
					Case MenuAddPage
						Local Page:LTPage = New LTPage
						Page.Name = EnterName()
						If Page.Name Then
							World.Pages.AddLast( Page )
							CurrentPage = Page
							RefreshPagesList()
						End If
					Case MenuAddSpriteType
						Local SpriteType:LTSpriteType = New LTSpriteType
						SpriteType.ImageVisualizer = New LTImageVisualizer
						If SpriteTypeProperties( SpriteType ) Then
							World.SpriteTypes.AddLast( SpriteType )
							CurrentSpriteType = SpriteType
							RefreshSpriteTypesList()
						End If
					Case MenuExit
						ExitEditor()
				End Select
			Case Event_GadgetAction
				Select EventSource()
					Case SpriteTypesListBox
						SpriteTypeProperties( CurrentSpriteType )
					Case PagesListBox
						Local Name:String = EnterName( CurrentPage.Name )
						If Name Then
							CurrentPage.Name = Name
							RefreshPagesList()
						End If
				End Select
			Case Event_GadgetSelect
				Select EventSource()
					Case SpriteTypesListBox
						CurrentSpriteType = LTSpriteType( World.SpriteTypes.ValueAtIndex( EventData() ) )
						RefreshSpriteTypesList()
					Case PagesListBox
						CurrentPage = LTPage( World.Pages.ValueAtIndex( EventData() ) )
						RefreshPagesList()
				End Select
		End Select
		
		Cursor.SetMouseCoords()
		
		Pan.Execute()
		CreateSprite.Execute()
		ModifySprite.Execute()
		
		Local NewD:Float = 1.0 * GraphicsWidth() / 32.0 * ( 1.1 ^ MouseZ() )
		L_CurrentCamera.SetMagnification( NewD, NewD )
		
		If CurrentPage.Tilemap Then L_CurrentCamera.LimitWith( CurrentPage.Tilemap )
	End Method
	
	
	
	
	Method EnterName:String( Name:String = "" )
		Local InputWindow:TGadget = CreateWindow( "Enter page name:", 0.5 * ClientWidth( Window ) - 100, 0.5 * ClientHeight( Window ) - 40, 200, 100, Desktop(), WINDOW_TITLEBAR )
		Local NameField:TGadget = CreateTextField( 8, 8, 180, 20, InputWindow )
		SetGadgetText( NameField, Name )
		Local OKButton:TGadget = CreateButton( "OK", 24, 36, 72, 24, InputWindow )
		Local CancelButton:TGadget = CreateButton( "Cancel", 104, 36, 72, 24, InputWindow )
		Repeat
			WaitEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case OKButton
							Name = TextFieldText( NameField )
							FreeGadget( InputWindow )
							Return Name
						Case CancelButton
							FreeGadget( InputWindow )
							Return "" 
					End Select
			End Select
		Forever
	End Method
	
	
	
	Method Render()
		Cls
		L_CurrentCamera.Viewport.X = 0.5 * Canvas.GetWidth()
		L_CurrentCamera.Viewport.Y = 0.5 * Canvas.GetHeight()
		L_CurrentCamera.Viewport.XSize = Canvas.GetWidth()
		L_CurrentCamera.Viewport.YSize = Canvas.GetHeight()
		CurrentPage.Draw()
		if MenuChecked( ShowGrid ) Then Grid.Draw()
		
		For Local Sprite:LTSprite = Eachin SelectedSprites
			Sprite.DrawUsingVisualizer( MarchingAnts )
		Next
		
		If Not Dragging Then
			SetAlpha( 0.75 )
			For Local Modifier:LTActor = Eachin Modifiers
				Local X:Float, Y:Float
				L_CurrentCamera.FieldToScreen( Modifier.X, Modifier.Y, X, Y )
				DrawImage( ModifiersImage, X, Y, Modifier.Frame )
			Next
			SetAlpha( 1.0 )
		End If
	End Method
	
	
	
	Method SelectSprite( Sprite:LTSprite )
		SelectedSprites.Clear()
		SelectedSprites.AddLast( Sprite )
	End Method
	
	
	
	Method SetSpriteModifiers( Sprite:LTSprite )
		Modifiers.Clear()
	
		Local SXSize:Float, SYSize:Float
		L_CurrentCamera.SizeFieldToScreen( 0.5 * Sprite.XSize, 0.5 * Sprite.YSize, SXSize, SYSize )
		
		If SXSize < 25 Then SXSize = 25
		If SYSize < 25 Then SYSize = 25
		
		AddModifier( Sprite, Move, 0, 0 )
		AddModifier( Sprite, ResizeHorizontally, -SXSize - 9, 0 )
		AddModifier( Sprite, ResizeHorizontally, SXSize + 9, 0 )
		AddModifier( Sprite, ResizeVertically, 0, -SYSize - 9 )
		AddModifier( Sprite, ResizeVertically, 0, +SYSize + 9 )
		AddModifier( Sprite, Resize, -SXSize + 8, -SYSize + 8 )
		AddModifier( Sprite, Resize, SXSize - 8, -SYSize + 8 )
		AddModifier( Sprite, Resize, -SXSize + 8, SYSize - 8 )
		AddModifier( Sprite, Resize, SXSize - 8, SYSize - 8 )
		AddModifier( Sprite, ResizeDiagonally1, SXSize + 9, SYSize + 9 )
		AddModifier( Sprite, ResizeDiagonally1, -SXSize - 9, -SYSize - 9 )
		AddModifier( Sprite, ResizeDiagonally2, -SXSize - 9, SYSize + 9 )
		AddModifier( Sprite, ResizeDiagonally2, SXSize + 9, -SYSize - 9 )
		AddModifier( Sprite, MirrorHorizontally, 0, -17 )
		AddModifier( Sprite, MirrorVertically, 0, 17 )
		AddModifier( Sprite, RotateBackward, -17, 0 )
		AddModifier( Sprite, RotateForward, 17, 0 )		
	End Method
	
	
	
	Method AddModifier( Sprite:LTSprite, ModType:Int, DX:Int, DY:Int )
		Local Modifier:LTActor = New LTActor
		Local FDX:Float, FDY:Float
		L_CurrentCamera.SizeScreenToField( DX, DY, FDX, FDY )
		Modifier.X = Sprite.X + FDX
		Modifier.Y = Sprite.Y + FDY
		Modifier.Frame = ModType
		Modifier.Shape = L_Rectangle
		Modifiers.AddLast( Modifier )
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
		Local Settings:TGadget =CreateWindow( "Choose tile size:", 0.5 * ClientWidth( Window ) - 72, 0.5 * ClientHeight( Window ) - 78, 144, 157, Desktop(), WINDOW_TITLEBAR )
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
	
	
	
	Method ChopFilename:String( Filename:String )
		Local Dir:String = CurrentDir()
		?Win32
		Local Slash:String = "\"
		Dir = Dir.Replace( "/", "\" ) + Slash
		?Linux
		Local Slash:String = "/"
		Dir = Dir + Slash
		?
		'debugstop
		For Local N:Int = 0 Until Len( Dir )
			If N => Len( Filename ) Then Return Filename
			If Dir[ N ] <> Filename[ N ] Then
				If N = 0 Then Return Filename
				Local SlashPos:Int = N - 1
				Filename = Filename[ N - 1.. ]
				Repeat
					SlashPos = Dir.Find( Slash, SlashPos + 1 )
					If SlashPos = -1 Then Exit
					Filename = ".." + Slash + Filename
				Forever
				Return Filename
			End If
		Next
	End Method
	
	
	
	Method ImportTilemap( TileXSize:Int, TileYSize:Int, Tilemap:TPixmap )
		Local TilemapXSize:Int = PixmapWidth( Tilemap )
		Local TilemapYSize:Int = PixmapHeight( Tilemap )
		
		Local TileXQuantity:Int = TilemapXSize / TileXSize
		Local TileYQuantity:Int = TilemapYSize / TileYSize
		
		Local Filename:String = ChopFilename( RequestFile( "Select file to save tiles image to...", "png", True ) )
		If Not Filename Then Return
		
		CurrentPage.TileMap = New LTTileMap
		CurrentPage.TileMap.FrameMap = New LTIntMap
		CurrentPage.TileMap.FrameMap.SetResolution( TileXQuantity, TileYQuantity )
		CurrentPage.TileMap.X = 0.5 * TileXQuantity
		CurrentPage.TileMap.Y = 0.5 * TileYQuantity
		CurrentPage.TileMap.XSize = TileXQuantity
		CurrentPage.TileMap.YSize = TileYQuantity
		
		Local Tiles:TList = New TList
		If FileType( Filename ) = 1 Then
			Local Image:TImage = LoadImage( Filename )
			Local TilesQuantity:Int = ImageWidth( Image ) * ImageHeight( Image ) / TileXSize / TileYSize
			Image = LoadAnimImage( LockImage( Image ), TileXSize, TileYSize, 0, TilesQuantity )
			For Local N:Int = 0 Until TilesQuantity
				Tiles.AddLast( LockImage( Image, N ) )
			Next
			UnLockImage( Image )
		End If
		
		For Local Y:Int = 0 Until TileYQuantity
			For Local X:Int = 0 Until TileXQuantity
				Local Pixmap:TPixmap = Tilemap.Window( X * TileXSize, Y * TileYSize, TileXSize, TileYSize )
				
				Local N:Int = 0
				For Local Tile:TPixmap = Eachin Tiles
					If ComparePixmaps( Pixmap, Tile ) Then Exit
					N :+ 1
				Next
				If N = Tiles.Count() Then Tiles.AddLast( Pixmap )
				
				CurrentPage.TileMap.FrameMap.Value[ X, Y ] = N
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
		CurrentPage.Tilemap.Visualizer = LTImageVisualizer.FromFile( Filename, 16, Ceil( 1.0 * TilesQuantity / 16 ) )
	End Method
	
	
	
	Method ExitEditor()
		Local IniFile:TStream = WriteFile( "editor.ini" )
		
		WriteLine( IniFile, WorldFilename )
		If MenuChecked( ShowGrid ) Then WriteLine( IniFile, "ShowGrid" ) Else WriteLine( IniFile, "DoNotShowGrid" )
		If MenuChecked( SnapToGrid ) Then WriteLine( IniFile, "SnapToGrid" ) Else WriteLine( IniFile, "DoNotSnapToGrid" )
		If MenuChecked( EditSprites ) Then WriteLine( IniFile, "EditSprites" ) Else WriteLine( IniFile, "EditTilemap" )
		
		CloseFile( IniFile )
		
		End
	End Method
	
	
	
	Method SpriteTypeProperties:Int( SpriteType:LTSpriteType )
		Local EditWindow:TGadget = CreateWindow( "Sprite type properties", 0.5 * ClientWidth( Window ) - 80, 0.5 * ClientHeight( Window ) - 170, 161, 339, Desktop(), WINDOW_TITLEBAR|WINDOW_RESIZABLE )
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
		
		SetGadgetText( NameTextField, SpriteType.Name )
	
		
		Local Image:TImage
		If SpriteType.Image Then
			Image = LoadImage( SpriteType.Image.Filename )
			SetGadgetText( XCellsTextField, SpriteType.Image.XCells )
			SetGadgetText( YCellsTextField, SpriteType.Image.YCells )
		Else
			SetGadgetText( XCellsTextField, 1 )
			SetGadgetText( YCellsTextField, 1 )
		End If
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
										SpriteType.Name = TypeName
										SpriteType.Shape = Shape
										
										SpriteType.Image = LTImage.FromFile( Filename, XCells, YCells )
										SpriteType.ImageVisualizer.Image = SpriteType.Image
										
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
	
	
	
	Method RefreshSpriteTypesList()
		ClearGadgetItems( SpriteTypesListBox )
		For Local SpriteType:LTSpriteType = Eachin World.SpriteTypes
			Local SpriteTypeName:String = SpriteType.Name
			If SpriteType = CurrentSpriteType Then SpriteTypeName :+ " (current)"
			AddGadgetItem( SpriteTypesListBox, SpriteTypeName )
		Next
	End Method
	
	
	
	Method RefreshPagesList()
		ClearGadgetItems( PagesListBox )
		For Local Page:LTPage = Eachin World.Pages
			Local PageName:String = Page.Name
			If Page = CurrentPage Then PageName :+ " (current)"
			AddGadgetItem( PagesListBox, PageName )
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