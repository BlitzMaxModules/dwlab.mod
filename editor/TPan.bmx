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

Type TPan Extends LTDrag
	Field CursorX:Double
	Field CursorY:Double
	Field Camera:LTCamera
	
	
	
	Method DragKey:Int()
		If MouseDown( 3 ) Or KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		If Editor.MouseIsOver = Editor.TilesetCanvas Then
			L_CurrentCamera = Editor.TilesetCamera
			Editor.Cursor.SetMouseCoords()
		End If
		CursorX = Editor.Cursor.X
		CursorY = Editor.Cursor.Y
	End Method
	
	
	
	Method Dragging()
		Camera.X = CursorX - ( MouseX() - Camera.Viewport.X ) / Camera.XK
		Camera.Y = CursorY - ( MouseY() - Camera.Viewport.Y ) / Camera.YK
		Camera.Update()
	End Method
End Type