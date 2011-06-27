'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Class for implementing dragging operations.
End Rem
Type LTDrag Extends LTObject
	Rem
	bbdoc: Dragging state: True if this dragging operation is currently active, False otherwise.
	End Rem
	Field DraggingState:Int
	
	
	
	Rem
	bbdoc: Method which should return True if drag key (or other similar controller) is down.
	returns: True is dragging key is down.
	about: Usually you should fill it with single line checking if dragging key is down.
	End Rem
	Method DragKey:Int()
	End Method
	
	
	
	Rem
	bbdoc: Method which should return True if all dragging conditions are met.
	returns: True if all dragging conditions are met.
	about: Fill it with conditions.
	End Rem
	Method DraggingConditions:Int()
		Return True
	End Method
	
	
	
	Rem
	bbdoc: Dragging starting method.
	about: Will be executed once when all dragging conditions are met and dragging key has been pressed.
	Fill it with dragging system initialization commands.
	End Rem
	Method StartDragging()
	End Method
	
	
	
	Rem
	bbdoc: Dragging method.
	about: Will be executed persistently during dragging process.
	Fill it with commands which will accompany dragging process.
	End Rem
	Method Dragging()
	End Method
	
	
	
	Rem
	bbdoc: Dragging ending method
	about: Will be executed when dragging key will be released during dragging.
	Fill it with dragging operation finalization commands.
	End Rem
	Method EndDragging()
	End Method
	
	
	
	Rem
	bbdoc: Dragging system executing method.
	about: Execute it persistently in your project Logic method or some object's Act() method.
	End Rem
	Method Execute()
		If DraggingState = False Then
			If DragKey() Then
				If DraggingConditions() Then
					DraggingState = True
					StartDragging()
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