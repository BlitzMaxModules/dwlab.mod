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

Framework brl.d3d7max2d
'Import brl.glmax2d
Import brl.random
Import brl.pngloader
Import brl.jpgloader
Import brl.bmploader
Import brl.reflection
Import brl.retro
Import brl.map
Import brl.eventqueue
Import brl.audio
import maxgui.win32maxguiex

include "../framework.bmx"
include "TPan.bmx"
include "TSelectSprites.bmx"
include "TMoveSprite.bmx"
include "TCreateSprite.bmx"
include "TModifySprite.bmx"
include "TGrid.bmx"
include "TAngleArrow.bmx"
include "TSetTile.bmx"
include "ChooseParameter.bmx"
include "ImportTilemap.bmx"
include "EnterString.bmx"
include "SpriteImageProperties.bmx"
include "TilesetProperties.bmx"

Incbin "toolbar.png"
Incbin "modifiers.png"

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Const Version:String = "1.1.3"
	Const Title:String = "Digital Wizard's Lab World Editor v" + Version
	
	Field Window:TGadget
	
	Field MainCanvas:TGadget
	Field MainCamera:LTCamera = New LTCamera
	Field MainCanvasZ:Int
	
	Field TilesetCanvas:TGadget
	Field TilesetCamera:LTCamera = New LTCamera
	Field TilesetCameraWidth:Int
	Field TilesetCanvasZ:Int
	
	Field Toolbar:TGadget
	
	Field MouseIsOver:TGadget
	Field Changed:Int
	
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
	Field RotatingCheckbox:TGadget
	Field ScalingCheckbox:TGadget
	Field ImgAngleField:TGadget
	Field HiddenOKButton:TGadget
	
	Field SnapToGrid:TGadget
	Field ShowGrid:TGadget
	Field EditTilemap:TGadget
	Field EditSprites:TGadget
	Field ReplacementOfTiles:TGadget
	Field ProlongTiles:TGadget
	
	Field World:LTWorld = New LTWorld
	Field CurrentPage:LTPage
	Field CurrentSprite:LTSprite
	Field CurrentTIleset:LTTileset
	Field TilesQueue:TMap = New TMap
	Field Cursor:LTSprite = New LTSprite
	Field SpriteUnderCursor:LTSprite
	Field SelectedSprites:TList = New TList
	Field SelectedModifier:LTSprite
	Field ModifiersImage:TImage
	Field Modifiers:TList = New TList
	Field ShapeVisualizer:LTFilledPrimitive = New LTFilledPrimitive
	Field AngleArrow:TAngleArrow = New TAngleArrow
	
	Field SelectedTile:LTSprite = New LTSprite
	Field TileX:Int, TileY:Int, TileNum:Int[] = New Int[ 2 ]
	Field TilesInRow:Int
	
	Field WorldFilename:String
	Field EditorPath:String
	
	Field Pan:TPan = New TPan
	Field SelectSprites:TSelectSprites = New TSelectSprites
	Field MoveSprite:TMoveSprite = New TMoveSprite
	Field CreateSprite:TCreateSprite = New TCreateSprite
	Field ModifySprite:TModifySprite = New TModifySprite
	Field SetTile:TSetTile = New TSetTile
	Field Grid:TGrid = New TGrid
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	
	
	Const MenuNew:Int = 0
	Const MenuOpen:Int = 1
	Const MenuSave:Int = 2
	Const MenuSaveAs:Int = 3
	Const MenuImportTilemap:Int = 18
	Const MenuImportTilemaps:Int = 19
	Const MenuExit:Int = 20
	Const MenuShowGrid:Int = 5
	Const MenuSnapToGrid:Int = 6
	Const MenuGridSettings:Int = 7
	Const MenuTilemapSettings:Int = 21
	Const MenuTilesetSettings:Int = 22
	Const MenuEditTilemap:Int = 9
	Const MenuEditSprites:Int = 10
	Const MenuAddPage:Int = 12
	Const MenuRemovePage:Int = 13
	Const MenuReplacementOfTiles:Int = 15
	Const MenuProlongTiles:Int = 16
	Const MenuEditReplacementRules:Int = 17
	
	
	
	Method Init()
		Window  = CreateWindow( "Digital Wizard's Lab world editor", 0, 0, 640, 480 )
		MaximizeWindow( Window )
		Const PanelHeight:Int = 268
		Const BarWidth:Int = 207
		Local BarHeight:Int = ClientHeight( Window ) - PanelHeight
		MainCanvas = CreateCanvas( 0, 0, ClientWidth( Window ) - BarWidth, ClientHeight( Window ), Window )
		SetGadgetLayout( MainCanvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		TilesetCanvas = CreateCanvas( ClientWidth( Window ) - BarWidth, 0, BarWidth, PanelHeight + 0.7 * BarHeight, Window )
		SetGadgetLayout( TilesetCanvas, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		SpritesListBox = CreateListBox( ClientWidth( Window ) - BarWidth, PanelHeight, BarWidth, 0.7 * BarHeight, Window )
		SetGadgetLayout( SpritesListBox, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		PagesListBox = CreateListBox( ClientWidth( Window ) - BarWidth, PanelHeight + 0.7 * BarHeight, BarWidth, 0.3 * BarHeight, Window )
		SetGadgetLayout( PagesListBox, Edge_Centered, Edge_Aligned, Edge_Relative, Edge_Aligned )
		
		Panel = CreatePanel( ClientWidth( Window ) - BarWidth, 0, BarWidth, PanelHeight - 2, Window, PANEL_RAISED )
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
		SelectImageButton  =  CreateButton(  "Select image",  104,  214,  96,  24,  Panel,  BUTTON_PUSH  )
		RotatingCheckbox = CreateButton( "Rot.", 40, 242, 40, 16, Panel, BUTTON_CHECKBOX )
		ScalingCheckbox = CreateButton( "Sc.", 2, 242, 40, 16, Panel, BUTTON_CHECKBOX )
		CreateLabel( "ImgAngle:", 90, 243, 50, 16, Panel, 0 )
		ImgAngleField = CreateTextField( 144, 240, 56, 20, Panel )
		HiddenOKButton = CreateButton( "", 0, 0, 0, 0, Panel, Button_OK )
		HideGadget( HiddenOKButton )
				
		MainCamera = LTCamera.Create( GadgetWidth( MainCanvas ), GadgetHeight( MainCanvas ), 32.0 )
		TilesetCamera = LTCamera.Create( GadgetWidth( TilesetCanvas ), GadgetHeight( TilesetCanvas ), 16.0 )
		L_CurrentCamera = MainCamera
		
		Local FileMenu:TGadget = CreateMenu( "File", 0, WindowMenu( Window ) )
		CreateMenu( "New", MenuNew, FileMenu )
		CreateMenu( "Open...", MenuOpen, FileMenu )
		CreateMenu( "Save...", MenuSave, FileMenu )
		CreateMenu( "Save as...", MenuSaveAs, FileMenu )
		CreateMenu( "", 0, FileMenu )
		CreateMenu( "Import tilemap...", MenuImportTilemap, FileMenu )
		CreateMenu( "Import tilemaps...", MenuImportTilemaps, FileMenu )
		CreateMenu( "", 0, FileMenu )
		CreateMenu( "Exit", MenuExit, FileMenu )
		
		Local EditMenu:TGadget = CreateMenu( "Edit", 0, WindowMenu( Window ) )
		ShowGrid = CreateMenu( "Show grid", MenuShowGrid, EditMenu )
		SnapToGrid = CreateMenu( "Snap to grid", MenuSnapToGrid, EditMenu )
		CreateMenu( "", 0, EditMenu )
		CreateMenu( "Grid settings", MenuGridSettings, EditMenu )
		CreateMenu( "Tilemap settings", MenuTilemapSettings, EditMenu )
		CreateMenu( "Tileset settings", MenuTilesetSettings, EditMenu )
		CreateMenu( "", 0, EditMenu )
		EditTilemap = CreateMenu( "Edit tilemap", MenuEditTilemap, EditMenu )
		EditSprites = CreateMenu( "Edit sprites", MenuEditSprites, EditMenu )
		CreateMenu( "", 0, EditMenu )
		CreateMenu( "Add page", MenuAddPage, EditMenu )
		CreateMenu( "Remove current page", MenuRemovePage, EditMenu )
		CreateMenu( "", 0, EditMenu )
		ReplacementOfTiles = CreateMenu( "Replacement of tiles", MenuReplacementOfTiles, EditMenu )
		ProlongTiles = CreateMenu( "Prolong tiles", MenuProlongTiles, EditMenu )
		CreateMenu( "Edit replacement rules", MenuEditReplacementRules, EditMenu )
		CheckMenu( EditSprites )
		
		UpdateWindowMenu( Window )
		
		Toolbar = CreateToolBar( "incbin::toolbar.png", 0, 0, 0, 0, Window )
		SetToolbarTips( Toolbar, [ "New", "Open", "Save", "Save as", "", "Show grid", "Snap to grid", "Grid settings", "", "Edit tilemap", "Edit sprites", "", "Add page", "Delete current page", "", "Auto-changement of tiles", "Prolong tiles", "Edit auto-changement rules" ] )
		
		SetGraphics( CanvasGraphics( MainCanvas ) )
		SetGraphicsParameters()
		
		SetClsColor( 255, 255, 255 )
		
		ModifiersImage = LoadAnimImage( "incbin::modifiers.png", 16, 16, 0, 10 )
		MidHandleImage( ModifiersImage )
		
		ShapeVisualizer.SetColorFromHex( "FF00FF" )
		ShapeVisualizer.Alpha = 0.5
		
		SelectedTile.Visualizer = New LTMarchingAnts
		
		AddPage( "Page1" )
		
		EditorPath = CurrentDir()
		
		If FileType( "editor.ini" ) = 1 Then
			Local IniFile:TStream = ReadFile( "editor.ini" )
			
			OpenWorld( ReadLine( IniFile ) )
			
			If ReadLine( IniFile ) = "1" Then SelectMenuItem( ShowGrid )
			If ReadLine( IniFile ) = "1" Then SelectMenuItem( SnapToGrid )
			
			If ReadLine( IniFile ) = "1" Then
				SelectMenuItem( EditSprites )
			Else
				SelectMenuItem( EditTilemap )
			End If
			
			If ReadLine( IniFile ) = "1" Then SelectMenuItem( ReplacementOfTiles )
			If ReadLine( IniFile ) = "1" Then SelectMenuItem( ProlongTiles )
			
			Grid.CellWidth = ReadLine( IniFile ).ToFloat()
			Grid.CellHeight = ReadLine( IniFile ).ToFloat()
			Grid.CellXDiv = ReadLine( IniFile ).ToInt()
			Grid.CellYDiv = ReadLine( IniFile ).ToInt()
			Editor.ShapeVisualizer.Red = ReadLine( IniFile ).ToInt()
			Editor.ShapeVisualizer.Green = ReadLine( IniFile ).ToInt()
			Editor.ShapeVisualizer.Blue = ReadLine( IniFile ).ToInt()
			
			CloseFile( IniFile )
		Else
			SelectMenuItem( EditTilemap )
			SelectMenuItem( ReplacementOfTiles )
		End If
		
		SetTitle()
	End Method
	
	
	
	Method SetTitle()
		Local Line:String = Title
		If WorldFilename Then Line = StripDir( WorldFilename ) + " - " + Line
		If Changed Then Line = "* " + Line
		SetGadgetText( Window, Line )
	End Method
	
	
	
	Method SetChanged( State:Int = True )
		If State <> Changed Then SetTitle()
		Changed = State
	End Method
	
	
	
	Method AskForSaving:Int()
		If Changed Then
			Local Choice:Int = Proceed( "Your world is not saved, would you like to save it now?" )
			If Choice = -1 Then Return False
			If Choice = 1 Then Return SaveWorld()
		End If
		Return True
	End Method
	
	
	
	Method NewWorld()
		If Not AskForSaving() Then Return
		
		WorldFilename = ""
		World.Pages.Clear()
		CurrentTileset = Null
		AddPage( "Page1" )
		RefreshPagesList()
		RefreshSpritesList()
	End Method
	
	
	
	Method OpenWorld( Filename:String )
		If Not AskForSaving() Then Return
		
		If Filename Then 
			If FileType( Filename ) = 0 Then Return
			
			L_ImagesList.Clear()
			
			WorldFilename = Filename
			ChangeDir( ExtractDir( Filename ) )
			
			World = LTWorld( L_LoadFromFile( Filename ) )
			
			CurrentSprite = Null
			For Local Page:LTPage = Eachin World.Pages
				For Local Sprite:LTSprite = Eachin Page.Sprites
					CurrentSprite = Sprite
					Exit
				Next
				If CurrentSprite Then Exit
			Next
			
			For Local Image:LTImage = Eachin L_ImagesList
				InitImage( Image )
			Next
			
			SelectPage( LTPage( World.Pages.First() ) )
			
			Changed = False
			
			SetTitle()
		End If
	End Method
	
	
	
	Method SaveWorld:Int( SaveAs:Int = False )
		Local Filename:String = WorldFilename
		If SaveAs Or Not Filename Then Filename = RequestFile( "Select world file name to save...", "DWLab world file:lw", True )
		If Filename Then 
			WorldFilename = Filename
			ChangeDir( ExtractDir( Filename ) )
			For Local Image:LTImage = Eachin L_ImagesList
				Debuglog Image.Filename
				Image.Filename = ChopFilename( String( RealPathsForImages.ValueForKey( Image ) ) )
				Debuglog Image.Filename
			Next
			
			World.SaveToFile( Filename )
			Changed = False
			SetTitle()
			Return True
		End If
	End Method
	
	
	
	Method ExitEditor()
		If Not AskForSaving() Then Return
	
		Local IniFile:TStream = WriteFile( EditorPath + "/editor.ini" )
		
		WriteLine( IniFile, WorldFilename )
		WriteLine( IniFile, MenuChecked( ShowGrid ) )
		WriteLine( IniFile, MenuChecked( SnapToGrid ) )
		WriteLine( IniFile, MenuChecked( EditSprites ) )
		WriteLine( IniFile, MenuChecked( ReplacementOfTiles ) )
		WriteLine( IniFile, MenuChecked( ProlongTiles ) )
		
		WriteLine( IniFile, Grid.CellWidth )
		WriteLine( IniFile, Grid.CellHeight )
		WriteLine( IniFile, Grid.CellXDiv )
		WriteLine( IniFile, Grid.CellYDiv )
		WriteLine( IniFile, Editor.ShapeVisualizer.Red )
		WriteLine( IniFile, Editor.ShapeVisualizer.Green )
		WriteLine( IniFile, Editor.ShapeVisualizer.Blue )
		
		CloseFile( IniFile )
		
		End
	End Method
	
	
	
	Method Logic()
		PollEvent()
		
		Local EvID:Int = EventID()
		If EvID = Event_GadgetAction And EventSource() = Toolbar Then
			EvID = Event_MenuAction
		End If
		
		Select EvID
			Case Event_KeyDown
				If EventData() = Key_Delete Then
					For Local Sprite:LTSprite = Eachin SelectedSprites
						CurrentPage.Sprites.Remove( Sprite )
						SetChanged()
					Next
					RefreshSpritesList()
					SelectedSprites.Clear()
					Modifiers.Clear()
				Else If EventData() = Key_Space Then
					If MenuChecked( EditSprites ) Then
						SelectMenuItem( EditTilemap )
					Else
						SelectMenuItem( EditSprites )
					End If
				End If
			Case Event_MouseWheel
				If Not Modifiers.IsEmpty() Then
					Local Sprite:LTSprite = LTSprite( SelectedSprites.First() )
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
					Case MenuNew
						NewWorld()
					Case MenuOpen
						OpenWorld( RequestFile( "Select world file to open...", "DWLab world file:lw" ) )
					Case MenuSave
						SaveWorld()
					Case MenuSaveAs
						SaveWorld( True )
					Case MenuImportTilemap
						Local TileWidth:Int = 16
						Local TileHeight:Int = 16
						If ChooseParameter( TileWidth, TileHeight, "tile size", "pixels" ) Then
							Local Filename:String = RequestFile( "Select tilemap file to process...", "Image files:png,jpg,bmp" )
							Local Tilemap:TPixmap = LoadPixmap( Filename )
							If Not Tilemap Then
								Notify( "Cannot load tilemap." )
							Else
								Local TilemapWidth:Int = PixmapWidth( Tilemap )
								Local TilemapHeight:Int = PixmapHeight( Tilemap )
								
								If TilemapWidth Mod TileWidth = 0 And TilemapHeight Mod TileHeight = 0 Then
									Local TilesetFilename:String = ChopFilename( RequestFile( "Select file to save tiles image to...", "png", True ) )
									If TilesetFilename Then
										ImportTilemap( TileWidth, TileHeight, Tilemap, TilesetFilename )
										Local Tileset:TImage = LoadImage( TilesetFilename )
										Local Visualizer:LTImageVisualizer = New LTImageVisualizer
										Visualizer.Image = LoadImageFromFile( TilesetFilename, Tileset.Width / TileWidth, Tileset.height / TileHeight )
										CurrentPage.Tilemap.Visualizer = Visualizer
										SelectPage( CurrentPage )
										SetChanged()
									End If
								Else
									Notify( "Tilemap size must be divideable by tile size." )
								End If
							End If
						End If
					Case MenuImportTilemaps
						Local TileWidth:Int = 16
						Local TileHeight:Int = 16
						If ChooseParameter( TileWidth, TileHeight, "tile size", "pixels" ) Then
							Local Path:String = RequestDir( "Select directory with tilemap files to process...", CurrentDir() )
							If Path Then 
								Local TilesetFilename:String = ChopFilename( RequestFile( "Select file to save tiles image to...", "png", True ) )
								If TilesetFilename Then 
									Local Dir:Int = ReadDir( Path )
									Local Num:Int = 1
									Local Visualizer:LTImageVisualizer = New LTImageVisualizer
									Repeat
										Local Filename:String = NextFile( Dir )
										If Not Filename Then Exit
										If Lower( Right( Filename, 4 ) ) <> ".png" Then Continue
										
										Filename = Path + "\" + Filename
										
										Local Tilemap:TPixmap = LoadPixmap( Filename )
										If Tilemap Then
											Local TilemapWidth:Int = PixmapWidth( Tilemap )
											Local TilemapHeight:Int = PixmapHeight( Tilemap )
											
											If TilemapWidth Mod TileWidth = 0 And TilemapHeight Mod TileHeight = 0 Then
												Local Page:LTPage = New LTPage
												Page.SetName( "Level " + Num )
												Editor.World.Pages.AddLast( Page )
												ImportTilemap( TileWidth, TileHeight, Tilemap, TilesetFilename )
												Page.Tilemap.Visualizer = Visualizer
												SelectPage( Page )
												SetChanged()
											End If
										End If
										
										Num :+ 1
									Forever
									Local Tileset:TImage = LoadImage( TilesetFilename )
									Visualizer.Image = LoadImageFromFile( TilesetFilename, Tileset.Width / TileWidth, Tileset.Height / TileHeight )
								End If
							End If
						End If
					Case MenuSnapToGrid
						SelectMenuItem( SnapToGrid, 2 )
					Case MenuShowGrid
						SelectMenuItem( ShowGrid, 2 )
					Case MenuTilemapSettings
						Local XQuantity:Int = 16
						Local YQuantity:Int = 16
						If CurrentPage.Tilemap Then
							XQuantity = CurrentPage.TileMap.FrameMap.XQuantity
							YQuantity = CurrentPage.TileMap.FrameMap.YQuantity
						End If
						
						If ChooseParameter( XQuantity, YQuantity, "tiles quantity", "tiles" ) Then
							If CurrentPage.Tilemap Then 
								CurrentPage.TileMap.FrameMap.SetResolution( XQuantity, YQuantity )
							Else
								CurrentPage.Tilemap = LTTilemap.Create( XQuantity, YQuantity, 16, 16, 16 )
							End If
							CurrentPage.TileMap.X = 0.5 * XQuantity
							CurrentPage.TileMap.Y = 0.5 * YQuantity
							CurrentPage.TileMap.Width = XQuantity
							CurrentPage.TileMap.Height = YQuantity
							SelectPage( CurrentPage )
						End If
					Case MenuGridSettings
						Grid.Settings()
					Case MenuTilesetSettings
						If CurrentPage.Tilemap Then
							SpriteImageProperties( CurrentPage.TileMap )
							SelectPage( CurrentPage )
						Else
							Notify( "Create tilemap first by visiting ''Edit/Tilemap settings'' first" )
						End If
					Case MenuEditTilemap
						SelectMenuItem( EditTilemap )
					Case MenuEditSprites
						SelectMenuItem( EditSprites )
					Case MenuAddPage
						Local PageName:String = EnterString( "Enter page name:" )
						If PageName Then
							Local Page:LTPage = New LTPage
							Page.SetName( PageName )
							World.Pages.AddLast( Page )
							SelectPage( Page )
						End If
					Case MenuRemovePage
						If World.Pages.Count() > 1 Then
							World.Pages.Remove( CurrentPage )
							SelectPage( LTPage( World.Pages.First() ) )
						Else
							Notify( "Cannot delete only page" )
						End If
					Case MenuReplacementOfTiles
						SelectMenuItem( ReplacementOfTiles, 2 )
					Case MenuProlongTiles
						SelectMenuItem( ProlongTiles, 2 )
					Case MenuEditReplacementRules
						TilesetProperties( CurrentPage.TileMap )
					Case MenuExit
						ExitEditor()
				End Select
			Case Event_GadgetAction
				Select EventSource()
					Case SpritesListBox
						Local Name:String = EnterString( "Enter name of sprite", CurrentSprite.GetName() )
						If Name Then
							SetObjectName( CurrentSprite, Name )
							RefreshSpritesList()
							SetChanged()
						End If
					Case PagesListBox
						Local Name:String = EnterString( "Enter name of page", CurrentPage.GetName() )
						If Name Then
							SetObjectName( CurrentPage, Name )
							RefreshPagesList()
							SetChanged()
						End If
					Case SelectImageButton
						If Not SelectedSprites.IsEmpty() Then
							Local FirstSprite:LTSprite = LTSprite( SelectedSprites.First() )
							If SpriteImageProperties( FirstSprite ) Then
								For Local Sprite:LTSprite = Eachin SelectedSprites
									LTImageVisualizer( Sprite.Visualizer ).Image = LTImageVisualizer( FirstSprite.Visualizer ).Image
								Next
							End If
						End If
				End Select
				
				For Local Sprite:LTSprite = Eachin SelectedSprites
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
									Sprite.Width = TextFieldText( WidthField ).ToFloat()
									SetSpriteModifiers( Sprite )
								Case HeightField
									Sprite.Height = TextFieldText( HeightField ).ToFloat()
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
								Case ImgAngleField
									LTImageVisualizer( Sprite.Visualizer ).Angle = TextFieldText( ImgAngleField ).ToFloat()
							End Select
							SetChanged()
					Case ScalingCheckbox
							Sprite.Visualizer.Scaling = ButtonState( ScalingCheckbox )
							SetChanged()
						Case RotatingCheckbox
							LTImageVisualizer( Sprite.Visualizer ).Rotating = ButtonState( RotatingCheckbox )
							SetChanged()
						Case RedSlider
							Sprite.Visualizer.Red = 0.01 * SliderValue( RedSlider )
							SetGadgetText( RedField, Sprite.Visualizer.Red )
							SetChanged()
						Case GreenSlider
							Sprite.Visualizer.Green = 0.01 * SliderValue( GreenSlider )
							SetGadgetText( GreenField, Sprite.Visualizer.Green )
							SetChanged()
						Case BlueSlider
							Sprite.Visualizer.Blue = 0.01 * SliderValue( BlueSlider )
							SetGadgetText( BlueField, Sprite.Visualizer.Blue )
							SetChanged()
						Case AlphaSlider
							Sprite.Visualizer.Alpha = 0.01 * SliderValue( AlphaSlider )
							SetGadgetText( AlphaField, Sprite.Visualizer.Alpha )
							SetChanged()
						Case ShapeBox
							Sprite.Shape = SelectedGadgetItem( ShapeBox )
							SetChanged()
					End Select
				Next
			Case Event_GadgetSelect
				Select EventSource()
					Case SpritesListBox
						SelectSprite( LTSprite( CurrentPage.Sprites.ValueAtIndex( EventData() ) ) )
					Case PagesListBox
						If EventData() >= 0 Then SelectPage( LTPage( World.Pages.ValueAtIndex( EventData() ) ) )
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
		For Local Modifier:LTSprite = Eachin Modifiers
			Local MX:Float, MY:Float
			MainCamera.FieldToScreen( Modifier.X, Modifier.Y, MX, MY )
			If MouseX() >= MX - 8 And MouseX() <= MX + 8 And MouseY() >= MY - 8 And MouseY() <= MY + 8 Then
				SelectedModifier = Modifier
			End If
		Next
		
		If MenuChecked( EditTilemap ) Then
			If CurrentPage.TileMap Then
				Local MX:Float, MY:Float
				MainCamera.ScreenToField( MouseX(), MouseY(), MX, MY )
				TileX = L_LimitInt( Floor( MX ), 0, CurrentPage.Tilemap.FrameMap.XQuantity - 1 )
				TileY = L_LimitInt( Floor( MY ), 0, CurrentPage.Tilemap.FrameMap.YQuantity - 1 )
				Local Image:LTImage = LTImageVisualizer( CurrentPage.Tilemap.Visualizer ).Image
				If Image then
					Local FWidth:Float, FHeight:Float
					TilesetCamera.SizeScreenToField( GadgetWidth( TilesetCanvas ), 0, FWidth, FHeight )
					TilesInRow = Max( 1, Min( Image.FramesQuantity(), Floor( FWidth ) ) )
					
					If MouseIsOver = TilesetCanvas Then
						Local FX:Float, FY:Float
						TilesetCamera.ScreenToField( MouseX(), MouseY(), FX, FY )
						Local TileNumUnderCursor:Int = Floor( FX ) + TilesInRow * Floor( FY )
						If MouseDown( 1 ) Then TileNum[ 0 ] = TileNumUnderCursor
						If MouseDown( 2 ) Then TileNum[ 1 ] = TileNumUnderCursor
					End If
				End If
			End If
			
			If CurrentTileset Then
				Local N:Int = 0
				Local FrameMap:LTIntMap = CurrentPage.TileMap.FrameMap
				For Local StringPos:String = Eachin TilesQueue.Keys()
					Local Pos:Int = StringPos.ToInt()
					CurrentTileset.Enframe( CurrentPage.TileMap, Pos Mod FrameMap.XQuantity, Floor( Pos / FrameMap.XQuantity ) )
					TilesQueue.Remove( StringPos )
					N :+ 1
					If N = 16 Then  Exit
				Next
			End If
			
			SetTile.Execute()
		Else
			SpriteUnderCursor = Null
			For Local Sprite:LTSprite = Eachin Editor.CurrentPage.Sprites
				If Editor.Cursor.CollidesWith( Sprite ) Then
					SpriteUnderCursor = Sprite
					Exit
				End If
			Next
			
			SelectSprites.Execute()
			MoveSprite.Execute()
			CreateSprite.Execute()
			ModifySprite.Execute()
		End If
		
		Pan.Execute()
		
		SetCameraMagnification( MainCamera, MainCanvas, MainCanvasZ, 32.0 )
		SetCameraMagnification( TilesetCamera, TilesetCanvas, TilesetCanvasZ, TilesetCameraWidth )
		
		If CurrentPage.Tilemap Then MainCamera.LimitWith( CurrentPage.Tilemap )
	End Method
	
	
	
	Method SetCameraMagnification( Camera:LTCamera, Canvas:TGadget, Z:Int, Width:Int )
		Local NewD:Float = 1.0 * GadgetWidth( Canvas ) / Width * ( 1.1 ^ Z )
		Camera.SetMagnification( NewD, NewD )
	End Method
	
	
	
	Method Render()
		If MenuChecked( EditTilemap ) And CurrentPage.TileMap Then
			SelectedTile.X = 0.5 + TileX
			SelectedTile.Y = 0.5 + TileY
			SelectedTile.Draw()
			
			TilesetCamera.Viewport.X = 0.5 * TilesetCanvas.GetWidth()
			TilesetCamera.Viewport.Y = 0.5 * TilesetCanvas.GetHeight()
			TilesetCamera.Viewport.Width = TilesetCanvas.GetWidth()
			TilesetCamera.Viewport.Height = TilesetCanvas.GetHeight()
			
			SetGraphics( CanvasGraphics( TilesetCanvas ) )
			Cls
			
			Local Image:LTImage = LTImageVisualizer( CurrentPage.Tilemap.Visualizer ).Image
			If Image Then
				TilesetCamera.X = 0.5 * TilesInRow
				TilesetCamera.Y = 0.5 * Ceil( Image.FramesQuantity() / TilesInRow )
				TilesetCamera.Update()
			
				Local TileWidth:Float, TileHeight:Float
				TilesetCamera.SizeFieldToScreen( 1.0, 1.0, TileWidth, TileHeight )
				SetScale( TileWidth / Image.BMaxImage.Width, TileHeight / Image.BMaxImage.Height )
				'debugstop
				For Local Frame:Int = 0 Until Image.FramesQuantity()
					Local SX:Float, SY:Float
					TilesetCamera.FieldToScreen( 0.5 + Frame Mod TilesInRow, 0.5 + Floor( Frame / TilesInRow ), SX, SY )
					DrawImage( Image.BMaxImage, SX, SY, Frame )
				Next
				
				SetScale( 1.0, 1.0 )
				
				L_CurrentCamera = TilesetCamera
				
				For Local N:Int = 0 To 1
					TileNum[ N ] = L_LimitInt( TileNum[ N ], 0, Image.FramesQuantity() - 1 )
					SelectedTile.X = 0.5 + TileNum[ N ] Mod TilesInRow
					SelectedTile.Y = 0.5 + Floor( TileNum[ N ] / TilesInRow )
					SelectedTile.Draw()
				Next
				
				L_CurrentCamera = MainCamera
			End If
			
			Flip
		End If
		
		SetGraphics( CanvasGraphics( MainCanvas ) )
		Cls
		
		MainCamera.Viewport.X = 0.5 * MainCanvas.GetWidth()
		MainCamera.Viewport.Y = 0.5 * MainCanvas.GetHeight()
		MainCamera.Viewport.Width = MainCanvas.GetWidth()
		MainCamera.Viewport.Height = MainCanvas.GetHeight()
		MainCamera.Update()
		
		If CurrentPage.TileMap Then CurrentPage.TileMap.Draw()
		
		For Local Sprite:LTSprite = Eachin CurrentPage.Sprites
			Sprite.Draw()
			Sprite.DrawUsingVisualizer( ShapeVisualizer )
			Sprite.DrawUsingVisualizer( AngleArrow )
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
			For Local Sprite:LTSprite = Eachin SelectedSprites
				Sprite.DrawUsingVisualizer( MarchingAnts )
			Next
			
			If SelectSprites.Frame Then SelectSprites.Frame.DrawUsingVisualizer( MarchingAnts )
			
			If Not ModifySprite.DraggingState And Not CreateSprite.DraggingState Then
				SetAlpha( 0.75 )
				For Local Modifier:LTSprite = Eachin Modifiers
					Local X:Float, Y:Float
					L_CurrentCamera.FieldToScreen( Modifier.X, Modifier.Y, X, Y )
					DrawImage( ModifiersImage, X, Y, Modifier.Frame )
				Next
				SetAlpha( 1.0 )
			End If
		End If
	End Method
	
	
	
	Method SelectMenuItem( MenuItem:TGadget, State:Int = 1 )
		If State = 2 Then State = 1 - MenuChecked( MenuItem )
	
		Select Menuitem
			Case ShowGrid
				If State Then
					CheckMenu( ShowGrid )
					SelectGadgetItem( Toolbar, MenuShowGrid )
				Else
					UncheckMenu( ShowGrid )
					DeselectGadgetItem( Toolbar, MenuShowGrid )
				End If
			Case SnapToGrid
				If State Then
					CheckMenu( SnapToGrid )
					SelectGadgetItem( Toolbar, MenuSnapToGrid )
				Else
					UncheckMenu( SnapToGrid )
					DeselectGadgetItem( Toolbar, MenuSnapToGrid )
				End If
			Case EditTilemap
				UncheckMenu( EditSprites )
				CheckMenu( EditTilemap )
				DeselectGadgetItem( Toolbar, MenuEditSprites )
				SelectGadgetItem( Toolbar, MenuEditTilemap )
			Case EditSprites
				CheckMenu( EditSprites )
				UncheckMenu( EditTilemap )
				SelectGadgetItem( Toolbar, MenuEditSprites )
				DeselectGadgetItem( Toolbar, MenuEditTilemap )
			Case ReplacementOfTiles
				If State Then
					CheckMenu( ReplacementOfTiles )
					SelectGadgetItem( Toolbar, MenuReplacementOfTiles )
				Else
					UncheckMenu( ReplacementOfTiles )
					DeselectGadgetItem( Toolbar, MenuReplacementOfTiles )
				End If
			Case ProlongTiles
				If State Then
					CheckMenu( ProlongTiles )
					SelectGadgetItem( Toolbar, MenuProlongTiles )
					L_ProlongTiles = True
				Else
					UncheckMenu( ProlongTiles )
					DeselectGadgetItem( Toolbar, MenuProlongTiles )
					L_ProlongTiles = False
				End If
		End Select
	End Method
	
	
	
	Method FillSpriteFields()
		If Not CurrentSprite Then Return
	
		SetGadgetText( XField, L_TrimFloat( CurrentSprite.X ) )
		SetGadgetText( YField ,L_TrimFloat( CurrentSprite.Y ) )
		SetGadgetText( WidthField, L_TrimFloat( CurrentSprite.Width ) )
		SetGadgetText( HeightField, L_TrimFloat( CurrentSprite.Height ) )
		SetGadgetText( AngleField, L_TrimFloat( CurrentSprite.Angle ) )
		SetGadgetText( VelocityField, L_TrimFloat( CurrentSprite.Velocity ) )
		SetGadgetText( FrameField, CurrentSprite.Frame )
		SetGadgetText( RedField, L_TrimFloat( CurrentSprite.Visualizer.Red ) )
		SetGadgetText( GreenField, L_TrimFloat( CurrentSprite.Visualizer.Green ) )
		SetGadgetText( BlueField, L_TrimFloat( CurrentSprite.Visualizer.Blue ) )
		SetGadgetText( AlphaField, L_TrimFloat( CurrentSprite.Visualizer.Alpha ) )
		SetGadgetText( XScaleField, L_TrimFloat( CurrentSprite.Visualizer.XScale ) )
		SetGadgetText( YScaleField, L_TrimFloat( CurrentSprite.Visualizer.YScale ) )
		SetGadgetText( ImgAngleField, L_TrimFloat( LTImageVisualizer( CurrentSprite.Visualizer ).Angle ) )
		
		SetButtonState( RotatingCheckbox, LTImageVisualizer( CurrentSprite.Visualizer ).Rotating )
		SetButtonState( ScalingCheckbox, CurrentSprite.Visualizer.Scaling )
		
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
	
	
	
	Method SelectSprite( Sprite:LTSprite )
		SelectedSprites.Clear()
		SelectedSprites.AddLast( Sprite )
		SetSpriteModifiers( Sprite )
		CurrentSprite = Sprite
		FillSpriteFields()
		RefreshSpritesList()
	End Method
	
	
	
	Method SetSpriteModifiers( Sprite:LTSprite )
		Modifiers.Clear()
	
		Local SWidth:Float, SHeight:Float
		L_CurrentCamera.SizeFieldToScreen( 0.5 * Sprite.Width, 0.5 * Sprite.Height, SWidth, SHeight )
		
		If SWidth < 25 Then SWidth = 25
		If SHeight < 25 Then SHeight = 25
		
		AddModifier( Sprite, TModifySprite.Move, 0, 0 )
		AddModifier( Sprite, TModifySprite.ResizeHorizontally, -SWidth - 9, 0 )
		AddModifier( Sprite, TModifySprite.ResizeHorizontally, SWidth + 9, 0 )
		AddModifier( Sprite, TModifySprite.ResizeVertically, 0, -SHeight - 9 )
		AddModifier( Sprite, TModifySprite.ResizeVertically, 0, +SHeight + 9 )
		AddModifier( Sprite, TModifySprite.Resize, -SWidth + 8, -SHeight + 8 )
		AddModifier( Sprite, TModifySprite.Resize, SWidth - 8, -SHeight + 8 )
		AddModifier( Sprite, TModifySprite.Resize, -SWidth + 8, SHeight - 8 )
		AddModifier( Sprite, TModifySprite.Resize, SWidth - 8, SHeight - 8 )
		AddModifier( Sprite, TModifySprite.ResizeDiagonally1, SWidth + 9, SHeight + 9 )
		AddModifier( Sprite, TModifySprite.ResizeDiagonally1, -SWidth - 9, -SHeight - 9 )
		AddModifier( Sprite, TModifySprite.ResizeDiagonally2, -SWidth - 9, SHeight + 9 )
		AddModifier( Sprite, TModifySprite.ResizeDiagonally2, SWidth + 9, -SHeight - 9 )
		AddModifier( Sprite, TModifySprite.MirrorHorizontally, 0, -17 )
		AddModifier( Sprite, TModifySprite.MirrorVertically, 0, 17 )
		AddModifier( Sprite, TModifySprite.RotateBackward, -17, 0 )
		AddModifier( Sprite, TModifySprite.RotateForward, 17, 0 )		
	End Method
	
	
	
	Method AddModifier( Sprite:LTSprite, ModType:Int, DX:Int, DY:Int )
		Local Modifier:LTSprite = New LTSprite
		Local FDX:Float, FDY:Float
		L_CurrentCamera.SizeScreenToField( DX, DY, FDX, FDY )
		Modifier.X = Sprite.X + FDX
		Modifier.Y = Sprite.Y + FDY
		Modifier.Frame = ModType
		Modifier.Shape = L_Rectangle
		Modifiers.AddLast( Modifier )
	End Method
	
	
	
	Method RefreshSpritesList()
		RefreshListBox( SpritesListBox, CurrentPage.Sprites.Children, CurrentSprite )
	End Method
	
	
	
	Method SelectPage( Page:LTPage )
		CurrentPage = Page
		RefreshPagesList()
		SelectedSprites.Clear()
		RefreshSpritesList()
		If CurrentPage.TileMap Then
			Local Image:LTImage = LTImageVisualizer( CurrentPage.TileMap.Visualizer ).Image
			If Image Then
				CurrentTileset = LTTileset( TilesetMap.ValueForKey( Image ) )
				TilesetCameraWidth = Image.XCells
				TilesetCanvasZ = 0.0
			End If
		End If
		Modifiers.Clear()
	End Method
	
	
	
	Method AddPage( PageName:String )
		Local Page:LTPage = New LTPage
		Page.SetName( PageName )
		World.Pages.AddLast( Page )
		SelectPage( Page )
	End Method	
	
	
	
	Method RefreshPagesList()
		RefreshListBox( PagesListBox, World.Pages, CurrentPage )
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





Function RefreshListBox( ListBox:TGadget, ObjectsList:TList, CurrentObject:LTObject )
	Local N:Int = 0
	For Local Obj:LTObject = Eachin ObjectsList
		Local ObjectName:String = Obj.GetName()
		If Obj = CurrentObject Then ObjectName = "* " + ObjectName + " *"
		If N < CountGadgetItems( ListBox ) Then
			If GadgetItemText( ListBox, N ) <> ObjectName Then ModifyGadgetItem( ListBox, N, ObjectName )
		Else
			AddGadgetItem( ListBox, ObjectName )
		End If
		N :+ 1
	Next
	
	While N < CountGadgetItems( ListBox )
		RemoveGadgetItem( ListBox, N )
	Wend
End Function




	
Function SetObjectName( Obj:LTObject, Name:String )
	Local NamePrefix:String = L_GetPrefix( Name )
	Local NameNumber:Int = L_GetNumber( Name )
	Local SpriteName:String = Name
	Obj.ClearName()
	Repeat
		If Not LTObject.FindByName( SpriteName ) Then Exit
		NameNumber :+ 1
		SpriteName = NamePrefix + NameNumber
	Forever
	Obj.SetName( SpriteName )
End Function