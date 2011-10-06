'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTButtonAction Extends LTObject
	Field Name:String
	Field Button:LTPushable
	
	Function Create:LTButtonAction( Button:LTPushable, Name:String = "" )
		Local ButtonAction:LTButtonAction = New LTButtonAction
		ButtonAction.Name = Name
		ButtonAction.Button = Button
		Return ButtonAction
	End Function
	
	Method GetButtonName:String()
		Return Button.GetName()
	End Method
	
	Method IsDown:Int()
		Return Button.IsDown()
	End Method
	
	Method WasPressed:Int()
		Return Button.WasPressed()
	End Method
	
	Method WasUnpressed:Int()
		Return Button.WasUnpressed()
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageStringAttribute( "name", Name )
		Button = LTPushable( XMLObject.ManageObjectField( "button", Button ) )
	End Method
End Type