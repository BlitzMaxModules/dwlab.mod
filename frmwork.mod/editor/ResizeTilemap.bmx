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

Function ResizeTilemap( TileMap:LTTileMap )
	Local Window:TGadget = CreateWindow( "{{W_ResizeTilemap}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( Window )
	Form.NewLine()
	Local XCellsTextField:TGadget = Form.AddTextField( "{{L_HorizontalCells}}", 150 )
	Local YCellsTextField:TGadget = Form.AddTextField( "{{L_VerticalCells}}", 150 )
	Form.NewLine()
	Local XShiftTextField:TGadget = Form.AddTextField( "{{L_HorizontalShift}}", 150 )
	Local YShiftTextField:TGadget = Form.AddTextField( "{{L_VerticalShift}}", 150 )
	Form.NewLine()
	Local Canvas:TGadget = Form.AddCanvas( 480, 480 )
	Form.NewLine()
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )

	Repeat
		SetGraphics( CanvasGraphics( Canvas ) )
		Flip( False )
		SetGraphics( CanvasGraphics( Editor.MainCanvas ) )
		
		WaitEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Exit
					Case CancelButton
						Exit
				End Select
			Case Event_WindowClose
				Exit
		End Select
	Forever
	FreeGadget( Window )
End Function
	
	
	Rem
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
	EndRem