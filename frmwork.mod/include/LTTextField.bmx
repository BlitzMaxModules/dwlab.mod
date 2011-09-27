'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_ActiveTextField:LTTextField

Type LTTextField Extends LTGadget
	Field Text:String
	Field LeftPart:String
	Field RightPart:String

	
	
	Method GetValue:String()
		Return Text
	End Method
	
	
	
	Method SetValue( Value:String )
		Text = Value
		LeftPart = Value
		RightPart = ""
	End Method	
	
	
	
	Method Draw()
		Super.Draw()
		Local TextToDisplay:String
		If L_ActiveTextField = Self Then 
			TextToDisplay = LeftPart + Chr( $2588 ) + RightPart
		Else
			TextToDisplay = Text
		End If
		Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
		L_CurrentCamera.FieldToScreen( LeftX(), Y, SX, SY )
		L_CurrentCamera.FieldToScreen( Width, Height, SWidth, SHeight )
		DrawText( TextToDisplay, X + 0.5 * ( SHeight - 8 ), Y - 8 )
	End Method
	
	
	
	Method GetClassTitle:String()
		Return "Text field"
	End Method
	
	
	
	Method OnMouseDown( Button:Int )
		If Button = 1 Then
			L_ActiveTextField = Self
			LeftPart = Text
			RightPart = ""
		End If
	End Method
End Type