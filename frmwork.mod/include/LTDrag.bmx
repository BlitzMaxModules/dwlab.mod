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
bbdoc: 
returns: 
about: 
End Rem
Type LTDrag Extends LTObject
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Field DraggingState:Int
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method DragKey:Int()
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method DraggingConditions:Int()
		Return True
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method StartDragging()
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method Dragging()
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method EndDragging()
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
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