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

Type TMovePivot Extends LTDrag
	Field DX:Float
	Field DY:Float
	Field Pivot:LTPivot
	Field MovePivot:LTMovePivot
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Editor.CurrentPivot Then Return True
	End Method
	
	
	
	Method StartDragging()
		DX = Editor.CurrentPivot.X - Editor.Cursor.X
		DY = Editor.CurrentPivot.Y - Editor.Cursor.Y
		Pivot = Editor.CurrentPivot
		MovePivot = LTMovePivot.Create( Pivot )
	End Method
	
	
	
	Method Dragging()
		Pivot.X = Editor.Cursor.X + DX
		Pivot.Y = Editor.Cursor.Y + DY
	End Method
	
	
	
	Method EndDragging()
		MovePivot.NewX = Pivot.X
		MovePivot.NewY = Pivot.Y
		MovePivot.Do()
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
			If Not Shared.Graph.FindLine( Line.Pivot[ 0 ], Line.Pivot[ 1 ] ) Then LTAddLineToGraph.Create( Shared.Graph, Line ).Do()
		End If
	End Method
End Type