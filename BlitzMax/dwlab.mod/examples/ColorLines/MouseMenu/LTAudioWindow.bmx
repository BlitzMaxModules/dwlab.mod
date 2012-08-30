'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTAudioWindow Extends LTWindow
	Method OnButtonPress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If ButtonAction = L_LeftMouseButton And L_CurrentProfile.SoundOn And LTButton( Gadget ) Then
			Select Gadget.GetParameter( "action" )
				Case "close", "save_and_close"
					L_CurrentProfile.PlaySnd( Menu.Close )
				Default
					L_CurrentProfile.PlaySnd( Menu.ButtonClick )
			End Select
		End If
		Super.OnButtonPress( Gadget, ButtonAction )
	End Method
End Type