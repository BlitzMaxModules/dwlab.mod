'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Pathfinder finds a path in tilemap using flooding algorithm.
End Rem
Type LTTileMapPathFinder Extends LTObject
	Field Map:LTIntMap
	Field AllowDiagonalMovement:Int
	Field Points:TMap

	
	
	Rem
	bbdoc: Creates pathfinder object with given tilemap and diagonal movement flag.
	returns: Found path or empty path if path is not found.
	about: See also: LTGraph
	End Rem
	Function Create:LTTileMapPathFinder( TileMap:LTIntMap, AllowDiagonalMovement:Int = True )
		Local TileMapPathFinder:LTTileMapPathFinder = New LTTileMapPathFinder
		TileMapPathFinder.AllowDiagonalMovement = AllowDiagonalMovement
		TileMapPathFinder.Map = TileMap
		Return TileMapPathFinder
	End Function
	
	
	
	Rem
	bbdoc: Finds a path between two given points on previously specified tilemap.
	returns: First tilemap position object in path. Next one can be retrieved using NextPosition field.
	End Rem
	Method FindPath:LTTileMapPosition( StartingX:Int, StartingY:Int, FinalX:Int, FinalY:Int )
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
	
	
	
	Rem
	bbdoc: Method which determines which tiles are passable.
	returns: True if tilemap cell with specified coordinates is passable.
	about: If you want to make your own way to determine is given tile passable, make class which extends LTTileMapPathFinder and rewrite this method.
	End Rem
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




Rem
bbdoc: Class for tilemap position - the point on tilemap.
End Rem
Type LTTileMapPosition
	Rem
	bbdoc: Tile coordinates of the tilemap postion.
	End Rem
	Field X:Int, Y:Int
	
	Rem
	bbdoc: Previous position in the path.
	End Rem
	Field PrevPosition:LTTileMapPosition
	
	Rem
	bbdoc: Next position in the path.
	End Rem
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