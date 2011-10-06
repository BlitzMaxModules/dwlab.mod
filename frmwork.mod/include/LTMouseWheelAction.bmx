'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTMouseWheelAction Extends LTPushable
	Field Z:Int
	Field Direction:Int
	
	Method Prepare()
		If Direction * ( MouseZ() - Z ) > 0 Then State = JustPressed
	End Method
	
	Method Flush()
		State = Unpressed
		Z = MouseZ()
	End Method
	
	Method IsDown:Int()
		Return State = JustPressed
	End Method
	
	Function Create:LTMouseWheelAction( Direction:Int )
		If Abs( Direction ) <> 1 Then L_Error( "Invalid mouse wheel direction" )
		
		For Local WheelAction:LTMouseWheelAction = Eachin L_Controllers
			If WheelAction.Direction = Direction Then Return WheelAction
		Next
		
		Local WheelAction:LTMouseWheelAction = New LTMouseWheelAction
		WheelAction.Direction = Direction
		L_Controllers.AddLast( WheelAction )
		Return WheelAction
	End Function
	
	Method GetName:String()
		Select Direction
			Case -1
				Return "Mouse wheel up"
			Case 1
				Return "Mouse wheel down"
		End Select
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageIntAttribute( "direction", Direction )
	End Method
End Type