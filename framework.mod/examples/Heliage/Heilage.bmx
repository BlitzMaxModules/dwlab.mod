' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

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

Type TEditor Extends LTProject
	Field Graph:LTGraph = New LTGraph
	Field Cursor:LTCircle = New LTCircle
	Field LineVisual:LTVisual
	Field PivotVisual:LTVisual
	Field CurrentPivotVisual:LTVisual
	Field CurrentPivot:LTPivot
	Field MovePivot:TMovePivot = New TMovePivot
	Field MakeLine:TMakeLine = New TMakeLine
	
	
	
	
	Method Init()
		LineVisual = New LTFilledPrimitive
		LineVisual.SetColorFromHex( "FF7FFF" )
		PivotVisual = New LTFilledPrimitive
		PivotVisual.VisualScale = 8.0
		PivotVisual.SetColorFromHex( "7F7F00" )
		CurrentPivotVisual = New LTFilledPrimitive
		CurrentPivotVisual.VisualScale = 12.0
		CurrentPivotVisual.SetColorFromHex( "FFFF00" )
		Cursor.Diameter = 0.33
	End Method
	
	
	
	Method Logic()
		If MouseHit( 1 ) And Not CurrentPivot Then
			Local Pivot:LTPivot = New LTPivot
			Pivot.SetMouseCoords()
			Graph.AddPivot( Pivot )
		End If
		
		If KeyHit( Key_F2 ) Then Graph.SaveToFile( "map.gra" )
		If KeyHit( Key_F3 ) Then Graph = LTGraph( LTObject.LoadFromFile( "map.gra" ) )
		
		Cursor.SetMouseCoords()
		MovePivot.Execute()
		MakeLine.Execute()
		CurrentPivot = Graph.FindPivotCollidingWith( Cursor )
		
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		Graph.DrawLinesUsing( LineVisual )
		Graph.DrawPivotsUsing( PivotVisual )
		If CurrentPivot Then CurrentPivot.DrawUsingVisual( CurrentPivotVisual )
		If MakeLine.DraggingState Then MakeLine.Line.DrawUsingVisual( LineVisual )
	End Method
End Type





Type TMakeLine Extends LTDrag
	Field Line:LTLine
	
	
	
	Method DragKey:Int()
		If MouseDown( 2 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Editor.CurrentPivot Then Return True
	End Method
	
	
	
	Method StartDragging()
	 	Line = New LTLine
		Line.Pivot[ 0 ] = Editor.CurrentPivot
		Line.Pivot[ 1 ] = Editor.Cursor
	End Method
	
	
	
	Method Dragging()
		'debugstop
	End Method
	
	
	
	Method EndDragging()
		If Editor.CurrentPivot Then
			Line.Pivot[ 1 ] = Editor.CurrentPivot
			If Not Editor.Graph.FindLine( Line.Pivot[ 0 ], Line.Pivot[ 1 ] ) Then Editor.Graph.AddLine( Line )
		End If
	End Method
End Type





Type TMovePivot Extends LTDrag
	Field DX:Float
	Field DY:Float
	Field Pivot:LTPivot
	
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Editor.CurrentPivot Then Return True
	End Method
	
	
	
	Method StartDragging()
		DX = Editor.CurrentPivot.X - Editor.Cursor.X
		DY = Editor.CurrentPivot.X - Editor.Cursor.X
		Pivot = Editor.CurrentPivot
	End Method
	
	
	
	Method Dragging()
		Pivot.X = Editor.Cursor.X + DX
		Pivot.Y = Editor.Cursor.Y + DY
	End Method
End Type




Global Editor:TEditor = New TEditor
Editor.Execute()