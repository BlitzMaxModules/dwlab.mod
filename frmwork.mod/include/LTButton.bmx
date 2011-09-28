'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTCheckBox.bmx"

Type LTButton Extends LTLabel
	Field State:Int
	Field Focus:Int
	
	
	
	Method Draw()
		If Visualizer.Image Then
			Select Visualizer.Image.FramesQuantity()
				Case 1; Frame = 0
				Case 2; Frame = State
				Case 4; Frame = State + Focus * 2
			End Select
		End If
		Super.Draw()
	End Method
	
	
	
	Method GetClassTitle:String()
		Return "Button"
	End Method

	
	
	Method OnMouseOver()
		Focus = True
	End Method
	
	
	
	Method OnMouseOut()
		Focus = False
	End Method
	
	
	
	Method OnMouseDown( Button:Int )
		State = True
	End Method
	
	
	
	Method OnMouseUp( Button:Int )
		State = False
	End Method
End Type