'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTGraph Extends LTShape
	Field Pivots:TMap = New TMap
	Field Lines:TMap = New TMap
	
	' ==================== Drawing ===================	
	
	Method	DrawPivotsUsing( Visual:LTVisual )
		For Local Pivot:LTActor = Eachin Pivots.Keys()
			'debugstop
			Pivot.DrawUsingVisual( Visual )
		Next
	End Method
	
	
	
	Method DrawLinesUsing( Visual:LTVisual )
		For Local Line:LTLine = Eachin Lines.Keys()
			Line.DrawUsingVisual( Visual )
		Next
	End Method
	
	' ==================== Add / Remove items ===================	
	
	Method AddPivot:TList( Pivot:LTActor )
		Local List:TList = TList( Pivots.ValueForKey( Pivot ) )
		If Not List Then
			List = New TList
			Pivots.Insert( Pivot, List )
		End If
		Return List
	End Method
	
	
	
	Method AddLine( Line:LTLine )
		Assert Line.Pivot[ 0 ] <> Line.Pivot[ 1 ], "Cannot add line with equal starting and ending points to the graph"
		Assert Not Lines.ValueForKey( Line ), "Line already exists in the graph"
		
		For local N:Int = 0 To 1
			AddPivot( Line.Pivot[ N ] ).AddLast( Line )
		Next
		Lines.Insert( Line, Line )
	End Method
	
	
	
	Method RemovePivot( Pivot:LTActor )
		Local List:TList = TList( Pivots.ValueForkey( Pivot ) )
		Assert List, "The deleting pivot doesn't belongs to the graph"
		
		For Local Line:LTLine = Eachin List
			RemoveLine( Line )
		Next
		Pivots.Remove( Pivot )
	End Method
	
	
	
	Method RemoveLine( Line:LTLine )
		Assert Lines.ValueForKey( Line ), "The deleting line doesn't belongs to the graph"
		Lines.Remove( Line )
		TList( Pivots.ValueForKey( Line.Pivot[ 0 ] ) ).Remove( Line )
		TList( Pivots.ValueForKey( Line.Pivot[ 1 ] ) ).Remove( Line )
	End Method
	
	' ==================== Collisions ===================
	
	Method FindPivotCollidingWith:LTActor( Shape:LTShape )
		For Local Pivot:LTActor = Eachin Pivots.Keys()
			If Shape.CollidesWithActor( Pivot ) Then Return Pivot
		Next
	End Method
	
	

	Method FindLineCollidingWith:LTLine( Shape:LTShape )
		For Local Line:LTLine = Eachin Lines.Keys()
			If Shape.CollidesWithLine( Line ) Then Return Line
		Next
	End Method

	' ==================== Contents ====================
	
	Method ContainsPivot:Int( Pivot:LTActor )
		If Pivots.ValueForKey( Pivot ) Then Return True
	End Method
	
	

	Method ContainsLine:Int( Line:LTLine )
		If Lines.ValueForKey( Line ) Then Return True
	End Method
	
	
	
	Method FindLine:LTLine( Pivot1:LTActor, Pivot2:LTActor )
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
			XMLObject.ManageChildList( List )
			For Local Line:LTLine = Eachin List
				AddLine( Line )
			Next
		Else
			List = New TList
			For Local Line:LTLine = Eachin Lines.Keys()
				List.AddLast( Line )
			Next
			XMLObject.ManageChildList( List )
		End If
	End Method
End Type





Type LTAddPivotToGraph Extends LTAction
	Field Graph:LTGraph
	Field Pivot:LTActor
	
	
	
	Function Create:LTAddPivotToGraph( Graph:LTGraph, Pivot:LTActor )
		Local Action:LTAddPivotToGraph = New LTAddPivotToGraph
		Action.Graph = Graph
		Action.Pivot = Pivot
		Return Action
	End Function
	
	
	
	Method Do()
		Graph.AddPivot( Pivot )
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Graph.RemovePivot( Pivot )
		L_CurrentRedoList.AddFirst( Self )
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
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Graph.RemoveLine( Line )
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type





Type LTRemovePivotFromGraph Extends LTAction
	Field Graph:LTGraph
	Field Pivot:LTActor
	Field Lines:TList
	
	
	
	Function Create:LTRemovePivotFromGraph( Graph:LTGraph, Pivot:LTActor )
		Assert Graph.ContainsPivot( Pivot ), "Cannot find pivot in the graph"
		Local Action:LTRemovePivotFromGraph = New LTRemovePivotFromGraph
		Action.Graph = Graph
		Action.Pivot = Pivot
		Return Action
	End Function
	
	
	
	Method Do()
		Lines = TList( Graph.Pivots.ValueForKey( Pivot ) ).Copy()
		Graph.RemovePivot( Pivot )
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Graph.AddPivot( Pivot )
		For Local Line:LTLine = Eachin Lines
			Graph.AddLine( Line )
		Next
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type





Type LTRemoveLineFromGraph Extends LTAction
	Field Graph:LTGraph
	Field Line:LTLine
	
	
	
	Function Create:LTRemoveLineFromGraph( Graph:LTGraph, Line:LTLine )
		Assert Graph.ContainsLine( Line ), "Cannot find line in the graph"
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