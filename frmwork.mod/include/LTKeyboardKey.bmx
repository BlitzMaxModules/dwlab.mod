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
bbdoc: Class for keyboard keys.
End Rem
Type LTKeyboardKey Extends LTPushable
	Field Code:Int
	
	
	
	Method GetName:String()
		Select Code
			Case KEY_BACKSPACE
				Return "Backspace"
			Case KEY_TAB
				Return "Tab"
			Case KEY_CLEAR
			Case KEY_ENTER
				Return "Enter"
			Case KEY_ESCAPE
				Return "Esc"
			Case KEY_SPACE
				Return "Space"
			Case KEY_PAGEUP
				Return "Page up"
			Case KEY_PAGEDOWN
				Return "Page down"
			Case KEY_END
				Return "End"
			Case KEY_HOME
				Return "Home"
			Case KEY_LEFT
				Return "Left arrow"
			Case KEY_UP
				Return "Up arrow"
			Case KEY_RIGHT
				Return "Right arrow"
			Case KEY_DOWN
				Return "Down arrow"
			Case KEY_SELECT
				Return "Select"
			Case KEY_PRINT
				Return "Print"
			Case KEY_EXECUTE
				Return "Execute"
			Case KEY_SCREEN
				Return "Screen"
			Case KEY_INSERT
				Return "Insert"
			Case KEY_DELETE
				Return "Delete"
			Case KEY_0
				Return "0"
			Case KEY_1
				Return "1"
			Case KEY_2
				Return "2"
			Case KEY_3
				Return "3"
			Case KEY_4
				Return "4"
			Case KEY_5
				Return "5"
			Case KEY_6
				Return "6"
			Case KEY_7
				Return "7"
			Case KEY_8
				Return "8"
			Case KEY_9
				Return "9"
			Case KEY_A
				Return "A"
			Case KEY_B
				Return "B"
			Case KEY_C
				Return "C"
			Case KEY_D
				Return "D"
			Case KEY_E
				Return "E"
			Case KEY_F
				Return "F"
			Case KEY_G
				Return "G"
			Case KEY_H
				Return "H"
			Case KEY_I
				Return "I"
			Case KEY_J
				Return "J"
			Case KEY_K
				Return "K"
			Case KEY_L
				Return "L"
			Case KEY_M
				Return "M"
			Case KEY_N
				Return "N"
			Case KEY_O
				Return "O"
			Case KEY_P
				Return "P"
			Case KEY_Q
				Return "Q"
			Case KEY_R
				Return "R"
			Case KEY_S
				Return "S"
			Case KEY_T
				Return "T"
			Case KEY_U
				Return "U"
			Case KEY_V
				Return "V"
			Case KEY_W
				Return "W"
			Case KEY_X
				Return "X"
			Case KEY_Y
				Return "Y"
			Case KEY_Z
				Return "Z"
			Case KEY_NUM0
				Return "Num 0"
			Case KEY_NUM1
				Return "Num 1"
			Case KEY_NUM2
				Return "Num 2"
			Case KEY_NUM3
				Return "Num 3"
			Case KEY_NUM4
				Return "Num 4"
			Case KEY_NUM5
				Return "Num 5"
			Case KEY_NUM6
				Return "Num 6"
			Case KEY_NUM7
				Return "Num 7"
			Case KEY_NUM8
				Return "Num 8"
			Case KEY_NUM9
				Return "Num 9"
			Case KEY_NUMMULTIPLY
				Return "Num *"
			Case KEY_NUMADD
				Return "Num +"
			Case KEY_NUMSUBTRACT
				Return "Num -"
			Case KEY_NUMDECIMAL
				Return "Num ."
			Case KEY_NUMDIVIDE
				Return "Num /"
			Case KEY_F1
				Return "F1"
			Case KEY_F2
				Return "F2"
			Case KEY_F3
				Return "F3"
			Case KEY_F4
				Return "F4"
			Case KEY_F5
				Return "F5"
			Case KEY_F6
				Return "F6"
			Case KEY_F7
				Return "F7"
			Case KEY_F8
				Return "F8"
			Case KEY_F9
				Return "F9"
			Case KEY_F10
				Return "F10"
			Case KEY_F11
				Return "F11"
			Case KEY_F12
				Return "F12"
			Case KEY_TILDE
				Return "~~"
			Case KEY_MINUS
				Return "-"
			Case KEY_EQUALS
				Return "="
			Case KEY_OPENBRACKET
				Return "["
			Case KEY_CLOSEBRACKET
				Return "]"
			Case KEY_BACKSLASH
				Return "\"
			Case KEY_SEMICOLON
				Return ";"
			Case KEY_QUOTES
				Return "~q"
			Case KEY_COMMA
				Return ","
			Case KEY_PERIOD
				Return "."
			Case KEY_SLASH
				Return "/"
			Case KEY_LSHIFT
				Return "Left Shift"
			Case KEY_RSHIFT
				Return "Right Shift"
			Case KEY_LCONTROL
				Return "Left Ctrl"
			Case KEY_RCONTROL
				Return "Right Ctrl"
			Case KEY_LALT
				Return "Left Alt"
			Case KEY_RALT
				Return "Right Alt"
		End Select
	End Method
	
	
	
	Method IsEqualTo:Int( Pushable:LTPushable )
		Local Key:LTKeyboardKey = LTKeyboardKey( Pushable )
		If Key Then Return Code = Key.Code
	End Method
	
	
	
	Method ProcessEvent( ID:Int )
		If EventData() <> Code Then Return
		Select ID
			Case EVENT_KEYDOWN
				State = JustPressed
			Case EVENT_KEYUP
				State = JustUnpressed
		End Select
	End Method
	
	
	
	Rem
	bbdoc: Creates keyboard key object.
	returns: New object of keyboard key with given code.
	End Rem	
	Function Create:LTKeyboardKey( Code:Int )
		For Local Key:LTKeyboardKey = Eachin L_Controllers
			If Key.Code = Code Then Return Key
		Next
		
		Local Key:LTKeyboardKey = New LTKeyboardKey
		Key.Code = Code
		L_Controllers.AddLast( Key )
		Return Key
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageIntAttribute( "code", Code )
		If L_XMLMode = L_XMLGet Then L_Controllers.AddLast( Self )
	End Method
End Type