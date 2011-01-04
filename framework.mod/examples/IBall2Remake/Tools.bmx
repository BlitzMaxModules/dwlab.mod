'
' I, Ball 2 Remake - Digital Wizard's Lab example
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
		Local Tilemap:TPixmap = CreatePixmap( 16 * TileWidth, Ceil( 1.0 * Quantity / 16 ) * TileHeight, PF_RGB888 )
		Local X:Int = 0, Y:Int = 0
		For Local Tile:TPixmap = Eachin Tiles
			Tilemap.Paste( Tile, X, Y )
			X :+ TileWidth
			If X = TileWidth * 16 Then
				X = 0
				Y :+ TileHeight
			End If
		Next
		SavePixmapPNG( Tilemap, "media\tilemap.png" )
	End Method

	
	
	Method ExtractTileFromImage( Filename:String )
		Local Screenshot:TPixmap = LoadPixmap( Filename )
		'debugLog PixmapFormat( Screenshot )
		For Local Y:Int = 0 Until PixmapHeight( Screenshot ) Step TileHeight
			For Local X:Int = 0 Until PixmapWidth( Screenshot ) Step TileWidth
				Local Pixmap:TPixmap = Screenshot.Window( X, Y, TileWidth, TileHeight )
				
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
	
	
	
	Method Execute( )
		Game.Init()
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
		Game.TileMap.FrameMap = New LTIntMap
		Game.TileMap.FrameMap.SetResolution( 15, 14 )
		Game.Objects = New LTList
		
		Local Screenshot:TPixmap = LoadPixmap( "screens\" + Filename )
		
		For Local Y:Int = 0 Until 14
			For Local X:Int = 0 Until 15
				Game.TileMap.FrameMap.Value[ X, Y ] = 49
			Next
		Next
		
		For Local Y:Int = 0 Until 12
			For Local X:Int = 0 Until 13
				Local Pixmap1:TPixmap = Screenshot.Window( X * TileWidth, Y * TileHeight, TileWidth, TileHeight )
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
				
				Game.TileMap.FrameMap.Value[ X + 1, Y + 1 ] = TileNum
			Next
		Next
		
		Game.SaveToFile( "levels\" + Left( Filename, 2 ) + ".xml" )
	End Method
End Type




Function CreateEnemyGeneratorImage()
	Local Circle:LTFloatMap[] = New LTFloatMap[ 18 ]
	For Local N:Int = 0 Until 18
		Circle[ N ] = New LTFloatMap
		Circle[ N ].SetResolution( 16, 16 )
		Circle[ N ].DrawCircle( 8.0, 8.0, 7.5, 1.0 * N / 17.0 )
	Next

	Local Map:LTFloatMap = New LTFloatMap
	Map.SetResolution( 64 * 8, 64 * 8 )
	For Local Angle:Float = 0.0 Until 180.0 Step 5.0
		Cls
		For Local Angle2:Float = 0.0 To L_LimitFloat( Angle, 0.0, 90.0 )
			For Local DAngle:Float = 0.0  To 270.0 Step 90.0
				Local Frame:Int = Int( Angle / 5.0 )
				Local X:Float = 24.0 - 24.0 * Cos( Angle + DAngle + Angle2 - L_LimitFloat( Angle, 0.0, 90.0 ) ) + 64 * ( Frame Mod 8 )
				Local Y:Float = 24.0 - 24.0 * Sin( Angle + DAngle + Angle2 - L_LimitFloat( Angle, 0.0, 90.0 ) ) + 64 * Int( Frame / 8 )
				Map.Paste( Circle[ Int( 17.0 * Angle2 / 90.0 ) ], X, Y, L_Max )
			Next
		Next
	Next
	
	Local Pixmap:TPixmap = Map.ToNewPixmap( L_Alpha )
	SavePixmapPNG( Pixmap, "media/generator.png" )
	End
End Function



Function ConvertLevels()
	Game.Init()

	Local World:LTWorld = New LTWorld
	Local BlockImage:LTImage = LTImage.FromFile( "media\tiles.png", 16, 11 )
	Local BlockVisualizer:LTImageVisualizer = New LTImageVisualizer
	BlockVisualizer.Image = BlockImage
	BlockVisualizer.Rotating = False
	For Local Num:Int = 1 To 50
		Local Page:LTPage = New LTPage
		Page.SetName( "Level " + Num )
		
		L_LoadFromFile( "levels\" + L_FirstZeroes( Num, 2 ) + ".xml" )

		Page.TileMap = New LTTileMap 
		Page.TileMap.FrameMap = Game.TileMap.FrameMap
		Page.TileMap.Visualizer = BlockVisualizer
		Page.TileMap.X = 0.5 * Game.TileMap.FrameMap.XQuantity
		Page.TileMap.Y = 0.5 * Game.TileMap.FrameMap.YQuantity
		Page.TileMap.Width = Game.TileMap.FrameMap.XQuantity
		Page.TileMap.Height = Game.TileMap.FrameMap.YQuantity
		
		World.Pages.AddLast( Page )
	Next
	
	L_IncludedObjects.Clear()
	World.SaveToFile( "world.xml" )
End Function