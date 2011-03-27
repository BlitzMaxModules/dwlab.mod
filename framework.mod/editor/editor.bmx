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
Incbin "treeview.png"
Incbin "modifiers.png"

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Const Version:String = "1.2.1"
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
	
	Field LayerMenu:TGadget
	Field TilemapMenu:TGadget
	Field SpriteMenu:TGadget
	
	Field World:LTWorld = New LTWorld
	Field CurrentLayer:LTLayer
	Field CurrentTilemap:LTTileMap
	Field CurrentSprite:LTSprite
	Field CurrentTileset:LTTileset
	Field SelectedObject:Object
	Field TilesQueue:TMap = New TMap
	Field Cursor:LTSprite = New LTSprite
	Field SpriteUnderCursor:LTSprite
	Field SelectedObjects:TList = New TList
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
	Const MenuShowGrid:Int = 5
	Const MenuSnapToGrid:Int = 6
	Const MenuGridSettings:Int = 7
	Const MenuReplacementOfTiles:Int = 9
	Const MenuProlongTiles:Int = 10
	Const MenuExit:Int = 11
	
	Const MenuRename:Int = 12
	Const MenuShiftToTheTop:Int = 13
	Const MenuShiftUp:Int = 14
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

	Const PanelHeight:Int = 268
	Const BarWidth:Int = 207
	
	
	
	Method Init()
		Window  = CreateWindow( "Digital Wizard's Lab world editor", 0, 0, 640, 480 )
		MaximizeWindow( Window )
		
		Toolbar = CreateToolBar( "incbin::toolbar.png", 0, 0, 0, 0, Window )
		SetToolbarTips( Toolbar, [ "New", "Open", "Save", "Save as", "", "Show grid", "Snap to grid", "Grid settings", "", "Auto-changement of tiles", "Prolong tiles" ] )
		
		Local BarHeight:Int = ClientHeight( Window ) - PanelHeight
		MainCanvas = CreateCanvas( 0, 0, ClientWidth( Window ) - BarWidth - 16, ClientHeight( Window ) - 16, Window )
		SetGadgetLayout( MainCanvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		TilesetCanvas = CreateCanvas( ClientWidth( Window ) - BarWidth, 0, BarWidth, 0.5 * ClientHeight( Window ), Window )
		SetGadgetLayout( TilesetCanvas, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		ProjectManager = CreateTreeView( ClientWidth( Window ) - BarWidth, PanelHeight, BarWidth, BarHeight - 24, Window )
		SetGadgetLayout( ProjectManager, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		AddLayerButton = CreateButton( "Add layer", ClientWidth( Window ) - BarWidth, ClientHeight( Window ) - 24, BarWidth, 24, Window )
		SetGadgetLayout( ProjectManager, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Relative )
		TreeViewIcons = LoadIconStrip( "incbin::treeview.png" )
		SetGadgetIconStrip( ProjectManager, TreeViewIcons )
		
		HScroller = CreateSlider( 0, ClientHeight( Window ) - 16, ClientWidth( Window ) - BarWidth - 16, 16, Window, Slider_Scrollbar | Slider_Horizontal )
		SetGadgetLayout( HScroller, Edge_Aligned, Edge_Aligned, Edge_Centered, Edge_Aligned )
		VScroller = CreateSlider( ClientWidth( Window ) - BarWidth - 16, 0, 16, ClientHeight( Window ) - 16, Window, Slider_Scrollbar | Slider_Vertical )
		SetGadgetLayout( VScroller, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Aligned )
		
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
		CreateMenu( "New project", MenuNew, FileMenu )
		CreateMenu( "Open project...", MenuOpen, FileMenu )
		CreateMenu( "Save project...", MenuSave, FileMenu )
		CreateMenu( "Save project as...", MenuSaveAs, FileMenu )
		CreateMenu( "", 0, FileMenu )
		CreateMenu( "Exit", MenuExit, FileMenu )
		
		Local EditMenu:TGadget = CreateMenu( "Edit", 0, WindowMenu( Window ) )
		ShowGrid = CreateMenu( "Show grid", MenuShowGrid, EditMenu )
		SnapToGrid = CreateMenu( "Snap to grid", MenuSnapToGrid, EditMenu )
		CreateMenu( "Grid settings", MenuGridSettings, EditMenu )
		CreateMenu( "", 0, EditMenu )
		ReplacementOfTiles = CreateMenu( "Replacement of tiles", MenuReplacementOfTiles, EditMenu )
		ProlongTiles = CreateMenu( "Prolong tiles", MenuProlongTiles, EditMenu )
		
		UpdateWindowMenu( Window )
		
		LayerMenu = CreateMenu( "Layer menu", 0, null )
		CreateMenu( "Select", MenuSelect, LayerMenu )
		CreateMenu( "Add new layer", MenuAddLayer, LayerMenu )
		CreateMenu( "Add new tilemap", MenuAddTilemap, LayerMenu )
		CreateMenu( "Import tilemap", MenuImportTilemap, LayerMenu )
		CreateMenu( "Import tilemaps", MenuImportTilemaps, LayerMenu )
		CreateMenu( "Remove bounds", MenuRemoveBounds, LayerMenu )
		AddCommonMenuItems( LayerMenu )
		
		TilemapMenu = CreateMenu( "Tilemap menu", 0, null )
		CreateMenu( "Edit", MenuEditTilemap, TilemapMenu )
		CreateMenu( "Select", MenuSelectTileMap, TilemapMenu )
		CreateMenu( "Toggle visibility", MenuToggleVisibility, TilemapMenu )
		CreateMenu( "Toggle activity", MenuToggleActivity, TilemapMenu )
		CreateMenu( "Properties", MenuTilemapSettings, TilemapMenu )
		CreateMenu( "Edit tileset image", MenuEditTileset, TilemapMenu )
		CreateMenu( "Edit tile replacement rules", MenuEditReplacementRules, TilemapMenu )
		CreateMenu( "Set as bounds of current layer", MenuSetBounds, TilemapMenu )
		AddCommonMenuItems( TilemapMenu )
		
		SpriteMenu = CreateMenu( "Sprite menu", 0, null )
		CreateMenu( "Toggle visibility", MenuToggleVisibility, SpriteMenu )
		CreateMenu( "Toggle activity", MenuToggleActivity, SpriteMenu )
		AddCommonMenuItems( SpriteMenu )
		CreateMenu( "Set as bounds of current layer", MenuSetBounds, SpriteMenu )
	
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
			SelectMenuItem( ReplacementOfTiles )
		End If
		
		SetTitle()
	End Method
	
	
	
	Method AddCommonMenuItems( Menu:TGadget )
		CreateMenu( "Rename", MenuRename, Menu )
		CreateMenu( "Shift to the top (Home)", MenuShiftToTheTop, Menu )
		CreateMenu( "Shift up (PgUp)", MenuShiftUp, Menu )
		CreateMenu( "Shift down (PgDn)", MenuShiftDown, Menu )
		CreateMenu( "Shift to the bottom (End)", MenuShiftToTheBottom, Menu )
		CreateMenu( "Remove", MenuRemove, Menu )
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
		World.Clear()
		CurrentTileset = Null
		AddLayer( "Layer 1" )
		RefreshProjectManager()
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
			CurrentLayer = Null
			If Not World.Children.IsEmpty() Then CurrentLayer = LTLayer( World.Children.First() )
			
			For Local Image:LTImage = Eachin L_ImagesList
				InitImage( Image )
			Next
			
			Changed = False
			
			SetTitle()
			RefreshProjectManager( World )
		End If
	End Method
	
	
	
	Method SaveWorld:Int( SaveAs:Int = False )
		Local Filename:String = WorldFilename
		If SaveAs Or Not Filename Then Filename = RequestFile( "Select world file name to save...", "DWLab world file:lw", True )
		If Filename Then 
			WorldFilename = Filename
			ChangeDir( ExtractDir( Filename ) )
			For Local Image:LTImage = Eachin L_ImagesList
				Image.Filename = ChopFilename( String( RealPathsForImages.ValueForKey( Image ) ) )
				Local Tileset:LTTileset = LTTileset( TilesetMap.ValueForKey( Image ) )
				if Tileset Then Tileset.SaveToFile( Image.Filename + ".lts" )
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
		Local EvData:Int = EventData()
		
		Select EvID
			Case Event_GadgetAction
				Select EventSource()
					Case Toolbar
						EvID = Event_MenuAction
					Case ProjectManager
						SelectedObject = GadgetExtra( TGadget( EventExtra() ) )
						If LTLayer( SelectedObject ) Then
							EvID = Event_MenuAction
							EvData = MenuSelect
						ElseIf LTTileMap( SelectedObject ) Then
							EvID = Event_MenuAction
							EvData = MenuEditTilemap
						Else
							CurrentTilemap = Null
							SelectSprite( LTSprite( SelectedObject ) )
							RefreshProjectManager()
						End If
				End Select
			Case Event_MenuAction
				Select EventData()
					Case MenuShiftToTheTop
						EvID = Event_KeyDown
						EvData = Key_Home
					Case MenuShiftUp
						EvID = Event_KeyDown
						EvData = Key_PageUp
					Case MenuShiftDown
						EvID = Event_KeyDown
						EvData = Key_PageDown
					Case MenuShiftToTheBottom
						EvID = Event_KeyDown
						EvData = Key_End
				End Select
		End Select
		
		Select EvID
			Case Event_KeyDown
				Select EvData
					Case Key_Delete
						If Not SelectedObjects.IsEmpty() Then
							For Local Obj:LTActiveObject = Eachin SelectedObjects
								CurrentLayer.Remove( Obj )
							Next
							SetChanged()
							SelectedObjects.Clear()
							RefreshProjectManager()
						End If
					Case Key_PageUp, Key_Home
						If Not SelectedObjects.IsEmpty() Then
							Local SelectedLink:TLink = SelectedObjects.FirstLink()
							Local SpriteLink:TLink = CurrentLayer.Children.FirstLink()
							Local SpritesList:TList = CurrentLayer.Children
							While SpriteLink And SelectedLink
								If SpriteLink.Value() = SelectedLink.Value() And ( SpriteLink.PrevLink() Or EvData = Key_Home ) Then
									if EventData() = Key_PageUp Then
										SpritesList.InsertBeforeLink( SpriteLink.Value(), SpriteLink.PrevLink() )
									Else
										SpritesList.InsertAfterLink( SpriteLink.Value(), SpritesList.LastLink() )
									End If
									SpriteLink.Remove()
									SelectedLink = SelectedLink.NextLink()
								End If
								SpriteLink = SpriteLink.NextLink()
							Wend
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_PageDown, Key_End
						If Not SelectedObjects.IsEmpty() Then
							Local SelectedLink:TLink = SelectedObjects.LastLink()
							Local SpriteLink:TLink = CurrentLayer.Children.LastLink()
							Local SpritesList:TList = CurrentLayer.Children
							While SpriteLink And SelectedLink
								If SpriteLink.Value() = SelectedLink.Value() And ( SpriteLink.NextLink() Or EvData = Key_End ) Then
									if EventData() = Key_PageDown Then
										SpritesList.InsertAfterLink( SpriteLink.Value(), SpriteLink.NextLink() )
									Else
										SpritesList.InsertBeforeLink( SpriteLink.Value(), SpritesList.FirstLink() )
									End If
									SpriteLink.Remove()
									SelectedLink = SelectedLink.PrevLink()
								End If
								SpriteLink = SpriteLink.PrevLink()
							Wend
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_NumAdd
						MainCanvasZ :+ 1
					Case Key_NumSubtract
						MainCanvasZ :- 1
					Case Key_V
						If Not SelectedObjects.IsEmpty() Then
							For Local Obj:LTActiveObject = Eachin SelectedObjects
								Obj.Visible = Not Obj.Visible
							Next
							SetChanged()
							RefreshProjectManager()
						End If
					Case Key_A
						If Not SelectedObjects.IsEmpty() Then
							For Local Obj:LTActiveObject = Eachin SelectedObjects
								Obj.Active = Not Obj.Active
							Next
							SetChanged()
							RefreshProjectManager()
						End If
				End Select
			Case Event_MouseWheel
				If Not Modifiers.IsEmpty() Then SetSpriteModifiers( LTSprite( SelectedObjects.First() ) )
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
				Select EvData
					Case MenuRename
						Local Name:String = EnterString( "Enter name of the object", LTObject( SelectedObject ).GetName() )
						If Name Then
							SetObjectName( LTObject( SelectedObject ), Name )
							RefreshProjectManager()
							SetChanged()
						End If
					Case MenuRemove
						RemoveObject( SelectedObject, World )
						If SelectedObject = CurrentLayer Then CurrentLayer = Null
						If SelectedObject = CurrentTilemap Then CurrentTilemap = Null
						RefreshProjectManager( World )
						SetChanged()
					Case MenuToggleVisibility
						LTSprite( SelectedObject ).Visible = Not LTSprite( SelectedObject ).Visible
						SetChanged()
						RefreshProjectManager()
					Case MenuToggleActivity
						LTSprite( SelectedObject ).Active = Not LTSprite( SelectedObject ).Active
						SetChanged()
						RefreshProjectManager()
				
					' ============================= Main menu ==================================
					
					Case MenuNew
						NewWorld()
					Case MenuOpen
						OpenWorld( RequestFile( "Select world file to open...", "DWLab world file:lw" ) )
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
					Case MenuReplacementOfTiles
						SelectMenuItem( ReplacementOfTiles, 2 )
					Case MenuProlongTiles
						SelectMenuItem( ProlongTiles, 2 )
						
					' ============================= Layer menu ==================================
					
					Case MenuSelect
						SelectLayer( LTLayer( SelectedObject ) )
						CurrentTileMap = Null
					Case MenuAddLayer
						Local LayerName:String = EnterString( "Enter layer name:" )
						If LayerName Then
							Local Layer:LTLayer = New LTLayer
							Layer.SetName( LayerName )
							LTLayer( SelectedObject ).AddLast( Layer )
							SelectLayer( Layer )
							SetChanged()
						End If
					Case MenuAddTilemap
						Local Name:String = EnterString( "Enter tilemap name:" )
						If Name Then
							Local XQuantity:Int = 16
							Local YQuantity:Int = 16
							CurrentTilemap = LTTilemap.Create( XQuantity, YQuantity, 16, 16, 16 )
							LTLayer( SelectedObject ).AddLast( CurrentTilemap )
							SelectedObject = CurrentTilemap
							TilemapSettings()
							SetChanged()
						End If
					Case MenuImportTilemap
						Local TileWidth:Int = 16
						Local TileHeight:Int = 16
						If ChooseParameter( TileWidth, TileHeight, "tile size", "pixels" ) Then
							Local Filename:String = RequestFile( "Select tilemap file to process...", "Image files:png,jpg,bmp" )
							Local TilemapPixmap:TPixmap = LoadPixmap( Filename )
							If Not TilemapPixmap Then
								Notify( "Cannot load tilemap." )
							Else
								Local TilemapWidth:Int = PixmapWidth( TilemapPixmap )
								Local TilemapHeight:Int = PixmapHeight( TilemapPixmap )
								
								If TilemapWidth Mod TileWidth = 0 And TilemapHeight Mod TileHeight = 0 Then
									Local TilesetFilename:String = ChopFilename( RequestFile( "Select file to save tiles image to...", "png", True ) )
									If TilesetFilename Then
										ImportTilemap( TileWidth, TileHeight, TilemapPixmap, TilesetFilename )
										Local Tileset:TImage = LoadImage( TilesetFilename )
										Local Visualizer:LTImageVisualizer = New LTImageVisualizer
										Visualizer.Image = LoadImageFromFile( TilesetFilename, Tileset.Width / TileWidth, Tileset.height / TileHeight )
										CurrentTilemap.Visualizer = Visualizer
										SelectLayer( CurrentLayer )
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
										
										Local TilemapPixmap:TPixmap = LoadPixmap( Filename )
										If TilemapPixmap Then
											Local TilemapWidth:Int = PixmapWidth( TilemapPixmap )
											Local TilemapHeight:Int = PixmapHeight( TilemapPixmap )
											
											If TilemapWidth Mod TileWidth = 0 And TilemapHeight Mod TileHeight = 0 Then
												Local Layer:LTLayer = New LTLayer
												Layer.SetName( "Level " + Num )
												Editor.World.AddLast( Layer )
												Local TileMap:LTTileMap = ImportTilemap( TileWidth, TileHeight, TilemapPixmap, TilesetFilename )
												Tilemap.Visualizer = Visualizer
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
						LTLayer( SelectedObject ).Bounds = Null
						SetChanged()

					' ============================= Tilemap menu ==================================
					
					Case MenuEditTilemap
						CurrentTileMap = LTTileMap( SelectedObject )
						RefreshTilemap()
					Case MenuSelectTileMap
						CurrentTileMap = Null
						SelectSprite( LTSprite( SelectedObject ) )
					Case MenuEditTileset
						SpriteImageProperties( LTSprite( SelectedObject ) )
						RefreshTilemap()
					Case MenuTilemapSettings
						TilemapSettings()
					Case MenuEditReplacementRules
						TilesetProperties( LTTileMap( SelectedObject ) )
					Case MenuSetBounds
						Local Bounds:LTSprite = New LTSprite
						Local Sprite:LTSprite = LTSprite( SelectedObject )
						Bounds.X = Sprite.X
						Bounds.Y = Sprite.Y
						Bounds.Width = Sprite.Width
						Bounds.Height = Sprite.Height
						Bounds.Visualizer = Null
						CurrentLayer.Bounds = Bounds
				End Select
			Case Event_GadgetAction
				Select EventSource()
					Case HScroller
						'MainCamera.X = SliderValue( HScroller ) * CurrentTilemap.Width / 10000.0 + 0.5 * MainCamera.Width
					Case VScroller
						'MainCamera.Y = SliderValue( VScroller ) * CurrentTilemap.Height / 10000.0 + 0.5 * MainCamera.Height
					Case AddLayerButton
						Local Name:String = EnterString( "Enter name of the new layer" )
						If Name Then
							AddLayer( Name )
							RefreshProjectManager( World )
						End If
				End Select
				
				For Local Sprite:LTSprite = Eachin SelectedObjects
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
			Case Event_GadgetMenu
				If EventSource() = ProjectManager Then
					SelectedObject = GadgetExtra( TGadget( EventExtra() ) )
					If LTLayer( SelectedObject ) Then
						PopUpWindowMenu( Window, LayerMenu )
					ElseIf LTTileMap( SelectedObject ) Then
						PopUpWindowMenu( Window, TileMapMenu )
					Else
						PopUpWindowMenu( Window, SpriteMenu )
					End If
				End If
		End Select
		
		If CurrentTilemap Then
			'SetSliderRange( HScroller, Min( 10000.0, 10000.0 * MainCamera.Width / CurrentTilemap.Width ), 10000.0 )
			'SetSliderRange( VScroller, Min( 10000.0, 10000.0 * MainCamera.Height / CurrentTilemap.Height ), 10000.0 )
			'If MainCamera.Width < CurrentTilemap.Width Then SetSliderValue( HScroller, 10000.0 * MainCamera.CornerX() / CurrentTilemap.Width )
			'If MainCamera.Height < CurrentTilemap.Height Then SetSliderValue( VScroller, 10000.0 * MainCamera.CornerY() / CurrentTilemap.Height )
		Else
			'SetSliderRange( HScroller, 1, 1 )
			'SetSliderRange( VScroller, 1, 1 )
		End If
		
		If Not CurrentLayer Then Return
		
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
				debuglog MinY
			EndIf
			TileX = L_LimitInt( Floor( MX ), MinX, CurrentTilemap.FrameMap.XQuantity - 1 )
			TileY = L_LimitInt( Floor( MY ), MinY, CurrentTilemap.FrameMap.YQuantity - 1 )
			Local Image:LTImage = LTImageVisualizer( CurrentTilemap.Visualizer ).Image
			If Image then
				Local FWidth:Float, FHeight:Float
				TilesetCamera.SizeScreenToField( GadgetWidth( TilesetCanvas ), 0, FWidth, FHeight )
				TilesInRow = Image.XCells
				
				If MouseIsOver = TilesetCanvas Then
					Local FX:Float, FY:Float
					TilesetCamera.ScreenToField( MouseX(), MouseY(), FX, FY )
					Local IFX:Int = Floor( FX )
					Local IFY:Int = Floor( FY )
					If IFX >= 0 And IFY >= 0 And IFX < TilesInRow And IFY < Image.YCells Then
						Local TileNumUnderCursor:Int = IFX + TilesInRow * IFY
						If MouseDown( 1 ) Then TileNum[ 0 ] = TileNumUnderCursor
						If MouseDown( 2 ) Then TileNum[ 1 ] = TileNumUnderCursor
						If CurrentTileset And KeyHit( Key_0 )  Then
							Local NewWidth:Int = IFX - ( TileNum0 Mod TilesInRow )
							Local NewHeight:Int = IFY - Floor( TileNum0 / TilesInRow )
							'debugstop
							if NewHeight >= 0 And NewWidth >= 0 Then
								CurrentTileset.BlockWidth[ TileNum0 ] = NewWidth
								CurrentTileset.BlockHeight[ TileNum0 ] = NewHeight
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
			SpriteUnderCursor = Null
			For Local Obj:LTActiveObject = Eachin CurrentLayer.Children
				If Not LTTileMap( Obj ) And Editor.Cursor.CollidesWith( Obj ) Then SpriteUnderCursor = LTSprite( Obj )
			Next
			SelectSprites.Execute()
			MoveSprite.Execute()
			CreateSprite.Execute()
			ModifySprite.Execute()
		End If
		
		Pan.Execute()
		
		SetCameraMagnification( MainCamera, MainCanvas, MainCanvasZ, 32.0 )
		SetCameraMagnification( TilesetCamera, TilesetCanvas, TilesetCanvasZ, TilesetCameraWidth )
		
		If CurrentLayer.Bounds Then MainCamera.LimitWith( CurrentLayer.Bounds )
	End Method
	
	
	
	Method SetCameraMagnification( Camera:LTCamera, Canvas:TGadget, Z:Int, Width:Int )
		Local NewD:Float = 1.0 * GadgetWidth( Canvas ) / Width * ( 1.1 ^ Z )
		Camera.SetMagnification( NewD, NewD )
	End Method
	
	
	
	Method Render()
		If CurrentTileMap Then
			SelectedTile.X = 0.5 + TileX
			SelectedTile.Y = 0.5 + TileY
			SelectedTile.Draw()
			
			TilesetCamera.Viewport.X = 0.5 * TilesetCanvas.GetWidth()
			TilesetCamera.Viewport.Y = 0.5 * TilesetCanvas.GetHeight()
			TilesetCamera.Viewport.Width = TilesetCanvas.GetWidth()
			TilesetCamera.Viewport.Height = TilesetCanvas.GetHeight()
			
			SetGraphics( CanvasGraphics( TilesetCanvas ) )
			Cls
			
			Local Image:LTImage = LTImageVisualizer( CurrentTileMap.Visualizer ).Image
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
					SelectedTile.X = 0.5 * SelectedTile.Width + TileNumN Mod TilesInRow
					SelectedTile.Y = 0.5 * SelectedTile.Height + Floor( TileNumN / TilesInRow )
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
			For Local Sprite:LTSprite = Eachin SelectedObjects
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
		
		'DrawText( SelectedObjects.Count(), 0, 0 )
	End Method
		
	
	
	Method DrawLayerSprites( Layer:LTLayer )
		For Local Obj:LTActiveObject = Eachin Layer
			If LTLayer( Obj ) Then
				DrawLayerSprites( LTLayer( Obj ) )
			Else
				Obj.Draw()
				If Not LTTilemap( Obj )
					Obj.DrawUsingVisualizer( ShapeVisualizer )
					Obj.DrawUsingVisualizer( AngleArrow )
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
		SelectedObjects.Clear()
		SelectedObjects.AddLast( Sprite )
		SetSpriteModifiers( Sprite )
		CurrentSprite = Sprite
		FillSpriteFields()
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
	
	
	
	Method TilemapSettings()
		Local Tilemap:LTTileMap = LTTilemap( SelectedObject )
		Local XQuantity:Int = Tilemap.FrameMap.XQuantity
		Local YQuantity:Int = Tilemap.FrameMap.YQuantity
		If ChooseParameter( XQuantity, YQuantity, "tiles quantity", "tiles" ) Then
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
			CurrentTileset = LTTileset( TilesetMap.ValueForKey( Image ) )
			TilesetCameraWidth = Image.XCells
			TilesetCanvasZ = 0.0
		End If
	End Method
	
	
	
	Method RefreshProjectManager( Layer:LTLayer = Null, Node:TGadget = Null )
		If Not Layer Then Layer = CurrentLayer
		If Not Layer Then Layer = World
		If Not Node Then Node = TreeViewRoot( ProjectManager )
		If GadgetExtra( Node ) = Layer Or ( Layer = World And Node = TreeViewRoot( ProjectManager ) ) Then
			If GadgetExtra( Node ) = CurrentLayer Then
				SetGadgetText( Node, "< " + Layer.GetName() + " >" )
			Else
				SetGadgetText( Node, Layer.GetName() )
			End If
			Local Link:TLink = Node.kids.FirstLink()
			Local SelectedObjectsLink:TLink = Null
			If Not SelectedObjects.IsEmpty() Then SelectedObjectsLink = SelectedObjects.FirstLink()
			For Local Obj:LTActiveObject = Eachin Layer.Children
				Local Icon:Int
				If LTLayer( Obj ) Then
					Icon = 0
				ElseIf LTTIleMap( Obj ) Then
					Icon = 1
				Else
					Icon = 2
				End If
				
				Local Name:String = Obj.GetName()
				Local Sprite:LTSprite = LTSprite( Obj )
				If Sprite Then
					If Not Sprite.Visible Then Name = "(x) " + Name
					If Not Sprite.Active Then Name = "(-) " + Name
				End If
				If Obj = CurrentTilemap Then Name = "< " + Name + " >"
				If SelectedObjectsLink Then
					If SelectedObjectsLink.Value() = Obj Then
						Name = "* " + Name + " *"
						SelectedObjectsLink = SelectedObjectsLink.NextLink()
					End If
				End If
				
				Local CurrentNode:TGadget
				If Link <> Null Then
					CurrentNode = TGadget( Link.Value() )
					ModifyTreeViewNode( CurrentNode, Name, Icon )
					SetGadgetExtra( CurrentNode, Obj )
					Link = Link.NextLink()
				Else
					CurrentNode = AddTreeViewNode( Name, Node, Icon, Obj )
				End If
				If LTLayer( Obj ) Then RefreshProjectManager( LTLayer( Obj ), CurrentNode )
			Next
			While Link <> Null
				FreeTreeViewNode( TGadget( Link.Value() ) )
				Link = Link.NextLink()
			WEnd
		Else
			For Local ChildNode:TGadget = Eachin Node.kids
				Local Obj:Object = GadgetExtra( ChildNode )
				If LTLayer( Obj ) Then RefreshProjectManager( LTLayer( Obj ), ChildNode )
			Next
		End If
	End Method	
	
	
	
	Method AddLayer( LayerName:String )
		Local Layer:LTLayer = New LTLayer
		Layer.SetName( LayerName )
		World.AddLast( Layer )
		SelectLayer( Layer )
	End Method
	
	
	
	Method SelectLayer( Layer:LTLayer )
		CurrentLayer = Layer
		SelectedObjects.Clear()
		Modifiers.Clear()
		RefreshProjectManager( World )
	End Method
	
	
	
	Method RemoveObject( Obj:Object, Layer:LTLayer )
		Layer.Children.Remove( Obj )
		For Local Obj:LTActiveObject = Eachin Layer
			If LTLayer( Obj ) Then RemoveObject( Obj, LTLayer( Obj ) )
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