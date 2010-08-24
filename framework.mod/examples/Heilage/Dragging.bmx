' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

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