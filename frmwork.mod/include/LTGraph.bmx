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
bbdoc: Graph is a collection of pivots and line segments between them.
End Rem
Type LTGraph Extends LTShape
	Field Pivots:TMap = New TMap
	Field Lines:TMap = New TMap
	
	' ==================== Drawing ===================	
	
	Rem
	bbdoc: Draws graph.
	about: Lines then pivots will be drawn using graph visualizer.
	End Rem
	Method Draw()
		If Visible Then
			DrawLinesUsing( Visualizer )
			DrawPivotsUsing( Visualizer )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Draws graph using another visualizer.
	about: Lines then pivots will be drawn using given visualizer.
	End Rem
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		If Visible Then
			DrawLinesUsing( Vis )
			DrawPivotsUsing( Vis )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Draws pivots using given visualizer.
	about: See also: #DrawLinesUsing
	End Rem
	Method DrawPivotsUsing( Visualizer:LTVisualizer )
		For Local Pivot:LTSprite = Eachin Pivots.Keys()
			'debugstop
			Pivot.DrawUsingVisualizer( Visualizer )
		Next
	End Method
	
	
	
	Rem
	bbdoc: Draws lines using given visualizer.
	about: See also: #DrawPivotsUsing
	End Rem
	Method DrawLinesUsing( Visualizer:LTVisualizer )
		For Local Line:LTLineSegment = Eachin Lines.Keys()
			Line.DrawUsingVisualizer( Visualizer )
		Next
	End Method
	
	
	
	Rem
	bbdoc: Draws path (given as list of pivots) using given visualizer.
	End Rem
	Function DrawPath( Path:TList, Visualizer:LTVisualizer )
		if Not Path Then Return
		Local OldPivot:LTSprite = Null
		For Local Pivot:LTSprite = Eachin Path
			If OldPivot Then
				LTLineSegment.FromPivots( Pivot, OldPivot ).DrawUsingVisualizer( Visualizer )
			End If
			OldPivot = Pivot
		Next
	End Function
	
	' ==================== Add / Remove items ===================	
	
	Rem
	bbdoc: Adds pivot to the graph.
	about: See also: #RemovePivot, #FindPivotCollidingWith, #ContainsPivot
	End Rem
	Method AddPivot:TList( Pivot:LTSprite )
		Local List:TList = TList( Pivots.ValueForKey( Pivot ) )
		If Not List Then
			List = New TList
			Pivots.Insert( Pivot, List )
		End If
		Return List
	End Method
	
	
	
	Rem
	bbdoc: Adds line to the graph.
	about: If you'll try to add line which already exists in the graph, an error will occur.
	Pivots of the line will be also inserted into the graph if they are not already there.
	
	See also: #RemoveLine, #FindLineCollidingWith, #ContainsLine, #FindLine
	End Rem
	Method AddLine( Line:LTLineSegment, StopOnErrors:Int = True )
		If Line.Pivot[ 0 ] = Line.Pivot[ 1 ] Then 
			?debug
			If StopOnErrors Then L_Error( "Cannot add line with equal starting and ending points to the graph" )
			?
			Return
		End If
		If Lines.ValueForKey( Line ) Then
			?debug
			If StopOnErrors Then L_Error( "This line already exists in the graph" )
			?
			Return
		End If
		For Local OtherLine:LTLineSegment = EachIn TList( Pivots.ValueForKey( Line.Pivot[ 0 ] ) )
			If OtherLine.Pivot[ 0 ] = Line.Pivot[ 0 ] Or OtherLine.Pivot[ 0 ] = Line.Pivot[ 1 ] Then
				If OtherLine.Pivot[ 1 ] = Line.Pivot[ 0 ] Or OtherLine.Pivot[ 1 ] = Line.Pivot[ 1 ] Then
					?debug
					If StopOnErrors Then L_Error( "Line with same pivots already exists in the graph" )
					?
					Return
				End If
			End If 
		Next
		?
		
		For local N:Int = 0 To 1
			AddPivot( Line.Pivot[ N ] ).AddLast( Line )
		Next
		Lines.Insert( Line, Line )
	End Method
	
	
	
	Rem
	bbdoc: Remove pivot from the graph.
	about: Line with this pivot will be also removed.
	
	See also: #AddPivot, #FindPivotCollidingWith, #ContainsPivot
	End Rem
	Method RemovePivot( Pivot:LTSprite )
		Local List:TList = TList( Pivots.ValueForkey( Pivot ) )
		?debug
		If List = Null Then L_Error( "The deleting pivot doesn't belongs to the graph" )
		?
		
		For Local Line:LTLineSegment = Eachin List
			RemoveLine( Line )
		Next
		Pivots.Remove( Pivot )
	End Method
	
	
	
	Rem
	bbdoc: Removes line from the graph.
	about: If line is not in the graph, you will encounter an error.
	
	See also: #AddLine, #FindLineCollidingWith, #ContainsLine, #FindLine
	End Rem
	Method RemoveLine( Line:LTLineSegment )
		?debug
		If Not Lines.ValueForKey( Line ) Then L_Error( "The deleting line doesn't belongs to the graph" )
		?
		Lines.Remove( Line )
		TList( Pivots.ValueForKey( Line.Pivot[ 0 ] ) ).Remove( Line )
		TList( Pivots.ValueForKey( Line.Pivot[ 1 ] ) ).Remove( Line )
	End Method
	
	' ==================== Collisions ===================
	
	Rem
	bbdoc: Finds pivot which collides with given sprite.
	about: See also: #AddPivot, #RemovePivot, #ContainsPivot
	End Rem
	Method FindPivotCollidingWithSprite:LTSprite( Sprite:LTSprite )
		For Local Pivot:LTSprite = Eachin Pivots.Keys()
			If Sprite.CollidesWithSprite( Pivot ) Then Return Pivot
		Next
	End Method
	
	

	Rem
	bbdoc: Finds line which collides with given sprite.
	See also: #AddLine, #RemoveLine, #ContainsLine, #FindLine
	End Rem
	Method FindLineCollidingWithSprite:LTLineSegment( Sprite:LTSprite )
		For Local LineSegment:LTLineSegment = Eachin Lines.Keys()
			If Sprite.CollidesWithLineSegment( LineSegment ) Then Return LineSegment
		Next
	End Method

	' ==================== Contents ====================
	
	Rem
	bbdoc: Checks if graph contains given pivot.
	returns: True if pivot is in the graph, otherwise False.
	about: See also: #AddPivot, #RemovePivot, #FindPivotCollidingWith
	End Rem
	Method ContainsPivot:Int( Pivot:LTSprite )
		If Pivots.ValueForKey( Pivot ) Then Return True
	End Method
	
	

	Rem
	bbdoc: Checks if graph contains given line.
	returns: True if line is in the graph, otherwise False.
	See also: #AddLine, #RemoveLine, #FindLineCollidingWith, #FindLine
	End Rem
	Method ContainsLine:Int( Line:LTLineSegment )
		If Lines.ValueForKey( Line ) Then Return True
	End Method
	
	
	
	Rem
	bbdoc: Finds a line in the graph for given pivots.
	See also: #AddLine, #RemoveLine, #FindLineCollidingWith, #ContainsLine
	End Rem
	Method FindLine:LTLineSegment( Pivot1:LTSprite, Pivot2:LTSprite )
		If Pivot1 = Pivot2 Then Return Null
		
		For Local KeyValue:TKeyValue = Eachin Pivots
			If KeyValue.Key() = Pivot1 Then
				For Local Line:LTLineSegment = Eachin TList( KeyValue.Value() )
					If Line.Pivot[ 0 ] = Pivot2 Or Line.Pivot[ 1 ] = Pivot2 Then Return Line
				Next
			End If
		Next
	End Method

	' ==================== Other ====================
	
	Field MaxLength:Double
	Field LengthMap:TMap
	Field ShortestPath:TList
	
	
	Rem
	bbdoc: Finds a path  between 2 given pivots of the graph.
	returns: List of pivots forming path between 2 give pivots if it's possible, otherwise null.
	See also: #LTGraph example
	End Rem
	Method FindPath:TList( FromPivot:LTSprite, ToPivot:LTSprite )
		ShortestPath = Null
		MaxLength = 999999
		LengthMap = New TMap
		Local Path:TList = New TList
		Path.AddLast( FromPivot )
		Spread( Path, FromPivot, ToPivot, 0 )
		Return ShortestPath
	End Method
	
	
	
	Method Spread:TList( Path:TList, FromPivot:LTSprite, ToPivot:LTSprite, Length:Double )
		For Local Line:LTLineSegment = Eachin TList( Pivots.ValueForKey( FromPivot ) )
			Local OtherPivot:LTSprite = Line.Pivot[ Line.Pivot[ 0 ] = FromPivot ]
			Local NewLength:Double = Length + FromPivot.DistanceTo( OtherPivot )
			If NewLength + OtherPivot.DistanceTo( ToPivot ) > MaxLength Then Continue
			Repeat
				If LengthMap.Contains( OtherPivot ) Then
					If String( LengthMap.ValueForKey( OtherPivot ) ).ToDouble() < NewLength Then Exit
				End If
				Local NewPath:TList = Path.Copy()
				NewPath.AddLast( OtherPivot )
				LengthMap.Insert( OtherPivot, String( NewLength ) )
				If OtherPivot = ToPivot Then
					ShortestPath = NewPath
					MaxLength = NewLength
				Else
					Spread( NewPath, OtherPivot, ToPivot, NewLength )
				End If
				Exit
			Forever
		Next
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Local Map:TMap = Null
		If L_XMLMode = L_XMLGet Then
			XMLObject.ManageObjectSetField( "pivots", Map )
			For Local Piv:LTSprite = Eachin Map.Keys()
				AddPivot( Piv )
			Next
			
			XMLObject.ManageObjectSetField( "lines", Map )
			For Local Line:LTLineSegment = Eachin Map.Keys()
				AddLine( Line )
			Next
		Else
			XMLObject.ManageObjectSetField( "pivots", Pivots )
			XMLObject.ManageObjectSetField( "lines", Lines )
		End If
	End Method
End Type





Type LTAddPivotToGraph Extends LTAction
	Field Graph:LTGraph
	Field Pivot:LTSprite
	
	
	
	Function Create:LTAddPivotToGraph( Graph:LTGraph, Pivot:LTSprite )
		Local Action:LTAddPivotToGraph = New LTAddPivotToGraph
		Action.Graph = Graph
		Action.Pivot = Pivot
		Return Action
	End Function
	
	
	
	Method Do()
		Graph.AddPivot( Pivot )
		Super.Do()
	End Method
	
	
	
	Method Undo()
		Graph.RemovePivot( Pivot )
		Super.Undo()
	End Method
End Type





Type LTAddLineToGraph Extends LTAction
	Field Graph:LTGraph
	Field Line:LTLineSegment
	
	
	
	Function Create:LTAddLineToGraph( Graph:LTGraph, Line:LTLineSegment )
		Local Action:LTAddLineToGraph = New LTAddLineToGraph
		Action.Graph = Graph
		Action.Line = Line
		Return Action
	End Function
	
	
	
	Method Do()
		Graph.AddLine( Line )
		Super.Do()
	End Method
	
	
	
	Method Undo()
		Graph.RemoveLine( Line )
		Super.Undo()
	End Method
End Type





Type LTRemovePivotFromGraph Extends LTAction
	Field Graph:LTGraph
	Field Pivot:LTSprite
	Field Lines:TList
	
	
	
	Function Create:LTRemovePivotFromGraph( Graph:LTGraph, Pivot:LTSprite )
		?debug
		If Not Graph.ContainsPivot( Pivot ) Then L_Error( "Cannot find pivot in the graph" )
		?
		Local Action:LTRemovePivotFromGraph = New LTRemovePivotFromGraph
		Action.Graph = Graph
		Action.Pivot = Pivot
		Return Action
	End Function
	
	
	
	Method Do()
		Lines = TList( Graph.Pivots.ValueForKey( Pivot ) ).Copy()
		Graph.RemovePivot( Pivot )
		Super.Undo()
	End Method
	
	
	
	Method Undo()
		Graph.AddPivot( Pivot )
		For Local Line:LTLineSegment = Eachin Lines
			Graph.AddLine( Line )
		Next
		Super.Do()
	End Method
End Type





Type LTRemoveLineFromGraph Extends LTAction
	Field Graph:LTGraph
	Field Line:LTLineSegment
	
	
	
	Function Create:LTRemoveLineFromGraph( Graph:LTGraph, Line:LTLineSegment )
		?debug
		If Not Graph.ContainsLine( Line ) Then L_Error( "Cannot find line in the graph" )
		?
		Local Action:LTRemoveLineFromGraph = New LTRemoveLineFromGraph
		Action.Graph = Graph
		Action.Line = Line
		Return Action
	End Function
	
	
	
	Method Do()
		Graph.RemoveLine( Line )
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Graph.AddLine( Line )
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type


