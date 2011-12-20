SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "tiles.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) )
	Field TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth, TileMapHeight )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 2, 2 )
	
	Method Init()
		L_InitGraphics()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		For Local Y:Int = 0 Until TileMapHeight
			For Local X:Int = 0 Until TileMapWidth
				TileMap.SetTile( X, Y, Rand( 1, 31 ) )
			Next
		Next
		Cursor.Visualizer.Image = TileMap.TileSet.Image
		Cursor.Frame = 1
	End Method
		
	Method Logic()
		Cursor.SetMouseCoords()
		Local TileX:Int, TileY:Int
		TileMap.GetTileForPoint( Cursor.X, Cursor.Y, TileX, TileY )
		if MouseDown( 1 ) Then TileMap.SetTile( TileX, TileY, Cursor.Frame )
		If MouseHit( 2 ) Then Cursor.SetAsTile( TileMap, TileX, TileY )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		Cursor.Draw()
		DrawText( "Press right mouse button to select brush, left button to draw.", 0, 0 )
		L_PrintText( "GetTileForPoint, SetTile, SetAsTile example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type