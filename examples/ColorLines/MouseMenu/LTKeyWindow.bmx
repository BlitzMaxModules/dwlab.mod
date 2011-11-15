'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTKeyWindow Extends LTWindow
	Field Z:Int
	
	Method Init()
		Super.Init()
		FlushKeys()
		FlushMouse()
		Z = MouseZ()
		
		Local Label:LTLabel = LTLabel( FindShapeWithParameter( "text", "PressKey" ) )
		Label.Text = Label.Text.Replace( "*", "~q" + LocalizeString( "{{" + L_CurrentButtonAction.Name +"}}" ) + "~q" )
	End Method

	Method Act()
		Super.Act()
		For Local Code:Int = 1 To 255
			If KeyHit( Code ) Then
				L_CurrentButtonAction.AddButton( LTKeyboardKey.Create( Code ) )
				Menu.Project.CloseWindow( Self )
			End If
		Next
		
		For Local Num:Int = 2 To 3
			If MouseHit( Num ) Then
				L_CurrentButtonAction.AddButton( LTMouseButton.Create( Num ) )
				Menu.Project.CloseWindow( Self )
			End If
		Next
		
		If Z <> MouseZ() Then
			L_CurrentButtonAction.AddButton( LTMouseWheelAction.Create( Sgn( MouseZ() - Z ) ) )
			Menu.Project.CloseWindow( Self )
		End If
	End Method
	
	Method OnButtonDown( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If Gadget.GetParameter( "action" ) <> "close" And ButtonAction = L_LeftMouseButton Then
			L_CurrentButtonAction.AddButton( LTMouseButton.Create( 1 ) )
			Menu.Project.CloseWindow( Self )
		End If
	End Method
End Type