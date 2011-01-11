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
	If Not Tilemap Then Return
	Local Image:LTImage = LTImageVisualizer( Tilemap.Visualizer ).Image
	If Not Image Then Return
	
	Local Window:TGadget = CreateWindow( "Tileset editor", 730, 500, 0.5 * ClientWidth( Desktop() ) - 365, 0.5 * ClientHeight( Desktop() ) - 250, Editor.Window )
	Local TilesetCanvas:TGadget = CreateCanvas( 0, 0, 500, 500, Window )
	SetGadgetLayout( TilesetCanvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
	Local TileRulesCanvas:TGadget = CreateCanvas( 500, 0, 231, 231, Window )
	SetGadgetLayout( TileRulesCanvas, Edge_Centered, Edge_Aligned, Edge_Aligned, Edge_Centered )
	Local CategoriesList:TGadget = CreateListBox( 500, 231, 231, 245, Window )
	SetGadgetLayout( CategoriesList, Edge_Centered, Edge_Aligned, Edge_Centered, Edge_Aligned )
	Local AddCategoryButton:TGadget = CreateButton( "Add category", 500, 476, 115, 24, Window )
	Local DeleteCategoryButton:TGadget = CreateButton( "Delete category", 615, 476, 115, 24, Window )
	
	Local MouseIsOver:TGadget
	Local Tileset:LTTileset = LTTileset( TilesetMap.ValueForKey( Image ) )
	If Not Tileset Then Tileset = New Tileset
	
	Local CurrentCategory:LTTileCategory
	Local CurrentTileRule:LTTileRule
	
	Repeat
		Local Magnifier:Float = Min( 1.0 * GadgetWidth( TilesetCanvas ) / Image.XCells / Image.Width(), 1.0 * GadgetHeight( TilesetCanvas ) / Image.YCells / Image.Height() )
		Local TileWidth:Float = Magnifier * Image.Width()
		Local TileHeight:Float = Magnifier * Image.Height()
		Local DX:Float = 0.5 * ( GadgetWidth( TilesetCanvas ) - TileWidth * Image.XCells )
		Local DY:Float = 0.5 * ( GadgetHeight( TilesetCanvas ) - TileHeight * Image.YCells )
		
		SetGraphics( CanvasGraphics( TilesetCanvas ) )
		Cls
		
		SetScale( Magnifier, Magnifier )
		For Local Y:Int = 0 Until Image.YCells
			For Local X:Int = 0 Until Image.XCells
				DrawImage( Image.BMaxImage, ( 0.5 + X ) * TileWidth + DX, ( 0.5 + Y ) * TileHeight + DY )
			Next
		Next
		SetScale( 1.0, 1.0 )
		
		SetColor( Editor.Grid.Red, Editor.Grid.Green, Editor.Grid.Blue )
		
		If CurrentCategory Then
			Local N:Int = 1
			For Local TileRule:LTTileRule = Eachin CurrentCategory.TileRules
				For Local Num:Int = Eachin TileRule.TileNums
					Local SX:Int = ( Num Mod Image.XCells ) * TileWidth + DX
					Local SY:Int = Floor( Num / Image.XCells ) * TileHeight + DY
					L_DrawEmptyRect( SX, SY, TileWidth, TileHeight )
					DrawLine( SX, SY, SX + TileWidth, SY + TileHeight )
					DrawLine( SX, SY + TileHeight, SX + TileWidth, SY )
					Local Text:String = N
					DrawText( Text, SX + 0.5 * ( TileWidth - TextWidth( Text ) ), SX + 0.5 * TileHeight - 8 )
				Next
				N :+ 1
			Next
		End If
		
		SetColor( 255, 255, 255 )
		
		SetGraphics( CanvasGraphics( TileRulesCanvas ) )
		
		If CurrentTileRule Then
			SetScale( 32.0 / TileWidth, 32.0 / TileHeight )
			For Local TilePos:LTTilePos = Eachin CurrentTileRule.TilePositions
				DrawImage( Image.BMaxImage, 115 + TilePos.DX * 32, 115 + TilePos.DY * 32, TilePos.TileNum )
			Next
		End If
		
		SetColor( Editor.Grid.Red, Editor.Grid.Green, Editor.Grid.Blue )
		
		For Local Coord:Int = 3 To 227 Step 32
			DrawLine( Coord, 3, Coord, 227 )
			DrawLine( 3, Coord, 227, Coord )
		Next
			
		SetColor( 255, 255, 255 )
		
		PollEvent()
		
		If MouseHit( 1 ) Then
			
		End If
		
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
					Case TileRulesCanvas
						ActivateGadget( TileRulesCanvas )
						DisablePolledInput()
						EnablePolledInput( TileRulesCanvas )
						MouseIsOver = TileRulesCanvas
				End Select
		End Select
	Forever
	
	FreeGadget( Window )
End Function