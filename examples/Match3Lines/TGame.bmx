Type TGame Extends LTProject
	Const BallsPerTurn:Int = 3

	Field Level:LTTileMap
	Field Objects:LTLayer = New LTLayer
	Field Particles:LTLayer = New LTLayer
	Field Cursor:TCursor = New TCursor
	Field Selected:TSelected
	Field EmptyCells:TList = New TList
	Field TileMapPathFinder:LTTileMapPathFinder
	Field Busy:Int

	Method Init()
		Level = LTTileMap( LTWorld.FromFile( "levels.lw" ).FindShape( "LTTileMap" ) )
		Level.SetCoords( 0, 0 )
		Level.Visualizer = New TVisualizer
		
		TileMapPathFinder = LTTileMapPathFinder.Create( Level, False )
		
		Cursor.ShapeType = LTSprite.Pivot
		Cursor.SetDiameter( 0.1 )
		
		L_InitGraphics( 1088, 704, 64.0 )
		
		CreateBalls()
	End Method
	
	Method Render()
		Level.Draw()
		Objects.Draw()
		Particles.Draw()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		If Not Busy Then Cursor.CollisionsWithTileMap( Level )
		
		If KeyHit( Key_Escape ) Then End
		Objects.Act()
		Particles.Act()
	End Method
	
	Method CreateBalls()
		RefreshEmptyCells()
		If EmptyCells.Count() < 3 Then End
		For Local N:Int = 0 Until BallsPerTurn
			Local Cell:TCell = TCell.PopFrom( EmptyCells )
			TPopUpBall.Create( Cell.X, Cell.Y, Rand( 1, 7 ) )
		Next
	End Method
	
	Method RefreshEmptyCells()
		EmptyCells.Clear()
		For Local Y:Int = 0 Until Level.YQuantity
			For Local X:Int = 0 Until Level.XQuantity
				If Level.Value[ X, Y ] = TVisualizer.Empty Then
					EmptyCells.AddLast( TCell.Create( X, Y ) )
				End If
			Next
		Next
	End Method
	
	Method TileToSprite:LTSprite( Model:LTBehaviorModel, X:Int, Y:Int )
		Local Sprite:LTSprite = New LTSprite
		Sprite.SetAsTile( Game.Level, X, Y )
		Game.Objects.AddLast( Sprite )
		Sprite.AttachModel( Model )
		Game.Level.SetTile( X, Y, TVisualizer.Empty )
		Return Sprite
	End Method
End Type

Type TCell
	Field X:Int, Y:Int
	
	Function Create:TCell( X:Int, Y:Int )
		Local Cell:TCell = New TCell
		Cell.X = X
		Cell.Y = Y
		Return Cell
	End Function
	
	Function PopFrom:TCell( List:TList )
		Local Num:Int = Rand( 0, List.Count() - 1 )
		Local Link:TLink = List.FirstLink()
		For Local N:Int = 1 To Num
			Link = Link.NextLink()
		Next
		Local Cell:TCell = TCell( Link.Value() )
		Link.Remove()
		Return Cell
	End Function
End Type