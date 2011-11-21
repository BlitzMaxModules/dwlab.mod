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
bbdoc: Class for text fields for entering text.
about: If window has text fields, one will be set as active. User can select active text field by clicking on another text field.
End Rem
Type LTTextField Extends LTGadget
	Field Text:String
	Field LeftPart:String
	Field RightPart:String
	Field MaxSymbols:Int = 0
	
	
	
	Method Init()
		Super.Init()
		L_ActiveTextField = Self
		MaxSymbols = GetParameter( "max" ).ToInt()
	End Method
	
	
	
	Method Draw()
		If Not Visible Then Return
		Super.Draw()
		SetColor( 0, 0, 0 )
		If L_ActiveTextField = Self Then
			PrintText( " " + LeftPart + "_" + RightPart, LTAlign.ToLeft )
		Else
			PrintText( " " + Text, LTAlign.ToLeft )
		End If
		LTVisualizer.ResetColor()
	End Method
	
	
	
	Method GetClassTitle:String()
		Return "Text field"
	End Method
	
	
	
	Method OnButtonPress( ButtonAction:LTButtonAction )
		If ButtonAction <> L_LeftMouseButton Then Return
		L_ActiveTextField = Self
		LeftPart = Text
		RightPart = ""
	End Method
End Type