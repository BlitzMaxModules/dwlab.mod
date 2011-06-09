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

Function ImportTilemap:LTTileMap( TileWidth:Int, TileHeight:Int, TilemapPixmap:TPixmap, TilesetFilename:String )
	Local TilemapWidth:Int = PixmapWidth( TilemapPixmap )
	Local TilemapHeight:Int = PixmapHeight( TilemapPixmap )
	
	Local TileXQuantity:Int = TilemapWidth / TileWidth
	Local TileYQuantity:Int = TilemapHeight / TileHeight
	
	Local Tilemap:LTTileMap = New LTTileMap
	TileMap.FrameMap = New LTIntMap
	TileMap.FrameMap.SetResolution( TileXQuantity, TileYQuantity )
	Editor.InitTileMap( TileMap )
	
	Local Tiles:TList = New TList
	If FileType( TilesetFilename ) = 1 Then
		Local Image:TImage = LoadImage( TilesetFilename )
		Local TilesQuantity:Int = ImageWidth( Image ) * ImageHeight( Image ) / TileWidth / TileHeight
		Image = LoadAnimImage( LockImage( Image ), TileWidth, TileHeight, 0, TilesQuantity )
		For Local N:Int = 0 Until TilesQuantity
			Local Pixmap:TPixmap = LockImage( Image, N )
			If PixmapIsEmpty( Pixmap ) Then Exit
			Tiles.AddLast( Pixmap )
		Next
		UnLockImage( Image )
	End If
	
	For Local Y:Int = 0 Until TileYQuantity
		For Local X:Int = 0 Until TileXQuantity
			Local Pixmap:TPixmap = TilemapPixmap.Window( X * TileWidth, Y * TileHeight, TileWidth, TileHeight )
			
			Local N:Int = 0
			For Local Tile:TPixmap = Eachin Tiles
				If ComparePixmaps( Pixmap, Tile ) Then Exit
				N :+ 1
			Next
			If N = Tiles.Count() Then Tiles.AddLast( Pixmap )
			
			TileMap.FrameMap.Value[ X, Y ] = N
		Next
	Next
	
	Local TilesQuantity:Int = Tiles.Count()
	Tilemap.TilesQuantity = Ceil( 1.0 * TilesQuantity / 16 ) * 16
	
	Local TilesPixmap:TPixmap = CreatePixmap( TileWidth * 16, TileHeight * Ceil( 1.0 * TilesQuantity / 16 ), PixmapFormat( TilemapPixmap ) )
	TilesPixmap.ClearPixels( $FFFF00FF )
	Local N:Int = 0
	For Local Tile:TPixmap = Eachin Tiles
		TilesPixmap.Paste( Tile, ( N Mod 16 ) * TileWidth, Floor( 1.0 * N / 16.0 ) * TileHeight )
		N :+ 1
	Next
	
	SavePixmapPNG( TilesPixmap, TilesetFilename )
	
	Return TileMap
End Function
	
	
	
Function PixmapIsEmpty:Int( Pixmap:TPixmap )
	For Local Y:Int = 0 Until Pixmap.Height
		For Local X:Int = 0 Until Pixmap.Width
			If Pixmap.ReadPixel( X, Y ) <> $FFFF00FF Then Return False
		Next
	Next
	Return True
End Function