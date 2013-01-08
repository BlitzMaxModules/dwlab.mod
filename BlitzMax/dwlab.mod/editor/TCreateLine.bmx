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
	
	
	
	Method DragKey:Int()
		Return MouseDown( 2 )
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Not Editor.CurrentTileMap And Editor.CurrentContainer And LTSprite( Editor.ShapeUnderCursor ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		Sprite = LTSprite( Editor.ShapeUnderCursor )
		'Editor.CurrentLine = N
	End Method
	
	
	
	Method Dragging()
		
	End Method
	
	
	
	Method EndDragging()
	End Method
End Type