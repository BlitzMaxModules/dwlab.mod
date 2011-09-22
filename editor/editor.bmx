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

Import brl.pngloader
Import brl.jpgloader
Import brl.bmploader

Import dwlab.frmwork
Import dwlab.forms

Include "TPan.bmx"
Include "TSelectShapes.bmx"
Include "TMoveShape.bmx"
Include "TCreateSprite.bmx"
Include "TModifyShape.bmx"
Include "TGrid.bmx"
Include "TSetTile.bmx"
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

Incbin "english.lng"
Incbin "russian.lng"

Incbin "toolbar.png"
Incbin "treeview.png"

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Const Version:String = "1.7.2"
	Const INIVersion:Int = 3
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
	Field RedField:TGadget
	Field RedSlider:TGadget
	Field ShapeBox:TGadget
	Field XField:TGadget
	Field YField:TGadget
	Field WidthField:TGadget
	Field HeightField:TGadget
	Field DXField:TGadget
	Field DYField:TGadget
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
	Field VisDXField:TGadget
	Field VisDYField:TGadget
	Field FrameField:TGadget
	Field SelectImageButton:TGadget
	Field RotatingCheckbox:TGadget
	Field ScalingCheckbox:TGadget
	Field ImgAngleField:TGadget
	Field HiddenOKButton:TGadget
	Field HScroller:TGadget
	Field VScroller:TGadget
	
	Field ShowGrid:Int
	Field SnapToGrid:Int
	Field ReplacementOfTiles:Int
	
	Field StaticModel:TGadget
	Field VectorModel:TGadget
	Field AngularModel:TGadget
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
	
	Field World:LTWorld = New LTWorld
	Field RealPathsForImages:TMap = New TMap
	Field BigImages:TMap = New TMap
	Field CurrentViewLayer:LTLayer
	Field CurrentTileMap:LTTileMap
	Field CurrentContainer:LTShape
	Field CurrentShape:LTShape
	Field SelectedShape:LTShape
	Field ShapeForParameters:LTShape
	Field SpriteModel:Int
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
	
	Field Pan:TPan = New TPan
	Field SelectShapes:TSelectShapes = New TSelectShapes
	Field MoveShape:TMoveShape = New TMoveShape
	Field CreateSprite:TCreateSprite = New TCreateSprite
	Field ModifyShape:TModifyShape = New TModifyShape
	Field SetTile:TSetTile = New TSetTile
	Field Grid:TGrid = New TGrid
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	
	
	Const MenuNew:Int = 0
	Const MenuOpen:Int = 1
	Const MenuSave:Int = 2
	Const MenuSaveAs:Int = 3
	Const MenuRecentFile:Int = 100
	Const MenuShowCollisionShapes:Int = 5
	Const MenuShowVectors:Int = 6
	Const MenuShowNames:Int = 7
	Const MenuShowGrid:Int = 9
	Const MenuSnapToGrid:Int = 10
	Const MenuGridSettings:Int = 11
	Const MenuStaticModel:Int = 13
	Const MenuVectorModel:Int = 14
	Const MenuAngularModel:Int = 15
	Const MenuTilemapEditingMode:Int = 17
	Const MenuReplacementOfTiles:Int = 19
	Const MenuProlongTiles:Int = 20
	Const MenuCameraProperties:Int = 51
	Const MenuIncbin:Int = 54
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

	Const PanelHeight:Int = 320
	Const BarWidth:Int = 256
	Const LabelWidth:Int = 63
	Const ListBoxHeight:Int = 62
	
	
	
	Method Init()
		AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
		
		SetLocalizationMode( Localization_On | Localization_Override )
		EnglishLanguage = LoadLanguage( "incbin::english.lng" )
		RussianLanguage = LoadLanguage( "incbin::russian.lng" )
		SetLocalizationLanguage( EnglishLanguage )
		AppTitle = LocalizeString( "{{Title}}" + Version )
	
		Window  = CreateWindow( "{{Title}}", 0, 0, 640, 480 )
		MaximizeWindow( Window )
		
		Toolbar = CreateToolBar( "incbin::toolbar.png", 0, 0, 0, 0, Window )
		SetToolbarTips( Toolbar, [ "{{M_New}}", "{{M_Open}}", "{{M_Save}}", "{{M_SaveAs}}", "", "{{M_ShowCollisions}}", "{{M_ShowVectors}}", "{{M_ShowNames}}", "", "{{M_ShowGrid}}", "{{M_SnapToGrid}}", "{{M_GridSettings}}", "", "{{M_StaticModel}}", "{{M_VectorModel}}", "{{M_AngularModel}}", "", "{{M_TileMapEditingMode}}", "", "{{M_ReplacementOfTiles}}", "{{M_ProlongTiles}}" ] )
		
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
		AngleField = PanelForm.AddTextField( "{{L_Angle}}", LabelWidth )
		VelocityField = PanelForm.AddTextField( "{{L_Velocity}}", LabelWidth )
		PanelForm.NewLine()
		DXField = PanelForm.AddTextField( "{{L_DX}}", LabelWidth )
		DYField = PanelForm.AddTextField( "{{L_DY}}", LabelWidth )
		PanelForm.NewLine( LTAlign.Stretch )		
		PanelForm.AddSliderWidthTextField( RedSlider, RedField, "{{L_Red}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )		
		PanelForm.AddSliderWidthTextField( GreenSlider, GreenField, "{{L_Green}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )		
		PanelForm.AddSliderWidthTextField( BlueSlider, BlueField, "{{L_Blue}}", LabelWidth, 50 )
		PanelForm.NewLine( LTAlign.Stretch )		
		PanelForm.AddSliderWidthTextField( AlphaSlider, AlphaField, "{{L_Alpha}}", LabelWidth, 50 )
		PanelForm.NewLine()
		VisDXField = PanelForm.AddTextField( "{{L_VisDX}}", LabelWidth )
		VisDYField = PanelForm.AddTextField( "{{L_VisDY}}", LabelWidth )
		PanelForm.NewLine()
		XScaleField = PanelForm.AddTextField( "{{L_XScale}}", LabelWidth )
		YScaleField = PanelForm.AddTextField( "{{L_YScale}}", LabelWidth )
		PanelForm.NewLine()
		FrameField = PanelForm.AddTextField( "{{L_Frame}}", LabelWidth )
		SelectImageButton = PanelForm.AddButton( "{{B_SelectImage}}", LabelWidth + 56 )
		PanelForm.NewLine( LTAlign.Stretch )
		RotatingCheckbox = PanelForm.AddButton( "{{CB_Rotation}}", 55, Button_Checkbox )
		ScalingCheckbox = PanelForm.AddButton( "{{CB_Scaling}}", 55, Button_Checkbox )
		ImgAngleField = PanelForm.AddTextField( "{{L_ImageAngle}}", LabelWidth + 4 )
		PanelForm.Finalize( False, 6, 6 )
		
		HiddenOKButton = CreateButton( "", 0, 0, 0, 0, Panel, Button_OK )
		HideGadget( HiddenOKButton )
				
		World.Camera = LTCamera.Create( GadgetWidth( MainCanvas ), GadgetHeight( MainCanvas ), 32.0 )
		TilesetCamera = LTCamera.Create( GadgetWidth( TilesetCanvas ), GadgetHeight( TilesetCanvas ), 16.0 )
		
		
		
		FileMenu = CreateMenu( "{{M_File}}", 0, WindowMenu( Window ) )
		Local EditMenu:TGadget = CreateMenu( "{{M_Edit}}", 0, WindowMenu( Window ) )
		LTMenuSwitch.Create( "{{M_ShowCollisions}}", Toolbar, MenuShowCollisionShapes, EditMenu )
		LTMenuSwitch.Create( "{{M_ShowVectors}}", Toolbar, MenuShowVectors, EditMenu )
		LTMenuSwitch.Create( "{{M_ShowNames}}", Toolbar, MenuShowNames, EditMenu )
		CreateMenu( "", 0, EditMenu )
		LTMenuSwitch.Create( "{{M_ShowGrid}}", Toolbar, MenuShowGrid, EditMenu )
		LTMenuSwitch.Create( "{{M_SnapToGrid}}", Toolbar, MenuSnapToGrid, EditMenu )
		CreateMenu( "{{M_GridSettings}}", MenuGridSettings, EditMenu )
		CreateMenu( "", 0, EditMenu )
		StaticModel = CreateMenu( "{{M_StaticModel}}", MenuStaticModel, EditMenu )
		VectorModel = CreateMenu( "{{M_VectorModel}}", MenuVectorModel, EditMenu )
		AngularModel = CreateMenu( "{{M_AngularModel}}", MenuAngularModel, EditMenu )
		CreateMenu( "", 0, EditMenu )
		LTMenuSwitch.Create( "{{M_TileMapEditingMode}}", Toolbar, MenuTileMapEditingMode, EditMenu, False )
		CreateMenu( "", 0, EditMenu )
		LTMenuSwitch.Create( "{{M_ReplacementOfTiles}}", Toolbar, MenuReplacementOfTiles, EditMenu )
		LTMenuSwitch.Create( "{{M_ProlongTiles}}", Toolbar, MenuProlongTiles, EditMenu )
		CreateMenu( "", 0, EditMenu )
		CreateMenu( "{{M_CameraProperties}}", MenuCameraProperties, EditMenu )
		IncbinMenu = CreateMenu( "{{M_Incbin}}", MenuIncbin, EditMenu )
		
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
		CreateMenu( "{{M_RemoveBounds}}", MenuRemoveBounds, LayerMenu )
		MixContent = CreateMenu( "{{M_MixContent}}", MenuMixContent, LayerMenu )
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
	
		L_DebugVisualizer.SetColorFromHex( "FF00FF" )
		L_DebugVisualizer.Alpha = 0.5
		
		SelectedTile.Visualizer = New LTMarchingAnts
		
		Flipping = False
		
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
		SelectMenuItem( VectorModel )
			
		If FileType( "editor.ini" ) = 1 Then
			Local IniFile:TStream = ReadFile( "editor.ini" )
			If ReadLine( IniFile ).ToInt() = INIVersion Then
				OpenWorld( ReadLine( IniFile ) )
				
				LTMenuSwitch.ReadSwitches( IniFile )
				L_DebugVisualizer.ShowCollisionShapes = LTMenuSwitch.Find( MenuShowCollisionShapes ).State()
				L_DebugVisualizer.ShowVectors = LTMenuSwitch.Find( MenuShowVectors ).State()
				L_DebugVisualizer.ShowNames = LTMenuSwitch.Find( MenuShowNames ).State()
				SnapToGrid = LTMenuSwitch.Find( MenuSnapToGrid ).State()
				ShowGrid = LTMenuSwitch.Find( MenuShowGrid ).State()
				L_ProlongTiles = LTMenuSwitch.Find( MenuProlongTiles ).State()
				ReplacementOfTiles = LTMenuSwitch.Find( MenuReplacementOfTiles ).State()
				
				Select ReadLine( IniFile )
					Case "0"
						SelectMenuItem( StaticModel )
					Case "1"
						SelectMenuItem( VectorModel )
					Case "2"
						SelectMenuItem( AngularModel )
				End Select
				
				SetLanguage( ReadLine( IniFile ).ToInt() )
				
				Grid.CellWidth = ReadLine( IniFile ).ToDouble()
				Grid.CellHeight = ReadLine( IniFile ).ToDouble()
				Grid.CellXDiv = ReadLine( IniFile ).ToInt()
				Grid.CellYDiv = ReadLine( IniFile ).ToInt()
				L_DebugVisualizer.Red = ReadLine( IniFile ).ToInt()
				L_DebugVisualizer.Green = ReadLine( IniFile ).ToInt()
				L_DebugVisualizer.Blue = ReadLine( IniFile ).ToInt()
				
				TileCollisionShapes.GridActive = ReadLine( IniFile ).ToInt()
				TileCollisionShapes.GridCellXDiv = ReadLine( IniFile ).ToInt()
				TileCollisionShapes.GridCellYDiv = ReadLine( IniFile ).ToInt()
				
				For Local N:Int = 0 Until RecentFilesQuantity
					RecentFiles[ N ] = ReadLine( IniFile )
				Next
			End If
			
			CloseFile( IniFile )
		End If

		MainCamera = World.Camera
		L_CurrentCamera = MainCamera
		FillFileMenu()
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
		SelectedShapes.Clear()
		RealPathsForImages.Clear()
		BigImages.Clear()
		InitParameterNames()
		CurrentViewLayer = AddLayer( "LTLayer" )
		CurrentContainer = CurrentViewLayer
		RefreshProjectManager()
	End Method
	
	
	
	Method OpenWorld( Filename:String )
		If FileType( Filename ) = 0 Then Return
		
		If Not AskForSaving() Then Return
		
		If Filename Then 
			WorldFilename = Filename
			InsertToRecentFiles( Filename )
			ChangeDir( ExtractDir( Filename ) )
			
			World = LTWorld.FromFile( Filename )
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
			
			RealPathsForImages.Clear()
			BigImages.Clear()
			For Local Image:LTImage = Eachin World.Images
				RealPathsForImages.Insert( Image, RealPath( Image.Filename ) )
				BigImages.Insert( Image, LoadImage( Image.Filename ) )
			Next
			
			InitParameterNames()
			AddParameterNames( World )
			
			Changed = False
			SetIncbin()
			
			SetTitle()
			RefreshProjectManager()
		End If
	End Method
	
	
	
	Method SaveWorld:Int( SaveAs:Int = False )
		Local Filename:String = WorldFilename
		If SaveAs Or Not Filename Then Filename = RequestFile( LocalizeString( "{{D_SelectFileNameToSave}}" ), "DWLab world file:lw", True )
		If Filename Then 
			WorldFilename = Filename
			InsertToRecentFiles( Filename )
			ChangeDir( ExtractDir( Filename ) )
			
			For Local Image:LTImage = Eachin World.Images
				Image.Filename = L_ChopFilename( String( RealPathsForImages.ValueForKey( Image ) ) )
			Next
			
			World.SaveToFile( Filename )
			Changed = False
			SetTitle()
			
			If World.IncbinValue Then
				Local File:TStream = WriteFile( StripAll( FileName ) + "_incbin.bmx" )
				WriteLine( File, "Incbin ~q" + StripDir( FileName ) + "~q" )
				For Local Image:LTImage = Eachin World.Images
					WriteLine( File, "Incbin ~q" + Image.Filename + "~q" )
				Next
				WriteLine( File, "SetIncbin( True )" )
			End If
			
			Return True
		End If
	End Method
	
	
	
	Method ExitEditor()
		If Not AskForSaving() Then Return
	
		Local IniFile:TStream = WriteFile( EditorPath + "\editor.ini" )
		
		WriteLine( IniFile, INIVersion )
		WriteLine( IniFile, WorldFilename )
		LTMenuSwitch.SaveSwicthes( IniFile )
		WriteLine( IniFile, SpriteModel )
		
		Select CurrentLanguage
			Case EnglishLanguage
				WriteLine( IniFile, EnglishNum )
			Case RussianLanguage
				WriteLine( IniFile, RussianNum )
		End Select
		
		WriteLine( IniFile, Grid.CellWidth )
		WriteLine( IniFile, Grid.CellHeight )
		WriteLine( IniFile, Grid.CellXDiv )
		WriteLine( IniFile, Grid.CellYDiv )
		WriteLine( IniFile, L_DebugVisualizer.Red )
		WriteLine( IniFile, L_DebugVisualizer.Green )
		WriteLine( IniFile, L_DebugVisualizer.Blue )
		WriteLine( IniFile, TileCollisionShapes.GridActive )
		WriteLine( IniFile, TileCollisionShapes.GridCellXDiv )
		WriteLine( IniFile, TileCollisionShapes.GridCellYDiv )

		For Local N:Int = 0 Until RecentFilesQuantity
			WriteLine( IniFile, RecentFiles[ N ] )
		Next
		
		CloseFile( IniFile )
		
		End
	End Method
	
	
	
	Method Logic()
		PollEvent()
	
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
								AddParameter( ShapeForParameters, SelectedParameter.Name, SelectedParameter.Value )
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
								RemoveObject( Obj, World )
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
						If KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then
							If Not SelectedShapes.IsEmpty() Then
								Buffer = SelectedShapes.Copy()
								SetChanged()
							End If
						Else
							For Local Sprite:LTSprite = Eachin SelectedShapes
								If Sprite.Visualizer.Image Then
									Local NewHeight:Double = Sprite.Width * Sprite.Visualizer.Image.Height() / Sprite.Visualizer.Image.Width()
									Sprite.SetCoords( Sprite.X, Sprite.Y + 0.5 * ( Sprite.Height - NewHeight ) )
									Sprite.SetSize( Sprite.Width, NewHeight )
								End If
							Next
							SetChanged()
						End If
					Case Key_D
						If Not SelectedShapes.IsEmpty() Then
							For Local Shape:LTShape = Eachin SelectedShapes
								InsertIntoContainer( Shape.Clone(), Editor.CurrentContainer )
							Next
							RefreshProjectManager()
							SetChanged()
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
							SetParameter( SelectedShape, "name", Name )
							RefreshParametersListBox()
							SetChanged()
						End If
					Case MenuSetClass
						Local Class:String = SelectedShape.GetParameter( "class" )
						If EnterString( LocalizeString( "{{D_EnterClassNameOfObject}}" ), Class ) Then
							SetParameter( SelectedShape, "class", Class )
							RefreshParametersListBox()
							SetChanged()
						End If
					Case MenuRemove, MenuCut
						If EvData = MenuCut Then
							Buffer.Clear()
							Buffer.AddLast( SelectedShape )
						End If
						RemoveObject( SelectedShape, World )
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
						OpenWorld( RequestFile( LocalizeString( "{{D_SelectFileNameToOpen}}" ), "DWLab world file:lw" ) )
					Case MenuSave
						SaveWorld()
					Case MenuSaveAs
						SaveWorld( True )
					Case MenuExit
						ExitEditor()
						
					Case MenuShowCollisionShapes
						L_DebugVisualizer.ShowCollisionShapes = LTMenuSwitch.Find( MenuShowCollisionShapes ).Toggle()
					Case MenuShowVectors
						L_DebugVisualizer.ShowVectors = LTMenuSwitch.Find( MenuShowVectors ).Toggle()
					Case MenuShowNames
						L_DebugVisualizer.ShowNames = LTMenuSwitch.Find( MenuShowNames ).Toggle()
					Case MenuSnapToGrid
						SnapToGrid = LTMenuSwitch.Find( MenuSnapToGrid ).Toggle()
					Case MenuShowGrid
						ShowGrid = LTMenuSwitch.Find( MenuShowGrid ).Toggle()
					Case MenuGridSettings
						Grid.Settings()
					Case MenuStaticModel
						SelectMenuItem( StaticModel )
					Case MenuVectorModel
						SelectMenuItem( VectorModel )
					Case MenuAngularModel
						SelectMenuItem( AngularModel )
					Case MenuTileMapEditingMode
						EditTileMap( Null )
					Case MenuReplacementOfTiles
						ReplacementOfTiles = LTMenuSwitch.Find( MenuReplacementOfTiles ).Toggle()
					Case MenuProlongTiles
						L_ProlongTiles = LTMenuSwitch.Find( MenuProlongTiles ).Toggle()
					Case MenuCameraProperties
						CameraProperties.Execute()
					Case MenuIncbin
						World.IncbinValue = 1 - World.IncbinValue
						SetIncbin()
						
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
							SetParameter( CurrentViewLayer, "name", LayerName )
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
								SetParameter( Tilemap, "name", Name )
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
									SetParameter( SpriteMap, "name", Name )
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
					Case MenuRemoveBounds
						LTLayer( SelectedShape ).Bounds = Null
						SetChanged()
					Case MenuMixContent
						LTLayer( SelectedShape ).MixContent = 1 - LTLayer( SelectedShape ).MixContent
						SetChanged()
					Case MenuPaste
						If Not Buffer.IsEmpty() Then
							For Local Shape:LTShape = Eachin Buffer
								InsertIntoContainer( Shape.Clone(), SelectedShape )
							Next
							RefreshProjectManager()
							SetChanged()
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
										Next
									End If
								End If
							End If
						End If
					Case HScroller
						If CurrentViewLayer Then 
							If CurrentViewLayer.Bounds Then MainCamera.X = SliderValue( HScroller ) * CurrentViewLayer.Bounds.Width / 10000.0 + 0.5 * MainCamera.Width
						End If
					Case VScroller
						If CurrentViewLayer Then 
							If CurrentViewLayer.Bounds Then MainCamera.Y = SliderValue( VScroller ) * CurrentViewLayer.Bounds.Height / 10000.0 + 0.5 * MainCamera.Height
						End If
				End Select
				
				For Local Shape:LTShape = Eachin SelectedShapes
					Local Visualizer:LTVisualizer = Shape.Visualizer
					Select EventSource()
						Case HiddenOKButton
							Select ActiveGadget()
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
								Case ImgAngleField
									Visualizer.Angle = TextFieldText( ImgAngleField ).ToDouble()
									SetChanged()
							End Select
						Case RedSlider
							Visualizer.Red = 0.01 * SliderValue( RedSlider )
							SetGadgetText( RedField, Shape.Visualizer.Red )
							SetChanged()
						Case GreenSlider
							Visualizer.Green = 0.01 * SliderValue( GreenSlider )
							SetGadgetText( GreenField, Shape.Visualizer.Green )
							SetChanged()
						Case BlueSlider
							Visualizer.Blue = 0.01 * SliderValue( BlueSlider )
							SetGadgetText( BlueField, Shape.Visualizer.Blue )
							SetChanged()
						Case AlphaSlider
							Visualizer.Alpha = 0.01 * SliderValue( AlphaSlider )
							SetGadgetText( AlphaField, Shape.Visualizer.Alpha )
							SetChanged()
						Case ScalingCheckbox
							Visualizer.Scaling = ButtonState( ScalingCheckbox )
							SetChanged()
						Case RotatingCheckbox
							Visualizer.Rotating = ButtonState( RotatingCheckbox )
							SetChanged()
					End Select
				Next
				
				For Local Sprite:LTSprite = Eachin SelectedShapes
					Select EventSource()
						Case HiddenOKButton
							Select ActiveGadget()
								Case DXField
									Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
									If VectorSprite Then
										VectorSprite.DX = TextFieldText( DXField ).ToDouble()
										SetChanged()
									End If
								Case DYField
									Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
									If VectorSprite Then
										VectorSprite.DY = TextFieldText( DYField ).ToDouble()
										SetChanged()
									End If
								Case AngleField
									Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
									If AngularSprite Then
										AngularSprite.Angle = TextFieldText( AngleField ).ToDouble()
										SetChanged()
									End If
								Case VelocityField
									Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
									If AngularSprite Then
										AngularSprite.Velocity = TextFieldText( VelocityField ).ToDouble()
										SetChanged()
									End If
								Case FrameField
									Local Image:LTImage = Sprite.Visualizer.Image
									If Image Then
										Sprite.Frame = L_LimitInt( TextFieldText( FrameField ).ToInt(), 0, Image.FramesQuantity() - 1 )
										SetGadgetText( FrameField, Sprite.Frame )
										SetChanged()
									End If
							End Select
						Case ShapeBox
							Sprite.ShapeType = SelectedGadgetItem( ShapeBox )
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
		
		If Not CurrentViewLayer Then Return
		
		Local Bounds:LTShape = CurrentViewLayer.Bounds
		If Bounds Then
			SetSliderRange( HScroller, Min( 10000.0, 10000.0 * MainCamera.Width / Bounds.Width ), 10000.0 )
			SetSliderRange( VScroller, Min( 10000.0, 10000.0 * MainCamera.Height / Bounds.Height ), 10000.0 )
			If MainCamera.Width < Bounds.Width Then SetSliderValue( HScroller, 10000.0 * MainCamera.LeftX() / Bounds.Width )
			If MainCamera.Height < Bounds.Height Then SetSliderValue( VScroller, 10000.0 * MainCamera.TopY() / Bounds.Height )
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
					Cursor.CollisionsWithSpriteMap( SpriteMap, , Map )
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
		SetClsColor( 255, 255, 255 )		
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
		End If
		
		Flip( False )
		'EndGraphics
	End Method
	
	
	
	Method SelectMenuItem( MenuItem:TGadget, State:Int = 1 )
		If State = 2 Then State = 1 - MenuChecked( MenuItem )
	
		Select Menuitem
			Case StaticModel
				CheckMenu( StaticModel )
				UnCheckMenu( VectorModel )
				UnCheckMenu( AngularModel )
				SelectGadgetItem( Toolbar, MenuStaticModel )
				DeselectGadgetItem( Toolbar, MenuVectorModel )
				DeselectGadgetItem( Toolbar, MenuAngularModel )
				SpriteModel = 0
			Case VectorModel
				UnCheckMenu( StaticModel )
				CheckMenu( VectorModel )
				UnCheckMenu( AngularModel )
				DeselectGadgetItem( Toolbar, MenuStaticModel )
				SelectGadgetItem( Toolbar, MenuVectorModel )
				DeselectGadgetItem( Toolbar, MenuAngularModel )
				SpriteModel = 1
			Case AngularModel
				UnCheckMenu( StaticModel )
				UnCheckMenu( VectorModel )
				CheckMenu( AngularModel )
				DeselectGadgetItem( Toolbar, MenuStaticModel )
				DeselectGadgetItem( Toolbar, MenuVectorModel )
				SelectGadgetItem( Toolbar, MenuAngularModel )
				SpriteModel = 2
		End Select
	End Method
	
	
	
	Method FillShapeFields()
		If Not CurrentShape Then Return
	
		Local Visualizer:LTVisualizer = CurrentShape.Visualizer
		
		SetGadgetText( XField, L_TrimDouble( CurrentShape.X ) )
		SetGadgetText( YField ,L_TrimDouble( CurrentShape.Y ) )
		SetGadgetText( WidthField, L_TrimDouble( CurrentShape.Width ) )
		SetGadgetText( HeightField, L_TrimDouble( CurrentShape.Height ) )
		SetGadgetText( RedField, L_TrimDouble( Visualizer.Red ) )
		SetGadgetText( GreenField, L_TrimDouble( Visualizer.Green ) )
		SetGadgetText( BlueField, L_TrimDouble( Visualizer.Blue ) )
		SetGadgetText( AlphaField, L_TrimDouble( Visualizer.Alpha ) )
		
		SetSliderValue( RedSlider, 100.0 * Visualizer.Red )
		SetSliderValue( GreenSlider, 100.0 * Visualizer.Green )
		SetSliderValue( BlueSlider, 100.0 * Visualizer.Blue )
		SetSliderValue( AlphaSlider, 100.0 * Visualizer.Alpha )
		
		SetGadgetText( VisDXField, L_TrimDouble( Visualizer.DX ) )
		SetGadgetText( VisDYField, L_TrimDouble( Visualizer.DY ) )
		SetGadgetText( XScaleField, L_TrimDouble( Visualizer.XScale ) )
		SetGadgetText( YScaleField, L_TrimDouble( Visualizer.YScale ) )
		SetGadgetText( ImgAngleField, L_TrimDouble( Visualizer.Angle ) )
		
		SetButtonState( RotatingCheckbox, Visualizer.Rotating )
		SetButtonState( ScalingCheckbox, Visualizer.Scaling )
		
		ClearGadgetItems( ShapeBox )
		
		Local CurrentSprite:LTSprite = LTSprite( CurrentShape )
		If Not CurrentSprite Then Return
		
		SetGadgetText( FrameField, CurrentSprite.Frame )
		
		FillShapeComboBox( ShapeBox )
		SelectGadgetItem( ShapeBox, CurrentSprite.ShapeType )
		
		Local CurrentAngularSprite:LTAngularSprite = LTAngularSprite( CurrentShape )
		If CurrentAngularSprite Then
			SetGadgetText( AngleField, L_TrimDouble( CurrentAngularSprite.Angle ) )
			SetGadgetText( VelocityField, L_TrimDouble( CurrentAngularSprite.Velocity ) )
		End If
		
		Local CurrentVectorSprite:LTVectorSprite = LTVectorSprite( CurrentShape )
		If CurrentVectorSprite Then
			SetGadgetText( DXField, L_TrimDouble( CurrentVectorSprite.DX ) )
			SetGadgetText( DYField, L_TrimDouble( CurrentVectorSprite.DY ) )
		End If
	End Method
	
	
	
	Method FillShapeComboBox( ComboBox:TGadget )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_Pivot}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_Oval}}" ) )
		AddGadgetItem( ComboBox, LocalizeString( "{{I_Rectangle}}" ) )
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
		SetParameter( Layer, "name", LayerName )
		World.AddLast( Layer )
		Return Layer
	End Method
	
	
	
	Method RemoveObject( Obj:Object, Layer:LTLayer = Null )
		If Not Layer Then Layer = World
		Local Sprite:LTSprite = LTSprite( Obj )
		Local Link:TLink = Layer.Children.FirstLink()
		While Link
			If Link.Value() = Obj Then
				Link.Remove()
			Else
				Local Layer:LTLayer = LTLayer( Link.Value() )
				If Layer Then
					RemoveObject( Obj, Layer )
				ElseIf Sprite Then
					Local SpriteMap:LTSpriteMap = LTSpriteMap( Link.Value() )
					If SpriteMap Then SpriteMap.RemoveSprite( Sprite )
				End If
			End If
			
			Link = Link.NextLink()
		WEnd
	End Method
	
	
	
	Method InitImage( Image:LTImage )
		BigImages.Insert( Image, LoadImage( Image.Filename ) )
		World.Images.AddLast( Image )
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
		If World.IncbinValue Then
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
	
	
	
	Method SetParameter( Shape:LTShape, Name:String, Value:String )
		If Shape.Parameters Then
			For Local Parameter:LTParameter = Eachin Shape.Parameters
				If Parameter.Name = Name Then
					Parameter.Value = Value
					Return
				End If
			Next
		End If
		AddParameter( Shape, Name, Value )
	End Method
	
	
	
	Method AddParameter:String( Shape:LTShape, Name:String, Value:String )
		Local Parameter:LTParameter = New LTParameter
		Parameter.Name = Name
		Parameter.Value = Value
		If Not Shape.Parameters Then Shape.Parameters = New TList
		Shape.Parameters.AddLast( Parameter )
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
End Type




	
Function ComparePixmaps:Int( Pixmap1:TPixmap, Pixmap2:TPixmap )
	For Local Y:Int = 0 Until PixmapHeight( Pixmap1 )
		For Local X:Int = 0 Until PixmapWidth( Pixmap1 )
			If ReadPixel( Pixmap1, X, Y ) <> ReadPixel( Pixmap2, X, Y ) Then Return False
		Next
	Next
	Return True
End Function