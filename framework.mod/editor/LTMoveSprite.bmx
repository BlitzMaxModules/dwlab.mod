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

Type LTMoveSprite Extends LTDrag
	Field StartX:Float, StartY:Float
	Field LastDX:Float, LastDY:Float
	
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If MenuChecked( Editor.EditSprites ) And Editor.SpriteUnderCursor And Not Editor.SelectSprites.DraggingState Then Return True
	End Method
	
	
	
	Method StartDragging()
		StartX = Editor.Cursor.X
		StartY = Editor.Cursor.Y
		LastDX = 0
		LastDY = 0
		
		If Not Editor.SelectedSprites.Contains( Editor.SpriteUnderCursor ) Then
			Editor.SelectedSprites.Clear()
			Editor.SelectedSprites.AddLast( Editor.SpriteUnderCursor )
		End If
		
		Editor.Modifiers.Clear()
	End Method
	
	
	
	Method Dragging()
		Local DX:Float = Editor.Cursor.X - StartX
		Local DY:Float = Editor.Cursor.Y - StartY
		Editor.Grid.Snap( DX, DY )
		
		For Local Sprite:LTActor = Eachin Editor.SelectedSprites
			Sprite.X :+ DX - LastDX
			Sprite.Y :+ DY - LastDY
		Next
		
		LastDX = DX
		LastDY = DY
	End Method
	
	
	
	Method EndDragging()
		If Editor.SelectedSprites.Count() = 1 Then Editor.SelectSprite( LTActor( Editor.SelectedSprites.First() ) )
	End Method
End Type