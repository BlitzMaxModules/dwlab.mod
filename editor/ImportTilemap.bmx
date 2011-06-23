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

Function TilemapImportDialog:Int( Multiple:Int = False )
	Local TileWidth:Int = 16
	Local TileHeight:Int = 16
	If Not ChooseParameter( TileWidth, TileHeight, "{{W_ChooseTileSize}}", "{{L_WidthInPixels}}", "{{L_HeightInPixels}}" ) Then Return False
	
	Local TileSet:LTTileSet
	
	If Not Editor.World.Tilesets.IsEmpty() Then
		Local Window:TGadget =CreateWindow( "{{W_SelectTileSet}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( Window )
		Form.NewLine()
		Local ComboBox:TGadget = Form.AddComboBox( "{{L_Tileset}}", 84, 150 )
		FillComboBox( ComboBox, New LTTileMap, Null )
		Local OKButton:TGadget, CancelButton:TGadget
		AddOKCancelButtons( Form, OKButton, CancelButton )
		
		Repeat
			PollEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case ComboBox
							TileSet = LTTileSet( GadgetItemExtra( ComboBox, SelectedGadgetItem( ComboBox ) ) )
						Case OKButton
							FreeGadget( Window )
							Exit
						Case CancelButton
							FreeGadget( Window )
							Return False
					End Select
				Case Event_WindowClose
					FreeGadget( Window )
					Return False
			End Select
		Forever
	End If
	
	Local ImageInit:Int
	If TileSet Then
		If Not TileSet.Image Then
			Notify( LocalizeString( "{{L_SelectImage}}" ) )
			Return False
		End If
	Else
		TileSet = New LTTileSet
		TileSet.Name = "Imported"
		TileSet.Image = New LTImage
		TileSet.Image.Filename = ChopFilename( RequestFile( LocalizeString( "{{D_SelectFileToSaveImageTo}}" ), "png", True ) )
		If Not TileSet.Image.Filename Then Return False
		ImageInit = True
	End If
	
	If Not Multiple Then
		Local Filename:String = RequestFile( LocalizeString( "{{D_SelectTilemapFile}}" ), "Image files:png,jpg,bmp" )
		If Not FileName Then Return False
		
		Local TilemapPixmap:TPixmap = LoadPixmap( Filename )
		If Not TilemapPixmap Then
			Notify( LocalizeString( "{{N_CannotLoadTilemap}}" ) )
			Return False
		End If
		
		Local TilemapWidth:Int = PixmapWidth( TilemapPixmap )
		Local TilemapHeight:Int = PixmapHeight( TilemapPixmap )
		
		If TilemapWidth Mod TileWidth <> 0 Or TilemapHeight Mod TileHeight <> 0 Then
			Notify( LocalizeString( "{{N_TilemapSize}}" ) )
			Return False
		End If
		
		Editor.CurrentTilemap = ImportTilemap( TileWidth, TileHeight, TilemapPixmap, TileSet )
	Else
		Local Path:String = RequestDir( LocalizeString( "{{D_SelectTilemapsDirectory}}" ), CurrentDir() )
		If Not Path Then Return False
		
		Local Dir:Int = ReadDir( Path )
		Local Num:Int = 1
		Repeat
			Local Filename:String = NextFile( Dir )
			If Not Filename Then Exit
			
			Filename = Path + "\" + Filename
			
			Local TilemapPixmap:TPixmap = LoadPixmap( Filename )
			If TilemapPixmap Then
				Local TilemapWidth:Int = PixmapWidth( TilemapPixmap )
				Local TilemapHeight:Int = PixmapHeight( TilemapPixmap )
				
				If TilemapWidth Mod TileWidth = 0 And TilemapHeight Mod TileHeight = 0 Then
					Local Layer:LTLayer = New LTLayer
					Layer.Name = "LTLayer," + Num
					Editor.World.AddLast( Layer )
					
					Local TileMap:LTTileMap = ImportTilemap( TileWidth, TileHeight, TilemapPixmap, TileSet )
					Layer.AddLast( TileMap )
					Layer.SetBounds( TileMap )
					Num :+ 1
				End If
			End If			
		Forever
	End If
	
	If ImageInit Then
		Editor.InitImage( TileSet.Image )
		Editor.World.Tilesets.AddLast( TileSet )
	Else
		Editor.BigImages.Insert( TileSet.Image, LoadImage( TileSet.Image.Filename ) )
	End If
	TileSet.RefreshTilesQuantity()
	Editor.RefreshTilemap()
	Editor.SetChanged()
	Return True
End Function





Function ImportTilemap:LTTileMap( TileWidth:Int, TileHeight:Int, TileMapPixmap:TPixmap, TileSet:LTTileSet )
	Local TileMapWidth:Int = PixmapWidth( TileMapPixmap )
	Local TileMapHeight:Int = PixmapHeight( TileMapPixmap )
	
	Local TileXQuantity:Int = TileMapWidth / TileWidth
	Local TileYQuantity:Int = TileMapHeight / TileHeight
	
	Local TileMap:LTTileMap = New LTTileMap
	TileMap.SetResolution( TileXQuantity, TileYQuantity )
	Editor.InitTileMap( TileMap )
	
	Local Tiles:TList = New TList
	
	Local Image:TImage = TileSet.Image.BMaxImage
	If Not Image Then
		Local Pixmap:TPixmap = LoadPixmap( TileSet.Image.Filename )
		Local PixmapWidth:Int = PixmapWidth( Pixmap )
		Local PixmapHeight:Int = PixmapHeight( Pixmap )
		If PixmapWidth Mod TileWidth = 0 And PixmapHeight Mod TileHeight = 0 Then
			Image = LoadAnimImage( Pixmap, TileWidth, TileHeight, 0, PixmapWidth / TileWidth * PixmapHeight / TileHeight )
		End If
	End If
	
	If Image Then
		For Local N:Int = 0 Until Image.frames.Dimensions()[ 0 ]
			Local Pixmap:TPixmap = LockImage( Image, N )
			If PixmapIsEmpty( Pixmap ) Then Exit
			Tiles.AddLast( Pixmap )
		Next
		UnLockImage( Image )
	End If
	Local TilesQuantity:Int = Tiles.Count()
	
	For Local Y:Int = 0 Until TileYQuantity
		For Local X:Int = 0 Until TileXQuantity
			Local Pixmap:TPixmap = TileMapPixmap.Window( X * TileWidth, Y * TileHeight, TileWidth, TileHeight )
			
			Local N:Int = 0
			For Local Tile:TPixmap = Eachin Tiles
				If ComparePixmaps( Pixmap, Tile ) Then Exit
				N :+ 1
			Next
			
			If N = TilesQuantity Then
				Tiles.AddLast( Pixmap )
				TilesQuantity :+ 1
			End If
			
			TileMap.Value[ X, Y ] = N
		Next
	Next
	
	TileSet.Image.XCells = 16
	TileSet.Image.YCells = Ceil( 1.0 * TilesQuantity / 16 )
	TileMap.TilesQuantity = TileSet.Image.XCells * TileSet.Image.YCells
	
	Local TilesPixmap:TPixmap = CreatePixmap( TileWidth * TileSet.Image.XCells, TileHeight * TileSet.Image.YCells, PixmapFormat( TilemapPixmap ) )
	TilesPixmap.ClearPixels( $FFFE00FE )
	
	Local N:Int = 0
	For Local Tile:TPixmap = Eachin Tiles
		TilesPixmap.Paste( Tile, ( N Mod TileSet.Image.XCells ) * TileWidth, Floor( 1.0 * N / TileSet.Image.XCells ) * TileHeight )
		N :+ 1
	Next
	
	SavePixmapPNG( TilesPixmap, TileSet.Image.Filename )
	TileSet.Image.BMaxImage = LoadAnimImage( TileSet.Image.Filename, TileWidth, TileHeight, 0, TileMap.TilesQuantity )
	MidHandleImage( TileSet.Image.BMaxImage )
	
	TileMap.Name = "LTTileMap"
	TileMap.TileSet = TileSet
	TileMap.Visualizer = New LTVisualizer
	Editor.InitTileMap( TileMap )

	Return TileMap
End Function
	



	
Function PixmapIsEmpty:Int( Pixmap:TPixmap )
	For Local Y:Int = 0 Until Pixmap.Height
		For Local X:Int = 0 Until Pixmap.Width
			If Pixmap.ReadPixel( X, Y ) <> $FFFE00FE Then Return False
		Next
	Next
	Return True
End Function