SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Const MapSize:Int = 64
Const MapScale:Double = 8
Const FilledTileNum:Int = 20

Incbin "tileset.lw"
Incbin "curved_areas.png"

L_InitGraphics()
SetClsColor( 64, 128, 0 )

Cls
Local DoubleMap:LTDoubleMap = New LTDoubleMap
DoubleMap.SetResolution( MapSize, MapSize )
DrawDoubleMap( DoubleMap )
DrawText( "Step 1: creating Double map and set its resolution", 0, 0 )
Flip
Waitkey

Cls
DoubleMap.PerlinNoise( 16, 16, 0.25, 0.5, 4 )
DrawDoubleMap( DoubleMap )
DrawText( "Step 2: filling DoubleMap with Perlin noise", 0, 0 )
Flip
Waitkey

Cls
L_SetIncbin( True )
Local World:LTWorld = LTWorld.FromFile( "tileset.lw" )
L_SetIncbin( False )
Local TileSet:LTTileSet = LTTileSet( World.Tilesets.First() )
Local TileMap:LTTileMap = LTTileMap.Create( TileSet, MapSize, MapSize )
TileMap.SetSize( MapSize * MapScale / 25.0, MapSize * MapScale / 25.0 )
DrawText( "Step 3: loading world, extract tileset from there and", 0, 0 )
DrawText( "creating tilemap with same size and this tileset", 0, 16 )
DrawDoubleMap( DoubleMap )
Flip
Waitkey


Cls
DoubleMap.ExtractTo( TileMap, 0.5, 1.0, FilledTileNum )
DrawText( "Step 4: setting tiles number of tilemap to FilledTileNum", 0, 0 )
DrawText( "if corresponding value of Double map is higher than 0.5", 0, 16 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey

Cls
For Local Y:Int = 0 Until MapSize
	For Local X:Int = 0 Until MapSize
		Fix( TileMap, X, Y )
	Next
Next
DrawText( "Step 5: preparing tilemap by fixing some unmanaged cell positions", 0, 0 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey

Cls
TileMap.Enframe()
DrawText( "Step 6a: enframing tile map", 0, 0 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey


Cls
L_ProlongTiles = False
TileMap.Enframe() 
DrawText( "Step 6b: enframing tile map with prolonging tiles off", 0, 0 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey

    

Function DrawDoubleMap( Map:LTDoubleMap )
	Local Image:TImage = CreateImage( MapSize, MapSize )
	Local Pixmap:TPixmap = Lockimage( Image )
	ClearPixels( Pixmap, $FF000000 )
	Map.PasteToPixmap( Pixmap )
	Unlockimage( Image )
	SetScale( MapScale, MapScale )
	DrawImage( Image, 400 - 0.5 * MapScale * MapSize, 300 - 0.5 * MapScale * MapSize )
	SetScale( 1, 1 )
	DrawSignature()
End Function



Function DrawSignature()
	L_PrintText( "PerlinNoise, ExtractTo, Enframe, L_ProlongTiles, example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
End Function



Function Fix( TileMap:LTTileMap, X:Int, Y:Int )
	If TileMap.Value[ X, Y ] = FilledTileNum Then Return
	Local DoFix:Int = False
	
	Local FixHorizontal:Int = True
	If X > 0 And X < MapSize - 1 Then
		If TileMap.Value[ X - 1, Y ] = FilledTileNum And TileMap.Value[ X + 1, Y ] = FilledTileNum Then DoFix = True
	Else
		FixHorizontal = False
	End If
	
	Local FixVertical:Int = True
	If Y > 0 And Y < MapSize - 1 Then
		If TileMap.Value[ X, Y - 1 ] = FilledTileNum And TileMap.Value[ X, Y + 1 ] = FilledTileNum Then DoFix = True
	Else
		FixVertical = False
	End If
	
	If DoFix Then
		TileMap.Value[ X, Y ] = FilledTileNum
		If FixHorizontal Then
			Fix( TileMap, X - 1, Y )
			Fix( TileMap, X + 1, Y )
		End If
		If FixVertical Then
			Fix( TileMap, X, Y - 1 )
			Fix( TileMap, X, Y + 1 )
		End If
	End If
End Function