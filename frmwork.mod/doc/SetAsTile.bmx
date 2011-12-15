SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "tiles.png", 8, 4 ) )
	Field TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth, TileMapHeight )
	Field Pieces:LTLayer = New LTLayer
	Field Cursor:LTSprite = New LTSprite
	
	Method Init()
		L_InitGraphics()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		For Local Y:Int = 0 Until TileMapHeight
			For Local X:Int = 0 Until TileMapWidth
				TileMap.SetTile( X, Y, Rand( 1, 31 ) )
			Next
		Next
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		If MouseHit( 1 ) Then 
			Local TileX:Int, TileY:Int
			TileMap.GetTileForPoint( Cursor.X, Cursor.Y, TileX, TileY )
			If TileMap.GetTile( TileX, TileY ) > 0 Then
				Local Piece:TPiece = TPiece.Create()
				Piece.SetAsTile( TileMap, TileX, TileY )
				TileMap.SetTile( TileX, TileY, 0 )
			End If
		End If
		Pieces.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		Pieces.Draw()
		DrawText( "Click on tiles to make them fall", 0, 0 )
	End Method
End Type



Type TPiece Extends LTVectorSprite
	Const Gravity:Double = 8.0
	
	Field StartingTime:Double = 0
	Field AngularDirection:Double = 0
	
	Function Create:TPiece()
		Local Piece:TPiece = New TPiece
		Piece.StartingTime = Example.Time
		Piece.AngularDirection = -1 + 2 * Rand( 0, 1 )
		Example.Pieces.AddFirst( Piece )
		Return Piece
	End Function
	
	Method Act()
		MoveForward()
		Angle = ( Example.Time - StartingTime ) * 45 * AngularDirection
		DY :+ Example.PerSecond( Gravity )
		If TopY() > Example.TileMap.BottomY() Then Example.Pieces.Remove( Self )
	End Method
End Type