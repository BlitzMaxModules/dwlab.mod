Type LTTileMapPathFinder Extends LTObject
	Field Map:LTIntMap
	Field AllowDiagonalMovement:Int
	Field Points:TMap

	Function Create:LTTileMapPathFinder( TileMap:LTIntMap, AllowDiagonalMovement:Int = True )
		Local TileMapPathFinder:LTTileMapPathFinder = New LTTileMapPathFinder
		TileMapPathFinder.AllowDiagonalMovement = AllowDiagonalMovement
		TileMapPathFinder.Map = TileMap
		Return TileMapPathFinder
	End Function
	
	Method FindPath:LTTileMapPosition( StartingX:Int, StartingY:Int, FinalX:Int, FinalY:Int )
		'DebugStop
		Points = New TMap
		Local List:TList = New TList
		List.AddLast( LTTileMapPosition.Create( Null, StartingX, StartingY ) )
		Repeat
			Local NewList:TList = New TList
			For Local Position:LTTileMapPosition = EachIn List
				Local FinalPosition:LTTileMapPosition = Position.Spread( Self, FinalX, FinalY, NewList )
				If FinalPosition Then Return FinalPosition.Revert()
			Next
			If NewList.IsEmpty() Then Return Null
			List = NewList
		Forever
	End Method
	
	Method Passage:Double( X:Int, Y:Int )
		Return Map.Value[ X, Y ] = 0
	End Method
	
	Method GetPoint:Object( X:Int, Y:Int )
		Return Points.ValueForKey( String( X + Map.XQuantity * Y ) )
	End Method
	
	Method SetPoint( X:Int, Y:Int, Position:LTTileMapPosition )
		Points.Insert( String( X + Map.XQuantity * Y ), Position )
	End Method
End Type

Type LTTileMapPosition
	Field X:Int, Y:Int
	Field PrevPosition:LTTileMapPosition
	Field NextPosition:LTTileMapPosition
	
	Function Create:LTTileMapPosition( PrevPosition:LTTileMapPosition, X:Int, Y:Int )
		Local Position:LTTileMapPosition = New LTTileMapPosition
		Position.X = X
		Position.Y = Y
		Position.PrevPosition = PrevPosition
		Return Position
	End Function
	
	Method Spread:LTTileMapPosition( TileMapPathFinder:LTTileMapPathFinder, FinalX:Int, FinalY:Int, List:TList )
		For Local DY:Int = -1 To 1
			Local YY:Int = Y + DY
			If YY < 0 Or YY >= TileMapPathFinder.Map.YQuantity Then Continue
			For Local DX:Int = -1 To 1
				If DX = 0 And DY = 0 Then Continue
				If Not TileMapPathFinder.AllowDiagonalMovement And DX <> 0 And DY <> 0 Then Continue
				Local XX:Int = X + DX
				If XX < 0 Or XX >= TileMapPathFinder.Map.XQuantity Then Continue
				If Not TileMapPathFinder.Passage( XX, YY ) Then Continue
				If TileMapPathFinder.GetPoint( XX, YY ) Then Continue
				Local Position:LTTileMapPosition = LTTileMapPosition.Create( Self, XX, YY )
				If XX = FinalX And YY = FinalY Then Return Position
				TileMapPathFinder.SetPoint( XX, YY, Position )
				List.AddLast( Position )
			Next
		Next
	End Method
	
	Method Revert:LTTileMapPosition()
		If PrevPosition = Null Then Return Self
		PrevPosition.NextPosition = Self
		Return PrevPosition.Revert()
	End Method
End Type