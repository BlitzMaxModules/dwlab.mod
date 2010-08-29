'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Const TileXSize:Int = 16
Const TileYSize:Int = 16

Type TTileExtractor Extends LTObject
	Field Tiles:TList = New TList
	
	
	
	Method Execute( Path:String )
		Local Dir:Int = ReadDir( Path )
		Repeat
			Local Filename:String = NextFile( Dir )
			If Not Filename Then Exit
			If Lower( Right( Filename, 4 ) ) <> ".png" Then Continue
			ExtractTileFromImage( Path + "\" + Filename )
		Forever
		
		Local Quantity:Int = Tiles.Count()
		Local Tilemap:TPixmap = CreatePixmap( 16 * TileXSize, Ceil( 1.0 * Quantity / 16 ) * TileYSize, PF_RGB888 )
		Local X:Int = 0, Y:Int = 0
		For Local Tile:TPixmap = Eachin Tiles
			Tilemap.Paste( Tile, X, Y )
			X :+ TileXSize
			If X = TileXSize * 16 Then
				X = 0
				Y :+ TileYSize
			End If
		Next
		SavePixmapPNG( Tilemap, "tilemap.png" )
	End Method

	
	
	Method ExtractTileFromImage( Filename:String )
		Local Screenshot:TPixmap = LoadPixmap( Filename )
		'debugLog PixmapFormat( Screenshot )
		For Local Y:Int = 0 Until PixmapHeight( Screenshot ) Step TileYSize
			For Local X:Int = 0 Until PixmapWidth( Screenshot ) Step TileXSize
				Local Pixmap:TPixmap = Screenshot.Window( X, Y, TileXSize, TileYSize )
				
				Local ImageFound:Int = False
				For Local Tile:TPixmap = Eachin Tiles
					If ComparePixmaps( Pixmap, Tile ) Then
						ImageFound = True
						Exit
					End If
				Next
				If Not ImageFound Then Tiles.AddLast( Pixmap )
			Next
		Next
	End Method
	
	
	
	Method ComparePixmaps:Int( Pixmap1:TPixmap, Pixmap2:TPixmap )
		Local Col1:Int = ReadPixel( Pixmap1, 0, 0 )
		Local Col2:Int = ReadPixel( Pixmap2, 0, 0 )
		For Local Y:Int = 0 Until PixmapHeight( Pixmap1 )
			For Local X:Int = 0 Until PixmapWidth( Pixmap1 )
				If ReadPixel( Pixmap1, X, Y ) = Col1 And ReadPixel( Pixmap2, X, Y ) <> Col2 Then Return False
				If ReadPixel( Pixmap1, X, Y ) <> Col1 And ReadPixel( Pixmap2, X, Y ) = Col2 Then Return False
			Next
		Next
		Return True
	End Method
End Type