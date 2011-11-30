SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import brl.pngloader

Const TileMapWidth:Int = 4
Const TileMapHeight:Int = 3

Local TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "tiles.png", 8, 4 ) )
Local TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth, TileMapHeight )

L_InitGraphics()
TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
For Local Y:Int = 0 Until TileMapHeight
	For Local X:Int = 0 Until TileMapWidth
		TileMap.SetTile( X, Y, Rand( 1, 31 ) )
	Next
Next

For Local N:Int = 1 To 3
	Cls
	TileMap.Draw()
	DrawText( "Press any key to stretch tilemap by 2 times", 0, 0 )
	Flip
	WaitKey
	TileMap.Stretch( 2, 2 )
	TileMap.AlterSize( 2, 2 )
Next