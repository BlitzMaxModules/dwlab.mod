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

Framework dwlab.frmwork
Import dwlab.graphicsdrivers
Import dwlab.physics2d
Import brl.bmploader
Import brl.freetypefont

?win32
Import maxgui.win32maxguiex
?linux
Import maxgui.fltkmaxgui
?macos
Import maxgui.cocoamaxgui
?

Include "LTForm.bmx"
Include "LTFormGadget.bmx"
Include "LTHorizontalList.bmx"
Include "LTMenuSwitch.bmx"

Include "TPan.bmx"
Include "TSelectShapes.bmx"
Include "TMoveShape.bmx"
Include "TCreateSprite.bmx"
Include "TModifyShape.bmx"
Include "TGrid.bmx"
Include "TSetTile.bmx"
Include "TSimulator.bmx"
Include "ChooseParameter.bmx"
Include "ImportTilemap.bmx"
Include "EnterString.bmx"
Include "TilesetRules.bmx"
Include "PrintImageToCanvas.bmx"
Include "ResizeTilemap.bmx"
Include "AddOKCancelButtons.bmx"
Include "SelectImageOrTileset.bmx"
Include "ImageProperties.bmx"
Include "TileCollisionShapes.bmx"
Include "SpriteMapProperties.bmx"
Include "CameraProperties.bmx"
Include "TileMapProperties.bmx"
Include "ParameterProperties.bmx"
Include "LayerBounds.bmx"


Incbin "english.lng"
Incbin "russian.lng"

Incbin "font.ttf"

Incbin "toolbar.png"
Incbin "treeview.png"

L_LoadingUpdater = New TLoadingUpdater

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Const Version:String = "1.9.2"
	Const INIVersion:Int = 6
	Const ModifierSize:Int = 3
	Const RecentFilesQuantity:Int = 8
	
	Field EnglishLanguage:TMaxGuiLanguage
	Field RussianLanguage:TMaxGuiLanguage
	Field CurrentLanguage:TMaxGuiLanguage
	
	Const EnglishNum:Int = 0
	Const RussianNum:Int = 1
	
	Field ParameterNames:TMap = New TMap
	
	Field Window:TGadget
	
	Field MainCanvas:TGadget
	Field MainCamera:LTCamera
	Field MainCanvasZ:Int
	
	Field TilesetCanvas:TGadget
	Field TilesetCamera:LTCamera = New LTCamera
	Field TilesetCameraWidth:Int
	Field TilesetCanvasZ:Int
	Field TilesetRectangle:LTSprite = New LTSprite
	Field ParametersListBox:TGadget
	
	Field Toolbar:TGadget
	Field TreeViewIcons:TIconStrip
	
	Field MouseIsOver:TGadget
	Field Changed:Int
	
	Field ProjectManager:TGadget
	Field Panel:TGadget
	Field ShapeBox:TGadget
	Field XField:TGadget
	Field YField:TGadget
	Field WidthField:TGadget
	Field HeightField:TGadget
	Field DXField:TGadget
	Field DYField:TGadget
	Field VelocityField:TGadget
	Field AngleSlider:TGadget, AngleField:TGadget
	Field DisplayingAngleSlider:TGadget, DisplayingAngleField:TGadget
	Field LayerSlider:TGadget, LayerField:TGadget
	Field RedSlider:TGadget, RedField:TGadget
	Field GreenSlider:TGadget, GreenField:TGadget
	Field BlueSlider:TGadget, BlueField:TGadget
	Field AlphaSlider:TGadget, AlphaField:TGadget
	Field XScaleField:TGadget
	Field YScaleField:TGadget
	Field VisDXField:TGadget
	Field VisDYField:TGadget
	Field FrameSlider:TGadget, FrameField:TGadget
	Field SelectImageButton:TGadget
	Field RotatingCheckbox:TGadget
	Field ScalingCheckbox:TGadget
	Field PhysicsCheckbox:TGadget
	Field HiddenOKButton:TGadget
	Field HScroller:TGadget
	Field VScroller:TGadget
	
	Field ShowGrid:Int
	Field SnapToGrid:Int
	Field ReplacementOfTiles:Int
	Field BilinearFiltering:Int
	
	Field IncbinMenu:TGadget
	Field Russian:TGadget
	Field English:TGadget
	Field MixContent:TGadget
	
	Field FileMenu:TGadget
	Field LayerMenu:TGadget
	Field TilemapMenu:TGadget
	Field SpriteMapMenu:TGadget
	Field SpriteMenu:TGadget
	Field MapSpriteMenu:TGadget
	Field ParameterMenu:TGadget
	Field RecentFiles:String[] = New String[ RecentFilesQuantity ]
	Field CurrentTextField:TGadget 
	
	Field World:LTWorld = New LTWorld
	Field RealPathsForImages:TMap = New TMap
	Field BigImages:TMap = New TMap
	Field CurrentViewLayer:LTLayer
	Field CurrentTileMap:LTTileMap
	Field CurrentContainer:LTShape
	Field CurrentShape:LTShape
	Field SelectedShape:LTShape
	Field ShapeForParameters:LTShape
	Field TilesQueue:TMap = New TMap
	Field Cursor:LTSprite = New LTSprite
	Field ShapeUnderCursor:LTShape
	Field SelectedShapes:TList = New TList
	Field Buffer:TList = New TList
	Field SelectedModifier:LTSprite
	Field SelectedParameter:LTParameter
	Field Modifiers:TList = New TList
	
	Field SelectedTile:LTSprite = New LTSprite
	Field TileX:Int, TileY:Int, TileNum:Int[] = New Int[ 2 ]
	
	Field WorldFilename:String
	Field EditorPath:String
	
	Field Pan:TPan
	Field SelectShapes:TSelectShapes = New TSelectShapes
	Field MoveShape:TMoveShape = New TMoveShape
	Field CreateSprite:TCreateSprite = New TCreateSprite
	Field ModifyShape:TModifyShape = New TModifyShape
	Field SetTile:TSetTile = New TSetTile
	Field Grid:TGrid = New TGrid
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	Field EmptyHandler:LTSpriteCollisionHandler = New LTSpriteCollisionHandler

	
	
	Const MenuNew:Int = 0
	Const MenuOpen:Int = 1
	Const MenuSave:Int = 2
	Const MenuSaveAs:Int = 3
	Const MenuMerge:Int = 64
	Const MenuRecentFile:Int = 100
	Const MenuShowCollisionShapes:Int = 5
	Const MenuShowVectors:Int = 6
	Const MenuShowNames:Int = 7
	Const MenuShowGrid:Int = 9
	Const MenuSnapToGrid:Int = 10
	Const MenuGridSettings:Int = 11
	Const MenuTilemapEditingMode:Int = 13
	Const MenuReplacementOfTiles:Int = 15
	Const MenuProlongTiles:Int = 16
	Const MenuBackgroundColor:Int = 66
	Const MenuCameraProperties:Int = 51
	Const MenuIncbin:Int = 54
	Const MenuBilinearFiltering:Int = 65
	Const MenuExit:Int = 34
	Const MenuRussian:Int = 32
	Const MenuEnglish:Int = 33
	Const MenuHotKeys:Int = 52
	Const MenuAbout:Int = 53
	
	Const MenuDuplicate:Int = 49
	Const MenuToggleVisibility:Int =  30
	Const MenuToggleActivity:Int =  31
	Const MenuRename:Int = 35
	Const MenuSetClass:Int = 56
	Const MenuShiftToTheTop:Int = 36
	Const MenuShiftUp:Int = 37
	Const MenuShiftDown:Int = 38
	Const MenuShiftToTheBottom:Int = 39
	Const MenuRemove:Int = 40
	Const MenuSetBounds:Int = 28
	Const MenuCut:Int = 59
	Const MenuCopy:Int = 60
	Const MenuPaste:Int = 61

	Const MenuSelectViewLayer:Int = 41
	Const MenuSelectContainer:Int = 45
	Const MenuAddLayer:Int = 47
	Const MenuAddTilemap:Int = 48
	Const MenuImportTilemap:Int = 21
	Const MenuImportTilemaps:Int = 22
	Const MenuAddSpriteMap:Int = 44
	Const MenuRemoveBounds:Int = 29
	Const MenuMixContent:Int = 55
	Const MenuStartSimulation:Int = 67
	Const MenuEditBounds:Int = 68

	Const MenuEditTilemap:Int = 23
	Const MenuSelectTileMap:Int = 27
	Const MenuSelectTileset:Int = 24
	Const MenuResizeTilemap:Int = 42
	Const MenuTilemapProperties:Int = 25
	Const MenuEditReplacementRules:Int = 26
	Const MenuEditTileCollisionShapes:Int = 43
	Const MenuEnframe:Int = 50
	Const MenuGenerateRulesAreas:Int = 62
	Const MenuGenerateRulesWalls:Int = 63
	
	Const MenuSpriteMapProperties:Int = 46
	
	Const MenuModifyParameter:Int = 57
	Const MenuRemoveParameter:Int = 58

	
	
	Const PanelHeight:Int = 368
	Const BarWidth:Int = 256
	Const LabelWidth:Int = 63
	Const ListBoxHeight:Int = 62
	
	
	
	Method Init()
		L_Flipping = False
		AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE | MIPMAPPEDIMAGE )
		
		SetLocalizationMode( Localization_On | Localization_Override )
		EnglishLanguage = LoadLanguage( "incbin::english.lng" )
		RussianLanguage = LoadLanguage( "incbin::russian.lng" )
		SetLocalizationLanguage( EnglishLanguage )
		AppTitle = LocalizeString( "{{Title}}" + Version )
	
		Window  = CreateWindow( "{{Title}}", 0, 0, 640, 480, Null, WINDOW_TITLEBAR | WINDOW_RESIZABLE | WINDOW_MENU )
		MaximizeWindow( Window )
		
		Toolbar = CreateToolBar( "incbin::toolbar.png", 0, 0, 0, 0, Window )
		SetToolbarTips( Toolbar, [ "{{M_New}}", "{{M_Open}}", "{{M_Save}}", "{{M_SaveAs}}", "", "{{M_ShowCollisions}}", "{{M_ShowVectors}}", "{{M_ShowNames}}", "", "{{M_ShowGrid}}", "{{M_SnapToGrid}}", "{{M_GridSettings}}", "", "{{M_TileMapEditingMode}}", "", "{{M_ReplacementOfTiles}}", "{{M_ProlongTiles}}" ] )
		
		Local BarHeight:Int = ClientHeight( Window ) - PanelHeight
		MainCanvas = CreateCanvas( 0, 0, ClientWidth( Window ) - BarWidth - 16, ClientHeight( Window ) - 16, Window )
		SetGadgetLayout( MainCanvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		Panel = CreatePanel( ClientWidth( Window ) - BarWidth, 0, BarWidth, PanelHeight - 2, Window, Panel_Raised )
		SetGadgetLayout( Panel, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Centered )
		TilesetCanvas = CreateCanvas( ClientWidth( Window ) - BarWidth, 0, BarWidth, 0.5 * ClientHeight( Window ), Window )
		SetGadgetLayout( TilesetCanvas, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		ProjectManager = CreateTreeView( ClientWidth( Window ) - BarWidth, PanelHeight, BarWidth, BarHeight - ListBoxHeight, Window )
		SetGadgetLayout( ProjectManager, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		ParametersListBox = CreateListBox( ClientWidth( Window ) - BarWidth, ClientHeight( Window ) - ListBoxHeight, BarWidth, ListBoxHeight, Window )
		SetGadgetLayout( ParametersListBox, Edge_Centered, Edge_Aligned, Edge_Centered, Edge_Aligned )
		TreeViewIcons = LoadIconStrip( "incbin::treeview.png" )
		SetGadgetIconStrip( ProjectManager, TreeViewIcons )
		
		HScroller = CreateSlider( 0, ClientHeight( Window ) - 16, ClientWidth( Window ) - BarWidth - 16, 16, Window, Slider_Scrollbar | Slider_Horizontal )
		SetGadgetLayout( HScroller, Edge_Aligned, Edge_Aligned, Edge_Centered, Edge_Aligned )
		VScroller = CreateSlider( ClientWidth( Window ) - BarWidth - 16, 0, 16, ClientHeight( Window ) - 16, Window, Slider_Scrollbar | Slider_Vertical )
		SetGadgetLayout( VScroller, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		
		
		Local PanelForm:LTForm = LTForm.Create( Panel, 2, 2, 2 )
		PanelForm.NewLine( LTAlign.Stretch )
		ShapeBox = PanelForm.AddComboBox( "{{L_Shape}}", LabelWidth )
		PanelForm.NewLine()
		XField = PanelForm.AddTextField( "{{L_X}}", LabelWidth )
		YField = PanelForm.AddTextField( "{{L_Y}}", LabelWidth )
		PanelForm.NewLine()
		WidthField = PanelForm.AddTextField( "{{L_Width}}", LabelWidth )
		HeightField = PanelForm.AddTextField( "{{L_Height}}", LabelWidth )
		PanelForm.NewLine()
		VelocityField = PanelForm.AddTextField( "{{L_Velocity}}", LabelWidth )
		SelectImageButton = PanelForm.AddButton( "{{B_SelectImage}}", LabelWidth + 56 )
		PanelForm.NewLine( LTAlign.Stretch )
		PanelForm.AddSliderWithTextField( FrameSlider, FrameField, "{{L_Frame}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )
		PanelForm.AddSliderWithTextField( AngleSlider, AngleField, "{{L_Angle}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )
		PanelForm.AddSliderWithTextField( DisplayingAngleSlider, DisplayingAngleField, "{{L_DisplayingAngle}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )
		PanelForm.AddSliderWithTextField( LayerSlider, LayerField, "{{L_CollLayer}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )
		PanelForm.AddSliderWithTextField( RedSlider, RedField, "{{L_Red}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )		
		PanelForm.AddSliderWithTextField( GreenSlider, GreenField, "{{L_Green}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )		
		PanelForm.AddSliderWithTextField( BlueSlider, BlueField, "{{L_Blue}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )		
		PanelForm.AddSliderWithTextField( AlphaSlider, AlphaField, "{{L_Alpha}}", LabelWidth, 50 )
		PanelForm.NewLine()
		VisDXField = PanelForm.AddTextField( "{{L_VisDX}}", LabelWidth )
		VisDYField = PanelForm.AddTextField( "{{L_VisDY}}", LabelWidth )
		PanelForm.NewLine()
		XScaleField = PanelForm.AddTextField( "{{L_XScale}}", LabelWidth )
		YScaleField = PanelForm.AddTextField( "{{L_YScale}}", LabelWidth )
		PanelForm.NewLine( LTAlign.Stretch )
		RotatingCheckbox = PanelForm.AddButton( "{{CB_Rotation}}", 80, Button_Checkbox )
		ScalingCheckbox = PanelForm.AddButton( "{{CB_Scaling}}", 80, Button_Checkbox )
		PhysicsCheckbox = PanelForm.AddButton( "{{CB_Physics}}", 80, Button_Checkbox )
		PanelForm.Finalize( False, 6, 6 )
		
		SetSliderRange( AngleSlider, 0, 23 )
		SetSliderRange( DisplayingAngleSlider, 0, 23 )
		SetSliderRange( LayerSlider, 0, L_MaxCollisionColor )
		SetSliderRange( RedSlider, 0, 100 )
		SetSliderRange( GreenSlider, 0, 100 )
		SetSliderRange( BlueSlider, 0, 100 )
		SetSliderRange( AlphaSlider, 0, 100 )
		
		HiddenOKButton = CreateButton( "", 0, 0, 0, 0, Panel, Button_OK )
		HideGadget( HiddenOKButton )
				
		World.Camera = LTCamera.Create( GadgetWidth( MainCanvas ), GadgetHeight( MainCanvas ), 32.0 )
		TilesetCamera = LTCamera.Create( GadgetWidth( TilesetCanvas ), GadgetHeight( TilesetCanvas ), 16.0 )
		Pan = TPan.Create( L_CurrentCamera )
		
		
		FileMenu = CreateMenu( "{{M_File}}", 0, WindowMenu( Window ) )
		
		Local EditMenu:TGadget = CreateMenu( "{{M_Edit}}", 0, WindowMenu( Window ) )
		LTMenuSwitch.Create( "{{M_SnapToGrid}}", Toolbar, MenuSnapToGrid, EditMenu )
		CreateMenu( "{{M_GridSettings}}", MenuGridSettings, EditMenu )
		CreateMenu( "", 0, EditMenu )
		LTMenuSwitch.Create( "{{M_TileMapEditingMode}}", Toolbar, MenuTileMapEditingMode, EditMenu, False )
		CreateMenu( "", 0, EditMenu )
		LTMenuSwitch.Create( "{{M_ReplacementOfTiles}}", Toolbar, MenuReplacementOfTiles, EditMenu )
		LTMenuSwitch.Create( "{{M_ProlongTiles}}", Toolbar, MenuProlongTiles, EditMenu )
		CreateMenu( "", 0, EditMenu )
		CreateMenu( "{{M_BackgroundColor}}", MenuBackgroundColor, EditMenu )
		CreateMenu( "{{M_CameraProperties}}", MenuCameraProperties, EditMenu )
		IncbinMenu = CreateMenu( "{{M_Incbin}}", MenuIncbin, EditMenu )
		
		Local ViewMenu:TGadget = CreateMenu( "{{M_View}}", 0, WindowMenu( Window ) )
		LTMenuSwitch.Create( "{{M_ShowCollisions}}", Toolbar, MenuShowCollisionShapes, ViewMenu )
		LTMenuSwitch.Create( "{{M_ShowVectors}}", Toolbar, MenuShowVectors, ViewMenu )
		LTMenuSwitch.Create( "{{M_ShowNames}}", Toolbar, MenuShowNames, ViewMenu )
		CreateMenu( "", 0, ViewMenu )
		LTMenuSwitch.Create( "{{M_ShowGrid}}", Toolbar, MenuShowGrid, ViewMenu )
		CreateMenu( "", 0, ViewMenu )
		LTMenuSwitch.Create( "{{M_BilinearFiltering}}", Null, MenuBilinearFiltering, ViewMenu )
		
		Local LanguageMenu:TGadget = CreateMenu( "{{M_Language}}", 0, WindowMenu( Window ) )
		English = CreateMenu( "{{M_English}}", MenuEnglish, LanguageMenu )
		Russian = CreateMenu( "{{M_Russian}}", MenuRussian, LanguageMenu )
		
		Local HelpMenu:TGadget = CreateMenu( "{{M_Help}}", 0, WindowMenu( Window ) )
		CreateMenu( "{{M_HotKeys}}", MenuHotKeys, HelpMenu )
		CreateMenu( "{{M_About}}", MenuAbout, HelpMenu )
		
		LayerMenu = CreateMenu( "", 0, null )
		CreateMenu( "{{M_SelectViewLayer}}", MenuSelectViewLayer, LayerMenu )
		CreateMenu( "{{M_SelectContainer}}", MenuSelectContainer, LayerMenu )
		CreateMenu( "", 0, LayerMenu )
		CreateMenu( "{{M_AddLayer}}", MenuAddLayer, LayerMenu )
		CreateMenu( "{{M_AddTilemap}}", MenuAddTilemap, LayerMenu )
		CreateMenu( "{{M_AddSpriteMap}}", MenuAddSpriteMap, LayerMenu )
		
		Local ImportMenu:TGadget = CreateMenu( "{{M_Import}}", 0, LayerMenu )
		CreateMenu( "{{M_ImportTilemap}}", MenuImportTilemap, ImportMenu )
		CreateMenu( "{{M_ImportTilemaps}}", MenuImportTilemaps, ImportMenu )
		
		CreateMenu( "", 0, LayerMenu )
		CreateMenu( "{{M_EditBounds}}", MenuEditBounds, LayerMenu )
		CreateMenu( "{{M_RemoveBounds}}", MenuRemoveBounds, LayerMenu )
		MixContent = CreateMenu( "{{M_MixContent}}", MenuMixContent, LayerMenu )
		CreateMenu( "{{M_StartSimulation}}", MenuStartSimulation, LayerMenu )
		CreateMenu( "", 0, LayerMenu )
		AddCommonMenuItems( LayerMenu )
		CreateMenu( "{{M_Paste}}", MenuPaste, LayerMenu )
		
		TilemapMenu = CreateMenu( "", 0, null )
		CreateMenu( "{{M_EditTilemap}}", MenuEditTilemap, TilemapMenu )
		CreateMenu( "{{M_SelectTilemap}}", MenuSelectTileMap, TilemapMenu )
		CreateMenu( "", 0, TilemapMenu )
		CreateMenu( "{{M_SelectTileset}}", MenuSelectTileset, TilemapMenu )
		CreateMenu( "{{M_ResizeTilemap}}", MenuResizeTilemap, TilemapMenu )
		CreateMenu( "{{M_TilemapProperties}}", MenuTilemapProperties, TilemapMenu )
		CreateMenu( "", 0, TilemapMenu )
		CreateMenu( "{{M_EditTileCollisionShapes}}", MenuEditTileCollisionShapes, TilemapMenu )
		CreateMenu( "{{M_SetBounds}}", MenuSetBounds, TilemapMenu )
		CreateMenu( "", 0, TilemapMenu )
		CreateMenu( "{{M_EditTileReplacementRules}}", MenuEditReplacementRules, TilemapMenu )
		CreateMenu( "{{M_Enframe}}", MenuEnframe, TilemapMenu )
		
		Local GenerateRulesMenu:TGadget = CreateMenu( "{{M_GenerateRules}}", MenuEnframe, TilemapMenu )
		CreateMenu( "{{M_Areas}}", MenuGenerateRulesAreas, GenerateRulesMenu )
		CreateMenu( "{{M_Walls}}", MenuGenerateRulesWalls, GenerateRulesMenu )
		
		CreateMenu( "", 0, TilemapMenu )
		AddCommonMenuItems( TilemapMenu )
		
		SpriteMapMenu = CreateMenu( "", 0, null )
		CreateMenu( "{{M_SelectContainer}}", MenuSelectContainer, SpriteMapMenu )
		CreateMenu( "{{M_SpriteMapProperties}}", MenuSpriteMapProperties, SpriteMapMenu )
		AddCommonMenuItems( SpriteMapMenu )
		
		SpriteMenu = CreateMenu( "", 0, null )
		AddCommonMenuItems( SpriteMenu )
		CreateMenu( "", 0, SpriteMenu )
		CreateMenu( "{{M_SetBounds}}", MenuSetBounds, SpriteMenu )
		
		MapSpriteMenu = CreateMenu( "", 0, null )
		AddCommonMenuItems( MapSpriteMenu, False )
		
		ParameterMenu = CreateMenu( "", 0, null )
		CreateMenu( "{{M_ModifyParameter}}", MenuModifyParameter, ParameterMenu )
		CreateMenu( "{{M_RemoveParameter}}", MenuRemoveParameter, ParameterMenu )
	
		L_EditorData = New LTEditorData
		
		SelectedTile.Visualizer = New LTMarchingAnts
		
		EditorPath = CurrentDir()
		CurrentViewLayer = AddLayer( "LTLayer" )
		CurrentContainer = CurrentViewLayer
		World.Camera = LTCamera.Create( GadgetWidth( TilesetCanvas ), GadgetHeight( TilesetCanvas ), 16.0 )
		RefreshProjectManager()
				
		SetLanguage( EnglishNum )
		L_DebugVisualizer.ShowCollisionShapes = LTMenuSwitch.Find( MenuShowCollisionShapes ).Toggle()
		L_DebugVisualizer.ShowVectors = LTMenuSwitch.Find( MenuShowVectors ).Toggle()
		L_DebugVisualizer.ShowNames = LTMenuSwitch.Find( MenuShowNames ).Toggle()
		SnapToGrid = LTMenuSwitch.Find( MenuSnapToGrid ).Toggle()
		ShowGrid = LTMenuSwitch.Find( MenuShowGrid ).Toggle()
		ReplacementOfTiles = LTMenuSwitch.Find( MenuReplacementOfTiles ).Toggle()
		ToggleBilinearFiltering()
		
		If AppArgs.Length > 1 Then OpenWorld( AppArgs[ 1 ] )
		
		If FileType( "editor.ini" ) = 1 Then
			Local IniFile:TStream = ReadFile( "editor.ini" )
			If ReadLine( IniFile ).ToInt() = INIVersion Then
				If AppArgs.Length = 1 Then
					OpenWorld( L_ASCIILineToUTF8( ReadLine( IniFile ) ) )
				Else
					ReadLine( IniFile )
				End If 
				
				LTMenuSwitch.ReadSwitches( IniFile )
				L_DebugVisualizer.ShowCollisionShapes = LTMenuSwitch.Find( MenuShowCollisionShapes ).State()
				L_DebugVisualizer.ShowVectors = LTMenuSwitch.Find( MenuShowVectors ).State()
				L_DebugVisualizer.ShowNames = LTMenuSwitch.Find( MenuShowNames ).State()
				SnapToGrid = LTMenuSwitch.Find( MenuSnapToGrid ).State()
				ShowGrid = LTMenuSwitch.Find( MenuShowGrid ).State()
				L_ProlongTiles = LTMenuSwitch.Find( MenuProlongTiles ).State()
				ReplacementOfTiles = LTMenuSwitch.Find( MenuReplacementOfTiles ).State()
				BilinearFiltering = LTMenuSwitch.Find( MenuBilinearFiltering ).State()
				TileCollisionShapes.GridActive = ReadLine( IniFile ).ToInt()
				
				SetLanguage( ReadLine( IniFile ).ToInt() )
				
				For Local N:Int = 0 Until RecentFilesQuantity
					RecentFiles[ N ] = L_ASCIILineToUTF8( ReadLine( IniFile ) )
				Next
			End If
			
			CloseFile( IniFile )
		End If

		MainCamera = World.Camera
		L_CurrentCamera = MainCamera
		FillFileMenu()
		
		SetGraphics( CanvasGraphics( MainCanvas ) )
		SetImageFont( LoadImageFont( "incbin::font.ttf", 16 ) )
		
		LTShape.CloneParameters = True
	End Method
	
	
	
	Method SetLanguage( Num:Int )
		Select Num
			Case EnglishNum
				CurrentLanguage = EnglishLanguage
				CheckMenu( English )
				UnCheckMenu( Russian )
			Case RussianNum
				CurrentLanguage = RussianLanguage
				CheckMenu( Russian )
				UnCheckMenu( English )
		End Select
		SetLocalizationLanguage( CurrentLanguage )
		UpdateWindowMenu( Window )
		SetTitle()
	End Method
	
	
	
	Method AddCommonMenuItems( Menu:TGadget, Shift:Int = True )
		CreateMenu( "{{M_Rename}}", MenuRename, Menu )
		CreateMenu( "{{M_SetClass}}", MenuSetClass, Menu )
		CreateMenu( "", 0, Menu )
		CreateMenu( "{{M_ToggleVisibility}}", MenuToggleVisibility, Menu )
		CreateMenu( "{{M_ToggleActivity}}", MenuToggleActivity, Menu )
		If Shift Then
			CreateMenu( "", 0, Menu )
			CreateMenu( "{{M_ShiftToTheTop}}", MenuShiftToTheTop, Menu )
			CreateMenu( "{{M_ShiftUp}}", MenuShiftUp, Menu )
			CreateMenu( "{{M_ShiftDown}}", MenuShiftDown, Menu )
			CreateMenu( "{{M_ShiftToTheBottom}}", MenuShiftToTheBottom, Menu )
		End If
		CreateMenu( "", 0, Menu )
		CreateMenu( "{{M_Duplicate}}", MenuDuplicate, Menu )
		CreateMenu( "{{M_Remove}}", MenuRemove, Menu )
		CreateMenu( "", 0, Menu )
		CreateMenu( "{{M_Cut}}", MenuCut, Menu )
		CreateMenu( "{{M_Copy}}", MenuCopy, Menu )
	End Method
	

	
	Method SetTitle()
		Local Line:String = LocalizeString( "{{Title}}" ) + Version
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
			Local Choice:Int = Proceed( LocalizeString( "{{D_UnsavedWorld}}" ) )
			If Choice = -1 Then Return False
			If Choice = 1 Then Return SaveWorld()
		End If
		Return True
	End Method
	
	
	
	Method NewWorld()
		If Not AskForSaving() Then Return
		
		WorldFilename = ""
		World = New LTWorld
		World.Camera = LTCamera.Create( GadgetWidth( TilesetCanvas ), GadgetHeight( TilesetCanvas ), 16.0 )
		CurrentShape = Null
		CurrentTileMap = Null
		L_EditorData.Images.Clear()
		L_EditorData.Tilesets.Clear()
		SelectedShapes.Clear()
		RealPathsForImages.Clear()
		BigImages.Clear()
		InitParameterNames()
		CurrentViewLayer = AddLayer( "LTLayer" )
		CurrentContainer = CurrentViewLayer
		RefreshProjectManager()
		
		WorldFilename = "untitled.lw"
		Changed = False
		SetTitle()
	End Method
	
	
	
	Method OpenWorld( Filename:String )
		If FileType( Filename ) = 0 Then Return
		
		If Not AskForSaving() Then Return
		
		If Filename Then 
			L_EditorData.Images.Clear()
			L_EditorData.Tilesets.Clear()
			
			WorldFilename = Filename
			InsertToRecentFiles( Filename )
			ChangeDir( ExtractDir( Filename ) )
			
			LoadingWindow = CreateWindow( "", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
			Local Form:LTForm = LTForm.Create( LoadingWindow )
			Form.NewLine()
			ProgressBar = Form.AddProgressBar( 200 )
			Form.Finalize()
			
			L_MaxID = 0
			Local XMLObject:LTXMLObject = LTXMLObject.ReadFromFile( FileName )
			UpdateXML( XMLObject )
			
			World = LTWorld( LoadFromFile( Filename, , XMLObject ) )
			If Not World.Camera Then World.Camera = LTCamera.Create( GadgetWidth( TilesetCanvas ), GadgetHeight( TilesetCanvas ), 16.0 )
			MainCamera = World.Camera
			MainCamera.Update()
			L_CurrentCamera = MainCamera
			MainCanvasZ = L_Round( Log( 32.0 / MainCamera.Width ) / Log( 1.1 ) )
			
			CurrentShape = Null
			CurrentTilemap = Null
			CurrentViewLayer = Null
			SelectedShapes.Clear()
			Modifiers.Clear()
			If Not World.Children.IsEmpty() Then CurrentViewLayer = LTLayer( World.Children.First() )
			CurrentContainer = CurrentViewLayer
			
			InitParameterNames()
			AddParameterNames( World )
			
			UpdateImages()
			
			SetIncbin()
			Changed = False
			
			SetTitle()
			RefreshProjectManager()
			
			FreeGadget( LoadingWindow )
		End If
	End Method

	
	
	Method InitWorld()
	End Method
	
	
	
	Method SaveWorld:Int( SaveAs:Int = False )
		Local Filename:String = WorldFilename
		If SaveAs Or Not Filename Then Filename = RequestFile( LocalizeString( "{{D_SelectFileNameToSave}}" ), "DWLab world file:lw", True )
		If Filename Then 
			WorldFilename = Filename
			InsertToRecentFiles( Filename )
			ChangeDir( ExtractDir( Filename ) )
			
			For Local Image:LTImage = Eachin L_EditorData.Images
				Image.Filename = L_ChopFilename( String( RealPathsForImages.ValueForKey( Image ) ) )
			Next
			
			World.SaveToFile( Filename )
			Changed = False
			SetTitle()
			
			If L_EditorData.IncbinValue Then
				Local File:TStream = WriteFile( StripAll( FileName ) + "_incbin.bmx" )
				WriteLine( File, "Incbin ~q" + StripDir( FileName ) + "~q" )
				For Local Image:LTImage = Eachin L_EditorData.Images
					WriteLine( File, "Incbin ~q" + Image.Filename + "~q" )
				Next
				WriteLine( File, "L_SetIncbin( True )" )
			End If
			
			Return True
		End If
	End Method
	
	
	
	Method MergeWithWorld( Filename:String )
		If Not Filename Then Return
		
		Local OldDir:String = CurrentDir()
		ChangeDir( ExtractDir( Filename ) )
		
		Local OldEditorData:LTEditorData = L_EditorData
		Local NewWorld:LTWorld = LTWorld.FromFile( Filename )
		
		ChangeDir( OldDir )
		
		For Local TileSet:LTTileSet = Eachin L_EditorData.Tilesets
			OldEditorData.Tilesets.AddLast( TileSet )
		Next
		
		L_EditorData = OldEditorData
		
		For Local Layer:LTLayer = Eachin NewWorld
			World.AddLast( Layer )
		Next
		
		AddParameterNames( NewWorld )
		
		UpdateImages()
		
		RefreshProjectManager()
	End Method
	
	
	
	Method ExitEditor()
		If Not AskForSaving() Then Return
	
		Local IniFile:TStream = WriteFile( EditorPath + "\editor.ini" )
		
		WriteLine( IniFile, INIVersion )
		WriteLine( IniFile, L_UTF8LineToASCII( WorldFilename ) )
		LTMenuSwitch.SaveSwicthes( IniFile )
		WriteLine( IniFile, TileCollisionShapes.GridActive )
		
		Select CurrentLanguage
			Case EnglishLanguage
				WriteLine( IniFile, EnglishNum )
			Case RussianLanguage
				WriteLine( IniFile, RussianNum )
		End Select
		
		For Local N:Int = 0 Until RecentFilesQuantity
			WriteLine( IniFile, L_UTF8LineToASCII( RecentFiles[ N ] ) )
		Next
		
		CloseFile( IniFile )
		
		End
	End Method
	
	
	
	Method OnEvent()
		If ActiveGadget() <> Panel Then CurrentTextField = ActiveGadget()
		
		Local EvID:Int = EventID()
		Local EvData:Int = EventData()
		
		Select EvID
			Case Event_GadgetSelect
				If EventSource() = ProjectManager And EventExtra() Then
					ShapeForParameters = LTShape( GadgetExtra( TGadget( EventExtra() ) ) )
					RefreshParametersListBox( False )
				End If
			Case Event_GadgetAction
				Select EventSource()
					Case Toolbar
						EvID = Event_MenuAction
					Case ProjectManager
						If Not EventExtra() Then
							SelectedShape = Null
						Else
							SelectedShape = LTShape( GadgetExtra( TGadget( EventExtra() ) ) )
						End If
						
						If SelectedShape Then
							If LTLayer( SelectedShape ) Then
								CurrentViewLayer = LTLayer( SelectedShape )
								CurrentContainer = SelectedShape
								RefreshProjectManager()
							ElseIf LTTileMap( SelectedShape ) Then
								EvData = MenuEditTilemap
								EvID = Event_MenuAction
							ElseIf LTSpriteMap( SelectedShape ) Then
								EvData = MenuSelectContainer
								EvID = Event_MenuAction
							Else
								EditTilemap( Null )
								SelectShape( SelectedShape )
							End If
						Else
							Local Name:String
							If EnterString( "{{D_EnterNameOfLayer}}", Name ) Then
								AddLayer( Name )
								RefreshProjectManager()
							End If
						End If
					Case ParametersListBox
						SelectedParameter = LTParameter( EventExtra() )
						If SelectedParameter Then
							ParameterProperties.Execute()
						Else
							SelectedParameter = New LTParameter
							ParameterProperties.Execute()
							If ParameterProperties.Succesful Then
								ShapeForParameters.AddParameter( SelectedParameter.Name, SelectedParameter.Value )
							End If
						End If
						If ParameterProperties.Succesful Then RefreshParametersListBox()
				End Select
			Case Event_MenuAction
				Select EventData()
					Case MenuShiftToTheTop
						EvID = Event_KeyDown
						EvData = Key_Home
						SelectShape( SelectedShape, True )
					Case MenuShiftUp
						EvID = Event_KeyDown
						EvData = Key_PageUp
						SelectShape( SelectedShape, True )
					Case MenuShiftDown
						EvID = Event_KeyDown
						EvData = Key_PageDown
						SelectShape( SelectedShape, True )
					Case MenuShiftToTheBottom
						EvID = Event_KeyDown
						EvData = Key_End
						SelectShape( SelectedShape, True )
					Case MenuDuplicate
						EvID = Event_KeyDown
						EvData = Key_D
						SelectShape( SelectedShape, True )
				End Select
		End Select
		
		Select EvID
			Case Event_KeyDown
				Select EvData
					Case Key_Delete, Key_X
						If ( KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Or EvData = Key_Delete ) And Not SelectedShapes.IsEmpty() Then
							if EvData = Key_X Then Buffer = SelectedShapes.Copy()
							For Local Obj:LTShape = Eachin SelectedShapes
								World.Remove( Obj )
							Next
							SetChanged()
							SelectedShapes.Clear()
							Modifiers.Clear()
							RefreshProjectManager()
						End If
					Case Key_PageUp, Key_End
						If Not SelectedShapes.IsEmpty() Then
							Local Link:TLink = SelectedShapes.FirstLink()
							ShiftPageUpEnd( World, Link, EvData )
							If LTLayer( SelectedShapes.First() ) Then SelectedShapes.Clear()
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_PageDown, Key_Home
						If Not SelectedShapes.IsEmpty() Then
							Local Link:TLink = SelectedShapes.LastLink()
							ShiftPageDownHome( World, Link, EvData )
							If LTLayer( SelectedShapes.First() ) Then SelectedShapes.Clear()
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_NumAdd
						MainCanvasZ :+ 1
					Case Key_NumSubtract
						MainCanvasZ :- 1
					Case Key_V
						If KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then
							If Not Buffer.IsEmpty() Then
								For Local Shape:LTShape = Eachin Buffer
									InsertIntoContainer( Shape.Clone(), Editor.CurrentContainer )
								Next
								RefreshProjectManager()
								SetChanged()
							End If
						ElseIf Not SelectedShapes.IsEmpty() Then
							For Local Shape:LTShape = Eachin SelectedShapes
								Shape.Visible = Not Shape.Visible
							Next
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_A
						If Not SelectedShapes.IsEmpty() Then
							For Local Shape:LTShape = Eachin SelectedShapes
								Shape.Active = Not Shape.Active
							Next
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_C
						If KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) And Not SelectedShapes.IsEmpty() Then
							Buffer = SelectedShapes.Copy()
							SetChanged()
						End If
					Case Key_H
						For Local Sprite:LTSprite = Eachin SelectedShapes
							If Sprite.Visualizer.Image Then
								Local NewHeight:Double = Sprite.Width * Sprite.Visualizer.Image.Height() / Sprite.Visualizer.Image.Width()
								Sprite.SetCoords( Sprite.X, Sprite.Y + 0.5 * ( Sprite.Height - NewHeight ) )
								Sprite.SetSize( Sprite.Width, NewHeight )
							End If
						Next
						SetChanged()
					Case Key_D
						If Not SelectedShapes.IsEmpty() Then
							Local Layer:LTLayer = LTLayer( SelectedShapes.First() )
							If Layer Then
								PutAfterLayer( LTLayer( Layer.Clone() ), Layer, World )
							Else
								For Local Shape:LTShape = Eachin SelectedShapes
									InsertIntoContainer( Shape.Clone(), Editor.CurrentContainer )
								Next
							End If
							RefreshProjectManager()
							SetChanged()
						End If
					Case Key_T
						If Not SelectedShapes.IsEmpty() Then
							Local Name:String = SelectedShape.GetName()
							If EnterString( LocalizeString( "{{D_EnterClassNameOfObject}}" ), Name ) Then
								For Local Shape:LTShape = Eachin SelectedShapes
									Shape.SetParameter( "class", Name )
								Next
								RefreshParametersListBox()
								SetChanged()
							End If
						End If
					Case Key_N
						If Not SelectedShapes.IsEmpty() Then
							Local Name:String = SelectedShape.GetName()
							If EnterString( LocalizeString( "{{D_EnterNameOfObject}}" ), Name ) Then
								For Local Shape:LTShape = Eachin SelectedShapes
									Shape.SetParameter( "name", Name )
								Next
								RefreshParametersListBox()
								SetChanged()
							End If
						End If
					Case Key_P
						If Not SelectedShapes.IsEmpty() Then
							SelectedParameter = New LTParameter
							ParameterProperties.Execute()
							If ParameterProperties.Succesful Then
								For Local Shape:LTShape = Eachin SelectedShapes
									Shape.AddParameter( SelectedParameter.Name, SelectedParameter.Value )
								Next
								RefreshParametersListBox()
								SetChanged()
							End If
						End If
					Case Key_S
						If Not SelectedShapes.IsEmpty() Then
							Grid.SnapPosition( Cursor.X, Cursor.Y, 0, 0, 0, 0 )
							For Local Sprite:LTSprite = Eachin SelectedShapes
								Sprite.DirectTo( Cursor )
							Next
							SetChanged()
						End If
					Case Key_F
						If Not SelectedShapes.IsEmpty() Then
							For Local Sprite:LTSprite = Eachin SelectedShapes
								Sprite.SetFacing( -Sprite.GetFacing() )
							Next
							SetChanged()
						End If
					Case Key_G
						If Not SelectedShapes.IsEmpty() Then
							Local Group:LTSpriteGroup = Null
							Local LeftX:Double, TopY:Double, RightX:Double, BottomY:Double
							Local FirstSprite:LTSprite
							For Local Sprite:LTSprite = Eachin SelectedShapes
								If Group Then
									LeftX = Min( LeftX, Sprite.LeftX() )
									TopY = Min( TopY, Sprite.TopY() )
									RightX = Max( RightX, Sprite.RightX() )
									BottomY = Max( BottomY, Sprite.BottomY() )
								Else
									Group = New LTSpriteGroup
									LeftX = Sprite.LeftX()
									TopY = Sprite.TopY()
									RightX = Sprite.RightX()
									BottomY = Sprite.BottomY()
									FirstSprite = Sprite
								End If
							Next
							If Group Then
								Group.X = 0.5 * ( LeftX + RightX )
								Group.Y = 0.5 * ( TopY + BottomY )
								Group.Width = RightX - LeftX
								Group.Height = BottomY - TopY
								World.InsertBeforeShape( Group, , FirstSprite )
								
								For Local Sprite:LTSprite = Eachin SelectedShapes
									World.Remove( Sprite )
									Group.InsertSprite( Sprite )
								Next
								
								RefreshProjectManager()
								SetChanged()
							End If
						End If
					Case Key_U
						If Not SelectedShapes.IsEmpty() Then
							For Local Group:LTSpriteGroup = Eachin SelectedShapes
								World.InsertBeforeShape( , Group.Children, Group )
								For Local Sprite:LTSprite = Eachin Group.Children
									Group.RemoveSprite( Sprite )
								Next
								World.Remove( Group )
								RefreshProjectManager()
								SetChanged()
							Next
						End If
					Case KEY_R
						Local TileSetName:String, TileNum1:String, TileNum2:String
						If EnterString( "Enter tileset name to process", TileSetName ) Then
							If EnterString( "Enter tile value to process", TileNum1 ) Then
								If EnterString( "Enter tile value to replace to", TileNum2 ) Then
									ReplaceTiles( World, TileSetName, TileNum1.ToInt(), TileNum2.ToInt() )
								End If
							End If
						End If
				End Select
			Case Event_MouseWheel
				If Not Modifiers.IsEmpty() Then SetShapeModifiers( LTShape( SelectedShapes.First() ) )
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
						Pan.Camera = MainCamera
					Case TilesetCanvas
						ActivateGadget( TilesetCanvas )
						DisablePolledInput()
						EnablePolledInput( TilesetCanvas )
						MouseIsOver = TilesetCanvas
						Pan.Camera = TilesetCamera
				End Select
			Case Event_MenuAction
				If EvData >= MenuRecentFile Then OpenWorld( RecentFiles[ EvData - MenuRecentFile ] )
				Select EvData
					Case MenuRename
						Local Name:String = SelectedShape.GetName()
						If EnterString( LocalizeString( "{{D_EnterNameOfObject}}" ), Name ) Then
							SelectedShape.SetParameter( "name", Name )
							RefreshParametersListBox()
							SetChanged()
						End If
					Case MenuSetClass
						Local Class:String = SelectedShape.GetParameter( "class" )
						If EnterString( LocalizeString( "{{D_EnterClassNameOfObject}}" ), Class ) Then
							SelectedShape.SetParameter( "class", Class )
							RefreshParametersListBox()
							SetChanged()
						End If
					Case MenuRemove, MenuCut
						If EvData = MenuCut Then
							Buffer.Clear()
							Buffer.AddLast( SelectedShape )
						End If
						World.Remove( SelectedShape )
						If SelectedShape = CurrentViewLayer Then CurrentViewLayer = Null
						If SelectedShape = CurrentTilemap Then EditTilemap( Null )
						If SelectedShape = CurrentContainer Then CurrentContainer = Null
						SetChanged()
						RefreshProjectManager()
					Case MenuCopy
						Buffer.Clear()
						Buffer.AddLast( SelectedShape )
					Case MenuToggleVisibility
						SelectedShape.Visible = Not SelectedShape.Visible
						SetChanged()
						RefreshProjectManager()
					Case MenuToggleActivity
						SelectedShape.Active = Not SelectedShape.Active
						SetChanged()
						RefreshProjectManager()
				
					' ============================= Main menu ==================================
					
					Case MenuNew
						NewWorld()
					Case MenuOpen
						OpenWorld( RequestFile( LocalizeString( "{{D_SelectFileNameToOpen}}" ), "DWLab world file:lw", False, ..
								ExtractDir( WorldFileName ) + "\" ) )
					Case MenuSave
						SaveWorld()
					Case MenuSaveAs
						SaveWorld( True )
					Case MenuMerge
						MergeWithWorld( RequestFile( LocalizeString( "{{D_SelectFileNameToMerge}}" ), "DWLab world file:lw" ) )
					Case MenuExit
						ExitEditor()
						
					Case MenuSnapToGrid
						SnapToGrid = LTMenuSwitch.Find( MenuSnapToGrid ).Toggle()
					Case MenuGridSettings
						Grid.Settings()
					Case MenuTileMapEditingMode
						EditTileMap( Null )
					Case MenuReplacementOfTiles
						ReplacementOfTiles = LTMenuSwitch.Find( MenuReplacementOfTiles ).Toggle()
					Case MenuProlongTiles
						L_ProlongTiles = LTMenuSwitch.Find( MenuProlongTiles ).Toggle()
					Case MenuBackgroundColor
						If SelectColor( L_EditorData.BackgroundColor, False ) Then SetChanged()
					Case MenuCameraProperties
						CameraProperties.Execute()
					Case MenuIncbin
						L_EditorData.IncbinValue = Not L_EditorData.IncbinValue
						SetIncbin()
						
					Case MenuShowCollisionShapes
						L_DebugVisualizer.ShowCollisionShapes = LTMenuSwitch.Find( MenuShowCollisionShapes ).Toggle()
					Case MenuShowVectors
						L_DebugVisualizer.ShowVectors = LTMenuSwitch.Find( MenuShowVectors ).Toggle()
					Case MenuShowNames
						L_DebugVisualizer.ShowNames = LTMenuSwitch.Find( MenuShowNames ).Toggle()
					Case MenuShowGrid
						ShowGrid = LTMenuSwitch.Find( MenuShowGrid ).Toggle()
					Case MenuBilinearFiltering
						ToggleBilinearFiltering()
						For Local Image:LTImage = Eachin L_EditorData.Images
							Image.Init()
						Next
						
					Case MenuEnglish
						SetLanguage( EnglishNum )
					Case MenuRussian
						SetLanguage( RussianNum )
					Case MenuHotKeys
						Notify( LocalizeString( "{{H_HotKeys}}" ).Replace( "|", "~r" ) )
					Case MenuAbout
						Notify( LocalizeString( "{{H_About1}}" + Version + "{{H_About2}}" ).Replace( "|", "~r" ) )
						
					' ============================= Layer menu ==================================
					
					Case MenuSelectViewLayer
						CurrentViewLayer = LTLayer( SelectedShape )
						RefreshProjectManager()
					Case MenuSelectContainer
						CurrentContainer = SelectedShape
						RefreshProjectManager()
					Case MenuAddLayer
						Local LayerName:String = ""
						If EnterString( "{{D_EnterNameOfLayer}}", LayerName ) Then
							CurrentViewLayer = New LTLayer
							CurrentViewLayer.SetParameter( "name", LayerName )
							LTLayer( SelectedShape ).AddLast( CurrentViewLayer )
							SetChanged()
							RefreshProjectManager()
						End If
					Case MenuAddTilemap
						Local Name:String = ""
						If EnterString( "{{D_EnterNameOfTilemap}}", Name ) Then
							Local XQuantity:Int = 16
							Local YQuantity:Int = 16
							If ChooseParameter( XQuantity, YQuantity, "{{W_ChooseTilemapSize}}", "{{L_WidthInTiles}}", "{{L_HeightInTiles}}" ) Then
								Local Tilemap:LTTileMap = LTTilemap.Create( Null, XQuantity, YQuantity )
								Tilemap.SetParameter( "name", Name )
								If SelectImageOrTileset( Tilemap ) Then
									Local Layer:LTLayer = LTLayer( SelectedShape )
									InitTileMap( Tilemap )
									If Layer.Children.IsEmpty() And Not Layer.Bounds Then Layer.SetBounds( Tilemap )
									Layer.AddLast( Tilemap )
									SetChanged()
									EditTileMap( Tilemap )
								End If
							End If
						End If
					Case MenuImportTilemap
						Local TileMap:LTTileMap = TileMapImportDialog()
						If Tilemap Then
							Local Layer:LTLayer = LTLayer( SelectedShape )
							If Layer.Children.IsEmpty() And Not Layer.Bounds Then Layer.SetBounds( Tilemap )
							Layer.AddLast( Tilemap )
							EditTileMap( Tilemap )
						End If
					Case MenuImportTilemaps
						Local TileMap:LTTileMap = TileMapImportDialog( True ) 
						If TileMap Then EditTileMap( Tilemap )
					Case MenuAddSpriteMap
						Local Name:String = ""
						If EnterString( "{{D_EnterNameOfSpriteMap}}", Name ) Then
							Local TextCellSize:String = "2"
							If EnterString( "{{D_EnterCellSize}}", TextCellSize ) Then
								Local CellSize:Double = TextCellSize.ToDouble()
								If CellSize > 0.0 Then
									Local SpriteMap:LTSpriteMap = New LTSpriteMap
									SpriteMap.SetParameter( "name", Name )
									SpriteMap.CellWidth = CellSize
									SpriteMap.CellHeight = CellSize
									
									Local Bounds:LTShape = LTLayer( SelectedShape ).Bounds
									If Bounds Then
										SpriteMap.SetResolution( L_ToPowerOf2( Bounds.Width / CellSize ), L_ToPowerOf2( Bounds.Height / CellSize ) )
									Else
										SpriteMap.SetResolution( 16, 16 )
									End If
									
									If SpriteMapProperties.Set( SpriteMap ) Then
										LTLayer( SelectedShape ).AddLast( SpriteMap )
										CurrentContainer = SpriteMap
										SetChanged()
										RefreshProjectManager()
									End If
								End If
							End If
						End If
					Case MenuEditBounds
						SwitchTo( LayerBounds )
					Case MenuRemoveBounds
						LTLayer( SelectedShape ).Bounds = Null
						SetChanged()
					Case MenuMixContent
						LTLayer( SelectedShape ).MixContent = Not LTLayer( SelectedShape ).MixContent
						SetChanged()
					Case MenuPaste
						If Not Buffer.IsEmpty() Then
							For Local Shape:LTShape = Eachin Buffer
								InsertIntoContainer( Shape.Clone(), SelectedShape )
							Next
							RefreshProjectManager()
							SetChanged()
						End If
					Case MenuStartSimulation
						If LTLayer( SelectedShape ).Bounds Then
							SwitchTo( Simulator )
						Else
							Notify( LocalizeString( "{{N_SetBounds}}" ) )
						End If


					' ============================= Tilemap menu ==================================
					
					Case MenuEditTilemap
						EditTileMap( LTTileMap( SelectedShape ) )
					Case MenuSelectTileMap
						SelectShape( SelectedShape )
						EditTilemap( Null )
					Case MenuSelectTileset
						SelectImageOrTileset( LTTileMap( SelectedShape ) )
						RefreshTilemap()
					Case MenuResizeTilemap
						ResizeTilemap( LTTileMap( SelectedShape ) )
						RefreshTilemap()
					Case MenuEditTileCollisionShapes
						TileCollisionShapes.TileSet = LTTileMap( SelectedShape ).TileSet
						TileCollisionShapes.Edit()
					Case MenuEditReplacementRules
						TilesetRules.Execute( LTTileMap( SelectedShape ).TileSet )
					Case MenuSetBounds
						CurrentViewLayer.SetBounds( SelectedShape )
						SetChanged()
					Case MenuEnframe
						LTTileMap( SelectedShape ).Enframe()
						SetChanged()
					Case MenuGenerateRulesAreas
						GenerateRules( LTTileMap( SelectedShape ), 1 )
					Case MenuGenerateRulesWalls
						GenerateRules( LTTileMap( SelectedShape ), 2 )
					Case MenuTileMapProperties
						TileMapProperties.TileMap = LTTileMap( SelectedShape )
						TileMapProperties.Execute()

					' ============================= Sprite map menu ==================================
					
					Case MenuSpriteMapProperties
						SpriteMapProperties.Set( LTSpriteMap( SelectedShape ) )
						
					' ============================= Parameter menu ==================================
					
					Case MenuModifyParameter
						ParameterProperties.Execute()
						If ParameterProperties.Succesful Then RefreshParametersListBox()
					Case MenuRemoveParameter
						ShapeForParameters.Parameters.Remove( SelectedParameter )
						RefreshParametersListBox()
				End Select
			Case Event_GadgetAction
				Select EventSource()
					Case SelectImageButton
						If Not SelectedShapes.IsEmpty() Then
							Local FirstSprite:LTSprite = LTSprite( SelectedShapes.First() )
							If FirstSprite Then
								FirstSprite = LTSprite( SelectImageOrTileset( FirstSprite ) )
								If FirstSprite Then
									If FirstSprite.Visualizer.Image Then
										For Local Sprite:LTSprite = Eachin SelectedShapes
											Sprite.Visualizer.Image = FirstSprite.Visualizer.Image
											Sprite.Frame = L_LimitInt( Sprite.Frame, 0, Sprite.Visualizer.Image.FramesQuantity() - 1 )
										Next
										Editor.FillShapeFields()
									End If
								End If
							End If
						End If
					Case HScroller
						If CurrentViewLayer Then
							Local Bounds:LTShape = CurrentViewLayer.Bounds
							If Bounds Then MainCamera.X = Bounds.LeftX() + SliderValue( HScroller ) * Bounds.Width / 10000.0 + 0.5 * MainCamera.Width
						End If
					Case VScroller
						If CurrentViewLayer Then
							Local Bounds:LTShape = CurrentViewLayer.Bounds
							If Bounds Then MainCamera.Y = Bounds.TopY() + SliderValue( VScroller ) * Bounds.Height / 10000.0 + 0.5 * MainCamera.Height
						End If
				End Select
				
				For Local Shape:LTShape = Eachin SelectedShapes
					Local Visualizer:LTVisualizer = Shape.Visualizer
					Select EventSource()
						Case HiddenOKButton
							Select CurrentTextField
								Case XField
									Shape.X = TextFieldText( XField ).ToDouble()
									SetShapeModifiers( Shape )
									SetChanged()
								Case YField
									Shape.Y = TextFieldText( YField ).ToDouble()
									SetShapeModifiers( Shape )
									SetChanged()
								Case WidthField
									Shape.Width = TextFieldText( WidthField ).ToDouble()
									SetShapeModifiers( Shape )
									SetChanged()
								Case HeightField
									Shape.Height = TextFieldText( HeightField ).ToDouble()
									SetShapeModifiers( Shape )
									SetChanged()
								Case RedField
									Visualizer.Red = TextFieldText( RedField ).ToDouble()
									SetSliderValue( RedSlider, 0.01 * Shape.Visualizer.Red )
									SetChanged()
								Case GreenField
									Visualizer.Green = TextFieldText( GreenField ).ToDouble()
									SetSliderValue( GreenSlider, 0.01 * Shape.Visualizer.Green )
									SetChanged()
								Case BlueField
									Visualizer.Blue = TextFieldText( BlueField ).ToDouble()
									SetSliderValue( BlueSlider, 0.01 * Shape.Visualizer.Blue )
									SetChanged()
								Case AlphaField
									Visualizer.Alpha = TextFieldText( AlphaField ).ToDouble()
									SetSliderValue( AlphaSlider, 0.01 * Shape.Visualizer.Alpha )
									SetChanged()
								Case VisDXField
									Visualizer.DX = TextFieldText( VisDXField ).ToDouble()
									SetChanged()
								Case VisDYField
									Visualizer.DY = TextFieldText( VisDYField ).ToDouble()
									SetChanged()
								Case XScaleField
									Visualizer.XScale = TextFieldText( XScaleField ).ToDouble()
									SetChanged()
								Case YScaleField
									Visualizer.YScale = TextFieldText( YScaleField ).ToDouble()
									SetChanged()
							End Select
						Case RedSlider
							Visualizer.Red = 0.01:Double * SliderValue( RedSlider )
							SetGadgetText( RedField, L_TrimDouble( Shape.Visualizer.Red, 4 ) )
							SetChanged()
						Case GreenSlider
							Visualizer.Green = 0.01:Double * SliderValue( GreenSlider )
							SetGadgetText( GreenField, L_TrimDouble( Shape.Visualizer.Green, 4 ) )
							SetChanged()
						Case BlueSlider
							Visualizer.Blue = 0.01:Double * SliderValue( BlueSlider )
							SetGadgetText( BlueField, L_TrimDouble( Shape.Visualizer.Blue, 4 ) )
							SetChanged()
						Case AlphaSlider
							Visualizer.Alpha = 0.01:Double * SliderValue( AlphaSlider )
							SetGadgetText( AlphaField, L_TrimDouble( Shape.Visualizer.Alpha, 4 ) )
							SetChanged()
						Case ScalingCheckbox
							Visualizer.Scaling = ButtonState( ScalingCheckbox )
							SetChanged()
						Case RotatingCheckbox
							Visualizer.Rotating = ButtonState( RotatingCheckbox )
							SetChanged()
						Case PhysicsCheckbox
							Local ToShape:LTShape = Null
							
							If LTSpriteGroup( Shape ) Then
								If Shape.Physics() Then
									ToShape = New LTSpriteGroup
								Else
									ToShape = New LTBox2DSpriteGroup
								End If
								
								For Local Sprite:LTSprite = Eachin LTSpriteGroup( Shape )
									LTSpriteGroup( ToShape ).Children.AddLast( Sprite )
								Next
							Else If LTSprite( Shape ) Then
								If Shape.Physics() Then
									ToShape = New LTSprite
								Else
									ToShape = New LTBox2DSprite
								End If
							Else If LTTileMap( Shape ) Then
								If Shape.Physics() Then
									ToShape = New LTTileMap
								Else
									ToShape = New LTBox2DTileMap
								End If
							End If
							
							If ToShape Then
								Shape.CopyTo( ToShape )
								World.InsertBeforeShape( ToShape, , Shape )
								World.Remove( Shape )
								CurrentShape = ToShape
								SelectedShapes.InsertAfterLink( ToShape, SelectedShapes.FindLink( Shape ) )
								SelectedShapes.Remove( Shape )
								RefreshProjectManager()
								SetChanged()
							End If
					End Select
				Next
				
				For Local Sprite:LTSprite = Eachin SelectedShapes
					Select EventSource()
						Case ShapeBox
							Sprite.ShapeType = SelectedGadgetItem( ShapeBox )
							SetChanged()
						Case HiddenOKButton
							Select CurrentTextField
								Case VelocityField
									Sprite.Velocity = TextFieldText( VelocityField ).ToDouble()
								Case AngleField
									Sprite.Angle = TextFieldText( AngleField ).ToDouble()
									SetSliderValue( AngleSlider, Abs( L_Round( Sprite.Angle / 15.0 ) ) Mod 24 )
									SetChanged()
								Case DisplayingAngleField
									Sprite.DisplayingAngle = TextFieldText( DisplayingAngleField ).ToDouble()
									SetSliderValue( DisplayingAngleSlider, Abs( L_Round( Sprite.DisplayingAngle / 15.0 ) ) Mod 24 )
									SetChanged()
								Case LayerField
									Sprite.CollisionLayer = Abs( TextFieldText( LayerField ).ToInt() )
									SetSliderValue( LayerSlider, Sprite.CollisionLayer & L_MaxCollisionColor )
									SetChanged()
								Case FrameField
									Local Image:LTImage = Sprite.Visualizer.Image
									If Image Then
										Sprite.Frame = L_LimitInt( TextFieldText( FrameField ).ToInt(), 0, Image.FramesQuantity() - 1 )
										SetGadgetText( FrameField, Sprite.Frame )
										SetChanged()
									End If
							End Select
						Case FrameSlider
							Sprite.Frame = SliderValue( FrameSlider )
							SetGadgetText( FrameField, Sprite.Frame )
							SetChanged()
						Case AngleSlider
							Sprite.Angle = SliderValue( AngleSlider ) * 15.0
							SetGadgetText( AngleField, L_Round( Sprite.Angle ) )
							SetChanged()
						Case DisplayingAngleSlider
							Sprite.DisplayingAngle = SliderValue( DisplayingAngleSlider ) * 15.0
							SetGadgetText( DisplayingAngleField, L_Round( Sprite.DisplayingAngle ) )
							SetChanged()
						Case LayerSlider
							Sprite.CollisionLayer = SliderValue( LayerSlider )
							SetGadgetText( LayerField, Sprite.CollisionLayer )
							SetChanged()
					End Select
				Next
			Case Event_GadgetMenu
				If EventSource() = ProjectManager Then
					SelectedShape = LTShape( GadgetExtra( TGadget( EventExtra() ) ) )
					If LTLayer( SelectedShape ) Then
						If LTLayer( SelectedShape ).MixContent Then
							CheckMenu( MixContent )
						Else
							UnCheckMenu( MixContent )
						End If
						PopUpWindowMenu( Window, LayerMenu )
					ElseIf LTTileMap( SelectedShape ) Then
						PopUpWindowMenu( Window, TileMapMenu )
					ElseIf LTSpriteMap( SelectedShape ) Then
						PopUpWindowMenu( Window, SpriteMapMenu )
					ElseIf SelectedShape Then
						If LTSprite( SelectedShape ).SpriteMap Then
							PopUpWindowMenu( Window, MapSpriteMenu )
						Else
							PopUpWindowMenu( Window, SpriteMenu )
						End If
					End If
				ElseIf EventSource() = ParametersListBox Then
					SelectedParameter = LTParameter( EventExtra() )
					If SelectedParameter Then PopUpWindowMenu( Window, ParameterMenu )
				End If
		End Select
	End Method
		
	Method Logic()
		Delay 10
		If Not CurrentViewLayer Then Return
		
		Local Bounds:LTShape = CurrentViewLayer.Bounds
		If Bounds Then
			SetSliderRange( HScroller, Min( 10000.0, 10000.0 * MainCamera.Width / Bounds.Width ), 10000.0 )
			SetSliderRange( VScroller, Min( 10000.0, 10000.0 * MainCamera.Height / Bounds.Height ), 10000.0 )
			If MainCamera.Width < Bounds.Width Then SetSliderValue( HScroller, 10000.0 * ( MainCamera.LeftX() - Bounds.LeftX() ) / Bounds.Width )
			If MainCamera.Height < Bounds.Height Then SetSliderValue( VScroller, 10000.0 * ( MainCamera.TopY() - Bounds.TopY() ) / Bounds.Height )
		Else
			SetSliderRange( HScroller, 1, 1 )
			SetSliderRange( VScroller, 1, 1 )
		End If
		
		If CurrentTilemap Then
			EnableGadget( TilesetCanvas )
			ShowGadget( TilesetCanvas )
			HideGadget( Panel )
			DisableGadget( Panel )
			SetGadgetShape( ProjectManager, ClientWidth( Window ) - BarWidth, 0.5 * ClientHeight( Window ), BarWidth, 0.5 * ClientHeight( Window ) - ListBoxHeight )
		Else
			HideGadget( TilesetCanvas )
			DisableGadget( TilesetCanvas )
			EnableGadget( Panel )
			ShowGadget( Panel )
			SetGadgetShape( ProjectManager, ClientWidth( Window ) - BarWidth, PanelHeight, BarWidth, ClientHeight( Window ) - PanelHeight - ListBoxHeight )
		End If
		
		Cursor.SetMouseCoords()
		
		SelectedModifier = Null
		For Local Modifier:LTSprite = Eachin Modifiers
			Local MX:Double, MY:Double
			MainCamera.FieldToScreen( Modifier.X, Modifier.Y, MX, MY )
			If MouseX() >= MX - ModifierSize And MouseX() <= MX + ModifierSize And MouseY() >= MY - ModifierSize And MouseY() <= MY + ModifierSize Then
				SelectedModifier = Modifier
				Exit
			End If
		Next
		
		If CurrentTilemap Then
			Local MX:Double, MY:Double
			MainCamera.ScreenToField( MouseX(), MouseY(), MX, MY )
			Local MinX:Int = 0
			Local MinY:Int = 0
			
			Rem
			If KeyHit( KEY_F12 ) Then
				Local NewValue:Int[,] = New Int[ CurrentTilemap.XQuantity, CurrentTilemap.YQuantity ]
				For Local Y:Int = 0 Until CurrentTilemap.YQuantity
					For Local X:Int = 0 Until CurrentTilemap.XQuantity
						NewValue[ X, Y ] = CurrentTilemap.Value[ X, CurrentTilemap.YQuantity - 1 - Y ]
					Next
				Next
				CurrentTilemap.Value = NewValue
			End If
			EndRem
			
			Local TileSet:LTTileSet = CurrentTilemap.TileSet
			If TileSet Then
				Local Image:LTImage = TileSet.Image
				If Image then
					Local TileNum0:Int = TileNum[ 0 ]
					
					MinX = -TileSet.BlockWidth[ TileNum0 ]
					MinY = -TileSet.BlockHeight[ TileNum0 ]
				
					Local FWidth:Double, FHeight:Double
					TilesetCamera.SizeScreenToField( GadgetWidth( TilesetCanvas ), 0, FWidth, FHeight )
					
					If MouseIsOver = TilesetCanvas Then
						Local FX:Double, FY:Double
						TilesetCamera.ScreenToField( MouseX(), MouseY(), FX, FY )
						Local IFX:Int = Floor( FX )
						Local IFY:Int = Floor( FY )
						If IFX >= 0 And IFY >= 0 And IFX < Image.XCells And IFY < Image.YCells Then
							Local TileNumUnderCursor:Int = IFX + Image.XCells * IFY
							If MouseDown( 1 ) Then TileNum[ 0 ] = TileNumUnderCursor
							If MouseDown( 2 ) Then TileNum[ 1 ] = TileNumUnderCursor
							If TileSet And KeyHit( Key_0 )  Then
								Local NewWidth:Int = IFX - ( TileNum0 Mod Image.XCells )
								Local NewHeight:Int = IFY - Floor( TileNum0 / Image.XCells )
								'debugstop
								if NewHeight >= 0 And NewWidth >= 0 Then
									TileSet.BlockWidth[ TileNum0 ] = NewWidth
									TileSet.BlockHeight[ TileNum0 ] = NewHeight
									SetChanged()
								End If							
							End If
							If KeyHit( Key_E ) Then
								If TileSet.EmptyTile = TileNumUnderCursor Then
									TileSet.EmptyTile = -1
								Else
									TileSet.EmptyTile = TileNumUnderCursor
								End If
								SetChanged()
							End If
							If KeyHit( Key_F ) Then
								If Proceed( LocalizeString( "{{D_AreYouSure}}" ), True ) Then
									For Local Y:Int = 0 Until CurrentTilemap.YQuantity
										For Local X:Int = 0 Until CurrentTilemap.XQuantity
											CurrentTilemap.Value[ X, Y ] = TileNumUnderCursor
										Next
									Next
									SetChanged()
								End If
							End If
						End If
					End If
				End If
			End If
			
			TileX = L_LimitInt( Floor( ( MX - CurrentTileMap.LeftX() )/ CurrentTileMap.GetTileWidth() ), MinX, CurrentTilemap.XQuantity - 1 )
			TileY = L_LimitInt( Floor( ( MY - CurrentTileMap.TopY() ) / CurrentTileMap.GetTileHeight() ), MinY, CurrentTilemap.YQuantity - 1 )
					
			SetTile.Execute()
		Else
			ShapeUnderCursor = Null
			Local Size:Double = MainCamera.DistScreenToField( 8.0 )
			Cursor.SetSize( Size, Size )
			CheckForSpriteUnderCursor( CurrentViewLayer )
			SelectShapes.Execute()
			MoveShape.Execute()
			CreateSprite.Execute()
			ModifyShape.Execute()
		End If
		
		Pan.Execute()
		MainCamera.MoveUsingArrows( MainCamera.Width )
		
		SetCameraMagnification( MainCamera, MainCanvas, MainCanvasZ, 32.0 )
		SetCameraMagnification( TilesetCamera, TilesetCanvas, TilesetCanvasZ, TilesetCameraWidth )
		
		If CurrentViewLayer.Bounds Then MainCamera.LimitWith( CurrentViewLayer.Bounds )
		TilesetCamera.LimitWith( TilesetRectangle )
	End Method
	
	
	
	Method CheckForSpriteUnderCursor( Layer:LTLayer )
		For Local Shape:LTShape = Eachin Layer.Children
			Local Sprite:LTSprite = LTSprite( Shape )
			If Sprite Then
				If Cursor.CollidesWithSprite( Sprite ) Then ShapeUnderCursor = Sprite
			Else
				Local SpriteMap:LTSpriteMap = LTSpriteMap( Shape )
				if SpriteMap Then
					Local Map:TMap = New TMap
					Cursor.CollisionsWithSpriteMap( SpriteMap, EmptyHandler, Map )
					For Sprite = Eachin Map.Keys()
						ShapeUnderCursor = Sprite
					Next
				Else
					Local ChildLayer:LTLayer = LTLayer( Shape )
					If ChildLayer Then CheckForSpriteUnderCursor( ChildLayer )
				End If
			End If
		Next
	End Method
	
	
	
	Method SetCameraMagnification( Camera:LTCamera, Canvas:TGadget, Z:Int, Width:Int )
		Local NewD:Double = 1.0 * GadgetWidth( Canvas ) / Width * ( 1.1 ^ Z )
		Camera.SetMagnification( NewD )
	End Method
	
	
	
	Method Render()
		TilesetCamera.Viewport.X = 0.5 * TilesetCanvas.GetWidth()
		TilesetCamera.Viewport.Y = 0.5 * TilesetCanvas.GetHeight()
		TilesetCamera.Viewport.Width = TilesetCanvas.GetWidth()
		TilesetCamera.Viewport.Height = TilesetCanvas.GetHeight()
		
		SetGraphics( CanvasGraphics( TilesetCanvas ) )
		SetBlend( AlphaBlend )
		Cls
		
		If CurrentTileMap Then
			Local TileSet:LTTileSet = CurrentTileMap.TileSet
			If TileSet Then
				Local Image:LTImage = TileSet.Image
				If Image Then
					Local TileWidth:Double, TileHeight:Double
					TilesetCamera.SizeFieldToScreen( 1.0, 1.0, TileWidth, TileHeight )
					SetScale( TileWidth / ImageWidth( Image.BMaxImage ), TileHeight / ImageHeight( Image.BMaxImage ) )
					'debugstop
					For Local Frame:Int = 0 Until Image.FramesQuantity()
						Local SX:Double, SY:Double
						TilesetCamera.FieldToScreen( 0.5 + Frame Mod Image.XCells, 0.5 + Floor( Frame / Image.XCells ), SX, SY )
						DrawImage( Image.BMaxImage, SX, SY, Frame )
					Next
					
					SetScale( 1.0, 1.0 )
					
					L_CurrentCamera = TilesetCamera
					
					For Local N:Int = 1 To 0 Step -1
						TileNum[ N ] = L_LimitInt( TileNum[ N ], 0, Image.FramesQuantity() - 1 )
						Local TileNumN:Int = TileNum[ N ]
						SelectedTile.Width = 1.0 + Tileset.BlockWidth[ TileNumN ]
						SelectedTile.Height =1.0 + Tileset.BlockHeight[ TileNumN ]
						SelectedTile.X = 0.5 * SelectedTile.Width + ( TileNumN Mod Image.XCells )
						SelectedTile.Y = 0.5 * SelectedTile.Height + Floor( TileNumN / Image.XCells )
						SelectedTile.Draw()
					Next
				End If
			End If
		End If
		
		Flip( False )
		'EndGraphics
		
		SetGraphics( CanvasGraphics( MainCanvas ) )
		SetBlend( AlphaBlend )
		L_EditorData.BackgroundColor.ApplyClsColor()
		Cls
		
		L_CurrentCamera = MainCamera
		If CurrentViewLayer Then
			MainCamera.Viewport.X = 0.5 * MainCanvas.GetWidth()
			MainCamera.Viewport.Y = 0.5 * MainCanvas.GetHeight()
			MainCamera.Viewport.Width = MainCanvas.GetWidth()
			MainCamera.Viewport.Height = MainCanvas.GetHeight()
			MainCamera.Update()
			
			CurrentViewLayer.DrawUsingVisualizer( L_DebugVisualizer )
			
			if ShowGrid Then Grid.Draw()
			
			If CurrentTilemap Then
				Local TileSet:LTTileSet = CurrentTileMap.TileSet
				If MouseIsOver = MainCanvas And TileSet Then
					Local TileWidth:Double = CurrentTileMap.GetTileWidth()
					Local TileHeight:Double = CurrentTileMap.GetTileHeight()
					SelectedTile.Width = TileWidth * ( 1.0 + Tileset.BlockWidth[ TileNum[ 0 ] ] )
					SelectedTile.Height = TileHeight * ( 1.0 + Tileset.BlockHeight[ TileNum[ 0 ] ] )
					SelectedTile.X = 0.5 * SelectedTile.Width + TileWidth * TileX + CurrentTileMap.LeftX()
					SelectedTile.Y = 0.5 * SelectedTile.Height + TileHeight * TileY + CurrentTileMap.TopY()
					SelectedTile.Draw()
				End If
			Else
				For Local Shape:LTShape = Eachin SelectedShapes
					Shape.DrawUsingVisualizer( MarchingAnts )
				Next
				
				If SelectShapes.Frame Then SelectShapes.Frame.DrawUsingVisualizer( MarchingAnts )
				
				If Not ModifyShape.DraggingState And Not CreateSprite.DraggingState Then
					For Local Modifier:LTSprite = Eachin Modifiers
						Local X:Double, Y:Double
						L_CurrentCamera.FieldToScreen( Modifier.X, Modifier.Y, X, Y )
						DrawRect( X - 3, Y - 3, 7, 7 )
						SetColor( 0, 0, 0 )
						DrawRect( X - 2, Y - 2, 5, 5 )
						SetColor( 255, 255, 255 )
					Next
				End If
			End If
			
			SetColor( 255, 0, 0 )
			If CurrentViewLayer.Bounds Then CurrentViewLayer.Bounds.DrawContour( 3.0 )
			SetColor( 255, 255, 255 )
		End If
		
		Flip( False )
		'EndGraphics
	End Method
	
	
	
	Method FillShapeFields()
		If Not CurrentShape Then Return
	
		Local Visualizer:LTVisualizer = CurrentShape.Visualizer
		
		SetGadgetText( XField, L_TrimDouble( CurrentShape.X, 4 ) )
		SetGadgetText( YField ,L_TrimDouble( CurrentShape.Y, 4 ) )
		SetGadgetText( WidthField, L_TrimDouble( CurrentShape.Width, 4 ) )
		SetGadgetText( HeightField, L_TrimDouble( CurrentShape.Height, 4 ) )
		SetGadgetText( RedField, L_TrimDouble( Visualizer.Red, 4 ) )
		SetGadgetText( GreenField, L_TrimDouble( Visualizer.Green, 4 ) )
		SetGadgetText( BlueField, L_TrimDouble( Visualizer.Blue, 4 ) )
		SetGadgetText( AlphaField, L_TrimDouble( Visualizer.Alpha, 4 ) )
		
		SetSliderValue( RedSlider, 100.0 * Visualizer.Red )
		SetSliderValue( GreenSlider, 100.0 * Visualizer.Green )
		SetSliderValue( BlueSlider, 100.0 * Visualizer.Blue )
		SetSliderValue( AlphaSlider, 100.0 * Visualizer.Alpha )
		
		SetGadgetText( VisDXField, L_TrimDouble( Visualizer.DX, 4 ) )
		SetGadgetText( VisDYField, L_TrimDouble( Visualizer.DY, 4 ) )
		SetGadgetText( XScaleField, L_TrimDouble( Visualizer.XScale, 4 ) )
		SetGadgetText( YScaleField, L_TrimDouble( Visualizer.YScale, 4 ) )
		
		SetButtonState( RotatingCheckbox, Visualizer.Rotating )
		SetButtonState( ScalingCheckbox, Visualizer.Scaling )
		SetButtonState( PhysicsCheckbox, CurrentShape.Physics() )
		
		ClearGadgetItems( ShapeBox )
		
		Local CurrentSprite:LTSprite = LTSprite( CurrentShape )
		If Not CurrentSprite Then Return
		
		FillShapeComboBox( ShapeBox )
		SelectGadgetItem( ShapeBox, CurrentSprite.ShapeType )
		
		SetGadgetText( FrameField, CurrentSprite.Frame )
		SetGadgetText( VelocityField, L_TrimDouble( CurrentSprite.Velocity ) )
		SetGadgetText( AngleField, L_TrimDouble( CurrentSprite.Angle ) )
		SetGadgetText( DisplayingAngleField, L_TrimDouble( CurrentSprite.DisplayingAngle ) )
		SetGadgetText( LayerField, CurrentSprite.CollisionLayer )
		
		If Visualizer.Image Then
			SetSliderRange( FrameSlider, 0, Visualizer.Image.FramesQuantity() - 1 )
			SetSliderValue( FrameSlider, CurrentSprite.Frame )
		End If
		
		SetSliderValue( AngleSlider, L_Round( CurrentSprite.Angle / 15.0 ) )
		SetSliderValue( DisplayingAngleSlider, L_Round( CurrentSprite.DisplayingAngle / 15.0 ) )
		SetSliderValue( LayerSlider, CurrentSprite.CollisionLayer & L_MaxCollisionColor )
	End Method
	
	
	
	Method FillShapeComboBox( ComboBox:TGadget )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_Pivot}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_Oval}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_Rectangle}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_Ray}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_TopLeftTriangle}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_TopRightTriangle}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_BottomLeftTriangle}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_BottomRightTriangle}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_Raster}}" ) )
	End Method
	
	
	
	Method SelectShape( Shape:LTShape, ForMoving:Int = False )
		If ForMoving Then If SelectedShapes.Contains( Shape ) Then Return
		SelectedShapes.Clear()
		SelectedShapes.AddLast( Shape )
		If LTLayer( Shape ) Then Return
		SetShapeModifiers( Shape )
		CurrentShape = Shape
		FillShapeFields()
		RefreshProjectManager()
	End Method
	
	
	
	Method SetShapeModifiers( Shape:LTShape )
		Modifiers.Clear()
	
		Local SWidth:Double, SHeight:Double
		Local Width:Double = 0.5 * Shape.Width
		Local Height:Double = 0.5 * Shape.Height
		
		If SWidth < 4 Then SWidth = 4
		If SHeight < 4 Then SHeight = 4
		
		AddModifier( Shape, TModifyShape.ResizeHorizontally, -Width, 0, -4, 0 )
		AddModifier( Shape, TModifyShape.ResizeHorizontally, Width, 0, 4, 0 )
		AddModifier( Shape, TModifyShape.ResizeVertically, 0, -Height, 0, -4 )
		AddModifier( Shape, TModifyShape.ResizeVertically, 0, Height, 0, 4 )
		AddModifier( Shape, TModifyShape.Resize, -Width, -Height, -4, -4 )
		AddModifier( Shape, TModifyShape.Resize, Width, -Height, 4, -4 )
		AddModifier( Shape, TModifyShape.Resize, -Width, Height, -4, 4 )
		AddModifier( Shape, TModifyShape.Resize, Width, Height, 4, 4 )
	End Method
	
	
	
	Method AddModifier( Shape:LTShape, ModType:Int, FDX:Double, FDY:Double, SDX:Int, SDY:Int )
		Local Modifier:LTSprite = New LTSprite
		Local FDX2:Double = 0, FDY2:Double = 0
		If Not L_CurrentCamera.Isometric Then L_CurrentCamera.SizeScreenToField( SDX, SDY, FDX2, FDY2 )
		Modifier.X = Shape.X + FDX + FDX2
		Modifier.Y = Shape.Y + FDY + FDY2
		Modifier.Frame = ModType
		Modifier.ShapeType = LTSprite.Rectangle
		Modifiers.AddLast( Modifier )
	End Method
	
	
	
	Method RefreshTilemap()
		If Not CurrentTileMap Then Return
		
		Local TileSet:LTTileSet = CurrentTileMap.TileSet
		If Not TileSet Then Return
		
		Local Image:LTImage = TileSet.Image
		If Not Image Then Return
		
		For Local N:Int = 0 To 1
			TileNum[ N ] = 0
		Next
		
		TilesetCameraWidth = Image.XCells
		TilesetCanvasZ = 0.0
		SetCameraMagnification( TilesetCamera, TilesetCanvas, TilesetCanvasZ, TilesetCameraWidth )
		TilesetCamera.X = 0.5 * Image.XCells
		TilesetCamera.Y = 0.5 * Image.YCells
		TilesetRectangle.X = TilesetCamera.X
		TilesetRectangle.Y = TilesetCamera.Y
		TilesetRectangle.Width = Image.XCells
		TilesetRectangle.Height = Image.YCells
		TilesetCamera.Update()
	End Method
	
	
	
	Method RefreshProjectManager( Layer:LTLayer = Null, Node:TGadget = Null )
		If Not Layer Then Layer = World
		If Not Node Then Node = TreeViewRoot( ProjectManager )
		
		Local Link:TLink = Node.kids.FirstLink()
		Local SelectedShapesLink:TLink = Null
		If Not SelectedShapes.IsEmpty() Then SelectedShapesLink = SelectedShapes.FirstLink()
		For Local Shape:LTShape = Eachin Layer.Children
			AddShapeEntry( Shape, Node, Link, SelectedShapesLink )
		Next
		While Link <> Null
			FreeTreeViewNode( TGadget( Link.Value() ) )
			Link = Link.NextLink()
		WEnd
		If Layer = World Then AddTreeViewNode( "{{N_AddNewLayer}}", Node, 4 )
	End Method
	
	
	
	Method AddShapeEntry( Shape:LTShape, Node:TGadget, Link:TLink Var, SelectedShapesLink:TLink Var )
		Local Icon:Int
		If LTLayer( Shape ) Then
			Icon = 0
		ElseIf LTTIleMap( Shape ) Then
			Icon = 1
		ElseIf LTSpriteMap( Shape ) Then
			Icon = 3
		ElseIf LTSpriteGroup( Shape ) Then
			Icon = 5
		Else
			Icon = 2
		End If
		
		Local Title:String = Shape.GetTitle()
		
		If Not Shape.Visible Then Title = "(x) " + Title
		If Not Shape.Active Then Title = "(-) " + Title
		
		If Shape = CurrentContainer Then Title = "{ " + Title + " }"
		If Shape = CurrentTilemap Or Shape = CurrentViewLayer Then Title = "< " + Title + " >"
		If SelectedShapesLink Then
			If SelectedShapesLink.Value() = Shape Then
				Title = "* " + Title + " *"
				SelectedShapesLink = SelectedShapesLink.NextLink()
			End If
		End If
		
		Local CurrentNode:TGadget
		If Link <> Null Then
			CurrentNode = TGadget( Link.Value() )
			ModifyTreeViewNode( CurrentNode, Title, Icon )
			SetGadgetExtra( CurrentNode, Shape )
			
			If Not LTLayer( Shape ) Then
				For Local ChildNode:TGadget = Eachin CurrentNode.kids
					FreeTreeViewNode( ChildNode )
				Next
			End If
			
			Link = Link.NextLink()
		Else
			CurrentNode = AddTreeViewNode( Title, Node, Icon, Shape )
		End If
		
		Local Layer:LTLayer = LTLayer( Shape )
		If Layer Then
			RefreshProjectManager( Layer, CurrentNode )
		Else
			Local SpriteMap:LTSpriteMap = LTSpriteMap( Shape )
			If SpriteMap Then
				Local ChildLink:TLink = CurrentNode.kids.FirstLink()
				For Local Sprite:LTSprite = Eachin SpriteMap.Sprites.Keys()
					AddShapeEntry( Sprite, CurrentNode, ChildLink, SelectedShapesLink )
				Next
				While ChildLink <> Null
					FreeTreeViewNode( TGadget( ChildLink.Value() ) )
					ChildLink = ChildLink.NextLink()
				WEnd
			End If
		End If
	End Method
	
	
	
	Method AddLayer:LTLayer( LayerName:String )
		Local Layer:LTLayer = New LTLayer
		Layer.SetParameter( "name", LayerName )
		World.AddLast( Layer )
		Return Layer
	End Method
	
	
	
	Method InitImage( Image:LTImage )
		L_EditorData.Images.AddLast( Image )
		BigImages.Insert( Image, LoadImage( Image.Filename ) )
		RealPathsForImages.Insert( Image, RealPath( Image.Filename ) )
	End Method
	
	
	
	Method InitTileMap( TileMap:LTTileMap )
		TileMap.X = 0.5 * TileMap.XQuantity
		TileMap.Y = 0.5 * TileMap.YQuantity
		TileMap.Width = TileMap.XQuantity
		TileMap.Height = TileMap.YQuantity
	End Method
	
	
	
	Method ShiftPageUpEnd( Layer:LTLayer, SelectedLink:TLink Var, Key:Int )
		Local ShapesList:TList = Layer.Children
		Local ShapeLink:TLink = ShapesList.FirstLink()
		While ShapeLink And SelectedLink
			If ShapeLink.Value() = SelectedLink.Value() And ( ShapeLink.PrevLink() Or Key = Key_End ) Then
				if Key = Key_PageUp Then
					ShapesList.InsertBeforeLink( ShapeLink.Value(), ShapeLink.PrevLink() )
				Else
					ShapesList.InsertAfterLink( ShapeLink.Value(), ShapesList.LastLink() )
				End If
				ShapeLink.Remove()
				SelectedLink = SelectedLink.NextLink()
			Else
				Local ChildLayer:LTLayer = LTLayer( ShapeLink.Value() )
				If ChildLayer Then ShiftPageUpEnd( ChildLayer, SelectedLink, Key )
			End If
			ShapeLink = ShapeLink.NextLink()
		Wend
	End Method
	
	
	
	Method ShiftPageDownHome( Layer:LTLayer, SelectedLink:TLink Var, Key:Int )
		Local ShapesList:TList = Layer.Children
		Local ShapeLink:TLink = ShapesList.LastLink()
		While ShapeLink And SelectedLink
			If ShapeLink.Value() = SelectedLink.Value() And ( ShapeLink.NextLink() Or Key = Key_Home ) Then
				if Key = Key_PageDown Then
					ShapesList.InsertAfterLink( ShapeLink.Value(), ShapeLink.NextLink() )
				Else
					ShapesList.InsertBeforeLink( ShapeLink.Value(), ShapesList.FirstLink() )
				End If
				ShapeLink.Remove()
				SelectedLink = SelectedLink.PrevLink()
			Else
				Local ChildLayer:LTLayer = LTLayer( ShapeLink.Value() )
				If ChildLayer Then ShiftPageDownHome( ChildLayer, SelectedLink, Key )
			End If
			ShapeLink = ShapeLink.PrevLink()
		Wend
	End Method
	
	
	
	Method InsertIntoContainer( Shape:LTShape, Container:LTShape )
		Local Layer:LTLayer = LTLayer( Container )
		If Layer Then
			Layer.AddLast( Shape )
		Else
			Local Sprite:LTSprite = LTSprite( Shape )
			if Sprite Then LTSpriteMap( Container ).InsertSprite( Sprite )
		End If
	End Method
	
	
	
	Method FillFileMenu()
		For Local kid:TGadget = EachIn FileMenu.kids
			kid.Free()
		Next
		FileMenu.kids.Clear()
		
		CreateMenu( "{{M_New}}", MenuNew, FileMenu )
		CreateMenu( "{{M_Open}}", MenuOpen, FileMenu )
		CreateMenu( "{{M_Save}}", MenuSave, FileMenu )
		CreateMenu( "{{M_SaveAs}}", MenuSaveAs, FileMenu )
		CreateMenu( "{{M_Merge}}", MenuMerge, FileMenu )
		CreateMenu( "", 0, FileMenu )
		
		Local ItemExists:Int = False
		For Local N:Int = 0 Until RecentFilesQuantity
			If RecentFiles[ N ] Then
				CreateMenu( RecentFiles[ N ], MenuRecentFile + N, FileMenu )
				ItemExists = True
			End If
		Next
		If ItemExists Then CreateMenu( "", 0, FileMenu )
		
		CreateMenu( "{{M_Exit}}", MenuExit, FileMenu )
		UpdateWindowMenu( Window )
	End Method
	
	
	
	Method InsertToRecentFiles( Filename:String )
		For Local N:Int = 0 Until RecentFilesQuantity
			If RecentFiles[ N ] = FileName Then
				For Local NN:Int = N Until RecentFilesQuantity - 1
					RecentFiles[ NN ] = RecentFiles[ NN + 1 ]
				Next
				RecentFiles[ RecentFilesQuantity - 1 ] = ""
			End If
		Next
		
		For Local N:Int = RecentFilesQuantity - 1 To 1 Step -1
			RecentFiles[ N ] = RecentFiles[ N - 1 ]
		Next
		
		RecentFiles[ 0 ] = FileName
		
		FillFileMenu()
	End Method
	
	
	
	Method SetIncbin()
		If L_EditorData.IncbinValue Then
			CheckMenu( IncbinMenu )
		Else
			UnCheckMenu( IncbinMenu )
		End If
	End Method
	
	
	
	Method EditTileMap( TileMap:LTTileMap )
		If TileMap Then
			If Not TileMap.TileSet Then Return
			CurrentTileMap = TileMap
			LTMenuSwitch.Find( MenuTileMapEditingMode ).Set( True )
		ElseIf CurrentTileMap Then
			LTMenuSwitch.Find( MenuTileMapEditingMode ).Set( False )
			CurrentTileMap = Null
		Else
			Return
		End If
		RefreshProjectManager()
		RefreshTilemap()
	End Method
	
	
	
	Method RemoveParameter( Shape:LTShape, Parameter:LTParameter )
		Shape.Parameters.Remove( Parameter )
		If Shape.Parameters.IsEmpty() Then Shape.Parameters = Null
	End Method
	
	
	
	Method RefreshParametersListBox( RefreshPM:Int = True )
		ClearGadgetItems( ParametersListBox )
		If Not ShapeForParameters Then Return
		If ShapeForParameters.Parameters Then
			For Local Parameter:LTParameter = Eachin ShapeForParameters.Parameters
				AddGadgetItem( ParametersListBox, Parameter.Name + ": " + Parameter.Value, , , , Parameter )
			Next
		End If
		AddGadgetItem( ParametersListBox, "Add new parameter" )
		If RefreshPM Then RefreshProjectManager()
	End Method
	
	
	
	Method InitParameterNames()
		ParameterNames.Clear()
		ParameterNames.Insert( "class", Null )
		ParameterNames.Insert( "name", Null )
	End Method
	
	
	
	Method AddParameterNames( Shape:LTShape )
		If Shape.Parameters Then
			For Local Parameter:LTParameter = Eachin Shape.Parameters
				ParameterNames.Insert( Parameter.Name, Null )
			Next
		End If
		Local Layer:LTLayer = LTLayer( Shape )
		If Layer Then
			For Local ChildShape:LTShape = Eachin Layer.Children
				AddParameterNames( ChildShape )
			Next
		End If
	End Method
	
	
	
	Method ToggleBilinearFiltering()
		BilinearFiltering = LTMenuSwitch.Find( MenuBilinearFiltering ).Toggle()
		If BilinearFiltering Then
			AutoImageFlags( FilteredImage | MipMappedImage )
		Else
			AutoImageFlags( 0 )
		End If
	End Method
	
	
	
	Method PutAfterLayer:Int( Layer:LTLayer, AfterLayer:LTLayer, FromLayer:LTLayer )
		Local Link:TLink = FromLayer.Children.FirstLink()
		While Link
			Local ChildLayer:LTLayer = LTLayer( Link.Value() )
			If ChildLayer = AfterLayer Then
				FromLayer.Children.InsertAfterLink( Layer, Link )
				Return True
			ElseIf ChildLayer Then
				If PutAfterLayer( Layer, AfterLayer, ChildLayer ) Then Return True
			End If
			Link = Link.NextLink()
		WEnd
	End Method
	
	
	
	Method UpdateXML( XMLObject:LTXMLObject )
		Local Version:Int = L_VersionToInt( XMLObject.GetAttribute( "dwlab_version" ) )
		If Version < 01020000 Then UpdateTo1_2( XMLObject )
		If Version < 01020600 Then UpdateTo1_2_6( XMLObject )
		If Version < 01041400 Then UpdateTo1_4_14( XMLObject )
		If Version < 01041800 Then UpdateTo1_4_18( XMLObject )
		If Version < 01042100 Then UpdateTo1_4_21( XMLObject )
		If Version < 01042400 Then UpdateTo1_4_24( XMLObject )
	End Method
	
	
	
	Method UpdateTo1_2( XMLObject:LTXMLObject )
		For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
			UpdateTo1_2( ChildXMLObject )
		Next
		For Local XMLObjectField:LTXMLObjectField = Eachin XMLObject.Fields
			UpdateTo1_2( XMLObjectField.Value )
		Next
		Local Name:String = XMLObject.GetAttribute( "name" )
		If Name And XMLObject.Name <> "lttileset" And XMLObject.Name <> "lttilecategory" Then
			Local CommaPos:Int = Name.Find( "," )
		
			XMLObject.RemoveAttribute( "name" )
			Local Parameters:LTXMLObject = New LTXMLObject
			Parameters.Name = "list"
			
			Local ClassName:String = Name
			If CommaPos >= 0 Then ClassName = Name[ ..CommaPos ]
			If ClassName.ToLower() <> XMLObject.Name Then 
				Local Parameter:LTXMLObject = New LTXMLObject
				Parameter.Name = "ltparameter"
				Parameter.SetAttribute( "name", "class" )
				Parameters.Children.AddLast( Parameter ) 
				Parameter.SetAttribute( "value", ClassName )
			End If
			
			If CommaPos >= 0 Then
				Local Parameter:LTXMLObject = New LTXMLObject
				Parameter.Name = "ltparameter"
				Parameter.SetAttribute( "name", "name" )
				Parameter.SetAttribute( "value", Name[ CommaPos + 1.. ] )
				Parameters.Children.AddLast( Parameter ) 
			End If 
			
			XMLObject.SetField( "parameters", Parameters )
		End If
	End Method
	
	
	
	Method UpdateTo1_2_6( XMLObject:LTXMLObject )
		If XMLObject.Name = "ltSprite" Then
			XMLObject.Name = "ltsprite"
		ElseIf XMLObject.Name = "ltvectorsprite" Then
			XMLObject.Name = "ltsprite"
			Local DX:Double = XMLObject.GetAttribute( "dx" ).ToDouble()
			Local DY:Double = XMLObject.GetAttribute( "dy" ).ToDouble()
			XMLObject.SetAttribute( "angle", ATan2( DY, DX ) )
			XMLObject.SetAttribute( "velocity", L_Distance( DY, DX ) )
			XMLObject.RemoveAttribute( "dx" )
			XMLObject.RemoveAttribute( "dy" )
		End If
		For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
			UpdateTo1_2_6( ChildXMLObject )
		Next
		For Local XMLObjectField:LTXMLObjectField = Eachin XMLObject.Fields
			UpdateTo1_2_6( XMLObjectField.Value )
		Next
	End Method
	
	
	
	Method UpdateTo1_4_14( XMLObject:LTXMLObject )
		If XMLObject.Name.ToLower() = "ltgroup" Then XMLObject.Name = "ltspritegroup"
		For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
			UpdateTo1_4_14( ChildXMLObject )
		Next
		For Local XMLObjectField:LTXMLObjectField = Eachin XMLObject.Fields
			UpdateTo1_4_14( XMLObjectField.Value )
		Next
	End Method
	
	

	Global TilesQ:TMap = New TMap
		
	Method UpdateTo1_4_18( XMLObject:LTXMLObject )
		For Local Attribute:LTXMLAttribute = Eachin XMLObject.Attributes
			Local Txt:String = Attribute.Value
			For Local N:Int = 0 Until Txt.Length
				if N >= Txt.Length - 1 Then Exit
				If Txt[ N ] = Asc( "\" ) And Txt[ N + 1 ] = Asc( "#" ) Then
					Txt = Txt[ ..N ] + Chr( ( Txt[ N + 2 ] - 48 ) + ( Txt[ N + 3 ] - 48 ) * 64 + ( Txt[ N + 4 ] - 48 ) * 4096 ) ..
							 + Txt[ N + 5.. ]
				End If
			Next
			Attribute.Value = Txt
		Next
		
		Select XMLObject.Name
			Case "lttilemap"
				Local TileSetField:LTXMLObject = XMLObject.GetField( "tileset" )
				Local ID:String = TileSetField.GetAttribute( "id" )
				Local TilesQuantity:String
				If TileSetField.Name = "object" Then
					TilesQuantity = String( TilesQ.ValueForKey( ID ) )
				ElseIf ID Then
					TilesQuantity = TileSetField.GetAttribute( "tiles-quantity" )
					TilesQ.Insert( ID, TilesQuantity )
				End If
				XMLObject.SetAttribute( "tiles-quantity", TilesQuantity )
				Local ChunkLength:Int = L_GetChunkLength( TilesQuantity.ToInt() )
				For Local Row:LTXMLObject = Eachin XMLObject.Children
					If Row.Name = "row" Then UpdateData( Row, "data", ChunkLength )
				Next
			Case "shapearray"
				For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
					If ChildXMLObject.Name = "ltspritegroup" Then ChildXMLObject.Name = "ltlayer"
				Next
			Case "lttileset"
				UpdateData( XMLObject, "block-width", 1 )
				UpdateData( XMLObject, "block-height", 1 )
		End Select
		
		For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
			UpdateTo1_4_18( ChildXMLObject )
		Next
		For Local XMLObjectField:LTXMLObjectField = Eachin XMLObject.Fields
			UpdateTo1_4_18( XMLObjectField.Value )
		Next
	End Method
	
	
	
	Method UpdateData( XMLObject:LTXMLObject, AttrName:String, ChunkLength:Int )
		Local Data:String = ""
		For Local Num:String = Eachin XMLObject.GetAttribute( AttrName ).Split( "," )
			Data :+ L_Encode( Num.ToInt(), ChunkLength )
		Next
		XMLObject.SetAttribute( AttrName, Data )
	End Method
	
	
	
	Method UpdateTo1_4_21( XMLObject:LTXMLObject )
		If XMLObject.Name = "ltsprite" Then
			Local VisField:LTXMLObject = XMLObject.GetField( "visualizer" )
			If VisField Then XMLObject.SetAttribute( "disp_angle", VisField.GetAttribute( "angle" ) )
		End If
		
		For Local Attribute:LTXMLAttribute = Eachin XMLObject.Attributes
			Select Attribute.Name
				Case "x", "y", "width", "height", "angle", "disp_angle", "velocity", "cell_width", "cell_height", ..
						"dx", "dy", "xscale", "yscale", "red", "green", "blue", "alpha"
					Local DotPos:Int = Attribute.Value.Find( "." )
					If DotPos >= 0 Then
						If DotPos + 5 < Attribute.Value.Length Then Attribute.Value = Attribute.Value[ ..DotPos + 6 ]
					End If
			End Select
		Next
		
		For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
			UpdateTo1_4_21( ChildXMLObject )
		Next
		For Local XMLObjectField:LTXMLObjectField = Eachin XMLObject.Fields
			UpdateTo1_4_21( XMLObjectField.Value )
		Next
	End Method
	
	
	
	Method UpdateTo1_4_24( XMLObject:LTXMLObject )
		If XMLObject.Name = "ltparameter" Then
			Local Name:String = XMLObject.GetAttribute( "name" )
			Select Name
				Case "text_size", "text_color", "text_shift", "text_h_align", "text_v_align", "gadget_name", "gadget_text", ..
						"pressing_shift", "pressing_shift", "pressing_dx", "pressing_dy", "item_size", "disp_angle"
					XMLObject.SetAttribute( "name", Name.Replace( "_", "-" ) )
				Case "text_dx"
					XMLObject.SetAttribute( "name", "text-h-margin" )
				Case "text_dy"
					XMLObject.SetAttribute( "name", "text-v-margin" )
			End Select
		End If
		
		For Local Attribute:LTXMLAttribute = Eachin XMLObject.Attributes
			If Attribute.Name = "angle" Then Attribute.Name = "moving-angle"
		Next
		
		For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
			UpdateTo1_4_24( ChildXMLObject )
		Next
		For Local XMLObjectField:LTXMLObjectField = Eachin XMLObject.Fields
			UpdateTo1_4_24( XMLObjectField.Value )
		Next
	End Method
	

	
	Method FindShapeContainer:LTShape( Layer:LTLayer, Shape:LTShape )
		For Local ChildShape:LTShape = Eachin Layer.Children
			If ChildShape = Shape Then Return Layer
			Local ChildLayer:LTLayer = LTLayer( ChildShape )
			If ChildLayer Then
				Local FoundShape:LTShape = FindShapeContainer( ChildLayer, Shape )
				If FoundShape Then Return FoundShape
			Else
				Local ChildSpriteMap:LTSpriteMap = LTSpriteMap( ChildShape )
				If ChildSpriteMap Then
					For Local Sprite:LTSprite = Eachin ChildSpriteMap.Sprites.Keys()
						If Sprite = Shape Then Return ChildSpriteMap
					Next
				End If
			End If
		Next
	End Method
	
	
	
	Global ImageMap:TMap
	
	Method UpdateImages()
		ImageMap = New TMap
		For Local Image:LTImage = Eachin L_EditorData.Images
			If ImageMap.Contains( RealPath( Image.Filename ) ) Then
				L_EditorData.Images.Remove( Image )
			Else
				ImageMap.Insert( RealPath( Image.Filename ), Image )
			End If
		Next
		MergeImages( World )
			
		RealPathsForImages.Clear()
		BigImages.Clear()
		For Local Image:LTImage = Eachin L_EditorData.Images
			RealPathsForImages.Insert( Image, RealPath( Image.Filename ) )
			BigImages.Insert( Image, LoadImage( Image.Filename ) )
		Next
	End Method
	
	
	
	Method MergeImages( Layer:LTLayer )
		For Local Sprite:LTSprite = Eachin Layer.Children
			MergeImage( Sprite.Visualizer.Image )
		Next
		
		For Local TileMap:LTTileMap = Eachin Layer.Children
			MergeImage( TileMap.TileSet.Image )
		Next
		
		For Local SpriteMap:LTSpriteMap = Eachin Layer.Children
			For Local Sprite:LTSprite = Eachin SpriteMap.Sprites.Keys()
				MergeImage( Sprite.Visualizer.Image )
			Next
		Next
		
		For Local ChildLayer:LTLayer = Eachin Layer.Children
			MergeImages( ChildLayer )
		Next
	End Method
	
	
	
	Method MergeImage( Image:LTImage Var )
		If Not Image Then Return
		Local MapImage:LTImage = LTImage( ImageMap.ValueForKey( RealPath( Image.Filename ) ) )
		If MapImage Then
			Image = MapImage
			DebugLog( "Merged" )
		Else
			ImageMap.Insert( RealPath( Image.Filename ), Image )
			DebugLog( "Inserted" )
			L_EditorData.Images.AddLast( Image )
		End If
	End Method
	
	
	
	Method ReplaceTiles( Layer:LTLayer, TileSetName:String, TileNum1:Int, TileNum2:Int )
		For Local TileMap:LTTileMap = Eachin Layer
			If TileMap.TileSet.Name <> TileSetName Then Continue
			For Local Y:Int = 0 Until TileMap.YQuantity
				For Local X:Int = 0 Until TileMap.XQuantity
					If TileMap.Value[ X, Y ] = TileNum1 Then TileMap.Value[ X, Y ] = TileNum2
				Next
			Next
		Next
		
		For Local ChildLayer:LTLayer = Eachin Layer
			ReplaceTiles( ChildLayer, TileSetName, TileNum1, TileNum2 )
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



Global LoadingWindow:TGadget
Global ProgressBar:TGadget

Type TLoadingUpdater Extends LTObject
	Method Update()
		UpdateProgBar( ProgressBar, L_LoadingProgress )
		SetGadgetText( LoadingWindow, L_LoadingStatus )
	End Method
End Type