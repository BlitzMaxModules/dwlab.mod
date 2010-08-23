' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

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
			If DragKey() And DraggingConditions() Then
				StartDragging()
				DraggingState = True
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