Import dwlab.frmwork

SuperStrict

Local Dir:Int = ReadDir( CurrentDir() )

Local World:LTWorld = New LTWorld
L_CurrentCamera.SetMagnification( 8 )
World.Camera = L_CurrentCamera
Local TileSet:LTTileSet[] = New LTTileSet[ 5 ]
For Local N:Int = 0 To 4
	Local Image:LTImage = LTImage.FromFile( "tiles" + ( N + 1 ) + ".png", 44, 9 )
	TileSet[ N ] = New LTTileSet
	TileSet[ N ].Image = Image
	TileSet[ N ].Name = "Tile set " + ( N + 1 )
	TileSet[ N ].RefreshTilesQuantity()
	World.Images.AddLast( Image )
	World.Tilesets.AddLast( TileSet[ N ] )
Next

Repeat
	Local FileName:String = NextFile( Dir )
	If Not FileName Then Exit
	If ExtractExt( FileName ) <> "txt" Then Continue
	Local File:TStream = ReadFile( FileName )
	Local Layer:LTLayer = New LTLayer
	Local XQuantity:Int = ReadByte( File )
	Local YQuantity:Int = ReadByte( File )
	Local TileSetNum:Int = ReadByte( File ) - 1
	Local Map:LTTileMap = LTTileMap.Create( TileSet[ TileSetNum ], XQuantity, YQuantity )
	Map.Width = XQuantity
	Map.Height = YQuantity
	For Local Y:Int = 0 Until YQuantity
		For Local X:Int = 0 Until XQuantity
			Map.Value[ X, Y ] = ReadShort( File )
		Next
	Next
	Layer.AddLast( Map )
	Layer.Bounds = New LTShape
	Layer.Bounds.JumpTo( Map )
	Layer.Bounds.SetSizeAs( Map )
	Local Parameter:LTParameter = New LTParameter
	Parameter.Name = "name"
	Parameter.Value = "Level " + StripAll( FileName )[ 0..1 ]
	Layer.Parameters = New TList
	Layer.Parameters.AddLast( Parameter )
	World.AddLast( Layer )
Forever
 World.SaveToFile( "chaoseng.lw" )