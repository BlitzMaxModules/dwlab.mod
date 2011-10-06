'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTKeyboardKey.bmx"
Include "LTMouseButton.bmx"
Include "LTMouseWheelAction.bmx"

Global L_Controllers:TList = New TList

Type LTPushable Extends LTObject
	Const JustPressed:Int = 0
	Const Pressed:Int = 1
	Const JustUnpressed:Int = 2
	Const Unpressed:Int = 3
	
	Field State:Int = Unpressed
	
	Method GetName:String()
	End Method
	
	Method Prepare()
		If IsDown() Then
			If State = Unpressed Then State = JustPressed
		Else
			If State = Pressed Then State = JustUnpressed
		End If
	End Method
	
	Method Flush()
		If IsDown() Then State = Pressed Else State = Unpressed
	End Method
	
	Method IsDown:Int()
	End Method
	
	Method WasPressed:Int()
		Return State = JustPressed
	End Method
	
	Method WasUnpressed:Int()
		Return State = JustUnpressed
	End Method
End Type
