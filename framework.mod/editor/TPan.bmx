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
	Field CursorX:Float
	Field CursorY:Float
	
	
	
	Method DragKey:Int()
		If MouseDown( 3 ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		CursorX = Editor.Cursor.X
		CursorY = Editor.Cursor.Y
	End Method
	
	
	
	Method Dragging()
		L_CurrentCamera.X = CursorX - ( MouseX() - L_CurrentCamera.Viewport.X ) / L_CurrentCamera.XK
		L_CurrentCamera.Y = CursorY - ( MouseY() - L_CurrentCamera.Viewport.Y ) / L_CurrentCamera.YK
		L_CurrentCamera.Update()
	End Method
End Type