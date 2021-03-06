'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTRemoveProfileWindow Extends LTAudioWindow
	Method Init()
		Super.Init()
		Local Label:LTLabel = LTLabel( FindShapeWithParameter( "text", "SureRemoveProfile" ) )
		Label.Text = Label.Text.Replace( "*", "~q" + LocalizeString( Menu.SelectedProfile.Name ) + "~q" )
	End Method
	
	Method Save()
		Menu.Profiles.Remove( Menu.SelectedProfile )
		L_CurrentProfile = LTProfile( Menu.Profiles.First() )
		Menu.SelectedProfile = L_CurrentProfile
	End Method
End Type