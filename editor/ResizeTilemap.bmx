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

Const TilemapsCanvasSize:Int = 480

Function ResizeTilemap( TileMap:LTTileMap )
	Local XQuantity:Int = TileMap.XQuantity
	Local YQuantity:Int = TileMap.YQuantity
		
	Local Window:TGadget = CreateWindow( "{{W_ResizeTilemap}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( Window )
	Form.NewLine()
	Local NewXQuantityTextField:TGadget = Form.AddTextField( "{{L_WidthInTiles}}", 180 )
	SetGadgetText( NewXQuantityTextField, XQuantity )
	ActivateGadget( NewXQuantityTextField )
	Local NewYQuantityTextField:TGadget = Form.AddTextField( "{{L_HeightInTiles}}", 180 )
	SetGadgetText( NewYQuantityTextField, YQuantity )
	Form.NewLine()
	Local XShiftTextField:TGadget = Form.AddTextField( "{{L_HorizontalShift}}", 180 )
	SetGadgetText( XShiftTextField, 0 )
	Local YShiftTextField:TGadget = Form.AddTextField( "{{L_VerticalShift}}", 180 )
	SetGadgetText( YShiftTextField, 0 )
	Form.NewLine()
	Form.AddLabel( "{{L_BlueTileMap}}", 300, Label_Center )
	Form.NewLine()
	Form.AddLabel( "{{L_RedTileMap}}", 300, Label_Center )
	Form.NewLine()
	Local TilemapsCanvas:TGadget = Form.AddCanvas( TilemapsCanvasSize, TilemapsCanvasSize )
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )

	Repeat
		Editor.Render()
	
		SetGraphics( CanvasGraphics( TilemapsCanvas ) )
		SetBlend( AlphaBlend )
		Cls
		
		Local NewXQuantity:Int = NewXQuantityTextField.GetText().ToInt()
		If NewXQuantity < 1 Then NewXQuantity = 1
		Local NewYQuantity:Int = NewYQuantityTextField.GetText().ToInt()
		If NewYQuantity < 1 Then NewYQuantity = 1
		
		Local XShift:Int = XShiftTextField.GetText().ToInt()
		If XShift < 0 Then XShift = 0
		If XShift > Abs( NewXQuantity - XQuantity ) Then XShift = Abs( NewXQuantity - XQuantity )
		Local YShift:Int = YShiftTextField.GetText().ToInt()
		If YShift < 0 Then YShift = 0
		If YShift > Abs( NewYQuantity - YQuantity ) Then YShift = Abs( NewYQuantity - YQuantity )
		
		Local X:Int, Y:Int
		If NewXQuantity > XQuantity Then X = -XShift Else X = XShift
		If NewYQuantity > YQuantity Then Y = -YShift Else Y = YShift
		
		Local MinX:Int = Min( X, 0 )
		Local MinY:Int = Min( Y, 0 )
		Local MaxX:Int = Max( X + NewXQuantity, XQuantity )
		Local MaxY:Int = Max( Y + NewYQuantity, YQuantity )
		Local XScale:Double = 1.0 * TilemapsCanvasSize / ( MaxX - MinX )
		Local YScale:Double = 1.0 * TilemapsCanvasSize / ( MaxY - MinY )
		Local Scale:Double = Min( XScale, YScale )
		Local DX:Int = 0.5 * ( TilemapsCanvasSize - Scale * ( MaxX - MinX ) )
		Local DY:Int = 0.5 * ( TilemapsCanvasSize - Scale * ( MaxY - MinY ) )
		
		SetColor( 255, 0, 0 )
		DrawRect( DX - MinX * XScale, DY - MinY * Scale, XQuantity * Scale, YQuantity * Scale )
		
		SetColor( 0, 0, 255 )
		SetAlpha( 0.5 )
		DrawRect( DX + ( X - MinX ) * XScale, DY + ( Y - MinY ) * Scale, NewXQuantity * Scale, NewYQuantity * Scale )
		
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
		
		Flip( False )
		'EndGraphics
		SetGraphics( CanvasGraphics( Editor.MainCanvas ) )
		
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Local Proceed:Int = True
						If NewXQuantity < XQuantity Or NewYQuantity < YQuantity Then Proceed = Confirm( LocalizeString( "{{D_TilemapDataLoss}}" ) )
						If Proceed Then
							Local OldValue:Int[ , ] = TileMap.Value
							TileMap.SetResolution( NewXQuantity, NewYQuantity )
							For Local TileY:Int = 0 Until NewYQuantity
								If TileY + Y >= 0 And TileY + Y < YQuantity Then
									For Local TileX:Int = 0 Until NewXQuantity
										If TileX + X >= 0 And TileX + X < XQuantity Then TileMap.Value[ TileX, TileY ] = OldValue[ TileX + X, TileY + Y ]
									Next
								End If
							Next
							TileMap.X :+ 0.5 * ( NewXQuantity - XQuantity ) + X
							TileMap.Y :+ 0.5 * ( NewYQuantity - YQuantity ) + Y
							TileMap.Width :* 1.0 * NewXQuantity / XQuantity
							TileMap.Height :* 1.0 * NewYQuantity / YQuantity
							Editor.SetChanged()
							Exit
						End If
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
		Local XQuantity:Int = Tilemap.XQuantity
		Local YQuantity:Int = Tilemap.YQuantity
		If ChooseParameter( XQuantity, YQuantity, LocalizeString( "{{L_TilesQuantity}}" ), LocalizeString( "{{L_Tiles}}" ) ) Then
			If XQuantity < Tilemap.XQuantity Or YQuantity < Tilemap.YQuantity Then
				If Not Confirm( LocalizeString( "{{D_TilemapDataLoss}}" ) ) Then Return
			End If
			Tilemap.SetResolution( XQuantity, YQuantity )
			Tilemap.X = 0.5 * XQuantity
			Tilemap.Y = 0.5 * YQuantity
			Tilemap.Width = XQuantity
			Tilemap.Height = YQuantity
			If TileMap = CurrentTileMap Then RefreshTilemap()
		End If
	End Method
	EndRem