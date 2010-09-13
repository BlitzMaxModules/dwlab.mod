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

Type TTileExtractor Extends LTObject
	Field Tiles:TList = New TList
	
	
	
	Method Execute()
		Local Dir:Int = ReadDir( "screens" )
		Repeat
			Local Filename:String = NextFile( Dir )
			If Not Filename Then Exit
			If Lower( Right( Filename, 4 ) ) <> ".png" Then Continue
			ExtractTileFromImage( "screens\" + Filename )
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
		SavePixmapPNG( Tilemap, "media\tilemap.png" )
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
End Type




	
Function ComparePixmaps:Int( Pixmap1:TPixmap, Pixmap2:TPixmap )
	Local Col1:Int = ReadPixel( Pixmap1, 0, 0 )
	Local Col2:Int = ReadPixel( Pixmap2, 0, 0 )
	For Local Y:Int = 0 Until PixmapHeight( Pixmap1 )
		For Local X:Int = 0 Until PixmapWidth( Pixmap1 )
			If ReadPixel( Pixmap1, X, Y ) = Col1 And ReadPixel( Pixmap2, X, Y ) <> Col2 Then Return False
			If ReadPixel( Pixmap1, X, Y ) <> Col1 And ReadPixel( Pixmap2, X, Y ) = Col2 Then Return False
		Next
	Next
	Return True
End Function
	
	
	
	

Type TLevelExtractor Extends LTObject
	Field Tiles:TImage
	Field TilesQuantity:Int = 56
	
	
	
	Method Execute( )
		Tiles = LoadAnimImage( "media\tiles_original.png", 16, 16, 0, TilesQuantity )
		
		Local Dir:Int = ReadDir( "screens" )
		Repeat
			Local Filename:String = NextFile( Dir )
			If Not Filename Then Exit
			If Lower( Right( Filename, 4 ) ) <> ".png" Then Continue
			ExtractLevelFromImage( Filename )
		Forever
	End Method

	
	
	Method ExtractLevelFromImage( Filename:String )
		Local Level:TLevel = New TLevel
		Game.CurrentLevel = Level
		
		Level.FrameMap = New LTIntMap
		Level.FrameMap.SetResolution( 13, 12 )
		Level.ObjectMap = New LTIntMap
		Level.ObjectMap.SetResolution( 13, 12 )
		
		Local Screenshot:TPixmap = LoadPixmap( "screens\" + Filename )
		
		For Local Y:Int = 0 Until 12
			For Local X:Int = 0 Until 13
				Local Pixmap1:TPixmap = Screenshot.Window( X * TileXSize, Y * TileYSize, TileXSize, TileYSize )
				Local TileNum:Int = 0
				For Local N:Int = 0 Until TilesQuantity
					Local Pixmap2:TPixmap = LockImage( Tiles, N )
					If ComparePixmaps( Pixmap1, Pixmap2 ) Then
						TileNum = N
						UnlockImage( Tiles )
						Exit
					End If
					UnlockImage( Tiles )
				Next
				
				Level.FrameMap.Value[ X, Y ] = TileNum
				Level.ObjectsMap.Value[ X, Y ] = Sgn( TileNum )
			Next
		Next
		
		Level.SaveToFile( "levels\" + Left( Filename, 2 ) + ".xml" )
	End Method
End Type