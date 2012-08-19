SuperStrict

Framework brl.basic

Import dwlab.frmwork
Import brl.pngloader

Global World:LTWorld = New LTWorld
Global TileMaps:LTTileMap[,]
World.Camera = LTCamera.Create()
World.Camera.Isometric = True
World.Camera.VX1 = 16
World.Camera.VY1 = 8
World.Camera.VX2 = -16
World.Camera.VY2 = 8
World.Camera.Update()

CreateLayer( "City", "city", 100, 100, 4 )
For Local N:Int = 0 Until 10
	PasteMap( "urban00", N * 10, 30 )
	PasteMap( "urban01", 20, N * 10 )
	PasteMap( "urban01", 70, N * 10 )
Next
For Local Shape:Int[] = Eachin [ [ 7, 0, 0 ], [ 14, 0, 2 ], [ 3, 1, 2 ], [ 2, 2, 3 ], [ 2, 7, 3 ], [ 16, 3, 0 ], [ 3, 4, 0 ], [ 3, 5, 0 ], [ 18, 6, 2 ], [ 7, 8, 0 ], ..
		[ 9, 3, 1 ], [ 8, 5, 4 ], [ 15, 8, 2 ], [ 15, 9, 2 ], [ 5, 0, 4 ], [ 17, 1, 6 ], [ 6, 3, 4 ], [ 17, 5, 2 ], [ 17, 0, 6 ], [ 16, 3, 6 ], [ 18, 3, 7 ], [ 4, 4, 6 ], ..
		[ 4, 4, 7 ], [ 7, 5, 6 ], [ 15, 8, 6 ], [ 16, 8, 7 ], [ 3, 9, 6 ], [ 3, 9, 7 ], [ 14, 1, 7 ], [ 15, 1, 8 ], [ 3, 0, 7 ], [ 3, 0, 8 ], [ 3, 1, 9 ], [ 8, 3, 8 ], ..
		[ 5, 5, 8 ], [ 8, 8, 8 ], [ 14, 6, 0 ], [ 16, 6, 1 ], [ 3, 5, 1 ] ]
	PasteMap( "urban" + L_FirstZeroes( Shape[ 0 ], 2 ), Shape[ 1 ] * 10, Shape[ 2 ] * 10 )
Next
PasteMap( "lightnin", 0, 90, 186, 41 )
PasteMap( "ufo_140", 80, 40, 228, 41 )

CreateLayer( "Farm", "farm", 60, 60, 4 )
For Local Y:Int = 0 Until 6
	For Local X:Int = 0 Until 6
		PasteMap( "culta" + L_FirstZeroes( Rand( 1, 18 ), 2 ), X * 10, Y * 10 )
	Next
Next
PasteMap( "plane", 50, 0, 66, 2 )
PasteMap( "ufo_130", 0, 40, 131, 2 )
PasteMap( "ufo_01a", 10, 10, 237, 2 )

CreateLayer( "Jungle", "jungle", 60, 60, 4 )
For Local Y:Int = 0 Until 6
	For Local X:Int = 0 Until 6
		PasteMap( "jungle" + L_FirstZeroes( Rand( 1, 9 ), 2 ), X * 10, Y * 10 )
	Next
Next
PasteMap( "avenger", 0, 10, 82, 2 )
PasteMap( "ufo_170", 30, 40, 139, 2 )

World.SaveToFile( "x-com.lw" )

Function CreateLayer( Name:String, TilesetName:String, Width:Int, Depth:Int, Height:Int )
	Local Layer:LTLayer = New LTLayer
	Layer.SetParameter( "name", Name )
	Local Image:LTImage = LTImage.FromFile( TilesetName + ".png", 16, -40 )
	World.Images.AddLast( Image )
	Local TileSet:LTTileSet = LTTileSet.Create( Image )
	TileSet.EmptyTile = 0
	TileSet.Name = TilesetName
	World.Tilesets.AddLast( TileSet )
	TileMaps = New LTTileMap[ Height, 4 ]
	For Local N:Int = 0 Until Height
		Local ChildLayer:LTLayer = New LTLayer
		ChildLayer.AddParameter( "name", "Layer " + ( N + 1 ) )
		ChildLayer.MixContent = True
		For Local M:Int = 0 To 3
			Local TileMap:LTTileMap = LTTileMap.Create( TileSet, Width, Depth )
			TileMap.SetCoords( -N * 1.6, -N * 1.6 )
			TileMap.SetSize( Width, Depth )
			TileMap.Visualizer.SetVisualizerScale( 1.0625, 2.65625 )
			TileMap.Visualizer.DY = -0.3125
			TileMap.AddParameter( "name", [ "Floor", "Left wall", "Right wall", "Object" ][ M ] )
			TileMaps[ N, M ] = TileMap
			ChildLayer.AddLast( TileMap )
		Next
		Layer.AddLast( ChildLayer )
	Next
	World.AddLast( Layer )
End Function

Function PasteMap( FileName:String, XOffset:Int = 0, ZOffset:Int = 0, Offset:Int = 0, LandTileNum:Int = 0 )
	Local File:TStream = ReadFile( FileName + ".map" )
	Local Depth:Int = ReadByte( File )
	Local Width:Int = ReadByte( File )
	Local Height:Int = ReadByte( File )
	
	For Local Y:Int = Height - 1 To 0 Step -1
		For Local Z:Int = 0 Until Depth
			For Local X:Int = 0 Until Width
				For Local N:Int = 0 To 3
					Local A:Int = ReadByte( File )
					If A >= 2 Then A :+ Offset
					If Offset And N = 0 And Y = 0 And A = 0 Then A = LandTileNum
					TileMaps[ Y, N ].Value[ X + XOffset, Z + ZOffset ] = A
				Next
			Next
		Next
	Next
	CloseFile( File )
End Function