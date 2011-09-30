'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTSettingsWindow Extends LTWindow
	

	Method GetTextFieldText:String( Name:String )
		Select Name
			Case "Language"
				Return L_CurrentProfile.Language.GetName()
			Case "Resolution"
				Return L_CurrentProfile.ScreenWidth + " x " + L_CurrentProfile.ScreenHeight
			Case "ColorDepth"
				Return L_CurrentProfile.ColorDepth + " bit"
			Case "Frequency"
				Return L_CurrentProfile.Frequency + " Hz"
			Case "VideoDriver"
				'Return L_CurrentProfile.VideoDriver.
		End Select
	End Method
	
	Method OnClick( Gadget:LTGadget, Button:Int )
		Select Gadget.GetParameter( "action" )
			Case "scroll_up"
				ChangeListItem( Gadget.GetParameter( "gadget" ), -1 )
			Case "scroll_down"
				ChangeListItem( Gadget.GetParameter( "gadget" ), +1 )
			Default
				Super.OnClick( Gadget, Button )
		End Select
	End Method
	
	Method ChangeListItem( GadgetName:String, D:Int = 0 )
		
	End Method
End Type