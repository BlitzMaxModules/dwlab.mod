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
	
	
	
	Function Create:TPan( Camera:LTCamera )
		Local Pan:TPan = New TPan
		Pan.Camera = Camera
		Return Pan
	End Function
	
	
	
	Method DragKey:Int()
		If MouseDown( 3 ) Or KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		L_Cursor.SetMouseCoords( Camera )
		CameraStartingX = Camera.X
		CameraStartingY = Camera.Y
		CursorStartingX = L_Cursor.X
		CursorStartingY = L_Cursor.Y
	End Method
	
	
	
	Method Dragging()
		L_Cursor.SetMouseCoords( Camera )
		Camera.SetCoords( CameraStartingX + CursorStartingX - L_Cursor.X, CameraStartingY + CursorStartingY - L_Cursor.Y )
		L_Cursor.SetMouseCoords( Camera )
		CameraStartingX = Camera.X
		CameraStartingY = Camera.Y
		CursorStartingX = L_Cursor.X
		CursorStartingY = L_Cursor.Y
	End Method
End Type