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
bbdoc: Class for action which can be triggered by activating pushable object (presing a key, mouse button, etc).
about: Key can be binded to several actions and several keys can be binded to one action.
End Rem	
Type LTButtonAction Extends LTObject
	Field Name:String
	Field ButtonList:TList = New TList
	
	Rem
	bbdoc: Maximum quantity of buttons in button list (0 means unlimited).
	End Rem	
	Field MaxButtons:Int = 3
	
	
	
	Method GetButtonNames:String( WithBrackets:Int = False )
		Local Names:String = ""
		For Local Button:LTPushable = Eachin ButtonList
			If Names Then Names :+ ", "
			If WithBrackets Then
				Names :+ "{{" + Button.GetName() + "}}"
			Else
				Names :+ Button.GetName()
			End If
		Next
		Return Names
	End Method
	
	
	
	Rem
	bbdoc: Creates button action with given pushable object (button) and name (optional).
	returns: New button action with one pushable object (button).
	End Rem
	Function Create:LTButtonAction( Button:LTPushable, Name:String = "" )
		Local ButtonAction:LTButtonAction = New LTButtonAction
		ButtonAction.Name = Name
		ButtonAction.ButtonList.AddLast( Button )
		Return ButtonAction
	End Function
	
	
	
	Rem
	bbdoc: Adds given pushable object (button) to the button action button list.
	End Rem
	Method AddButton( Button:LTPushable )
		For Local OldButton:LTPushable = Eachin ButtonList
			If OldButton.IsEqualTo( Button ) Then Return
		Next
		ButtonList.AddLast( Button )
		If MaxButtons > 0 Then If ButtonList.Count() > MaxButtons Then ButtonList.RemoveFirst()
	End Method
	
	
	
	Rem
	bbdoc: Removes all pushable objects (buttons) of the button action.
	End Rem
	Method Clear()
		ButtonList.Clear()
	End Method	
	
	
	
	Rem
	bbdoc: Function which checks button action pressing state.
	returns: True if one of pushable objects (buttons) of this action is currently pressed.
	End Rem
	Method IsDown:Int()
		For Local Button:LTPushable = Eachin ButtonList
			If Button.IsDown() Then Return True
		Next
	End Method
	
	
	
	Rem
	bbdoc: Function which checks button action just-pressing state.
	returns: True if one of pushable objects (buttons) of this action was pressed in current project cycle.
	End Rem
	Method WasPressed:Int()
		For Local Button:LTPushable = Eachin ButtonList
			If Button.WasPressed() Then Return True
		Next
	End Method
	
	
	
	Rem
	bbdoc: Function which checks button action just-unpressing state.
	returns: True if one of pushable objects (buttons) of this action was unpressed in current project cycle.
	End Rem	
	Method WasUnpressed:Int()
		For Local Button:LTPushable = Eachin ButtonList
			If Button.WasUnpressed() Then Return True
		Next
	End Method
	
	
	
	Function Find:LTButtonAction( Keys:TList, Name:String )
		For Local ButtonAction:LTButtonAction = Eachin Keys
			If ButtonAction.Name = Name Then Return ButtonAction
		Next
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageStringAttribute( "name", Name )
		XMLObject.ManageChildList( ButtonList )
	End Method
End Type