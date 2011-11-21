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
		Menu.Project.FindWindow( "", "LTOptionsWindow" ).Active = False
	End Method

	Method Act()
		Super.Act()
		For Local Code:Int = 1 To 255
			If KeyHit( Code ) Then
				AddButton( LTKeyboardKey.Create( Code ) )
			End If
		Next
		
		For Local Num:Int = 2 To 3
			If MouseHit( Num ) Then
				AddButton( LTMouseButton.Create( Num ) )
			End If
		Next
		
		If Z <> MouseZ() Then
			AddButton( LTMouseWheelAction.Create( Sgn( MouseZ() - Z ) ) )
		End If
	End Method
	
	Method OnButtonDown( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If Gadget.GetParameter( "action" ) <> "close" And ButtonAction = L_LeftMouseButton Then
			AddButton( LTMouseButton.Create( 1 ) )
		End If
	End Method
	
	Method AddButton( Button:LTPushable )
		For Local ButtonAction:LTButtonAction = Eachin L_CurrentProfile.Keys
			ButtonAction.ButtonList.Remove( Button )
		Next
		L_CurrentButtonAction.AddButton( Button )
		Menu.Project.CloseWindow( Self )
	End Method	
	
	Method DeInit()
		Menu.Project.FindWindow( "", "LTOptionsWindow" ).Active = True
	End Method
End Type