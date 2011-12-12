SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const TileMapWidth:Int = 64
	Const TileMapHeight:Int = 64
	Const ShakingPeriod:Double = 1.0
	Const PeriodBetweenShakes:Double = 3.0
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
	Field Z:Double, BaseK:Double
	
	Method Init()
		L_InitGraphics()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		For Local Y:Int = 0 Until TileMapHeight
			For Local X:Int = 0 Until TileMapWidth
				TileMap.SetTile( X, Y, Rand( 1, 31 ) )
			Next
		Next
		Cursor.Visualizer.SetColorFromHex( "FFBF7F" )
		BaseK = L_CurrentCamera.K
	End Method
	
	Method Logic()
		Cursor.MoveUsingArrows( 10.0 )
		L_CurrentCamera.ShiftCameraToShape( Cursor, 10.0 )
		
		If KeyDown( Key_A ) Then Z :+ L_DeltaTime * 8.0
		If KeyDown( Key_Z ) Then Z :- L_DeltaTime * 8.0
		L_CurrentCamera.AlterCameraMagnification( Z, BaseK, 2.0 )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		Cursor.Draw()
		DrawText( "Shift cursor by arrow keys and alter magnigication by A and Z keys.", 0, 0 )
	End Method
End Type