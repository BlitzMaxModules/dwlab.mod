Type LTAStar Extends LTObject
	Field TileMap:LTTileMap
	Field AllowDiagonalMovement:Int
	Field Points:TMap

	Function Create:LTAStar( TileMap:LTTileMap, AllowDiagonalMovement:Int = True )
		Local AStar:LTAStar = New LTAStar
		AStar.AllowDiagonalMovement = AllowDiagonalMovement
		AStar.TileMap = TileMap
		Return AStar
	End Function
	
	Method FindPath:LTAStarDirection( StartingX:Int, StartingY:Int, FinalX:Int, FinalY:Int )
		Points = New TMap
		Local List:TList = New TList
		List.AddLast( LTAStarDirection.Create( Null, StartingX, StartingY ) )
		Repeat
			Local NewList = New TList
			For Local Direction:LTAStarDirection = Eachin List
				Local FinalDirection:LTAStarDirection = Direction.Spread( Self, FinalX, FinalY, NewList )
				If FinalDirection Then Return FinalDirection.Revert()
			Next
		Forever		
	End Method
	
	Method Passage:Double( X:Int, Y:Int )
		Return TileMap.Value[ X, Y ]
	End Method
	
	Method GetPoint:Object( X:Int, Y:Int )
		Return Points.ValueForKey( X + TileMap.XQuantity * Y )
	End Method
	
	Method SetPoint( X:Int, Y:Int, Direction:LTAStarDirection )
		Return Points.Insert( X + TileMap.XQuantity * Y, Direction )
	End Method
End Type

Type LTAStarDirection
	Field X:Int, Y:Int
	Field PrevDirection:LTAStarDirection
	Field NextDirection:LTAStarDirection
	
	Function Create:LTAStarDirection( PrevDirection:LTAStarDirection, X:Int, Y:Int )
		Local Direction:LTAStarDirection = New LTAStarDirection
		Direction.X = X
		Direction.Y = Y
		Direction.PrevDirection = PrevDirection
		Return Direction
	End Function
	
	Method Spread:LTAStarDirection( AStar:LTAStar, FinalX:Int, FinalY:Int, List:TList )
		For Local DY = -1 To 1
			For Local DX = -1 To 1
				If DX = 0 And DY = 0 Then Continue
				If Not AllowDiagonalMovement And DX <> 0 And DY <> 0 Then Continue
				Local XX:Int = X + DX
				Local YY:Int = Y + DY
				If Not AStar.Passage( XX, YY ) Then Continue
				If AStar.GetPoint( XX, YY ) Then Continue
				Local Direction:LTAStarDirection = LTAStarDirection.Create( Self, XX, YY )
				AStar.SetPoint( XX, YY, Direction )
				List.AddLast( Direction )
			Next
		Next
	End Method
	
	Method Revert:LTAStarDirection()
		PrevDirection.NextDirection = Self
		If PrevDirection = Null Then Return Self
		Return PrevDirection.Revert()
	End Method
End Type