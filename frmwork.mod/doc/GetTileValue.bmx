SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import brl.pngloader

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	Field Cursor:LTSprite = New LTSprite
	
	Method Init()
		L_InitGraphics()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		TileMap.Visualizer = New TLighntingVisualizer
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
	End Method
End Type

Type TLighntingVisualizer Extends LTVisualizer
	Const Radius:Double = 4
	
	Method GetTileValue:Int( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local X0:Int, Y0:Int
		TileMap.GetTileForPoint( Example.Cursor.X, Example.Cursor.Y, X0, Y0 )
		If L_Distance( TileX - X0, TileY - Y0 ) <= Radius Then Return 18 Else Return 26
	End Method
End Type