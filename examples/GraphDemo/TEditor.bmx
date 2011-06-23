'
' Graph usage demo - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

AppTitle = "Graph editor"

Type TEditor Extends LTProject
	Field GameMap:TGameMap
	Field CurrentLine:LTLine
	Field CurrentLineVisualizer:LTEmptyPrimitive = New LTEmptyPrimitive
	Field MovePivot:TMovePivot = New TMovePivot
	Field MakeLine:TMakeLine = New TMakeLine
	
	
	
	
	Method Init()
		Game.Init()
		
		CurrentLineVisualizer.LineWidth = 3.0
		CurrentLineVisualizer.Scaling = False
		CurrentLineVisualizer.SetColorFromHex( "FFBF7F" )
	End Method
	
	
	
	Method Logic()
		If Game.Map.PlayerPivot Then
			If Not Game.Map.ContainsPivot( Game.Map.PlayerPivot ) Then Game.Map.PlayerPivot = Null
		End If
		
		Game.Time = Time
		Game.Logic()
		
		If MouseHit( 1 ) And Not Game.CurrentPivot Then
			Local NewPivot:LTSprite = New LTSprite
			LTAddPivotToGraph.Create( Game.Map, NewPivot ).Do()
			NewPivot.SetMouseCoords()
		End If
		
		If KeyHit( Key_F2 ) Then Game.Map.SaveToFile( "map.gra" )
		If KeyHit( Key_F3 ) Then Game.Map = TGameMap( LoadFromFile( "map.gra" ) )
		
		MovePivot.Execute()
		MakeLine.Execute()
		
		CurrentLine = Null
		If Not Game.CurrentPivot Then CurrentLine = Game.Map.FindLineCollidingWith( Game.Cursor )
		
		If KeyHit( Key_Delete ) Then
			If Game.CurrentPivot Then LTRemovePivotFromGraph.Create( Game.Map, Game.CurrentPivot ).Do()
			If CurrentLine Then LTRemoveLineFromGraph.Create( Game.Map, CurrentLine ).Do()
		End If
		
		L_PushUndoList()
		If KeyHit( Key_Z ) And KeyDown( Key_LControl ) Then L_Undo()
		If KeyHit( Key_Y ) And KeyDown( Key_LControl ) Then L_Redo()
	End Method
	
	
	
	Method Render()
		Game.Render()
		If CurrentLine Then CurrentLine.DrawUsingVisualizer( CurrentLineVisualizer )
		If MakeLine.DraggingState Then MakeLine.Line.DrawUsingVisualizer( Game.LineVisualizer )
		
		For Local KeyValue:TKeyValue = Eachin Game.Map.Events
			SetColor( 0, 255, 0 )
			TGlobalMapEvent( KeyValue.Key() ).DrawInfo( LTSprite( KeyValue.Value() ) )
			SetColor( 255, 255, 255 )
		Next
		
		Game.Player.Draw()
		
		Game.Font.Print( "Drag selected pivot with left mouse button.", -16.0, -10.0, 1.0 )
		Game.Font.Print( "Create pivots with right mouse button on empty space.", -16.0, -9.0, 1.0 )
		Game.Font.Print( "Create lines by dragging right mouse button from one pivot to another.", -16.0, -8.0, 1.0 )
		Game.Font.Print( "Press Del to delete selected object.", -16.0, -7.0, 1.0 )
		Game.Font.Print( "Press Ctrl-Z to undo.", -16.0, -6.0, 1.0 )
		Game.Font.Print( "Press Ctrl-Y to redo.", -16.0, -5.0, 1.0 )
		Game.Font.Print( "Press F2 to save map.", -16.0, -4.0, 1.0 )
		Game.Font.Print( "Press F3 to load map.", -16.0, -3.0, 1.0 )
	End Method
End Type