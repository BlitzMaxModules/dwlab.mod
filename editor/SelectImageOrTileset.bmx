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

Const ImageCanvasSize:Int = 480

Function SelectImageOrTileset:LTObject( Obj:LTObject )
	Local Sprite:LTSprite = LTSprite( Obj )
	Local TileMap:LTTileMap = LTTileMap( Obj )
	Local TileSet:LTTileSet = LTTileSet( Obj )
	
	Local Title:String
	Local Image:LTImage
	Local Frame:Int = -1
	Local ItemName:String = "{{L_Image}}"
	Local SelectedObject:LTObject
	
	If Sprite Then
		Title = "{{W_SelectSpriteImage}}"
		Image = Sprite.Visualizer.GetImage()
		SelectedObject = Image
		Frame = Sprite.Frame
	ElseIf TileMap Then
		Title = "{{W_SelectTilemapTileset}}"
		ItemName = "{{L_Tileset}}"
		If TileMap.TileSet Then Image = TileMap.TileSet.Image
		SelectedObject = TileMap.TileSet
	Else
		Title = "{{W_SelectTilesetImage}}"
		Image = TileSet.Image
		SelectedObject = Image
	End If

	Local Window:TGadget = CreateWindow( Title, 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( Window )
	Form.NewLine()
	Local ComboBox:TGadget = Form.AddComboBox( ItemName, 84, 150 )
	Local AddButton:TGadget = Form.AddButton( "{{B_Add}}", 64 )
	Local ModifyButton:TGadget = Form.AddButton( "{{B_Modify}}", 64 )
	Local RemoveButton:TGadget = Form.AddButton( "{{B_Remove}}", 64 )
	Form.NewLine()
	Local Canvas:TGadget = Form.AddCanvas( ImageCanvasSize, ImageCanvasSize )
	Form.NewLine()
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )

	FillComboBox( ComboBox, TileMap, SelectedObject )
	
	Repeat
		If Image Then
			Frame = PrintImageToCanvas( TImage( Editor.BigImages.ValueForKey( Image ) ), Canvas, Image.XCells, Image.YCells, Frame )
		Else
			RefreshCanvas( Canvas )
		End If
	
		WaitEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case AddButton
						Local NewObject:LTObject
						If TileMap Then
							Local Name:String = EnterString( "{{D_EnterNameOfTileset}}", "Default" )
							If Name Then
								Local NewTileSet:LTTileSet = New LTTileSet
								NewTileSet.Name = Name
								If SelectImageOrTileSet( TileSet ) Then
									Editor.World.TileSets.AddLast( TileSet )
									NewObject = TileSet
								End If
							End If
						Else
							Local Filename:String = RequestFile( LocalizeString( "{{D_SelectImage}}" ), "Image files:png,jpg,bmp" )
							If Filename Then
								Filename = ChopFilename( Filename )
								Local LoadedImage:TImage = LoadImage( Filename )
								If LoadedImage Then
									Local NewImage:LTImage = New LTImage
									NewImage.Filename = Filename
									NewImage.BMaxImage = LoadedImage
									If ImageProperties( NewImage ) Then
										Editor.World.Images.AddLast( NewImage )
										NewObject = NewImage
									End If
								End If
							End If
						End If
						
						If NewObject Then
							SelectedObject = NewObject
							FillComboBox( ComboBox, TileMap, SelectedObject )
						End If
					Case ModifyButton
						If SelectedObject Then 
							If TileMap Then
								SelectImageOrTileSet( SelectedObject )
							Else
								ImageProperties( LTImage( SelectedObject ) )
							End If
						End If
					Case RemoveButton
						If SelectedObject Then
							Local Proceed:Int = True
							If TileMap Then
								If CheckTileSetUsage( LTTileSet( SelectedObject ), Editor.World ) Then
									Proceed = Confirm( LocalizeString( "{{D_TilesetInUse}}" ) )
								End If
								If Proceed Then
									RemoveTileset( LTTileSet( SelectedObject ), Editor.World )
									Editor.World.TileSets.Remove( SelectedObject )
								End If
							Else
								If CheckImageUsage( LTImage( SelectedObject ) ) Then
									Proceed = Confirm( LocalizeString( "{{D_ImageInUse}}" ) )
								End If
								If Proceed Then
									RemoveImage( LTImage( SelectedObject ), Editor.World )
									For Local TileSet:LTTileSet = Eachin Editor.World.TileSets
										If TileSet.Image = Image Then TileSet.Image = Null
									Next
									Editor.World.Images.Remove( SelectedObject )
								End If
							End If
						End If
					Case OKButton
						Local Proceed:Int = True
						If TileSet Then
							If TileSet.TilesQuantity > Image.FramesQuantity() Then
								Proceed = Confirm( LocalizeString( "{{D_TilesetDataLoss}}" ) )
								If Proceed And CheckTileSetUsage( TileSet, Editor.World ) Then
									Proceed = Confirm( LocalizeString( "{{D_TilemapsDataLoss}}" ) )
								End If
							End If
						ElseIf TileMap Then
							If TileMap.TilesQuantity < TileSet.TilesQuantity Then
								Proceed = Confirm( LocalizeString( "{{D_TilemapDataLoss}}" ) )
							End If
						End If
						
						If Proceed Then
							FreeGadget( Window )
							If Sprite Then
								Sprite.Visualizer.SetImage( Image )
								Sprite.Frame = Frame
								Return Sprite
							ElseIf TileMap Then
								TileMap.RefreshTilesQuantity()
								Return TileMap
							Else
								TileSet.RefreshTilesQuantity()
								RefreshTileSetTileMaps( TileSet, Editor.World )
								Return TileSet
							End If
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





Function FillComboBox( ComboBox:TGadget, TileMap:LTTileMap, SelectedObject:LTObject )
	ClearGadgetItems( ComboBox )
	AddGadgetItem( ComboBox, LocalizeString( "{{I_Null}}" ) )
	SelectGadgetItem( ComboBox, 0 )
	If TileMap Then
		For Local TileSet:LTTileSet = Eachin Editor.World.TileSets
			AddGadgetItem( ComboBox, TileSet.Name, , , , TileSet )
			If TileSet = SelectedObject Then SelectGadgetItem( ComboBox, CountGadgetItems( ComboBox ) - 1 )
		Next
	Else
		For Local Image:LTImage = Eachin Editor.World.Images
			AddGadgetItem( ComboBox, StripDir( Image.Filename ), , , , TileSet )
			If Image = SelectedObject Then SelectGadgetItem( ComboBox, CountGadgetItems( ComboBox ) - 1 )
		Next
	End If
End Function





Function CheckImageUsage:Int( Image:LTImage, Layer:LTLayer = Null )
	If Layer Then
		For Local Shape:LTShape = Eachin Layer.Children
			Local ChildLayer:LTLayer = LTLayer( Shape )
			If ChildLayer Then
				Local Value:Int = CheckImageUsage( Image, ChildLayer )
				If Value Then Return True
			Else
				Local Sprite:LTSprite = LTSprite( Shape )
				If Sprite Then If Sprite.Visualizer.GetImage() = Image Then Return True
			End If
		Next
	Else
		For Local TileSet:LTTileSet = Eachin Editor.World.TileSets
			If TileSet.Image = Image Then Return True
		Next
		CheckImageUsage( Image, Editor.World )
	End If
End Function




Function CheckTileSetUsage:Int( TileSet:LTTileSet, Layer:LTLayer )
	For Local Shape:LTShape = Eachin Layer.Children
		Local ChildLayer:LTLayer = LTLayer( Shape )
		If ChildLayer Then
			Local Value:Int = CheckTileSetUsage( TileSet, ChildLayer )
			If Value Then Return True
		Else
			Local TileMap:LTTileMap = LTTileMap( Shape )
			If TileMap Then If TileMap.TileSet = TileSet Then Return True
		End If
	Next
End Function





Function RefreshTileSetTileMaps( TileSet:LTTileSet, Layer:LTLayer )
	For Local Shape:LTShape = Eachin Layer.Children
		Local ChildLayer:LTLayer = LTLayer( Shape )
		If ChildLayer Then
			RefreshTileSetTileMaps( TileSet, ChildLayer )
		Else
			Local TileMap:LTTileMap = LTTileMap( Shape )
			If TileMap Then If TileMap.TileSet = TileSet Then TileMap.RefreshTilesQuantity()
		End If
	Next
End Function





Function RemoveImage( Image:LTImage, Layer:LTLayer )
	For Local Shape:LTShape = Eachin Layer.Children
		Local ChildLayer:LTLayer = LTLayer( Shape )
		If ChildLayer Then
			RemoveImage( Image, ChildLayer )
		Else
			Local Sprite:LTSprite = LTSprite( Shape )
			If Sprite Then If Sprite.Visualizer.GetImage() = Image Then Sprite.Visualizer.SetImage( Null )
		End If
	Next
End Function





Function RemoveTileset( TileSet:LTTileSet, Layer:LTLayer )
	For Local Shape:LTShape = Eachin Layer.Children
		Local ChildLayer:LTLayer = LTLayer( Shape )
		If ChildLayer Then
			RemoveTileset( TileSet, ChildLayer )
		Else
			Local TileMap:LTTileMap = LTTileMap( Shape )
			If TileMap Then If TileMap.TileSet = TileSet Then TileMap.TileSet = Null
		End If
	Next
End Function





Function RefreshCanvas( Canvas:TGadget )
	SetGraphics( CanvasGraphics( Canvas ) )
	Cls
	Flip( False )
	SetGraphics( CanvasGraphics( Editor.MainCanvas ) )
End Function