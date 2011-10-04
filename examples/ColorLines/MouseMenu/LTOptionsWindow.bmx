'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTOptionsWindow Extends LTWindow
	Method Init()
		Super.Init()
		InitButton()
	End Method
	
	Method InitButton()
		For Local Label:LTLabel = Eachin Children
			If Label.GetName() = "Fullscreen" Then
				If L_CurrentProfile.FullScreen Then Label.Text = LocalizeString( "{{Fullscreen}}" ) Else Label.Text = LocalizeString( "{{Windowed}}" )
			End If
		Next
	End Method
	
	Method OnClick( Gadget:LTGadget, Button:Int )
		Select Gadget.GetName()
			Case "Fullscreen"
				L_CurrentProfile.FullScreen = Not L_CurrentProfile.FullScreen
				L_CurrentProfile.Apply( True, [ Menu ], True )
				InitButton()
		End Select
	End Method
End Type