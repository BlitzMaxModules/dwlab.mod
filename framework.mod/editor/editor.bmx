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
include "LTSetTile.bmx"

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Field Window:TGadget
	
	Field MainCanvas:TGadget
	Field MainCamera:LTCamera = New LTCamera
	Field MainCanvasZ:Int
	
	Field TilesetCanvas:TGadget
	Field TilesetCamera:LTCamera = New LTCamera
	Field TilesetCanvasZ:Int
	
	Field MouseIsOver:TGadget
	
	Field SpritesListBox:TGadget
	Field PagesListBox:TGadget
	Field Panel:TGadget
	Field RedField:TGadget
	Field RedSlider:TGadget
	Field ShapeBox:TGadget
	Field XField:TGadget
	Field YField:TGadget
	Field WidthField:TGadget
	Field HeightField:TGadget
	Field AngleField:TGadget
	Field VelocityField:TGadget
	Field GreenSlider:TGadget
	Field GreenField:TGadget
	Field BlueSlider:TGadget
	Field BlueField:TGadget
	Field AlphaSlider:TGadget
	Field AlphaField:TGadget
	Field XScaleField:TGadget
	Field YScaleField:TGadget
	Field FrameField:TGadget
	Field SelectImageButton:TGadget
	Field HiddenOKButton:TGadget
	
	Field SnapToGrid:TGadget
	Field ShowGrid:TGadget
	Field EditTilemap:TGadget
	Field EditSprites:TGadget
	
	Field World:LTWorld = New LTWorld
	Field CurrentPage:LTPage
	Field CurrentSprite:LTActor
	Field SelectedSprites:TList = New TList
	Field SelectedModifier:LTActor
	Field ModifiersImage:TImage
	Field Modifiers:TList = New TList
	Field ShapeVisualizer:LTFilledPrimitive = New LTFilledPrimitive
	
	Field SelectedTile:LTActor = New LTActor
	Field TileX:Int, TileY:Int, TileNum:Int[] = New Int[ 2 ]
	Field TilesInRow:Int
	
	Field WorldFilename:String
	Field EditorPath:String
	Field RealPathsForImages:TMap = New TMap
	
	Field Cursor:LTActor = New LTActor
	Field Pan:LTPan = New LTPan
	Field CreateSprite:LTCreateSprite = New LTCreateSprite
	Field ModifySprite:LTModifySprite = New LTModifySprite
	Field SetTile:LTSetTile = New LTSetTile
	Field Grid:LTGrid = New LTGrid
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	
	
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
	Const MenuAddPage:Int = 15
	
	
	
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
		Window  = CreateWindow( "Digital Wizard's Lab world editor", 0, 0, 640, 480 )
		MaximizeWindow( Window )
		Local BarSize:Float = ClientHeight( Window ) - 246
		MainCanvas = CreateCanvas( 0, 0, ClientWidth( Window ) - 207, ClientHeight( Window ), Window )
		SetGadgetLayout( MainCanvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		TilesetCanvas = CreateCanvas( ClientWidth( Window ) - 207, 0, 207, 246 + 0.7 * BarSize, Window )
		SetGadgetLayout( TilesetCanvas, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		SpritesListBox = CreateListBox( ClientWidth( Window ) - 207, 248, 207, 0.7 * BarSize, Window )
		SetGadgetLayout( SpritesListBox, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		PagesListBox = CreateListBox( ClientWidth( Window ) - 207, 248 + 0.7 * BarSize, 207, 0.3 * BarSize, Window )
		SetGadgetLayout( PagesListBox, Edge_Centered, Edge_Aligned, Edge_Relative, Edge_Aligned )
		Panel = CreatePanel( ClientWidth( Window ) - 207, 0, 207, 246, Window, PANEL_RAISED )
		SetGadgetLayout( Panel, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Centered )

		CreateLabel( "X:", 27, 27, 12, 16, Panel, 0 )
		CreateLabel( "Y:", 131, 27, 13, 16, Panel, 0 )
		CreateLabel( "Width:", 6, 51, 33, 16, Panel, 0 )
		CreateLabel( "Height:", 106, 51, 37, 16, Panel, 0 )
		CreateLabel( "Shape:", 4, 6, 36, 16, Panel, 0 )
		ShapeBox = CreateComboBox( 40, 0, 160, 20, Panel )
		XField = CreateTextField( 40, 24, 56, 20, Panel )
		YField = CreateTextField( 144, 24, 56, 20, Panel )
		WidthField = CreateTextField( 40, 48, 56, 20, Panel )
		HeightField = CreateTextField( 144, 48, 56, 20, Panel )
		CreateLabel( "Angle:", 6, 75, 34, 16, Panel, 0 )
		AngleField = CreateTextField( 40, 72, 56, 20, Panel )
		CreateLabel( "Velocity:", 100, 75, 44, 16, Panel, 0 )
		VelocityField = CreateTextField( 144, 72, 56, 20, Panel )
		CreateLabel( "Alpha:", 6, 171, 33, 16, Panel, 0 )
		CreateLabel( "Red:", 14, 101, 25, 16, Panel, 0 )
		CreateLabel( "Green:", 4, 123, 35, 16, Panel, 0 )
		RedField = CreateTextField( 168, 96, 32, 20, Panel )
		RedSlider = CreateSlider( 40, 100, 120, 20, Panel, SLIDER_TRACKBAR | SLIDER_HORIZONTAL )
		SetSliderRange( RedSlider, 0, 100 )
		GreenSlider = CreateSlider( 40, 122, 120, 20, Panel, SLIDER_TRACKBAR | SLIDER_HORIZONTAL )
		GreenField = CreateTextField( 168, 120, 32, 20, Panel )
		SetSliderRange( GreenSlider, 0, 100 )
		CreateLabel( "Blue:", 13, 147, 26, 16, Panel, 0 )
		BlueSlider = CreateSlider( 40, 146, 120, 20, Panel, SLIDER_TRACKBAR | SLIDER_HORIZONTAL )
		BlueField = CreateTextField( 168, 144, 32, 20, Panel )
		SetSliderRange( BlueSlider, 0, 100 )
		AlphaSlider = CreateSlider( 40, 170, 120, 20, Panel, SLIDER_TRACKBAR | SLIDER_HORIZONTAL )
		AlphaField = CreateTextField( 168, 168, 32, 20, Panel )
		SetSliderRange( AlphaSlider, 0, 100 )
		XScaleField = CreateTextField( 40, 192, 56, 20, Panel )
		CreateLabel( "XScale:", 2, 196, 37, 16, Panel, 0 )
		CreateLabel( "YScale:", 106, 195, 37, 16, Panel, 0 )
		YScaleField = CreateTextField( 144, 192, 56, 20, Panel )
		CreateLabel( "Frame:", 3, 220, 37, 16, Panel, 0 )
		FrameField = CreateTextField( 40, 216, 56, 20, Panel )
		SelectImageButton = CreateButton( "Select image", 104, 216, 96, 24, Panel, BUTTON_PUSH )
		'SelectColorButton = CreateButton( "Select Color", 104, 246, 96, 24, Panel, BUTTON_PUSH )
		HiddenOKButton = CreateButton( "", 0, 0, 0, 0, Panel, Button_OK )
		HideGadget( HiddenOKButton )
				
		MainCamera = LTCamera.Create( GadgetWidth( MainCanvas ), GadgetHeight( MainCanvas ), 32.0 )
		TilesetCamera = LTCamera.Create( GadgetWidth( TilesetCanvas ), GadgetHeight( TilesetCanvas ), 8.0 )
		L_CurrentCamera = MainCamera
		
		SetGraphics( CanvasGraphics( MainCanvas ) )
		SetGraphicsParameters()
		
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
		CheckMenu( EditSprites )
		
		UpdateWindowMenu( Window )
		SetClsColor( 255, 255, 255 )
		
		ModifiersImage = LoadAnimImage( "modifiers.png", 16, 16, 0, 10 )
		MidHandleImage( ModifiersImage )
		
		ShapeVisualizer.Green = 0.5
		ShapeVisualizer.Blue = 0.5
		ShapeVisualizer.Alpha = 0.4
		
		SelectedTile.Visualizer = New LTMarchingAnts
		
		AddPage( "Page1" )
		
		EditorPath = CurrentDir()
		
		If FileType( "editor.ini" ) = 1 Then
			Local IniFile:TStream = ReadFile( "editor.ini" )
			
			OpenWorld( ReadLine( IniFile ) )
			
			If ReadLine( IniFile ) = "ShowGrid" Then CheckMenu( ShowGrid )
			If ReadLine( IniFile ) = "SnapToGrid" Then CheckMenu( SnapToGrid )
			
			If ReadLine( IniFile ) = "EditSprites" Then
				CheckMenu( EditSprites )
				UncheckMenu( EditTilemap )
			Else
				CheckMenu( EditTilemap )
				UncheckMenu( EditSprites )
			End If
			
			CloseFile( IniFile )
		End If
	End Method
	
	
	
	Method FillSpriteFields()
		SetGadgetText( XField, L_TrimFloat( CurrentSprite.X ) )
		SetGadgetText( YField ,L_TrimFloat( CurrentSprite.Y ) )
		SetGadgetText( WidthField, L_TrimFloat( CurrentSprite.XSize ) )
		SetGadgetText( HeightField, L_TrimFloat( CurrentSprite.YSize ) )
		SetGadgetText( AngleField, L_TrimFloat( CurrentSprite.Angle ) )
		SetGadgetText( VelocityField, L_TrimFloat( CurrentSprite.Velocity ) )
		SetGadgetText( FrameField, CurrentSprite.Frame )
		SetGadgetText( RedField, L_TrimFloat( CurrentSprite.Visualizer.Red ) )
		SetGadgetText( GreenField, L_TrimFloat( CurrentSprite.Visualizer.Green ) )
		SetGadgetText( BlueField, L_TrimFloat( CurrentSprite.Visualizer.Blue ) )
		SetGadgetText( AlphaField, L_TrimFloat( CurrentSprite.Visualizer.Alpha ) )
		SetGadgetText( XScaleField, L_TrimFloat( CurrentSprite.Visualizer.XScale ) )
		SetGadgetText( YScaleField, L_TrimFloat( CurrentSprite.Visualizer.YScale ) )
		
		SetSliderValue( RedSlider, 100.0 * CurrentSprite.Visualizer.Red )
		SetSliderValue( GreenSlider, 100.0 * CurrentSprite.Visualizer.Green )
		SetSliderValue( BlueSlider, 100.0 * CurrentSprite.Visualizer.Blue )
		SetSliderValue( AlphaSlider, 100.0 * CurrentSprite.Visualizer.Alpha )
		
		ClearGadgetItems( ShapeBox )
		AddGadgetItem( ShapeBox, "Pivot" )
		AddGadgetItem( ShapeBox, "Circle" )
		AddGadgetItem( ShapeBox, "Rectangle" )
		SelectGadgetItem( ShapeBox, CurrentSprite.Shape )
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
			
			L_ImagesList.Clear()
			
			WorldFilename = Filename
			ChangeDir( ExtractDir( Filename ) )
			
			World = LTWorld( L_LoadFromFile( Filename ) )
			
			CurrentPage = LTPage( World.Pages.First() )
			CurrentSprite = Null
			For Local Page:LTPage = Eachin World.Pages
				For Local Sprite:LTActor = Eachin Page.Sprites
					CurrentSprite = Sprite
					Exit
				Next
				If CurrentSprite Then Exit
			Next
			
			For Local Image:LTImage = Eachin L_ImagesList
				RealPathsForImages.Insert( Image, RealPath( Image.Filename ) )
			Next
			
			SelectedSprites.Clear()
			RefreshPagesList()
			RefreshSpritesList()
		End If
	End Method
	
	
	
	Method SaveWorld( Filename:String )
		If Filename Then 
			WorldFilename = Filename
			ChangeDir( ExtractDir( Filename ) )
			For Local Image:LTImage = Eachin L_ImagesList
				Debuglog Image.Filename
				Image.Filename = ChopFilename( String( RealPathsForImages.ValueForKey( Image ) ) )
				Debuglog Image.Filename
			Next
			
			World.SaveToFile( Filename )
		End If
	End Method
	
	
	
	Method Logic()
		PollEvent()
		Select EventID()
			Case Event_KeyDown
				If EventData() = Key_Delete Then
					For Local Sprite:LTActor = Eachin SelectedSprites
						CurrentPage.Sprites.Remove( Sprite )
					Next
					RefreshSpritesList()
					SelectedSprites.Clear()
					Modifiers.Clear()
				End If
			Case Event_MouseWheel
				If Not Modifiers.IsEmpty() Then
					Local Sprite:LTActor = LTActor( SelectedSprites.First() )
					SetSpriteModifiers( Sprite )
				End If
				If MouseIsOver = MainCanvas Then
					MainCanvasZ :+ EventData()
				Else
					TilesetCanvasZ :+ EventData()
				End If
			Case Event_WindowClose
				ExitEditor()
			Case Event_MouseEnter
				Select EventSource()
					Case MainCanvas
						ActivateGadget( MainCanvas )
						DisablePolledInput()
						EnablePolledInput( MainCanvas )
						MouseIsOver = MainCanvas
					Case TilesetCanvas
						ActivateGadget( TilesetCanvas )
						DisablePolledInput()
						EnablePolledInput( TilesetCanvas )
						MouseIsOver = TilesetCanvas
				End Select
			Case Event_MenuAction
				Select EventData()
					Case MenuOpen
						OpenWorld( RequestFile( "Select world file to open...", "DWLab world XML file:xml" ) )
					Case MenuSave
						If WorldFilename Then
							SaveWorld( WorldFilename )
						Else
							SaveWorld( RequestFile( "Select world file name to save...", "DWLab world XML file:xml", True ) )
						End If
					Case MenuSaveAs
						SaveWorld( RequestFile( "Select world file name to save...", "DWLab world XML file:xml", True ) )
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
						Page.Name = EnterName( "Enter page name:" )
						If Page.Name Then
							World.Pages.AddLast( Page )
							CurrentPage = Page
							RefreshPagesList()
						End If
					Case MenuExit
						ExitEditor()
				End Select
			Case Event_GadgetAction
				Select EventSource()
					Case SpritesListBox
						Local Name:String = EnterName( "Enter name of sprite", CurrentSprite.GetName() )
						If Name Then
							CurrentSprite.SetName( Name )
							RefreshSpritesList()
						End If
					Case PagesListBox
						Local Name:String = EnterName( "Enter name of page", CurrentPage.Name )
						If Name Then
							CurrentPage.Name = Name
							RefreshPagesList()
						End If
					Case SelectImageButton
						If Not SelectedSprites.IsEmpty() Then
							Local FirstSprite:LTActor = LTActor( SelectedSprites.First() )
							SpriteImageProperties( FirstSprite )
							For Local Sprite:LTActor = Eachin SelectedSprites
								LTImageVisualizer( Sprite.Visualizer ).Image = LTImageVisualizer( FirstSprite.Visualizer ).Image
							Next
						End If
				End Select
				
				For Local Sprite:LTActor = Eachin SelectedSprites
					Select EventSource()
						Case HiddenOKButton
							Select ActiveGadget()
								Case XField
									Sprite.X = TextFieldText( XField ).ToFloat()
									SetSpriteModifiers( Sprite )
								Case YField
									Sprite.Y = TextFieldText( YField ).ToFloat()
									SetSpriteModifiers( Sprite )
								Case WidthField
									Sprite.XSize = TextFieldText( WidthField ).ToFloat()
									SetSpriteModifiers( Sprite )
								Case HeightField
									Sprite.YSize = TextFieldText( HeightField ).ToFloat()
									SetSpriteModifiers( Sprite )
								Case AngleField
									Sprite.Angle = TextFieldText( AngleField ).ToFloat()
								Case VelocityField
									Sprite.Velocity = TextFieldText( VelocityField ).ToFloat()
								Case RedField
									Sprite.Visualizer.Red = TextFieldText( RedField ).ToFloat()
									SetSliderValue( RedSlider, 0.01 * Sprite.Visualizer.Red )
								Case GreenField
									Sprite.Visualizer.Green = TextFieldText( GreenField ).ToFloat()
									SetSliderValue( GreenSlider, 0.01 * Sprite.Visualizer.Green )
								Case BlueField
									Sprite.Visualizer.Blue = TextFieldText( BlueField ).ToFloat()
									SetSliderValue( BlueSlider, 0.01 * Sprite.Visualizer.Blue )
								Case AlphaField
									Sprite.Visualizer.Alpha = TextFieldText( AlphaField ).ToFloat()
									SetSliderValue( AlphaSlider, 0.01 * Sprite.Visualizer.Alpha )
								Case XScaleField
									Sprite.Visualizer.XScale = TextFieldText( XScaleField ).ToFloat()
								Case YScaleField
									Sprite.Visualizer.YScale = TextFieldText( YScaleField ).ToFloat()
								Case FrameField
									Local Image:LTImage = LTImageVisualizer( Sprite.Visualizer ).Image
									If Image Then
										Sprite.Frame = L_LimitInt( TextFieldText( FrameField ).ToInt(), 0, Image.BMaxImage.frames.Dimensions()[ 0 ] - 1 )
										SetGadgetText( FrameField, Sprite.Frame )
									End If
							End Select
						Case RedSlider
							Sprite.Visualizer.Red = 0.01 * SliderValue( RedSlider )
							SetGadgetText( RedField, Sprite.Visualizer.Red )
						Case GreenSlider
							Sprite.Visualizer.Green = 0.01 * SliderValue( GreenSlider )
							SetGadgetText( GreenField, Sprite.Visualizer.Green )
						Case BlueSlider
							Sprite.Visualizer.Blue = 0.01 * SliderValue( BlueSlider )
							SetGadgetText( BlueField, Sprite.Visualizer.Blue )
						Case AlphaSlider
							Sprite.Visualizer.Alpha = 0.01 * SliderValue( AlphaSlider )
							SetGadgetText( AlphaField, Sprite.Visualizer.Alpha )
						Case ShapeBox
							Sprite.Shape = SelectedGadgetItem( ShapeBox )
					End Select
				Next
			Case Event_GadgetSelect
				Select EventSource()
					Case SpritesListBox
						CurrentSprite = LTActor( CurrentPage.Sprites.ValueAtIndex( EventData() ) )
						RefreshSpritesList()
					Case PagesListBox
						CurrentPage = LTPage( World.Pages.ValueAtIndex( EventData() ) )
						Modifiers.Clear()
						SelectedSprites.Clear()
						RefreshPagesList()
				End Select
		End Select
		
		If MenuChecked( EditTilemap ) Then
			EnableGadget( TilesetCanvas )
			ShowGadget( TilesetCanvas )
			DisableGadget( Panel )
			HideGadget( Panel )
			DisableGadget( SpritesListBox )
			HideGadget( SpritesListBox )
		Else
			DisableGadget( TilesetCanvas )
			HideGadget( TilesetCanvas )
			EnableGadget( Panel )
			ShowGadget( Panel )
			EnableGadget( SpritesListBox )
			ShowGadget( SpritesListBox )
		End If
		
		Cursor.SetMouseCoords()
		
		SelectedModifier = Null
		For Local Modifier:LTActor = Eachin Modifiers
			Local MX:Float, MY:Float
			L_CurrentCamera.FieldToScreen( Modifier.X, Modifier.Y, MX, MY )
			If MouseX() >= MX - 8 And MouseX() <= MX + 8 And MouseY() >= MY - 8 And MouseY() <= MY + 8 Then
				SelectedModifier = Modifier
			End If
		Next
		
		If MenuChecked( EditTilemap ) Then
			If CurrentPage.TileMap Then
				Local MX:Float, MY:Float
				L_CurrentCamera.ScreenToField( MouseX(), MouseY(), MX, MY )
				TileX = L_LimitInt( Floor( MX ), 0, CurrentPage.Tilemap.FrameMap.XQuantity )
				TileY = L_LimitInt( Floor( MY ), 0, CurrentPage.Tilemap.FrameMap.YQuantity )
				Local Image:LTImage = LTImageVisualizer( CurrentPage.Tilemap.Visualizer ).Image
				If Image then
					Local FXSize:Float, FYSize:Float
					TilesetCamera.SizeScreenToField( GadgetWidth( TilesetCanvas ), 0, FXSize, FYSize )
					TilesInRow = Max( 1, Min( Image.FramesQuantity(), Floor( FXSize ) ) )
					
					If MouseIsOver = TilesetCanvas Then
						Local FX:Float, FY:Float
						TilesetCamera.ScreenToField( MouseX(), MouseY(), FX, FY )
						Local TileNumUnderCursor:Int = Floor( FX ) + TilesInRow * Floor( FY )
						If MouseDown( 1 ) Then TileNum[ 0 ] = TileNumUnderCursor
						If MouseDown( 2 ) Then TileNum[ 1 ] = TileNumUnderCursor
					End If
				End If
			End If
			
			SetTile.Execute()
		Else
			If Not ModifySprite.DraggingState And MouseHit( 1 ) Then
				For Local Sprite:LTActor = Eachin Editor.CurrentPage.Sprites
					If Editor.Cursor.CollidesWith( Sprite ) Then Editor.SelectSprite( Sprite )
				Next
			End If
			
			CreateSprite.Execute()
			ModifySprite.Execute()
		End If
		
		Pan.Execute()
		
		SetCameraMagnification( MainCamera, MainCanvas, MainCanvasZ, 32.0 )
		SetCameraMagnification( TilesetCamera, TilesetCanvas, TilesetCanvasZ, 8.0 )
		
		If CurrentPage.Tilemap Then L_CurrentCamera.LimitWith( CurrentPage.Tilemap )
	End Method
	
	
	
	Method SetCameraMagnification( Camera:LTCamera, Canvas:TGadget, Z:Int, Width:Int )
		Local NewD:Float = 1.0 * GadgetWidth( Canvas ) / Width * ( 1.1 ^ Z )
		Camera.SetMagnification( NewD, NewD )
	End Method
	
	
	
	Method EnterName:String( Message:String, Name:String = "" )
		Local InputWindow:TGadget = CreateWindow( Message, 0.5 * ClientWidth( Window ) - 100, 0.5 * ClientHeight( Window ) - 40, 200, 100, Desktop(), WINDOW_TITLEBAR )
		Local NameField:TGadget = CreateTextField( 8, 8, 180, 20, InputWindow )
		SetGadgetText( NameField, Name )
		ActivateGadget( NameField )
		Local OKButton:TGadget = CreateButton( "OK", 24, 36, 72, 24, InputWindow, Button_OK )
		Local CancelButton:TGadget = CreateButton( "Cancel", 104, 36, 72, 24, InputWindow, Button_Cancel )
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
		If MenuChecked( EditTilemap ) And CurrentPage.TileMap Then
			SelectedTile.X = 0.5 + TileX
			SelectedTile.Y = 0.5 + TileY
			SelectedTile.Draw()
			
			TilesetCamera.Viewport.X = 0.5 * TilesetCanvas.GetWidth()
			TilesetCamera.Viewport.Y = 0.5 * TilesetCanvas.GetHeight()
			TilesetCamera.Viewport.XSize = TilesetCanvas.GetWidth()
			TilesetCamera.Viewport.YSize = TilesetCanvas.GetHeight()
			
			SetGraphics( CanvasGraphics( TilesetCanvas ) )
			Cls
			
			Local Image:LTImage = LTImageVisualizer( CurrentPage.Tilemap.Visualizer ).Image
			If Image Then
				TilesetCamera.X = 0.5 * TilesInRow
				TilesetCamera.Y = 0.5 * Ceil( Image.FramesQuantity() / TilesInRow )
				TilesetCamera.Update()
			
				Local TileXSize:Float, TileYSize:Float
				TilesetCamera.SizeFieldToScreen( 1.0, 1.0, TileXSize, TileYSize )
				SetScale( TileXSize / Image.BMaxImage.Width, TileYSize / Image.BMaxImage.Height )
				'debugstop
				For Local Frame:Int = 0 Until Image.FramesQuantity()
					Local SX:Float, SY:Float
					TilesetCamera.FieldToScreen( 0.5 + Frame Mod TilesInRow, 0.5 + Floor( Frame / TilesInRow ), SX, SY )
					DrawImage( Image.BMaxImage, SX, SY, Frame )
				Next
				
				SetScale( 1.0, 1.0 )
				
				L_CurrentCamera = TilesetCamera
				
				For Local N:Int = 0 To 1
					SelectedTile.X = 0.5 + TileNum[ N ] Mod TilesInRow
					SelectedTile.Y = 0.5 + Floor( TileNum[ N ] / TilesInRow )
					SelectedTile.Draw()
				Next
				
				L_CurrentCamera = MainCamera
			End If
			
			Flip
			
			SetGraphics( CanvasGraphics( MainCanvas ) )
		End If
		
		Cls
		MainCamera.Viewport.X = 0.5 * MainCanvas.GetWidth()
		MainCamera.Viewport.Y = 0.5 * MainCanvas.GetHeight()
		MainCamera.Viewport.XSize = MainCanvas.GetWidth()
		MainCamera.Viewport.YSize = MainCanvas.GetHeight()
		
		If CurrentPage.TileMap Then CurrentPage.TileMap.Draw()
		
		For Local Sprite:LTActor = Eachin CurrentPage.Sprites
			Sprite.Draw()
			Sprite.DrawUsingVisualizer( ShapeVisualizer )
		Next
		
		if MenuChecked( ShowGrid ) Then Grid.Draw()
		
		If MenuChecked( EditTilemap ) Then
			If CurrentPage.TileMap Then
				If MouseIsOver = MainCanvas Then
					SelectedTile.X = 0.5 + TileX
					SelectedTile.Y = 0.5 + TileY
					SelectedTile.Draw()
				End If
			End If
		Else
			For Local Sprite:LTActor = Eachin SelectedSprites
				Sprite.DrawUsingVisualizer( MarchingAnts )
			Next
			
			If Not ModifySprite.DraggingState And Not CreateSprite.DraggingState Then
				SetAlpha( 0.75 )
				For Local Modifier:LTActor = Eachin Modifiers
					Local X:Float, Y:Float
					L_CurrentCamera.FieldToScreen( Modifier.X, Modifier.Y, X, Y )
					DrawImage( ModifiersImage, X, Y, Modifier.Frame )
				Next
				SetAlpha( 1.0 )
			End If
		End If
		
		DrawText( MouseX() + ", " + MouseY(), 0, 0 )
	End Method
	
	
	
	Method SelectSprite( Sprite:LTActor )
		SelectedSprites.Clear()
		SelectedSprites.AddLast( Sprite )
		SetSpriteModifiers( Sprite )
		CurrentSprite = Sprite
		FillSpriteFields()
	End Method
	
	
	
	Method SetSpriteModifiers( Sprite:LTActor )
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
	
	
	
	Method AddModifier( Sprite:LTActor, ModType:Int, DX:Int, DY:Int )
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
		Local IniFile:TStream = WriteFile( EditorPath + "/editor.ini" )
		
		WriteLine( IniFile, WorldFilename )
		If MenuChecked( ShowGrid ) Then WriteLine( IniFile, "ShowGrid" ) Else WriteLine( IniFile, "DoNotShowGrid" )
		If MenuChecked( SnapToGrid ) Then WriteLine( IniFile, "SnapToGrid" ) Else WriteLine( IniFile, "DoNotSnapToGrid" )
		If MenuChecked( EditSprites ) Then WriteLine( IniFile, "EditSprites" ) Else WriteLine( IniFile, "EditTilemap" )
		
		CloseFile( IniFile )
		
		End
	End Method
	
	
	
	Method SpriteImageProperties:Int( Sprite:LTActor )
		Local EditWindow:TGadget = CreateWindow( "Sprite type properties", 0.5 * ClientWidth( Window ) - 80, 0.5 * ClientHeight( Window ) - 170, 161, 339, Desktop(), WINDOW_TITLEBAR|WINDOW_RESIZABLE )
		CreateLabel( "Horizontal cells:", 8, 32, 75, 16, EditWindow, 0 )
		Local XCellsTextField:TGadget = CreateTextField( 88, 29, 56, 20, EditWindow )
		CreateLabel( "Vertical cells:", 8, 56, 62, 16, EditWindow, 0 )
		Local YCellsTextField:TGadget = CreateTextField( 88, 53, 56, 20, EditWindow )
		Local ImageCanvas:TGadget = CreateCanvas( 8, 104, 136, 136, EditWindow )
		Local LoadImageButton:TGadget = CreateButton( "Load image", 8, 248, 136, 24, EditWindow, BUTTON_PUSH )
		Local OkButton:TGadget = CreateButton( "OK", 8, 280, 64, 24, EditWindow, BUTTON_PUSH )
		Local CancelButton:TGadget = CreateButton( "Cancel", 80, 280, 64, 24, EditWindow, BUTTON_PUSH )

		Local Image:TImage
		Local SpriteImage:LTImage = LTImageVisualizer( Sprite.Visualizer ).Image
		If SpriteImage Then
			Image = LoadImage( SpriteImage.Filename )
			SetGadgetText( XCellsTextField, SpriteImage.XCells )
			SetGadgetText( YCellsTextField, SpriteImage.YCells )
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
				SetGraphics( CanvasGraphics( MainCanvas ) )
			End If
			
			PollEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case LoadImageButton
							Filename = RequestFile( "Select image..., ". "Image files:png,jpg,bmp" )
							Filename = ChopFilename( Filename )
							If Filename Then Image = LoadImage( Filename ) Else Image = Null
						Case OKButton
							If Image And Filename Then
								If XCells > 0 And YCells > 0 Then
									If Image.Width Mod XCells = 0 And Image.Height Mod YCells = 0 Then
										Local NewImage:LTImage = LTImage.FromFile( Filename, XCells, YCells )
										LTImageVisualizer( Sprite.Visualizer ).Image = NewImage
										RealPathsForImages.Insert( NewImage, RealPath( Filename ) )
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
	
	
	
	Method RefreshSpritesList()
		ClearGadgetItems( SpritesListBox )
		For Local Sprite:LTActor = Eachin CurrentPage.Sprites
			Local SpriteName:String = Sprite.GetName()
			If Sprite = CurrentSprite Then SpriteName :+ " (current)"
			AddGadgetItem( SpritesListBox, SpriteName )
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