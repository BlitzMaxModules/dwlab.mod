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
	Field CameraStartingX:Double
	Field CameraStartingY:Double
	Field CursorStartingX:Double
	Field CursorStartingY:Double
	Field Camera:LTCamera
	
	
	
	Method DragKey:Int()
		If MouseDown( 3 ) Or KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		'If Editor.MouseIsOver = Editor.TilesetCanvas Then L_CurrentCamera = Editor.TilesetCamera Else 
		L_CurrentCamera = Camera
		Editor.Cursor.SetMouseCoords()
		CameraStartingX = Camera.X
		CameraStartingY = Camera.Y
		CursorStartingX = Editor.Cursor.X
		CursorStartingY = Editor.Cursor.Y
	End Method
	
	
	
	Method Dragging()
		L_CurrentCamera = Camera
		Editor.Cursor.SetMouseCoords()
		Camera.SetCoords( CameraStartingX + CursorStartingX - Editor.Cursor.X, CameraStartingY + CursorStartingY - Editor.Cursor.Y )
		Editor.Cursor.SetMouseCoords()
		CameraStartingX = Camera.X
		CameraStartingY = Camera.Y
		CursorStartingX = Editor.Cursor.X
		CursorStartingY = Editor.Cursor.Y
	End Method
End Type