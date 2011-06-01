'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTDrag Extends LTObject
	Field DraggingState:Int
	
	
	
	Method DragKey:Int()
	End Method
	
	
	
	Method DraggingConditions:Int()
		Return True
	End Method
	
	
	
	Method StartDragging()
	End Method
	
	
	
	Method Dragging()
	End Method
	
	
	
	Method EndDragging()
	End Method
	
	
	
	Method Execute()
		If DraggingState = False Then
			If DragKey() Then
				If DraggingConditions() Then
					StartDragging()
					DraggingState = True
				End If
			End If
		Else
			If DragKey() Then
				Dragging()
			Else
				DraggingState = False
				EndDragging()
			End If
		End If
	End Method
End Type