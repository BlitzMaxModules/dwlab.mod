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
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	
	Method Init()
		L_InitGraphics()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		TileMap.Visualizer = New TLighntingVisualizer
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		L_PrintText( "GetTileValue example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type

Type TLighntingVisualizer Extends LTVisualizer
	Const Radius:Double = 4
	
	Method GetTileValue:Int( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local X0:Int, Y0:Int
		TileMap.GetTileForPoint( L_Cursor.X, L_Cursor.Y, X0, Y0 )
		If L_Distance( TileX - X0, TileY - Y0 ) <= Radius Then Return 18 Else Return 26
	End Method
End Type