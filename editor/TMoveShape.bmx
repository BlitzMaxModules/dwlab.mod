'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type TMoveShape Extends LTDrag
	Field StartX:Float, StartY:Float
	Field LastDX:Float, LastDY:Float
	
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Not Editor.CurrentTilemap And Editor.ShapeUnderCursor And Not Editor.SelectShapes.DraggingState Then Return True
	End Method
	
	
	
	Method StartDragging()
		StartX = Editor.Cursor.X
		StartY = Editor.Cursor.Y
		LastDX = 0
		LastDY = 0
		
		If Not Editor.SelectedShapes.Contains( Editor.ShapeUnderCursor ) Then Editor.SelectShape( Editor.ShapeUnderCursor )
		
		Editor.Modifiers.Clear()
	End Method
	
	
	
	Method Dragging()
		Local DX:Float = Editor.Cursor.X - StartX
		Local DY:Float = Editor.Cursor.Y - StartY
		Editor.Grid.Snap( DX, DY )
		
		For Local Shape:LTShape = Eachin Editor.SelectedShapes
			Shape.X :+ DX - LastDX
			Shape.Y :+ DY - LastDY
		Next
		
		LastDX = DX
		LastDY = DY
	End Method
	
	
	
	Method EndDragging()
		If Editor.SelectedShapes.Count() = 1 Then Editor.SelectShape( LTShape( Editor.SelectedShapes.First() ) )
		Editor.SetChanged()
	End Method
End Type