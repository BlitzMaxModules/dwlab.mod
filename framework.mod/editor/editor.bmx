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
include "TSelectShapes.bmx"
include "TMoveShape.bmx"
include "TCreateSprite.bmx"
include "TModifyShape.bmx"
include "TGrid.bmx"
include "TAngleArrow.bmx"
include "TSetTile.bmx"
include "ChooseParameter.bmx"
include "ImportTilemap.bmx"
include "EnterString.bmx"
include "ShapeImageProperties.bmx"
include "TilesetProperties.bmx"

Incbin "english.lng"
Incbin "russian.lng"

Incbin "toolbar.png"
Incbin "treeview.png"
Incbin "modifiers.png"

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Const Version:String = "1.2.4"
	
	Field EnglishLanguage:TMaxGuiLanguage
	Field RussianLanguage:TMaxGuiLanguage
	Field CurrentLanguage:TMaxGuiLanguage
	
	Const EnglishNum:Int = 0
	Const RussianNum:Int = 1
	
	Field Window:TGadget
	
	Field MainCanvas:TGadget
	Field MainCamera:LTCamera = New LTCamera
	Field MainCanvasZ:Int
	
	Field TilesetCanvas:TGadget
	Field TilesetCamera:LTCamera = New LTCamera
	Field TilesetCameraWidth:Int
	Field TilesetCanvasZ:Int
	Field TilesetRectangle:LTSprite = New LTSprite
	
	Field Toolbar:TGadget
	Field TreeViewIcons:TIconStrip
	
	Field MouseIsOver:TGadget
	Field Changed:Int
	
	Field ProjectManager:TGadget
	Field AddLayerButton:TGadget
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
	Field FrameField:TGadget
	Field SelectImageButton:TGadget
	Field RotatingCheckbox:TGadget
	Field ScalingCheckbox:TGadget
	Field ImgAngleField:TGadget
	Field HiddenOKButton:TGadget
	Field HScroller:TGadget
	Field VScroller:TGadget
	
	Field SnapToGrid:TGadget
	Field ShowGrid:TGadget
	Field ReplacementOfTiles:TGadget
	Field ProlongTiles:TGadget
	Field StaticModel:TGadget
	Field VectorModel:TGadget
	Field AngularModel:TGadget
	Field Russian:TGadget
	Field English:TGadget
	
	Field LayerMenu:TGadget
	Field TilemapMenu:TGadget
	Field SpriteMenu:TGadget
	
	Field World:LTWorld = New LTWorld
	Field ImagesMap:TMap = New TMap
	Field TilesetForImage:TMap = New TMap
	Field CurrentLayer:LTLayer
	Field CurrentTilemap:LTTileMap
	Field CurrentShape:LTShape
	Field CurrentTileset:LTTileset
	Field SelectedShape:LTShape
	Field SpriteModel:Int
	Field TilesQueue:TMap = New TMap
	Field Cursor:LTSprite = New LTSprite
	Field ShapeUnderCursor:LTShape
	Field SelectedShapes:TList = New TList
	Field SelectedModifier:LTSprite
	Field ModifiersImage:TImage
	Field Modifiers:TList = New TList
	Field ShapeVisualizer:LTFilledPrimitive = New LTFilledPrimitive
	Field AngleArrow:TAngleArrow = New TAngleArrow
	
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
	Const MenuShowGrid:Int = 5
	Const MenuSnapToGrid:Int = 6
	Const MenuGridSettings:Int = 7
	Const MenuStaticModel:Int = 9
	Const MenuVectorModel:Int = 10
	Const MenuAngularModel:Int = 11
	Const MenuReplacementOfTiles:Int = 13
	Const MenuProlongTiles:Int = 14
	Const MenuExit:Int = 34
	Const MenuRussian:Int = 32
	Const MenuEnglish:Int = 33
	
	Const MenuRename:Int = 35
	Const MenuShiftToTheTop:Int = 36
	Const MenuShiftUp:Int = 37
	Const MenuShiftDown:Int = 15
	Const MenuShiftToTheBottom:Int = 16
	Const MenuRemove:Int = 17
	Const MenuSetBounds:Int = 28

	Const MenuSelect:Int = 18
	Const MenuAddLayer:Int = 19
	Const MenuAddTilemap:Int = 20
	Const MenuImportTilemap:Int = 21
	Const MenuImportTilemaps:Int = 22
	Const MenuRemoveBounds:Int = 29

	Const MenuToggleVisibility:Int =  30
	Const MenuToggleActivity:Int =  31
		
	Const MenuEditTilemap:Int = 23
	Const MenuSelectTileMap:Int = 27
	Const MenuEditTileset:Int = 24
	Const MenuTilemapSettings:Int = 25
	Const MenuEditReplacementRules:Int = 26

	Const PanelHeight:Int = 292
	Const BarWidth:Int = 207
	
	
	
	Method Init()
		SetLocalizationMode( Localization_On | Localization_Override )
		EnglishLanguage = LoadLanguage( "incbin::english.lng" )
		RussianLanguage = LoadLanguage( "incbin::russian.lng" )
		SetLocalizationLanguage( EnglishLanguage )
	
		Window  = CreateWindow( "{{Title}}", 0, 0, 640, 480 )
		MaximizeWindow( Window )
		
		Toolbar = CreateToolBar( "incbin::toolbar.png", 0, 0, 0, 0, Window )
		SetToolbarTips( Toolbar, [ "{{TB_New}}", "{{TB_Open}}", "{{TB_Save}}", "{{TB_SaveAs}}", "", "{{TB_ShowGrid}}", "{{TB_SnapToGrid}}", "{{TB_GridSettings}}", "", "{{TB_StaticModel}}", "{{TB_VectorModel}}", "{{TB_AngularModel}}", "", "{{TB_AutoChangementOfTiles}}", "{{TB_ProlongTiles}}" ] )
		
		Local BarHeight:Int = ClientHeight( Window ) - PanelHeight
		MainCanvas = CreateCanvas( 0, 0, ClientWidth( Window ) - BarWidth - 16, ClientHeight( Window ) - 16, Window )
		SetGadgetLayout( MainCanvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		TilesetCanvas = CreateCanvas( ClientWidth( Window ) - BarWidth, 0, BarWidth, 0.5 * ClientHeight( Window ), Window )
		SetGadgetLayout( TilesetCanvas, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		ProjectManager = CreateTreeView( ClientWidth( Window ) - BarWidth, PanelHeight, BarWidth, BarHeight - 24, Window )
		SetGadgetLayout( ProjectManager, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		AddLayerButton = CreateButton( "{{B_AddLayer}}", ClientWidth( Window ) - BarWidth, ClientHeight( Window ) - 24, BarWidth, 24, Window )
		SetGadgetLayout( AddLayerButton, Edge_Centered, Edge_Aligned, Edge_Centered, Edge_Aligned )
		TreeViewIcons = LoadIconStrip( "incbin::treeview.png" )
		SetGadgetIconStrip( ProjectManager, TreeViewIcons )
		
		HScroller = CreateSlider( 0, ClientHeight( Window ) - 16, ClientWidth( Window ) - BarWidth - 16, 16, Window, Slider_Scrollbar | Slider_Horizontal )
		SetGadgetLayout( HScroller, Edge_Aligned, Edge_Aligned, Edge_Centered, Edge_Aligned )
		VScroller = CreateSlider( ClientWidth( Window ) - BarWidth - 16, 0, 16, ClientHeight( Window ) - 16, Window, Slider_Scrollbar | Slider_Vertical )
		SetGadgetLayout( VScroller, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		
		Panel = CreatePanel( ClientWidth( Window ) - BarWidth, 0, BarWidth, PanelHeight - 2, Window, Panel_Raised )
		SetGadgetLayout( Panel, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Centered )
		CreateLabel( "{{L_Shape}}", 2, 6, 37, 16, Panel, Label_Right )
		ShapeBox = CreateComboBox( 40, 0, 160, 20, Panel )
		CreateLabel( "{{L_X}}", 2, 27, 37, 16, Panel, Label_Right )
		XField = CreateTextField( 40, 24, 56, 20, Panel )
		CreateLabel( "{{L_Y}}", 131, 27, 13, 16, Panel, Label_Right )
		YField = CreateTextField( 144, 24, 56, 20, Panel )
		CreateLabel( "{{L_Width}}", 2, 51, 37, 16, Panel, Label_Right )
		WidthField = CreateTextField( 40, 48, 56, 20, Panel )
		CreateLabel( "{{L_Height}}", 106, 51, 37, 16, Panel, Label_Right )
		HeightField = CreateTextField( 144, 48, 56, 20, Panel )
		CreateLabel( "{{L_Angle}}", 2, 75, 37, 16, Panel, Label_Right )
		AngleField = CreateTextField( 40, 72, 56, 20, Panel )
		CreateLabel( "{{L_Velocity}}", 100, 75, 44, 16, Panel, Label_Right )
		VelocityField = CreateTextField( 144, 72, 56, 20, Panel )
		CreateLabel( "{{L_DX}}", 2, 99, 37, 16, Panel, Label_Right )
		DXField = CreateTextField( 40, 96, 56, 20, Panel )
		CreateLabel( "{{L_DY}}", 100, 99, 44, 16, Panel, Label_Right )
		DYField = CreateTextField( 144, 96, 56, 20, Panel )
		CreateLabel( "{{L_Red}}", 2, 125, 37, 16, Panel, Label_Right )
		RedField = CreateTextField( 168, 120, 32, 20, Panel )
		RedSlider = CreateSlider( 40, 124, 120, 20, Panel, Slider_Trackbar | Slider_Horizontal )
		SetSliderRange( RedSlider, 0, 100 )
		CreateLabel( "{{L_Green}}", 2, 147, 37, 16, Panel, Label_Right )
		GreenSlider = CreateSlider( 40, 146, 120, 20, Panel, Slider_Trackbar | Slider_Horizontal )
		GreenField = CreateTextField( 168, 144, 32, 20, Panel )
		SetSliderRange( GreenSlider, 0, 100 )
		CreateLabel( "{{L_Blue}}", 2, 171, 37, 16, Panel, Label_Right )
		BlueSlider = CreateSlider( 40, 170, 120, 20, Panel, Slider_Trackbar | Slider_Horizontal )
		BlueField = CreateTextField( 168, 168, 32, 20, Panel )
		SetSliderRange( BlueSlider, 0, 100 )
		CreateLabel( "{{L_Alpha}}", 2, 195, 37, 16, Panel, Label_Right )
		AlphaSlider = CreateSlider( 40, 194, 120, 20, Panel, Slider_Trackbar | Slider_Horizontal )
		AlphaField = CreateTextField( 168, 192, 32, 20, Panel )
		SetSliderRange( AlphaSlider, 0, 100 )
		CreateLabel( "{{L_XScale}}", 2, 216, 37, 16, Panel, Label_Right )
		XScaleField = CreateTextField( 40, 216, 56, 20, Panel )
		CreateLabel( "{{L_YScale}}", 106, 219, 37, 16, Panel, Label_Right )
		YScaleField = CreateTextField( 144, 216, 56, 20, Panel )
		CreateLabel( "{{L_Frame}}", 2, 244, 37, 16, Panel, Label_Right )
		FrameField = CreateTextField( 40, 240, 56, 20, Panel )
		SelectImageButton  =  CreateButton(  "{{B_SelectImage}}",  104,  238,  96,  24,  Panel )
		RotatingCheckbox = CreateButton( "{{CB_Rotation}}", 40, 266, 40, 16, Panel, Button_Checkbox )
		ScalingCheckbox = CreateButton( "{{CB_Scaling}}", 2, 266, 40, 16, Panel, Button_Checkbox )
		CreateLabel( "{{L_ImageAngle}}", 85, 267, 55, 16, Panel, Label_Right )
		ImgAngleField = CreateTextField( 144, 264, 56, 20, Panel )
		HiddenOKButton = CreateButton( "", 0, 0, 0, 0, Panel, Button_OK )
		HideGadget( HiddenOKButton )
				
		MainCamera = LTCamera.Create( GadgetWidth( MainCanvas ), GadgetHeight( MainCanvas ), 32.0 )
		TilesetCamera = LTCamera.Create( GadgetWidth( TilesetCanvas ), GadgetHeight( TilesetCanvas ), 16.0 )
		L_CurrentCamera = MainCamera
		
		
		
		Local FileMenu:TGadget = CreateMenu( "{{M_File}}", 0, WindowMenu( Window ) )
		CreateMenu( "{{M_New}}", MenuNew, FileMenu )
		CreateMenu( "{{M_Open}}", MenuOpen, FileMenu )
		CreateMenu( "{{M_Save}}", MenuSave, FileMenu )
		CreateMenu( "{{M_SaveAs}}", MenuSaveAs, FileMenu )
		CreateMenu( "", 0, FileMenu )
		CreateMenu( "{{M_Exit}}", MenuExit, FileMenu )
		
		Local EditMenu:TGadget = CreateMenu( "{{M_Edit}}", 0, WindowMenu( Window ) )
		ShowGrid = CreateMenu( "{{M_ShowGrid}}", MenuShowGrid, EditMenu )
		SnapToGrid = CreateMenu( "{{M_SnapToGrid}}", MenuSnapToGrid, EditMenu )
		CreateMenu( "{{M_GridSettings}}", MenuGridSettings, EditMenu )
		CreateMenu( "", 0, EditMenu )
		StaticModel = CreateMenu( "{{M_StaticModel}}", MenuStaticModel, EditMenu )
		VectorModel = CreateMenu( "{{M_VectorModel}}", MenuVectorModel, EditMenu )
		AngularModel = CreateMenu( "{{M_AngularModel}}", MenuAngularModel, EditMenu )
		CreateMenu( "", 0, EditMenu )
		ReplacementOfTiles = CreateMenu( "{{M_ReplacementOfTiles}}", MenuReplacementOfTiles, EditMenu )
		ProlongTiles = CreateMenu( "{{M_ProlongTiles}}", MenuProlongTiles, EditMenu )
		
		Local LanguageMenu:TGadget = CreateMenu( "{{M_Language}}", 0, WindowMenu( Window ) )
		English = CreateMenu( "{{M_English}}", MenuEnglish, LanguageMenu )
		Russian = CreateMenu( "{{M_Russian}}", MenuRussian, LanguageMenu )
		
		UpdateWindowMenu( Window )
		
		LayerMenu = CreateMenu( "", 0, null )
		CreateMenu( "{{M_Select}}", MenuSelect, LayerMenu )
		CreateMenu( "{{M_AddLayer}}", MenuAddLayer, LayerMenu )
		CreateMenu( "{{M_AddTilemap}}", MenuAddTilemap, LayerMenu )
		CreateMenu( "{{M_ImportTilemap}}", MenuImportTilemap, LayerMenu )
		CreateMenu( "{{M_ImportTilemaps}}", MenuImportTilemaps, LayerMenu )
		CreateMenu( "{{M_RemoveBounds}}", MenuRemoveBounds, LayerMenu )
		AddCommonMenuItems( LayerMenu )
		
		TilemapMenu = CreateMenu( "", 0, null )
		CreateMenu( "{{M_EditTilemap}}", MenuEditTilemap, TilemapMenu )
		CreateMenu( "{{M_Select}}", MenuSelectTileMap, TilemapMenu )
		CreateMenu( "{{M_ToggleVisibility}}", MenuToggleVisibility, TilemapMenu )
		CreateMenu( "{{M_ToggleActivity}}", MenuToggleActivity, TilemapMenu )
		CreateMenu( "{{M_TileMapSettings}}", MenuTilemapSettings, TilemapMenu )
		CreateMenu( "{{M_EditTileset}}", MenuEditTileset, TilemapMenu )
		CreateMenu( "{{M_EditTileReplacementRules}}", MenuEditReplacementRules, TilemapMenu )
		CreateMenu( "{{M_SetBounds}}", MenuSetBounds, TilemapMenu )
		AddCommonMenuItems( TilemapMenu )
		
		SpriteMenu = CreateMenu( "", 0, null )
		CreateMenu( "{{M_ToggleVisibility}}", MenuToggleVisibility, SpriteMenu )
		CreateMenu( "{{M_ToggleActivity}}", MenuToggleActivity, SpriteMenu )
		AddCommonMenuItems( SpriteMenu )
		CreateMenu( "{{M_SetBounds}}", MenuSetBounds, SpriteMenu )
	
		SetGraphics( CanvasGraphics( MainCanvas ) )
		SetGraphicsParameters()
		
		SetClsColor( 255, 255, 255 )
		
		ModifiersImage = LoadAnimImage( "incbin::modifiers.png", 16, 16, 0, 10 )
		MidHandleImage( ModifiersImage )
		
		ShapeVisualizer.SetColorFromHex( "FF00FF" )
		ShapeVisualizer.Alpha = 0.5
		
		SelectedTile.Visualizer = New LTMarchingAnts
		
		EditorPath = CurrentDir()
		AddLayer( "Layer 1" )
				
		If FileType( "editor.ini" ) = 1 Then
			Local IniFile:TStream = ReadFile( "editor.ini" )
			
			OpenWorld( ReadLine( IniFile ) )
			
			If ReadLine( IniFile ) = "1" Then SelectMenuItem( ShowGrid )
			If ReadLine( IniFile ) = "1" Then SelectMenuItem( SnapToGrid )
			Select ReadLine( IniFile )
				Case "0"
					SelectMenuItem( StaticModel )
				Case "1"
					SelectMenuItem( VectorModel )
				Case "2"
					SelectMenuItem( AngularModel )
			End Select
			If ReadLine( IniFile ) = "1" Then SelectMenuItem( ReplacementOfTiles )
			If ReadLine( IniFile ) = "1" Then SelectMenuItem( ProlongTiles )
			
			SetLanguage( ReadLine( IniFile ).ToInt() )
			
			Grid.CellWidth = ReadLine( IniFile ).ToFloat()
			Grid.CellHeight = ReadLine( IniFile ).ToFloat()
			Grid.CellXDiv = ReadLine( IniFile ).ToInt()
			Grid.CellYDiv = ReadLine( IniFile ).ToInt()
			ShapeVisualizer.Red = ReadLine( IniFile ).ToInt()
			ShapeVisualizer.Green = ReadLine( IniFile ).ToInt()
			ShapeVisualizer.Blue = ReadLine( IniFile ).ToInt()
			
			CloseFile( IniFile )
		Else
			SetLanguage( 0 )
			SelectMenuItem( ReplacementOfTiles )
			SelectMenuItem( VectorModel )
		End If
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
	
	
	
	Method AddCommonMenuItems( Menu:TGadget )
		CreateMenu( "{{M_Rename}}", MenuRename, Menu )
		CreateMenu( "{{M_ShiftToTheTop}}", MenuShiftToTheTop, Menu )
		CreateMenu( "{{M_ShiftUp}}", MenuShiftUp, Menu )
		CreateMenu( "{{M_ShiftDown}}", MenuShiftDown, Menu )
		CreateMenu( "{{M_ShiftToTheBottom}}", MenuShiftToTheBottom, Menu )
		CreateMenu( "{{M_Remove}}", MenuRemove, Menu )
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
		World.Clear()
		CurrentTileset = Null
		AddLayer( "Layer 1" )
		RefreshProjectManager()
	End Method
	
	
	
	Method OpenWorld( Filename:String )
		If Not AskForSaving() Then Return
		
		If Filename Then 
			If FileType( Filename ) = 0 Then Return
			
			ImagesMap.Clear()
			TilesetForImage.Clear()
			
			WorldFilename = Filename
			ChangeDir( ExtractDir( Filename ) )
			
			World = LTWorld( L_LoadFromFile( Filename ) )
			
			CurrentShape = Null
			CurrentLayer = Null
			If Not World.Children.IsEmpty() Then CurrentLayer = LTLayer( World.Children.First() )
			ProcessShapes( World )
			
			Changed = False
			
			SetTitle()
			RefreshProjectManager( World )
		End If
	End Method
	
	
	
	Method SaveWorld:Int( SaveAs:Int = False )
		Local Filename:String = WorldFilename
		If SaveAs Or Not Filename Then Filename = RequestFile( LocalizeString( "{{D_SelectFileNameToSave}}" ), "DWLab world file:lw", True )
		If Filename Then 
			WorldFilename = Filename
			ChangeDir( ExtractDir( Filename ) )
			For Local Image:LTImage = Eachin ImagesMap.Values()
				Image.Filename = ChopFilename( String( RealPathsForImages.ValueForKey( Image ) ) )
			Next
			For Local KeyValue:TKeyValue = Eachin TilesetForImage
				LTTileset( KeyValue.Value() ).SaveToFile( LTImage( KeyValue.Key() ).Filename + ".lts" )
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
		WriteLine( IniFile, SpriteModel )
		WriteLine( IniFile, MenuChecked( ReplacementOfTiles ) )
		WriteLine( IniFile, MenuChecked( ProlongTiles ) )
		
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
		WriteLine( IniFile, ShapeVisualizer.Red )
		WriteLine( IniFile, ShapeVisualizer.Green )
		WriteLine( IniFile, ShapeVisualizer.Blue )
		
		CloseFile( IniFile )
		
		End
	End Method
	
	
	
	Method Logic()
		PollEvent()
	
		Local EvID:Int = EventID()
		Local EvData:Int = EventData()
		
		Select EvID
			Case Event_GadgetAction
				Select EventSource()
					Case Toolbar
						EvID = Event_MenuAction
					Case ProjectManager
						SelectedShape = LTShape( GadgetExtra( TGadget( EventExtra() ) ) )
						If LTLayer( SelectedShape ) Then
							EvID = Event_MenuAction
							EvData = MenuSelect
						ElseIf LTTileMap( SelectedShape ) Then
							EvID = Event_MenuAction
							EvData = MenuEditTilemap
						Else
							DeselectTilemap()
							SelectShape( SelectedShape )
						End If
				End Select
			Case Event_MenuAction
				Select EventData()
					Case MenuShiftToTheTop
						EvID = Event_KeyDown
						EvData = Key_Home
						SelectShape( SelectedShape )
					Case MenuShiftUp
						EvID = Event_KeyDown
						EvData = Key_PageUp
						SelectShape( SelectedShape )
					Case MenuShiftDown
						EvID = Event_KeyDown
						EvData = Key_PageDown
						SelectShape( SelectedShape )
					Case MenuShiftToTheBottom
						EvID = Event_KeyDown
						EvData = Key_End
						SelectShape( SelectedShape )
				End Select
		End Select
		
		Select EvID
			Case Event_KeyDown
				Select EvData
					Case Key_Delete
						If Not SelectedShapes.IsEmpty() Then
							For Local Obj:LTShape = Eachin SelectedShapes
								CurrentLayer.Remove( Obj )
							Next
							SetChanged()
							SelectedShapes.Clear()
							Modifiers.Clear()
							RefreshProjectManager()
						End If
					Case Key_PageUp, Key_End
						If Not SelectedShapes.IsEmpty() Then
							Local SelectedLink:TLink = SelectedShapes.FirstLink()
							Local ShapeLink:TLink = CurrentLayer.Children.FirstLink()
							Local ShapesList:TList = CurrentLayer.Children
							While ShapeLink And SelectedLink
								If ShapeLink.Value() = SelectedLink.Value() And ( ShapeLink.PrevLink() Or EvData = Key_End ) Then
									if EvData = Key_PageUp Then
										ShapesList.InsertBeforeLink( ShapeLink.Value(), ShapeLink.PrevLink() )
									Else
										ShapesList.InsertAfterLink( ShapeLink.Value(), ShapesList.LastLink() )
									End If
									ShapeLink.Remove()
									SelectedLink = SelectedLink.NextLink()
								End If
								ShapeLink = ShapeLink.NextLink()
							Wend
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_PageDown, Key_Home
						If Not SelectedShapes.IsEmpty() Then
							Local SelectedLink:TLink = SelectedShapes.LastLink()
							Local ShapeLink:TLink = CurrentLayer.Children.LastLink()
							Local ShapesList:TList = CurrentLayer.Children
							While ShapeLink And SelectedLink
								If ShapeLink.Value() = SelectedLink.Value() And ( ShapeLink.NextLink() Or EvData = Key_Home ) Then
									if EvData = Key_PageDown Then
										ShapesList.InsertAfterLink( ShapeLink.Value(), ShapeLink.NextLink() )
									Else
										ShapesList.InsertBeforeLink( ShapeLink.Value(), ShapesList.FirstLink() )
									End If
									ShapeLink.Remove()
									SelectedLink = SelectedLink.PrevLink()
								End If
								ShapeLink = ShapeLink.PrevLink()
							Wend
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_NumAdd
						MainCanvasZ :+ 1
					Case Key_NumSubtract
						MainCanvasZ :- 1
					Case Key_V
						If Not SelectedShapes.IsEmpty() Then
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
				Select EvData
					Case MenuRename
						Local Name:String = EnterString( LocalizeString( "{{D_EnterNameOfObject}}" ), SelectedShape.Name )
						If Name Then
							SelectedShape.Name = Name
							RefreshProjectManager()
							SetChanged()
						End If
					Case MenuRemove
						RemoveObject( SelectedShape, World )
						If SelectedShape = CurrentLayer Then CurrentLayer = Null
						If SelectedShape = CurrentTilemap Then DeselectTilemap() Else RefreshProjectManager( World )
						SetChanged()
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
					Case MenuSnapToGrid
						SelectMenuItem( SnapToGrid, 2 )
					Case MenuShowGrid
						SelectMenuItem( ShowGrid, 2 )
					Case MenuGridSettings
						Grid.Settings()
					Case MenuStaticModel
						SelectMenuItem( StaticModel )
					Case MenuVectorModel
						SelectMenuItem( VectorModel )
					Case MenuAngularModel
						SelectMenuItem( AngularModel )
					Case MenuReplacementOfTiles
						SelectMenuItem( ReplacementOfTiles, 2 )
					Case MenuProlongTiles
						SelectMenuItem( ProlongTiles, 2 )
					Case MenuEnglish
						SetLanguage( EnglishNum )
					Case MenuRussian
						SetLanguage( RussianNum )
						
					' ============================= Layer menu ==================================
					
					Case MenuSelect
						DeselectTilemap()
						SelectLayer( LTLayer( SelectedShape ) )
					Case MenuAddLayer
						Local LayerName:String = EnterString( LocalizeString( "{{D_EnterNameOfLayer}}" ) )
						If LayerName Then
							Local Layer:LTLayer = New LTLayer
							Layer.Name = LayerName
							LTLayer( SelectedShape ).AddLast( Layer )
							SelectLayer( Layer )
							SetChanged()
						End If
					Case MenuAddTilemap
						Local Name:String = EnterString( LocalizeString( "{{D_EnterNameOfTilemap}}" ) )
						If Name Then
							Local XQuantity:Int = 16
							Local YQuantity:Int = 16
							CurrentTilemap = LTTilemap.Create( XQuantity, YQuantity, 16, 16, 16 )
							InitShape( CurrentTilemap )
							LTLayer( SelectedShape ).AddLast( CurrentTilemap )
							SelectedShape = CurrentTilemap
							TilemapSettings()
							RefreshProjectManager( World )
							SetChanged()
						End If
					Case MenuImportTilemap
						Local TileWidth:Int = 16
						Local TileHeight:Int = 16
						If ChooseParameter( TileWidth, TileHeight, LocalizeString( "{{L_TileSize}}" ), LocalizeString( "{{L_Pixels}}" ) ) Then
							Local Filename:String = RequestFile( LocalizeString( "{{D_SelectTilemapFile}}" ), "Image files:png,jpg,bmp" )
							Local TilemapPixmap:TPixmap = LoadPixmap( Filename )
							If Not TilemapPixmap Then
								Notify( LocalizeString( "{{N_CannotLoadTilemap}}" ) )
							Else
								Local TilemapWidth:Int = PixmapWidth( TilemapPixmap )
								Local TilemapHeight:Int = PixmapHeight( TilemapPixmap )
								
								If TilemapWidth Mod TileWidth = 0 And TilemapHeight Mod TileHeight = 0 Then
									Local TilesetFilename:String = ChopFilename( RequestFile( LocalizeString( "{{D_SelectFileToSaveImageTo}}" ), "png", True ) )
									If TilesetFilename Then
										CurrentTilemap = ImportTilemap( TileWidth, TileHeight, TilemapPixmap, TilesetFilename )
										Local Tileset:TImage = LoadImage( TilesetFilename )
										Local Visualizer:LTImageVisualizer = New LTImageVisualizer
										Visualizer.Image = LoadImageFromFile( TilesetFilename, Tileset.Width / TileWidth, Tileset.height / TileHeight )
										CurrentTilemap.Visualizer = Visualizer
										InitShape( CurrentTilemap )
										SelectLayer( CurrentLayer )
										SetChanged()
									End If
								Else
									Notify( LocalizeString( "{{N_TilemapSize}}" ) )
								End If
							End If
						End If
					Case MenuImportTilemaps
						Local TileWidth:Int = 16
						Local TileHeight:Int = 16
						If ChooseParameter( TileWidth, TileHeight, LocalizeString( "{{L_TileSize}}" ), LocalizeString( "{{L_Pixels}}" ) ) Then
							Local Path:String = RequestDir( LocalizeString( "{{D_SelectTilemapsDirectory}}" ), CurrentDir() )
							If Path Then 
								Local TilesetFilename:String = ChopFilename( RequestFile( LocalizeString( "{{D_SelectFileToSaveImageTo}}" ), "png", True ) )
								If TilesetFilename Then 
									Local Dir:Int = ReadDir( Path )
									Local Num:Int = 1
									Local Visualizer:LTImageVisualizer = New LTImageVisualizer
									Repeat
										Local Filename:String = NextFile( Dir )
										If Not Filename Then Exit
										If Lower( Right( Filename, 4 ) ) <> ".png" Then Continue
										
										Filename = Path + "\" + Filename
										
										Local TilemapPixmap:TPixmap = LoadPixmap( Filename )
										If TilemapPixmap Then
											Local TilemapWidth:Int = PixmapWidth( TilemapPixmap )
											Local TilemapHeight:Int = PixmapHeight( TilemapPixmap )
											
											If TilemapWidth Mod TileWidth = 0 And TilemapHeight Mod TileHeight = 0 Then
												Local Layer:LTLayer = New LTLayer
												Layer.Name = "Level " + Num
												Editor.World.AddLast( Layer )
												Local TileMap:LTTileMap = ImportTilemap( TileWidth, TileHeight, TilemapPixmap, TilesetFilename )
												Tilemap.Visualizer = Visualizer
												InitShape( TileMap )
												Layer.AddLast( TileMap )
												SelectLayer( Layer )
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
					Case MenuRemoveBounds
						LTLayer( SelectedShape ).Bounds = Null
						SetChanged()

					' ============================= Tilemap menu ==================================
					
					Case MenuEditTilemap
						CurrentTileMap = LTTileMap( SelectedShape )
						RefreshProjectManager( World )
						RefreshTilemap()
					Case MenuSelectTileMap
						SelectShape( SelectedShape )
						DeselectTilemap()
					Case MenuEditTileset
						ShapeImageProperties( SelectedShape )
						InitShape( SelectedShape )
						RefreshTilemap()
					Case MenuTilemapSettings
						TilemapSettings()
					Case MenuEditReplacementRules
						TilesetProperties( LTTileMap( SelectedShape ) )
					Case MenuSetBounds
						Local Bounds:LTShape = New LTShape
						Bounds.X = SelectedShape.X
						Bounds.Y = SelectedShape.Y
						Bounds.Width = SelectedShape.Width
						Bounds.Height = SelectedShape.Height
						Bounds.Visualizer = Null
						CurrentLayer.Bounds = Bounds
						SetChanged()
				End Select
			Case Event_GadgetAction
				Select EventSource()
					Case SelectImageButton
						If Not SelectedShapes.IsEmpty() Then
							Local FirstShape:LTShape = LTShape( SelectedShapes.First() )
							If ShapeImageProperties( FirstShape ) Then
								For Local Shape:LTShape = Eachin SelectedShapes
									LTImageVisualizer( Shape.Visualizer ).Image = LTImageVisualizer( FirstShape.Visualizer ).Image
								Next
							End If
						End If
					Case HScroller
						If CurrentLayer Then 
							If CurrentLayer.Bounds Then MainCamera.X = SliderValue( HScroller ) * CurrentLayer.Bounds.Width / 10000.0 + 0.5 * MainCamera.Width
						End If
					Case VScroller
						If CurrentLayer Then 
							If CurrentLayer.Bounds Then MainCamera.Y = SliderValue( VScroller ) * CurrentLayer.Bounds.Height / 10000.0 + 0.5 * MainCamera.Height
						End If
					Case AddLayerButton
						Local Name:String = EnterString( LocalizeString( "{{D_EnterNameOfLayer}}" ) )
						If Name Then
							AddLayer( Name )
							RefreshProjectManager( World )
						End If
				End Select
				
				For Local Shape:LTShape = Eachin SelectedShapes
					Select EventSource()
						Case HiddenOKButton
							Select ActiveGadget()
								Case XField
									Shape.X = TextFieldText( XField ).ToFloat()
									SetShapeModifiers( Shape )
									SetChanged()
								Case YField
									Shape.Y = TextFieldText( YField ).ToFloat()
									SetShapeModifiers( Shape )
									SetChanged()
								Case WidthField
									Shape.Width = TextFieldText( WidthField ).ToFloat()
									SetShapeModifiers( Shape )
									SetChanged()
								Case HeightField
									Shape.Height = TextFieldText( HeightField ).ToFloat()
									SetShapeModifiers( Shape )
									SetChanged()
								Case RedField
									Shape.Visualizer.Red = TextFieldText( RedField ).ToFloat()
									SetSliderValue( RedSlider, 0.01 * Shape.Visualizer.Red )
									SetChanged()
								Case GreenField
									Shape.Visualizer.Green = TextFieldText( GreenField ).ToFloat()
									SetSliderValue( GreenSlider, 0.01 * Shape.Visualizer.Green )
									SetChanged()
								Case BlueField
									Shape.Visualizer.Blue = TextFieldText( BlueField ).ToFloat()
									SetSliderValue( BlueSlider, 0.01 * Shape.Visualizer.Blue )
									SetChanged()
								Case AlphaField
									Shape.Visualizer.Alpha = TextFieldText( AlphaField ).ToFloat()
									SetSliderValue( AlphaSlider, 0.01 * Shape.Visualizer.Alpha )
									SetChanged()
							End Select
						Case RedSlider
							Shape.Visualizer.Red = 0.01 * SliderValue( RedSlider )
							SetGadgetText( RedField, Shape.Visualizer.Red )
							SetChanged()
						Case GreenSlider
							Shape.Visualizer.Green = 0.01 * SliderValue( GreenSlider )
							SetGadgetText( GreenField, Shape.Visualizer.Green )
							SetChanged()
						Case BlueSlider
							Shape.Visualizer.Blue = 0.01 * SliderValue( BlueSlider )
							SetGadgetText( BlueField, Shape.Visualizer.Blue )
							SetChanged()
						Case AlphaSlider
							Shape.Visualizer.Alpha = 0.01 * SliderValue( AlphaSlider )
							SetGadgetText( AlphaField, Shape.Visualizer.Alpha )
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
										VectorSprite.DX = TextFieldText( DXField ).ToFloat()
										SetChanged()
									End If
								Case DYField
									Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
									If VectorSprite Then
										VectorSprite.DY = TextFieldText( DYField ).ToFloat()
										SetChanged()
									End If
								Case AngleField
									Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
									If AngularSprite Then
										AngularSprite.Angle = TextFieldText( AngleField ).ToFloat()
										SetChanged()
									End If
								Case VelocityField
									Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
									If AngularSprite Then
										AngularSprite.Velocity = TextFieldText( VelocityField ).ToFloat()
										SetChanged()
									End If
								Case XScaleField
									Sprite.Visualizer.XScale = TextFieldText( XScaleField ).ToFloat()
									SetChanged()
								Case YScaleField
									Sprite.Visualizer.YScale = TextFieldText( YScaleField ).ToFloat()
									SetChanged()
								Case FrameField
									Local Image:LTImage = LTImageVisualizer( Sprite.Visualizer ).Image
									If Image Then
										Sprite.Frame = L_LimitInt( TextFieldText( FrameField ).ToInt(), 0, Image.FramesQuantity() - 1 )
										SetGadgetText( FrameField, Sprite.Frame )
										SetChanged()
									End If
								Case ImgAngleField
									LTImageVisualizer( Sprite.Visualizer ).Angle = TextFieldText( ImgAngleField ).ToFloat()
									SetChanged()
							End Select
						Case ScalingCheckbox
							Sprite.Visualizer.Scaling = ButtonState( ScalingCheckbox )
							SetChanged()
						Case RotatingCheckbox
							LTImageVisualizer( Sprite.Visualizer ).Rotating = ButtonState( RotatingCheckbox )
							SetChanged()
						Case ShapeBox
							Sprite.ShapeType = SelectedGadgetItem( ShapeBox )
							SetChanged()
					End Select
				Next
			Case Event_GadgetMenu
				If EventSource() = ProjectManager Then
					SelectedShape = LTShape( GadgetExtra( TGadget( EventExtra() ) ) )
					If LTLayer( SelectedShape ) Then
						PopUpWindowMenu( Window, LayerMenu )
					ElseIf LTTileMap( SelectedShape ) Then
						PopUpWindowMenu( Window, TileMapMenu )
					Else
						PopUpWindowMenu( Window, SpriteMenu )
					End If
				End If
		End Select
		
		If Not CurrentLayer Then Return
		
		Local Bounds:LTShape = CurrentLayer.Bounds
		If Bounds Then
			SetSliderRange( HScroller, Min( 10000.0, 10000.0 * MainCamera.Width / Bounds.Width ), 10000.0 )
			SetSliderRange( VScroller, Min( 10000.0, 10000.0 * MainCamera.Height / Bounds.Height ), 10000.0 )
			If MainCamera.Width < Bounds.Width Then SetSliderValue( HScroller, 10000.0 * MainCamera.CornerX() / Bounds.Width )
			If MainCamera.Height < Bounds.Height Then SetSliderValue( VScroller, 10000.0 * MainCamera.CornerY() / Bounds.Height )
		Else
			SetSliderRange( HScroller, 1, 1 )
			SetSliderRange( VScroller, 1, 1 )
		End If
		
		If CurrentTilemap Then
			EnableGadget( TilesetCanvas )
			ShowGadget( TilesetCanvas )
			DisableGadget( Panel )
			HideGadget( Panel )
			SetGadgetShape( ProjectManager, ClientWidth( Window ) - BarWidth, 0.5 * ClientHeight( Window ), BarWidth, 0.5 * ClientHeight( Window ) - 24 )
		Else
			DisableGadget( TilesetCanvas )
			HideGadget( TilesetCanvas )
			EnableGadget( Panel )
			ShowGadget( Panel )
			SetGadgetShape( ProjectManager, ClientWidth( Window ) - BarWidth, PanelHeight, BarWidth, ClientHeight( Window ) - PanelHeight - 24 )
		End If
		
		Cursor.SetMouseCoords()
		
		SelectedModifier = Null
		For Local Modifier:LTSprite = Eachin Modifiers
			Local MX:Float, MY:Float
			MainCamera.FieldToScreen( Modifier.X, Modifier.Y, MX, MY )
			If MouseX() >= MX - 8 And MouseX() <= MX + 8 And MouseY() >= MY - 8 And MouseY() <= MY + 8 Then
				SelectedModifier = Modifier
				Exit
			End If
		Next
		
		If CurrentTilemap Then
			Local MX:Float, MY:Float
			MainCamera.ScreenToField( MouseX(), MouseY(), MX, MY )
			Local MinX:Int = 0
			Local MinY:Int = 0
			Local TileNum0:Int = TileNum[ 0 ]
			If CurrentTileset Then
				MinX = -CurrentTileset.BlockWidth[ TileNum0 ]
				MinY = -CurrentTileset.BlockHeight[ TileNum0 ]
			EndIf
			TileX = L_LimitInt( Floor( MX ), MinX, CurrentTilemap.FrameMap.XQuantity - 1 )
			TileY = L_LimitInt( Floor( MY ), MinY, CurrentTilemap.FrameMap.YQuantity - 1 )
			Local Image:LTImage = LTImageVisualizer( CurrentTilemap.Visualizer ).Image
			If Image then
				Local FWidth:Float, FHeight:Float
				TilesetCamera.SizeScreenToField( GadgetWidth( TilesetCanvas ), 0, FWidth, FHeight )
				
				If MouseIsOver = TilesetCanvas Then
					Local FX:Float, FY:Float
					TilesetCamera.ScreenToField( MouseX(), MouseY(), FX, FY )
					Local IFX:Int = Floor( FX )
					Local IFY:Int = Floor( FY )
					If IFX >= 0 And IFY >= 0 And IFX < Image.XCells And IFY < Image.YCells Then
						Local TileNumUnderCursor:Int = IFX + Image.XCells * IFY
						If MouseDown( 1 ) Then TileNum[ 0 ] = TileNumUnderCursor
						If MouseDown( 2 ) Then TileNum[ 1 ] = TileNumUnderCursor
						If CurrentTileset And KeyHit( Key_0 )  Then
							Local NewWidth:Int = IFX - ( TileNum0 Mod Image.XCells )
							Local NewHeight:Int = IFY - Floor( TileNum0 / Image.XCells )
							'debugstop
							if NewHeight >= 0 And NewWidth >= 0 Then
								CurrentTileset.BlockWidth[ TileNum0 ] = NewWidth
								CurrentTileset.BlockHeight[ TileNum0 ] = NewHeight
								SetChanged()
							End If							
						End If
					End If
				End If
			End If
			
			If CurrentTileset Then
				Local N:Int = 0
				Local FrameMap:LTIntMap = CurrentTilemap.FrameMap
				For Local StringPos:String = Eachin TilesQueue.Keys()
					Local Pos:Int = StringPos.ToInt()
					CurrentTileset.Enframe( CurrentTilemap, Pos Mod FrameMap.XQuantity, Floor( Pos / FrameMap.XQuantity ) )
					TilesQueue.Remove( StringPos )
					N :+ 1
					If N = 16 Then  Exit
				Next
			End If
			
			SetTile.Execute()
		Else
			ShapeUnderCursor = Null
			For Local Sprite:LTSprite = Eachin CurrentLayer.Children
				If Editor.Cursor.CollidesWithSprite( Sprite ) Then ShapeUnderCursor = Sprite
			Next
			SelectShapes.Execute()
			MoveShape.Execute()
			CreateSprite.Execute()
			ModifyShape.Execute()
		End If
		
		Pan.Execute()
		
		SetCameraMagnification( MainCamera, MainCanvas, MainCanvasZ, 32.0 )
		SetCameraMagnification( TilesetCamera, TilesetCanvas, TilesetCanvasZ, TilesetCameraWidth )
		
		If CurrentLayer.Bounds Then MainCamera.LimitWith( CurrentLayer.Bounds )
		TilesetCamera.LimitWith( TilesetRectangle )
	End Method
	
	
	
	Method SetCameraMagnification( Camera:LTCamera, Canvas:TGadget, Z:Int, Width:Int )
		Local NewD:Float = 1.0 * GadgetWidth( Canvas ) / Width * ( 1.1 ^ Z )
		Camera.SetMagnification( NewD, NewD )
	End Method
	
	
	
	Method Render()
		TilesetCamera.Viewport.X = 0.5 * TilesetCanvas.GetWidth()
		TilesetCamera.Viewport.Y = 0.5 * TilesetCanvas.GetHeight()
		TilesetCamera.Viewport.Width = TilesetCanvas.GetWidth()
		TilesetCamera.Viewport.Height = TilesetCanvas.GetHeight()
		
		If CurrentTileMap Then
			SelectedTile.X = 0.5 + TileX
			SelectedTile.Y = 0.5 + TileY
			SelectedTile.Draw()
			
			SetGraphics( CanvasGraphics( TilesetCanvas ) )
			Cls
			
			Local Image:LTImage = LTImageVisualizer( CurrentTileMap.Visualizer ).Image
			If Image Then
				Local TileWidth:Float, TileHeight:Float
				TilesetCamera.SizeFieldToScreen( 1.0, 1.0, TileWidth, TileHeight )
				SetScale( TileWidth / Image.BMaxImage.Width, TileHeight / Image.BMaxImage.Height )
				'debugstop
				For Local Frame:Int = 0 Until Image.FramesQuantity()
					Local SX:Float, SY:Float
					TilesetCamera.FieldToScreen( 0.5 + Frame Mod Image.XCells, 0.5 + Floor( Frame / Image.XCells ), SX, SY )
					DrawImage( Image.BMaxImage, SX, SY, Frame )
				Next
				
				SetScale( 1.0, 1.0 )
				
				L_CurrentCamera = TilesetCamera
				
				For Local N:Int = 1 To 0 Step -1
					TileNum[ N ] = L_LimitInt( TileNum[ N ], 0, Image.FramesQuantity() - 1 )
					Local TileNumN:Int = TileNum[ N ]
					If CurrentTileset Then
						SelectedTile.Width = 1.0 + CurrentTileset.BlockWidth[ TileNumN ]
						SelectedTile.Height = 1.0 + CurrentTileset.BlockHeight[ TileNumN ]
					Else
						SelectedTile.Width = 1.0
						SelectedTile.Height = 1.0
					EndIf
					SelectedTile.X = 0.5 * SelectedTile.Width + TileNumN Mod Image.XCells
					SelectedTile.Y = 0.5 * SelectedTile.Height + Floor( TileNumN / Image.XCells )
					SelectedTile.Draw()
				Next
				
				L_CurrentCamera = MainCamera
			End If
			
			Flip
		End If
		
		If Not CurrentLayer Then Return
		
		SetGraphics( CanvasGraphics( MainCanvas ) )
		Cls
		
		MainCamera.Viewport.X = 0.5 * MainCanvas.GetWidth()
		MainCamera.Viewport.Y = 0.5 * MainCanvas.GetHeight()
		MainCamera.Viewport.Width = MainCanvas.GetWidth()
		MainCamera.Viewport.Height = MainCanvas.GetHeight()
		MainCamera.Update()
		
		DrawLayerSprites( CurrentLayer )
		
		if MenuChecked( ShowGrid ) Then Grid.Draw()
		
		If CurrentTileMap Then
			If MouseIsOver = MainCanvas Then
				SelectedTile.X = 0.5 * SelectedTile.Width + TileX
				SelectedTile.Y = 0.5 * SelectedTile.Height + TileY
				SelectedTile.Draw()
			End If
		Else
			For Local Shape:LTShape = Eachin SelectedShapes
				Shape.DrawUsingVisualizer( MarchingAnts )
			Next
			
			If SelectShapes.Frame Then SelectShapes.Frame.DrawUsingVisualizer( MarchingAnts )
			
			If Not ModifyShape.DraggingState And Not CreateSprite.DraggingState Then
				SetAlpha( 0.75 )
				For Local Modifier:LTSprite = Eachin Modifiers
					Local X:Float, Y:Float
					L_CurrentCamera.FieldToScreen( Modifier.X, Modifier.Y, X, Y )
					DrawImage( ModifiersImage, X, Y, Modifier.Frame )
				Next
				SetAlpha( 1.0 )
			End If
		End If
		
		'DrawText( SelectedShapes.Count(), 0, 0 )
	End Method
		
	
	
	Method DrawLayerSprites( Layer:LTLayer )
		For Local Shape:LTShape = Eachin Layer
			If LTLayer( Shape ) Then
				DrawLayerSprites( LTLayer( Shape ) )
			Else
				Shape.Draw()
				If Not LTTilemap( Shape )
					Shape.DrawUsingVisualizer( ShapeVisualizer )
					Shape.DrawUsingVisualizer( AngleArrow )
				End If
			End If
		Next
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
	
	
	
	Method FillShapeFields()
		If Not CurrentShape Then Return
	
		SetGadgetText( XField, L_TrimFloat( CurrentShape.X ) )
		SetGadgetText( YField ,L_TrimFloat( CurrentShape.Y ) )
		SetGadgetText( WidthField, L_TrimFloat( CurrentShape.Width ) )
		SetGadgetText( HeightField, L_TrimFloat( CurrentShape.Height ) )
		SetGadgetText( RedField, L_TrimFloat( CurrentShape.Visualizer.Red ) )
		SetGadgetText( GreenField, L_TrimFloat( CurrentShape.Visualizer.Green ) )
		SetGadgetText( BlueField, L_TrimFloat( CurrentShape.Visualizer.Blue ) )
		SetGadgetText( AlphaField, L_TrimFloat( CurrentShape.Visualizer.Alpha ) )
		
		SetSliderValue( RedSlider, 100.0 * CurrentShape.Visualizer.Red )
		SetSliderValue( GreenSlider, 100.0 * CurrentShape.Visualizer.Green )
		SetSliderValue( BlueSlider, 100.0 * CurrentShape.Visualizer.Blue )
		SetSliderValue( AlphaSlider, 100.0 * CurrentShape.Visualizer.Alpha )
		
		ClearGadgetItems( ShapeBox )
		
		Local CurrentSprite:LTSprite = LTSprite( CurrentShape )
		If Not CurrentSprite Then Return
		
		SetGadgetText( FrameField, CurrentSprite.Frame )
		SetGadgetText( XScaleField, L_TrimFloat( CurrentSprite.Visualizer.XScale ) )
		SetGadgetText( YScaleField, L_TrimFloat( CurrentSprite.Visualizer.YScale ) )
		SetGadgetText( ImgAngleField, L_TrimFloat( LTImageVisualizer( CurrentSprite.Visualizer ).Angle ) )
		
		SetButtonState( RotatingCheckbox, LTImageVisualizer( CurrentSprite.Visualizer ).Rotating )
		SetButtonState( ScalingCheckbox, CurrentSprite.Visualizer.Scaling )
		
		AddGadgetItem( ShapeBox, LocalizeString( "{{I_Pivot}}" ) )
		AddGadgetItem( ShapeBox, LocalizeString( "{{I_Circle}}" ) )
		AddGadgetItem( ShapeBox, LocalizeString( "{{I_Rectangle}}" ) )
		SelectGadgetItem( ShapeBox, CurrentSprite.ShapeType )
		
		Local CurrentAngularSprite:LTAngularSprite = LTAngularSprite( CurrentShape )
		If CurrentAngularSprite Then
			SetGadgetText( AngleField, L_TrimFloat( CurrentAngularSprite.Angle ) )
			SetGadgetText( VelocityField, L_TrimFloat( CurrentAngularSprite.Velocity ) )
		End If
		
		Local CurrentVectorSprite:LTVectorSprite = LTVectorSprite( CurrentShape )
		If CurrentVectorSprite Then
			SetGadgetText( DXField, L_TrimFloat( CurrentVectorSprite.DX ) )
			SetGadgetText( DYField, L_TrimFloat( CurrentVectorSprite.DY ) )
		End If
	End Method
	
	
	
	Method SelectShape( Shape:LTShape )
		SelectedShapes.Clear()
		SelectedShapes.AddLast( Shape )
		SetShapeModifiers( Shape )
		CurrentShape = Shape
		FillShapeFields()
		RefreshProjectManager()
	End Method
	
	
	
	Method SetShapeModifiers( Shape:LTShape )
		Modifiers.Clear()
	
		Local SWidth:Float, SHeight:Float
		L_CurrentCamera.SizeFieldToScreen( 0.5 * Shape.Width, 0.5 * Shape.Height, SWidth, SHeight )
		
		If SWidth < 25 Then SWidth = 25
		If SHeight < 25 Then SHeight = 25
		
		AddModifier( Shape, TModifyShape.Move, 0, 0 )
		AddModifier( Shape, TModifyShape.ResizeHorizontally, -SWidth - 9, 0 )
		AddModifier( Shape, TModifyShape.ResizeHorizontally, SWidth + 9, 0 )
		AddModifier( Shape, TModifyShape.ResizeVertically, 0, -SHeight - 9 )
		AddModifier( Shape, TModifyShape.ResizeVertically, 0, +SHeight + 9 )
		AddModifier( Shape, TModifyShape.Resize, -SWidth + 8, -SHeight + 8 )
		AddModifier( Shape, TModifyShape.Resize, SWidth - 8, -SHeight + 8 )
		AddModifier( Shape, TModifyShape.Resize, -SWidth + 8, SHeight - 8 )
		AddModifier( Shape, TModifyShape.Resize, SWidth - 8, SHeight - 8 )
		AddModifier( Shape, TModifyShape.ResizeDiagonally1, SWidth + 9, SHeight + 9 )
		AddModifier( Shape, TModifyShape.ResizeDiagonally1, -SWidth - 9, -SHeight - 9 )
		AddModifier( Shape, TModifyShape.ResizeDiagonally2, -SWidth - 9, SHeight + 9 )
		AddModifier( Shape, TModifyShape.ResizeDiagonally2, SWidth + 9, -SHeight - 9 )
		AddModifier( Shape, TModifyShape.MirrorHorizontally, 0, -17 )
		AddModifier( Shape, TModifyShape.MirrorVertically, 0, 17 )
		
		If Not LTAngularSprite( Shape ) Then Return
		
		AddModifier( Shape, TModifyShape.RotateBackward, -17, 0 )
		AddModifier( Shape, TModifyShape.RotateForward, 17, 0 )		
	End Method
	
	
	
	Method AddModifier( Shape:LTShape, ModType:Int, DX:Int, DY:Int )
		Local Modifier:LTSprite = New LTSprite
		Local FDX:Float, FDY:Float
		L_CurrentCamera.SizeScreenToField( DX, DY, FDX, FDY )
		Modifier.X = Shape.X + FDX
		Modifier.Y = Shape.Y + FDY
		Modifier.Frame = ModType
		Modifier.ShapeType = LTSprite.Rectangle
		Modifiers.AddLast( Modifier )
	End Method
	
	
	
	Method TilemapSettings()
		Local Tilemap:LTTileMap = LTTilemap( SelectedShape )
		Local XQuantity:Int = Tilemap.FrameMap.XQuantity
		Local YQuantity:Int = Tilemap.FrameMap.YQuantity
		If ChooseParameter( XQuantity, YQuantity, LocalizeString( "{{L_TilesQuantity}}" ), LocalizeString( "{{L_Tiles}}" ) ) Then
			If XQuantity < Tilemap.FrameMap.XQuantity Or YQuantity < Tilemap.FrameMap.YQuantity Then
				If Not Confirm( LocalizeString( "{{D_TilemapDataLoss}}" ) ) Then Return
			End If
			Tilemap.FrameMap.SetResolution( XQuantity, YQuantity )
			Tilemap.X = 0.5 * XQuantity
			Tilemap.Y = 0.5 * YQuantity
			Tilemap.Width = XQuantity
			Tilemap.Height = YQuantity
			If TileMap = CurrentTileMap Then RefreshTilemap()
		End If
	End Method
	
	
	
	Method RefreshTilemap()
		If Not CurrentTileMap Then Return
		Local Image:LTImage = LTImageVisualizer( CurrentTileMap.Visualizer ).Image
		If Image Then
			CurrentTileset = LTTileset( TilesetForImage.ValueForKey( Image ) )
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
		End If
	End Method
	
	
	
	Method RefreshProjectManager( Layer:LTLayer = Null, Node:TGadget = Null )
		If Not Layer Then Layer = CurrentLayer
		If Not Layer Then Layer = World
		If Not Node Then Node = TreeViewRoot( ProjectManager )
		If GadgetExtra( Node ) = Layer Or ( Layer = World And Node = TreeViewRoot( ProjectManager ) ) Then
			If GadgetExtra( Node ) = CurrentLayer Then
				SetGadgetText( Node, "< " + Layer.Name + " >" )
			Else
				SetGadgetText( Node, Layer.Name )
			End If
			Local Link:TLink = Node.kids.FirstLink()
			Local SelectedShapesLink:TLink = Null
			If Not SelectedShapes.IsEmpty() Then SelectedShapesLink = SelectedShapes.FirstLink()
			For Local Shape:LTShape = Eachin Layer.Children
				Local Icon:Int
				If LTLayer( Shape ) Then
					Icon = 0
				ElseIf LTTIleMap( Shape ) Then
					Icon = 1
				Else
					Icon = 2
				End If
				
				Local Name:String = Shape.Name
				If Not Shape.Visible Then Name = "(x) " + Name
				If Not Shape.Active Then Name = "(-) " + Name
				
				If Shape = CurrentTilemap Then Name = "< " + Name + " >"
				If SelectedShapesLink Then
					If SelectedShapesLink.Value() = Shape Then
						Name = "* " + Name + " *"
						SelectedShapesLink = SelectedShapesLink.NextLink()
					End If
				End If
				
				Local CurrentNode:TGadget
				If Link <> Null Then
					CurrentNode = TGadget( Link.Value() )
					ModifyTreeViewNode( CurrentNode, Name, Icon )
					SetGadgetExtra( CurrentNode, Shape )
					Link = Link.NextLink()
				Else
					CurrentNode = AddTreeViewNode( Name, Node, Icon, Shape )
				End If
				If LTLayer( Shape ) Then RefreshProjectManager( LTLayer( Shape ), CurrentNode )
			Next
			While Link <> Null
				FreeTreeViewNode( TGadget( Link.Value() ) )
				Link = Link.NextLink()
			WEnd
		Else
			For Local ChildNode:TGadget = Eachin Node.kids
				Local Layer:LTLayer = LTLayer( GadgetExtra( ChildNode ) )
				If Layer Then RefreshProjectManager( Layer, ChildNode )
			Next
		End If
	End Method	
	
	
	
	Method AddLayer( LayerName:String )
		Local Layer:LTLayer = New LTLayer
		Layer.Name = LayerName
		World.AddLast( Layer )
		SelectLayer( Layer )
	End Method
	
	
	
	Method SelectLayer( Layer:LTLayer )
		CurrentLayer = Layer
		SelectedShapes.Clear()
		Modifiers.Clear()
		RefreshProjectManager( World )
	End Method
	
	
	
	Method RemoveObject( Obj:Object, Layer:LTLayer )
		Layer.Children.Remove( Obj )
		For Local Layer:LTLayer = Eachin Layer
			RemoveObject( Obj, Layer )
		Next
	End Method
	
	
	
	Method LoadImageFromFile:LTImage( Filename:String, XCells:Int, YCells:Int )
		For Local Image:LTImage = Eachin ImagesMap.Values()
			If Image.Filename = Filename And Image.XCells = XCells And Image.YCells = YCells Then Return Image
		Next
		Local Image:LTImage = LTImage.FromFile( Filename, XCells, YCells )
		InitImage( Image )
		Return Image
	End Method
	
	
	
	Method ProcessShapes( Layer:LTLayer )
		For Local Shape:LTShape = Eachin Layer
			If LTLayer( Shape ) Then
				ProcessShapes( LTLayer( Shape ) )
			Else
				InitShape( Shape )
			End If
		Next
	End Method
	
	
	
	Method InitImage( Image:LTImage )
		ImagesMap.Insert( Image, Null )
		RealPathsForImages.Insert( Image, RealPath( Image.Filename ) )
	End Method
	
	
	
	Method InitShape( Shape:LTShape )
		Local Image:LTImage = LTImageVisualizer( Shape.Visualizer ).Image
		InitImage( Image )
		If LTTileMap( Shape ) Then
			Local Tileset:LTTileset = LTTileSet( TilesetForImage.ValueForKey( Image ) )
			If Not Tileset Then
				Local TilesetFilename:String = Image.Filename + ".lts"
				If FileType( TilesetFilename ) = 1 Then
					Tileset = LTTileset( L_LoadFromFile( TilesetFilename ) )
				Else
					Tileset = New LTTileset
				End If
				Tileset.TilesQuantity = Image.FramesQuantity()
				TilesetForImage.Insert( Image, Tileset )
			End If
			Tileset.Init()
			If Shape = CurrentTileMap Then
				For Local N:Int = 0 To 1
					L_LimitInt( TileNum[ N ], 0, Image.FramesQuantity() - 1 )
				Next
			End If
		End If
	End Method
	
	
	Method DeselectTilemap()
		If CurrentTileMap Then
			CurrentTileMap = Null
			RefreshProjectManager( World )
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