'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTAddProfileWindow Extends LTAudioWindow
	Method Save()
		Local Name:String = LTTextField( FindShape( "ProfileName" ) ).Text
		If Name Then
			Local Profile:LTProfile = L_CurrentProfile.Clone()
			Profile.Name = Name
			Profile.Init()
			Profile.Reset()
			Menu.Profiles.AddLast( Profile )
			Menu.SelectedProfile = Profile
		End If
	End Method
End Type