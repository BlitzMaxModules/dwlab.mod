'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTPath.bmx"

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
		For Local Line:LTLine = Eachin Lines.Keys()
			Line.DrawUsingVisualizer( Visualizer )
		Next
	End Method
	
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
	Method AddLine( Line:LTLine )
		?debug
		If Line.Pivot[ 0 ] = Line.Pivot[ 1 ] Then L_Error( "Cannot add line with equal starting and ending points to the graph" )
		If Lines.ValueForKey( Line ) Then L_Error( "Line already exists in the graph" )
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
		
		For Local Line:LTLine = Eachin List
			RemoveLine( Line )
		Next
		Pivots.Remove( Pivot )
	End Method
	
	
	
	Rem
	bbdoc: Removes line from the graph.
	about: If line is not in the graph, you will encounter an error.
	
	See also: #AddLine, #FindLineCollidingWith, #ContainsLine, #FindLine
	End Rem
	Method RemoveLine( Line:LTLine )
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
	Method FindPivotCollidingWith:LTSprite( Sprite:LTSprite )
		For Local Pivot:LTSprite = Eachin Pivots.Keys()
			If Sprite.CollidesWithSprite( Pivot ) Then Return Pivot
		Next
	End Method
	
	

	Rem
	bbdoc: Finds line which collides with given sprite.
	See also: #AddLine, #RemoveLine, #ContainsLine, #FindLine
	End Rem
	Method FindLineCollidingWith:LTLine( Sprite:LTSprite )
		For Local Line:LTLine = Eachin Lines.Keys()
			If Sprite.CollidesWithLine( Line ) Then Return Line
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
	Method ContainsLine:Int( Line:LTLine )
		If Lines.ValueForKey( Line ) Then Return True
	End Method
	
	
	
	Rem
	bbdoc: Finds a line in the graph for given pivots.
	See also: #AddLine, #RemoveLine, #FindLineCollidingWith, #ContainsLine
	End Rem
	Method FindLine:LTLine( Pivot1:LTSprite, Pivot2:LTSprite )
		If Pivot1 = Pivot2 Then Return Null
		
		For Local KeyValue:TKeyValue = Eachin Pivots
			If KeyValue.Key() = Pivot1 Then
				For Local Line:LTLine = Eachin TList( KeyValue.Value() )
					If Line.Pivot[ 0 ] = Pivot2 Or Line.Pivot[ 1 ] = Pivot2 Then Return Line
				Next
			End If
		Next
	End Method

	' ==================== Other ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Local List:TList
		If L_XMLMode = L_XMLGet Then
			XMLObject.ManageListField( "pivots", List )
			For Local Piv:LTSprite = Eachin List
				AddPivot( Piv )
			Next
			
			XMLObject.ManageListField( "lines", List )
			For Local Line:LTLine = Eachin List
				AddLine( Line )
			Next
		Else
			List = New TList
			For Local Piv:LTSprite = Eachin Pivots.Keys()
				List.AddLast( Piv )
			Next
			XMLObject.ManageListField( "pivots", List )
			
			List = New TList
			For Local Line:LTLine = Eachin Lines.Keys()
				List.AddLast( Line )
			Next
			XMLObject.ManageListField( "lines", List )
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
	Field Line:LTLine
	
	
	
	Function Create:LTAddLineToGraph( Graph:LTGraph, Line:LTLine )
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
		For Local Line:LTLine = Eachin Lines
			Graph.AddLine( Line )
		Next
		Super.Do()
	End Method
End Type





Type LTRemoveLineFromGraph Extends LTAction
	Field Graph:LTGraph
	Field Line:LTLine
	
	
	
	Function Create:LTRemoveLineFromGraph( Graph:LTGraph, Line:LTLine )
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