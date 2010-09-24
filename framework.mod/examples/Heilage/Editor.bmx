'
' Heilage: Ogres rivage - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

SuperStrict

Framework brl.d3d7max2d
'Import brl.glmax2d
Import brl.random
Import brl.pngloader
Import brl.jpgloader
Import brl.reflection
'Import brl.audio
'Import brl.freeaudioaudio
Import brl.directsoundaudio
Import brl.wavloader
Import brl.retro
Import brl.map
'Import maxgui.win32maxgui

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"
Include "Dragging.bmx"
Include "SharedGameData.bmx"

Init( 1024, 768 )

Global Editor:TEditor = New TEditor
Editor.Execute()

Type TEditor Extends LTProject
	Field Cursor:LTActor = New LTActor
	Field LineVisual:LTEmptyPrimitive
	Field PivotVisual:LTFilledPrimitive
	Field CurrentPivot:LTActor
	Field CurrentLine:LTLine
	Field CurrentLineVisual:LTEmptyPrimitive
	Field CurrentPivotVisual:LTFilledPrimitive
	Field MovePivot:TMovePivot = New TMovePivot
	Field MakeLine:TMakeLine = New TMakeLine
	
	
	
	
	Method Init()
		'Assert 0, "koo!"
		Shared.Init()
		
		Cursor.Shape = L_Circle
		Cursor.SetDiameter( 0.2 )
		
		PivotVisual = New LTFilledPrimitive
		PivotVisual.SetVisualScale( 0.25, 0.25 )
		PivotVisual.SetColorFromHex( "FF7F00" )
		
		LineVisual = New LTEmptyPrimitive
		LineVisual.Scaling = False
		LineVisual.SetColorFromHex( "FF7F00" )
		
		CurrentPivotVisual = New LTFilledPrimitive
		CurrentPivotVisual.SetVisualScale( 0.35, 0.35 )
		CurrentPivotVisual.SetColorFromHex( "FFBF7F" )
		
		CurrentLineVisual = New LTEmptyPrimitive
		CurrentLineVisual.LineWidth = 3.0
		CurrentLineVisual.Scaling = False
		CurrentLineVisual.SetColorFromHex( "FFBF7F" )
	End Method
	
	
	
	Method Logic()
		If Shared.PlayerPivot Then
			If Not Shared.Graph.ContainsPivot( Shared.PlayerPivot ) Then Shared.PlayerPivot = Null
		End If
		
		Shared.Logic()
		
		If MouseHit( 1 ) And Not CurrentPivot Then
			Local Pivot:LTActor = New LTActor
			LTAddPivotToGraph.Create( Shared.Graph, Pivot ).Do()
			Pivot.SetMouseCoords()
		End If
		
		If KeyHit( Key_F2 ) Then Editor.SaveToFile( "map.gra" )
		If KeyHit( Key_F3 ) Then L_LoadFromFile( "map.gra" )
		
		Cursor.SetMouseCoords()
		MovePivot.Execute()
		MakeLine.Execute()
		
		CurrentPivot = Shared.Graph.FindPivotCollidingWith( Cursor )
		CurrentLine = Null
		If Not CurrentPivot Then CurrentLine = Shared.Graph.FindLineCollidingWith( Cursor )
		
		If KeyHit( Key_Delete ) Then
			If CurrentPivot Then LTRemovePivotFromGraph.Create( Shared.Graph, CurrentPivot ).Do()
			If CurrentLine Then LTRemoveLineFromGraph.Create( Shared.Graph, CurrentLine ).Do()
		End If
		
		If KeyHit( Key_Escape ) Then End
		
		L_PushUndoList()
		If KeyHit( Key_Z ) And KeyDown( Key_LControl ) Then L_Undo()
		If KeyHit( Key_Y ) And KeyDown( Key_LControl ) Then L_Redo()
	End Method
	
	
	
	Method Render()
		Shared.Background.Draw()
		Shared.Graph.DrawLinesUsing( LineVisual )
		If CurrentLine Then CurrentLine.DrawUsingVisual( CurrentLineVisual )
		Shared.Graph.DrawPivotsUsing( PivotVisual )
		If CurrentPivot Then CurrentPivot.DrawUsingVisual( CurrentPivotVisual )
		If MakeLine.DraggingState Then MakeLine.Line.DrawUsingVisual( LineVisual )
		
		For Local KeyValue:TKeyValue = Eachin Shared.Events
			SetColor( 0, 255, 0 )
			TGlobalMapEvent( KeyValue.Key() ).DrawInfo( LTActor( KeyValue.Value() ) )
			SetColor( 255, 255, 255 )
		Next
		
		Shared.Player.Draw()
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Shared.Graph = LTGraph( XMLObject.ManageObjectField( "map", Shared.Graph ) )
		Shared.PlayerPivot = LTActor( XMLObject.ManageObjectField( "player", Shared.PlayerPivot ) )
		XMLObject.ManageObjectMapField( "events", Shared.Events )
	End Method
End Type