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

Type TCreateLine Extends LTDrag
	Field Sprite:LTSprite
	Field Cursor:LTSprite
	
	
	
	Method DragKey:Int()
		Return MouseDown( 2 )
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Not Editor.CurrentTileMap And Editor.CurrentContainer And Editor.ShapeUnderCursor And Not Editor.CreateSprite.DraggingState Then Return True
	End Method
	
	
	
	Method StartDragging()
		Sprite = LTSprite( Editor.ShapeUnderCursor )
	End Method
	
	
	
	Method Dragging()
		Cursor = Editor.Cursor
		If Editor.ShapeUnderCursor And  Editor.ShapeUnderCursor<> Sprite Then Cursor = LTSprite( Editor.ShapeUnderCursor )
	End Method
	
	
	
	Method EndDragging()
		If Editor.ShapeUnderCursor Then
			Local LineSegment:LTLineSegment = LTLineSegment.FromPivots( Sprite, Cursor )
			Editor.InsertIntoContainer( LineSegment, Editor.CurrentContainer )
			Editor.SelectShape( LineSegment )
			Editor.SetChanged()
		End If
		Sprite = Null
	End Method
End Type