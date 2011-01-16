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

Type TSelectSprites Extends LTDrag
	Field StartX:Float, StartY:Float
	Field Frame:LTSprite


	Method DraggingConditions:Int()
		If MenuChecked( Editor.EditSprites ) And Not Editor.SpriteUnderCursor And Not Editor.MoveSprite.DraggingState Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		StartX = Editor.Cursor.X
		StartY = Editor.Cursor.Y
		Frame = New LTSprite
		Frame.Shape = L_Rectangle
		Editor.SelectedSprites.Clear()
		Editor.Modifiers.Clear()
	End Method
	
	
	
	Method Dragging()
		Frame.X = 0.5 * ( StartX + Editor.Cursor.X )
		Frame.Y = 0.5 * ( StartY + Editor.Cursor.Y )
		Frame.Width = Abs ( StartX - Editor.Cursor.X )
		Frame.Height = Abs ( StartY - Editor.Cursor.Y )
	End Method
	
	
	
	Method EndDragging()
		For Local Sprite:LTSprite = Eachin Editor.CurrentPage.Sprites
			If Frame.OverlapsSprite( Sprite ) Then Editor.SelectedSprites.AddLast( Sprite )
		Next
		Editor.FillSpriteFields()
		Frame = Null
	End Method
End Type