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

Rem
bbdoc: Common class for keys, buttons and mouse wheel rolls.
End Rem
Type LTPushable Extends LTObject
	Const JustPressed:Int = 0
	Const Pressed:Int = 1
	Const JustUnpressed:Int = 2
	Const Unpressed:Int = 3
	
	Field State:Int = Unpressed
	
	
	
	Rem
	bbdoc: Name of pushable object.
	returns: Name of object.
	about: You can use LocalizeString to get name in current language.
	End Rem
	Method GetName:String()
	End Method
	
	
	
	Method ProcessEvent( ID:Int )
	End Method
	
	
	
	Method Reset()
		Select State
			Case JustPressed
				State = Pressed
			Case JustUnpressed
				State = Unpressed
		End Select
	End Method
	
	
	
	Rem
	bbdoc: Function which checks is the object pressed.
	returns: True if pushable object is currently pressed.
	End Rem
	Method IsDown:Int()
		Return State = JustPressed Or State = Pressed
	End Method
	
	
	
	Method IsEqualTo:Int( Pushable:LTPushable )
	End Method
	
	
	
	Rem
	bbdoc: Function which checks was the object pressed.
	returns: True if pushable object was presed during this project cycle.
	End Rem
	Method WasPressed:Int()
		Return State = JustPressed
	End Method
	
	
	
	Rem
	bbdoc: Function which checks was the object unpressed.
	returns: True if pushable object was unpresed during this project cycle.
	End Rem
	Method WasUnpressed:Int()
		Return State = JustUnpressed
	End Method
End Type
