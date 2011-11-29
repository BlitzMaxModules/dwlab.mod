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

'CreateLayer( "City", "city", 20, 20, 4 )

CreateLayer( "Farm", "farm", 20, 20, 4 )
PasteMap( "culta16" )
'CreateLayer( "Avenger", "avenger", 20, 20, 4 )
'PasteMap( "avenger" )

World.SaveToFile( "x-com.lw" )

Function CreateLayer( Name:String, TilesetName:String, Width:Int, Depth:Int, Height:Int )
	Local Layer:LTLayer = New LTLayer
	Local Image:LTImage = LTImage.FromFile( TilesetName + ".png", 16, -40 )
	World.Images.AddLast( Image )
	Local TileSet:LTTileSet = LTTileSet.Create( Image )
	World.Tilesets.AddLast( TileSet )
	TileSet.EmptyTile = 0
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

Function PasteMap( FileName:String, X:Int = 0, Y:Int = 0, Offset:Int = 0 )
	Local File:TStream = ReadFile( FileName + ".map" )
	Local Depth:Int = ReadByte( File )
	Local Width:Int = ReadByte( File )
	Local Height:Int = ReadByte( File )
	
	For Local Y:Int = Height - 1 To 0 Step -1
		For Local Z:Int = 0 Until Depth
			For Local X:Int = 0 Until Width
				For Local N:Int = 0 To 3
					TileMaps[ Y, N ].Value[ X, Z ] = ReadByte( File ) + Offset
				Next
			Next
		Next
	Next
	CloseFile( File )
End Function