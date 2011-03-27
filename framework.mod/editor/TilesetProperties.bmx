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

Global TilesetMap:TMap = New TMap

Function TilesetProperties( Tilemap:LTTilemap )
	Local Image:LTImage = LTImageVisualizer( Tilemap.Visualizer ).Image
	If Not Image Then
		Notify( "Load tileset for tilemap first" )
		Return
	End If
	
	Local Window:TGadget = CreateWindow( "Tileset editor", 0.5 * ClientWidth( Desktop() ) - 365, 0.5 * ClientHeight( Desktop() ) - 250, 760, 500, Editor.Window, Window_titlebar | Window_resizable )
	MaximizeWindow( Window )
	
	Local Width:Int = ClientWidth( Window )
	Local Height:Int = ClientHeight( Window )
	
	Local TilesetCanvas:TGadget = CreateCanvas( 0, 0, Width - 263, Height, Window )
	SetGadgetLayout( TilesetCanvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
	Local TileRuleUpButton:TGadget = CreateButton( "up", Width - 263, 0, 19, 24, Window )
	SetGadgetLayout( TileRuleUpButton, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Centered )
	Local TileRuleDownButton:TGadget = CreateButton( "dn", Width - 244, 0, 19, 24, Window )
	SetGadgetLayout( TileRuleDownButton, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Centered )
	Local TileRulesList:TGadget = CreateCanvas( Width - 263, 24, 38, Height - 48, Window )
	SetGadgetLayout( TileRulesList, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Aligned )
	Local AddTileRuleButton:TGadget = CreateButton( "+", Width - 263, Height - 24, 19, 24, Window )
	SetGadgetLayout( AddTileRuleButton, Edge_Centered, Edge_Aligned, Edge_Centered, Edge_Aligned )
	Local DeleteTileRuleButton:TGadget = CreateButton( "-", Width - 244, Height - 24, 19, 24, Window )
	SetGadgetLayout( DeleteTileRuleButton, Edge_Centered, Edge_Aligned, Edge_Centered, Edge_Aligned )
	Local TileRuleCanvas:TGadget = CreateCanvas( Width - 225, 0, 225, 225, Window )
	SetGadgetLayout( TileRuleCanvas, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Centered )

	Local PosPanel:TGadget = CreatePanel( Width - 225, 225, 225, 50, Window )
	SetGadgetLayout( PosPanel, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Centered )
	CreateLabel( "X:", 4, 6, 15, 16, PosPanel, 0 )
	Local XField:TGadget = CreateTextField( 19, 3, 72, 20, PosPanel )
	Local XDividerField:TGadget = CreateTextField( 147, 3, 72, 20, PosPanel )
	CreateLabel( "XDivider:", 99, 5, 45, 16, PosPanel, 0 )
	CreateLabel( "Y:", 4, 29, 15, 16, PosPanel, 0 )
	Local YField:TGadget = CreateTextField( 19, 27, 72, 20, PosPanel )
	CreateLabel( "YDivider:", 99, 29, 48, 16, PosPanel, 0 )
	Local YDividerField:TGadget = CreateTextField( 147, 27, 72, 20, PosPanel )
	Local HiddenOKButton:TGadget = CreateButton( "", 0, 0, 0, 0, PosPanel, Button_OK )
	DisableGadget( PosPanel )
	
	Local CategoriesListBox:TGadget = CreateListBox( Width - 225, 275, 225, Height - 299, Window )
	SetGadgetLayout( CategoriesListBox, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Aligned )
	Local AddCategoryButton:TGadget = CreateButton( "Add ctg", Width - 225, Height - 24, 75, 24, Window )
	SetGadgetLayout( AddCategoryButton, Edge_Centered, Edge_Aligned, Edge_Centered, Edge_Aligned )
	Local DeleteCategoryButton:TGadget = CreateButton( "Del ctg", Width - 150, Height - 24, 75, 24, Window )
	SetGadgetLayout( DeleteCategoryButton, Edge_Centered, Edge_Aligned, Edge_Centered, Edge_Aligned )
	Local CopyCategoryButton:TGadget = CreateButton( "Copy ctg", Width - 75, Height - 24, 75, 24, Window )
	SetGadgetLayout( CopyCategoryButton, Edge_Centered, Edge_Aligned, Edge_Centered, Edge_Aligned )

	
	Local MouseIsOver:TGadget
	Local Tileset:LTTileset = LTTileset( TilesetMap.ValueForKey( Image ) )
	
	If Not Tileset Then
		Tileset = New LTTileset
		Tileset.TilesQuantity = Image.FramesQuantity()
		TilesetMap.Insert( Image, Tileset )
	Else
		RefreshListBox( CategoriesListBox, Tileset.Categories, null )
	End If
	
	Local CurrentCategory:LTTileCategory
	Local CurrentTileRule:LTTileRule
	Local PosDX:Int, PosDY:Int, TIleRulesListDY:Int
	
	Repeat
		Local Magnifier:Float = Min( 1.0 * GadgetWidth( TilesetCanvas ) / Image.XCells / Image.Width(), 1.0 * GadgetHeight( TilesetCanvas ) / Image.YCells / Image.Height() )
		Local TileWidth:Float = Floor( Magnifier * Image.Width() )
		Local TileHeight:Float = Floor( Magnifier * Image.Height() )
		Local DX:Float = 0.5 * ( GadgetWidth( TilesetCanvas ) - TileWidth * Image.XCells )
		Local DY:Float = 0.5 * ( GadgetHeight( TilesetCanvas ) - TileHeight * Image.YCells )
		
		SetGraphics( CanvasGraphics( TilesetCanvas ) )
		SetClsColor( 255, 255, 255 )
		Cls
		
		SetScale( Magnifier, Magnifier )
		For Local Y:Int = 0 Until Image.YCells
			For Local X:Int = 0 Until Image.XCells
				DrawImage( Image.BMaxImage, ( 0.5 + X ) * TileWidth + DX, ( 0.5 + Y ) * TileHeight + DY, X + Y * Image.XCells )
			Next
		Next
		SetScale( 1.0, 1.0 )
		
		Editor.ShapeVisualizer.ApplyColor()
		
		If CurrentCategory Then
			SetAlpha( 0.5 )
			SetBlend( AlphaBlend )
			Local Tiles:TMap = New TMap
			For Local TileRule:LTTileRule = Eachin CurrentCategory.TileRules
				For Local Num:Int = Eachin TileRule.TileNums
					Tiles.Insert( String( Num ), Null )
				Next
			Next
			
			For Local NumString:String = Eachin Tiles.Keys()
				Local Num:Int = NumString.ToInt()
				Local SX:Int = ( Num Mod Image.XCells ) * TileWidth + DX
				Local SY:Int = Floor( Num / Image.XCells ) * TileHeight + DY
				DrawRect( SX, SY, TileWidth, TileHeight )
			Next
			SetAlpha( 1.0 )
		End If
		
		SetColor( 255, 255, 255 )
		
		If CurrentTileRule Then
			For Local Num:Int = Eachin CurrentTileRule.TileNums
				Local SX:Int = ( Num Mod Image.XCells ) * TileWidth + DX
				Local SY:Int = Floor( Num / Image.XCells ) * TileHeight + DY
				LTMarchingAnts.DrawMARect( SX, SY, TileWidth, TileHeight )
			Next
		End If
		
		Flip
		
		SetGraphics( CanvasGraphics( TileRulesList ) )
		SetClsColor( 255, 255, 255 )
		Cls
		
		If CurrentCategory Then
			TileRulesListDY = L_LimitInt( TileRulesListDY, 0, Max( 0, CurrentCategory.TileRules.Count() * 32 - ClientHeight( TileRulesList ) ) )
			Local Y:Int = 20 - TileRulesListDY
			For Local TileRule:LTTileRule = Eachin CurrentCategory.TileRules
				SetScale( 32.0 / Image.Width(), 32.0 / Image.Height() )
				DrawImage( Image.BMaxImage, 20, Y, TileRule.TileNums[ 0 ] )
				If TileRule = CurrentTileRule Then LTMarchingAnts.DrawMARect( 4, Y - 16, 32, 32 )
				Y :+ 32
			Next
			SetScale( 1.0, 1.0 )
		End If
		
		Flip
		
		SetGraphics( CanvasGraphics( TileRuleCanvas ) )
		SetClsColor( 255, 255, 255 )
		Cls
		
		If CurrentTileRule Then
			SetScale( 32.0 / Image.Width(), 32.0 / Image.Height() )
			For Local TilePos:LTTilePos = Eachin CurrentTileRule.TilePositions
				DrawImage( Image.BMaxImage, 112 + TilePos.DX * 32, 112 + TilePos.DY * 32, TilePos.TileNum )
			Next
			DrawImage( Image.BMaxImage, 112, 112, CurrentTileRule.TileNums[ 0 ] )
			SetScale( 1.0, 1.0 )
		End If
		
		Editor.ShapeVisualizer.ApplyColor()

		For Local Coord:Int = 0 To 224 Step 32
			DrawLine( Coord, 0, Coord, 224 )
			DrawLine( 0, Coord, 224, Coord )
		Next
			
		SetColor( 255, 255, 255 )
		LTMarchingAnts.DrawMARect( ( PosDX + 3 ) * 32, ( PosDY + 3 ) * 32, 33, 33 )
		
		Flip
		
		SetGraphics( CanvasGraphics( Editor.MainCanvas ) )
		
		Local LMB:Int = MouseHit( 1 )
		Local RMB:Int = MouseHit( 2 )
		If LMB Or RMB Then
			Select MouseIsOver
				Case TilesetCanvas
					If CurrentTileRule Then
						Local TileNum:Int = L_LimitInt( Floor( ( MouseX() - DX ) / TIleWidth ) + Floor( ( MouseY() - DY ) / TIleHeight ) * Image.XCells, 0, Image.FramesQuantity() - 1 )
						If LMB Then
							If PosDX = 0 And PosDY = 0 Then
								CurrentTileRule.TileNums[ 0 ] = TileNum
							Else
								Local TilePos:LTTilePos = FindTilePos( CurrentTileRule, PosDX, PosDY )
								If Not TIlePos Then
									TilePos = New LTTilePos
									TilePos.DX = PosDX
									TilePos.DY = PosDY
									CurrentTileRule.TilePositions.AddLast( TilePos )
								End If
								TilePos.TileNum = TileNum
							End If
						Else
							Local N:Int
							Local Quantity:Int = CurrentTileRule.TilesQuantity()
							For N = 0 Until Quantity
								If CurrentTileRule.TileNums[ N ] = TileNum Then Exit
							Next
							If N < Quantity Then
								If Quantity > 1 Then L_RemoveItemFromIntArray( CurrentTileRule.TileNums, N )
							Else
								L_AddItemToIntArray( CurrentTileRule.TileNums, TileNum )
							End If
						End If
					End If
				Case TileRulesList
					If CurrentCategory Then
						Local Quantity:Int = CurrentCategory.TileRules.Count()
						If Quantity > 0 Then
							CurrentTileRule = LTTileRule( CurrentCategory.TileRules.ValueAtIndex( L_LimitInt( Floor( ( MouseY() - 4.0 + TileRulesListDY ) / 32.0 ), 0, Quantity - 1 ) ) )
							EnableGadget( PosPanel )
							SetGadgetText( XField, CurrentTileRule.X )
							SetGadgetText( XDividerField, CurrentTileRule.XDivider )
							SetGadgetText( YField, CurrentTileRule.Y )
							SetGadgetText( YDividerField, CurrentTileRule.YDivider )
							PosDX = 0
							PosDY = 0
						End If
					End If
				Case TileRuleCanvas
					PosDX = Floor( MouseX() / 32 ) - 3
					PosDY = Floor( MouseY() / 32 ) - 3
					If RMB Then
						Local TilePos:LTTilePos = FindTilePos( CurrentTileRule, PosDX, PosDY )
						If TilePos Then CurrentTileRule.TilePositions.Remove( TilePos )
					End If
			End Select
		End If
		
		Repeat
			PollEvent()
			
			Select EventID()
				Case Event_WindowClose
					Exit
				Case Event_MouseEnter
					Select EventSource()
						Case TilesetCanvas
							ActivateGadget( TilesetCanvas )
							DisablePolledInput()
							EnablePolledInput( TilesetCanvas )
							MouseIsOver = TilesetCanvas
						Case TileRulesList
							ActivateGadget( TileRulesList )
							DisablePolledInput()
							EnablePolledInput( TileRulesList )
							MouseIsOver = TileRulesList
						Case TileRuleCanvas
							ActivateGadget( TileRuleCanvas )
							DisablePolledInput()
							EnablePolledInput( TileRuleCanvas )
							MouseIsOver = TileRuleCanvas
					End Select
				Case Event_KeyDown
					Select EventData()
						Case Key_Left
							If PosDX > - 3 Then PosDX :- 1
						Case Key_Right
							If PosDX < 3 Then PosDX :+ 1
						Case Key_Up
							If PosDY > - 3 Then PosDY :- 1
						Case Key_Down
							If PosDY < 3 Then PosDY :+ 1
					End Select
				Case Event_MouseWheel
					If EventSource() = TileRulesList Then TIleRulesListDY :- EventData() * 16
				Case Event_GadgetAction
					Select EventSource()
						Case AddCategoryButton, CopyCategoryButton
							Local ES:Object = EventSource()
							Local Name:String = ""
							If ES = CopyCategoryButton Then Name = CurrentCategory.GetName()
							Name = EnterString( "Enter name of new category", Name )
							If Name Then
								Local NewCategory:LTTileCategory = New LTTileCategory
								Tileset.Categories.AddLast(	NewCategory )
								SetObjectName( NewCategory, Name )
								CurrentTileRule = Null
								
								If ES = CopyCategoryButton Then
									Tileset.Init()
									Local Shift:Int = EnterString( "Enter tile shift" ).ToInt()
									For Local Rule:LTTileRule = Eachin CurrentCategory.TileRules
										Local NewRule:LTTileRule = New LTTileRule
										Local Quantity:Int = Rule.TilesQuantity()
										NewRule.TileNums = New Int[ Quantity ]
										For Local N:Int = 0 Until Quantity
											NewRule.TileNums[ N ] = Rule.TileNums[ N ] + Shift
										Next
										For Local Pos:LTTilePos = Eachin Rule.TilePositions
											Local NewPos:LTTilePos = New LTTilePos
											NewPos.DX = Pos.DX
											NewPos.DY = Pos.DY
											If Pos.Category = CurrentCategory.Num Then
												NewPos.TileNum = Pos.TileNum + Shift
											Else
												NewPos.TileNum = Pos.TileNum
											End If
											NewRule.TilePositions.AddLast( NewPos )
										Next
										NewCategory.TileRules.AddLast( NewRule )
									Next	
								End If
								
								CurrentCategory = NewCategory
								RefreshListBox( CategoriesListBox, Tileset.Categories, CurrentCategory )
							End If
						Case DeleteCategoryButton
							If CurrentCategory Then
								Tileset.Categories.Remove( CurrentCategory )
								CurrentCategory = Null
								CurrentTileRule = Null
								DisableGadget( PosPanel )
								RefreshListBox( CategoriesListBox, Tileset.Categories, CurrentCategory )
							End If
						Case AddTileRuleButton
							If CurrentCategory Then
								CurrentTIleRule = New LTTileRule
								CurrentTIleRule.TileNums = New Int[ 1 ]
								CurrentCategory.TileRules.AddLast( CurrentTIleRule )
							End If
						Case DeleteTileRuleButton
							If CurrentTileRule Then
								CurrentCategory.TileRules.Remove( CurrentTileRule )
								CurrentTileRule = Null
								DisableGadget( PosPanel )
							End If
						Case CategoriesListBox
							If CurrentCategory Then
								Local Name:String = EnterString( "Enter name of category", CurrentCategory.GetName() )
								If Name Then
									SetObjectName( CurrentCategory, Name )
									RefreshListBox( CategoriesListBox, Tileset.Categories, CurrentCategory )
								End If
							End If
						Case TileRuleUpButton
							If CurrentCategory Then
								If CurrentCategory.TileRules.First() <> CurrentTileRule Then
									Local Link:TLink = CurrentCategory.TileRules.FindLink( CurrentTileRule )
									CurrentCategory.TileRules.InsertBeforeLink( CurrentTileRule, Link.PrevLink() )
									Link.Remove()
								End If
							End If
						Case TileRuleDownButton
							If CurrentCategory Then
								If CurrentCategory.TileRules.Last() <> CurrentTileRule Then
									Local Link:TLink = CurrentCategory.TileRules.FindLink( CurrentTileRule )
									CurrentCategory.TileRules.InsertAfterLink( CurrentTileRule, Link.NextLink() )
									Link.Remove()
								End If
							End If
						Case HiddenOKButton
							If CurrentTileRule Then
								Select ActiveGadget()
									Case XField
										CurrentTileRule.X = TextFieldText( XField ).ToInt()
									Case XDividerField
										CurrentTileRule.XDivider = TextFieldText( XDividerField ).ToInt()
									Case YField
										CurrentTileRule.Y = TextFieldText( YField ).ToInt()
									Case YDividerField
										CurrentTileRule.YDivider = TextFieldText( YDividerField ).ToInt()
								End Select
							End If
					End Select
				Case Event_GadgetSelect
					If EventSource() = CategoriesListBox And EventData() >= 0 Then
						CurrentCategory = LTTileCategory( Tileset.Categories.ValueAtIndex( EventData() ) )
						RefreshListBox( CategoriesListBox, Tileset.Categories, CurrentCategory )
						PosDX = 0
						PosDY = 0
						TIleRulesListDY = 0
						CurrentTileRule = Null
						DisableGadget( PosPanel )
					End If
				Case 0
					Exit
			End Select
		Forever
		
		If EventID() = Event_WindowClose Then Exit
	Forever
	
	FreeGadget( Window )
	Tileset.Init()
End Function





Function FindTilePos:LTTilePos( TileRule:LTTileRule, PosDX:Int, PosDY:Int )
	For Local TilePos:LTTilePos = Eachin TileRule.TilePositions
		If TilePos.DX = PosDX And TilePos.DY = PosDY Then Return TilePos
	Next
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
