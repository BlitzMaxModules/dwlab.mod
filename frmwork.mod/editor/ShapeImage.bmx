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

Global RealPathsForImages:TMap = New TMap
	
Function ShapeImage:Int( Shape:LTShape )
	Local EditWindow:TGadget = CreateWindow( "{{W_SpriteImage}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( EditWindow )
	Form.NewLine()
	Local ImageComboBox:TGadget = Form.AddComboBox( "{{L_Image}}", 84, 150 )
	Local AddImageButton:TGadget = Form.AddButton( "{{B_Add}}", 64 )
	Local ModifyImageButton:TGadget = Form.AddButton( "{{B_Modify}}", 64 )
	Local RemoveImageButton:TGadget = Form.AddButton( "{{B_Remove}}", 64 )
	Form.NewLine()
	Local XCellsTextField:TGadget = Form.AddTextField( "{{L_HorizontalCells}}", 150 )
	Local YCellsTextField:TGadget = Form.AddTextField( "{{L_VerticalCells}}", 150 )
	Form.NewLine()
	Local ImageCanvas:TGadget = Form.AddCanvas( 480, 480 )
	Form.NewLine()
	Local LoadImageButton:TGadget = Form.AddButton( "{{B_LoadImage}}", 136 )
	Local OkButton:TGadget = Form.AddButton( "{{B_OK}}", 64, Button_OK )
	Local CancelButton:TGadget = Form.AddButton( "{{B_Cancel}}", 64, Button_Cancel )
	Form.Finalize()

	Local Image:TImage
	Local Filename:String = ""
	Local Frame:Int = 0
	Local Sprite:LTSprite = LTSprite( Shape )
	If Sprite Then Frame = Sprite.Frame
	Local ShapeImage:LTImage = LTImageVisualizer( Shape.Visualizer ).Image
	
	If ShapeImage Then
		Image = LoadImage( ShapeImage.Filename )
		Filename = ShapeImage.Filename
		SetGadgetText( XCellsTextField, ShapeImage.XCells )
		SetGadgetText( YCellsTextField, ShapeImage.YCells )
	Else
		SetGadgetText( XCellsTextField, 1 )
		SetGadgetText( YCellsTextField, 1 )
	End If
	
	ActivateGadget( ImageCanvas )
	DisablePolledInput()
	EnablePolledInput( ImageCanvas )
	
	Repeat
		Local XCells:Int = TextFieldText( XCellsTextField ).ToInt()
		Local YCells:Int = TextFieldText( YCellsTextField ).ToInt()
		
		Frame = PrintImageToCanvas( Image, ImageCanvas, XCells, YCells, Frame )
		SetGraphics( CanvasGraphics( Editor.MainCanvas ) )
		
		PollEvent()
		
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case LoadImageButton
						Filename = RequestFile( LocalizeString( "{{D_SelectImage}}" ), "Image files:png,jpg,bmp" )
						Filename = ChopFilename( Filename )
						If Filename Then Image = LoadImage( Filename ) Else Image = Null
					Case OKButton
						If Image Then
							If XCells > 0 And YCells > 0 Then
								If Image.Width Mod XCells = 0 And Image.Height Mod YCells = 0 Then
									Local ExitFlag:Int = 0
									Local TileMap:LTTileMap = LTTileMap( Shape )
									If TileMap Then
										Local TotalQuantity:Int = XCells* YCells
										Local TilemapImage:LTImage = LTImageVisualizer( TileMap.Visualizer ).Image
										If TilemapImage Then
											If TilemapImage.FramesQuantity() > TotalQuantity Then
												If Not Confirm( LocalizeString( "{{D_TilemapDataLoss}}" ) ) Then
													ExitFlag = 1
												Else
													TileMap.TilesQuantity = TotalQuantity
													For Local Y:Int = 0 Until TileMap.FrameMap.YQuantity
														For Local X:Int = 0 Until TileMap.FrameMap.XQuantity
															If TileMap.FrameMap.Value[ X, Y ] >= TotalQuantity Then TileMap.FrameMap.Value[ X, Y ] = TotalQuantity - 1
														Next
													Next
												End If
											Else
												TileMap.TilesQuantity = TotalQuantity
											End If
										End If
									End If
									
									If Not ExitFlag Then
										LTImageVisualizer( Shape.Visualizer ).Image = Editor.LoadImageFromFile( Filename, XCells, YCells )
										If Sprite Then Sprite.Frame = Frame
										Editor.SetChanged()
										FreeGadget( EditWindow )
										Return True
									End If
								Else
									Notify( LocalizeString( "{{N_ImageDivideable}}" ), True )
								End If
							Else
								Notify( LocalizeString( "{{N_MoreThanZero}}" ), True )
							End If
						Else
							LTImageVisualizer( Shape.Visualizer ).Image = Null
							Editor.SetChanged()
							FreeGadget( EditWindow )
							Return True
						End If
					Case CancelButton
						Exit
				End Select
			Case Event_WindowClose
				Exit
		End Select
	Forever
	FreeGadget( EditWindow )
	Return False
End Function