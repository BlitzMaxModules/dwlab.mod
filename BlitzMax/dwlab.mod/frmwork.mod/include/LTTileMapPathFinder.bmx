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
	Method FindPath:LTTileMapPosition( StartingX:Int, StartingY:Int, FinalX:Int, FinalY:Int, Range:Int = 0, MaxDistance:Int = 1024 )
		If Not Passage( FinalX, FinalY ) And Range = 0 Then Return Null
		Points = New TMap
		Local List:TList = New TList
		List.AddLast( LTTileMapPosition.Create( Null, StartingX, StartingY ) )
		If Abs( StartingX - FinalX ) <= Range And Abs( StartingY - FinalY ) <= Range Then Return LTTileMapPosition( List.First() )
		Local Distance:Int = 0
		Repeat
			Distance :+ 1
			If Distance > MaxDistance Then Return Null
			
			Local NewList:TList = New TList
			For Local Position:LTTileMapPosition = EachIn List
				Local FinalPosition:LTTileMapPosition = Position.Spread( Self, FinalX, FinalY, NewList, Range )
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




Global L_SpreadingDirections:Int[] = [ -1, 0, 0, -1, 1, 0, 0, 1, -1, -1, -1, 1, 1, -1, 1, 1 ]

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
	
	
	
	Method Spread:LTTileMapPosition( TileMapPathFinder:LTTileMapPathFinder, FinalX:Int, FinalY:Int, List:TList, Range:Int )
		For Local N:Int = 0 Until 8 + ( 8 * TileMapPathFinder.AllowDiagonalMovement ) Step 2
			Local XX:Int = X + L_SpreadingDirections[ N ]
			If XX < 0 Or XX >= TileMapPathFinder.Map.XQuantity Then Continue
			
			Local YY:Int = Y + L_SpreadingDirections[ N + 1 ]
			If YY < 0 Or YY >= TileMapPathFinder.Map.YQuantity Then Continue
			
			If Not TileMapPathFinder.Passage( XX, YY ) Then Continue
			If TileMapPathFinder.GetPoint( XX, YY ) Then Continue
			
			Local Position:LTTileMapPosition = LTTileMapPosition.Create( Self, XX, YY )
			If Abs( XX - FinalX ) <= Range And Abs( YY - FinalY ) <= Range Then Return Position
			
			TileMapPathFinder.SetPoint( XX, YY, Position )
			List.AddLast( Position )
		Next
	End Method
	
	
	
	Rem
	bbdoc: Method for retrieving first position in queue.
	returns: First position in queue.
	End Rem
	Method FirstPosition:LTTileMapPosition()
		Local Position:LTTileMapPosition = Self
		While Position.PrevPosition <> Null
			Position = Position.PrevPosition
		WEnd
		Return Position
	End Method
	
	
	Rem
	bbdoc: Method for retrieving last position in queue.
	returns: Last position in queue.
	End Rem
	Method LastPosition:LTTileMapPosition()
		Local Position:LTTileMapPosition = Self
		While Position.NextPosition <> Null
			Position = Position.NextPosition
		WEnd
		Return Position
	End Method
	
	
	
	Method Revert:LTTileMapPosition()
		Local Position:LTTileMapPosition = Self
		While Position.PrevPosition <> Null
			Position.PrevPosition.NextPosition = Position
			Position = Position.PrevPosition
		WEnd
		Return Position
	End Method
End Type