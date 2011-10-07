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
		LTSlider( FindShape( "SoundVolume" ) ).Size = L_CurrentProfile.SoundVolume
		LTSlider( FindShape( "MusicVolume" ) ).Size = L_CurrentProfile.MusicVolume
	End Method

	Method Act()
		Super.Act()
		If L_CurrentProfile.FullScreen Then
			LTLabel( FindShape( "Fullscreen" ) ).Text = LocalizeString( "{{Fullscreen}}" )
		Else
			LTLabel( FindShape( "Fullscreen" ) ).Text = LocalizeString( "{{Windowed}}" )
		End If
		LTButton( FindShape( "SoundOn" ) ).State = L_CurrentProfile.SoundOn
		LTButton( FindShape( "MusicOn" ) ).State = L_CurrentProfile.MusicOn
	End Method
	
	Method OnButtonPress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If ButtonAction <> L_ClickButton Then Return
		Select Gadget.GetName()
			Case "Fullscreen"
				L_CurrentProfile.FullScreen = Not L_CurrentProfile.FullScreen
				L_CurrentProfile.Apply( [ Menu.Project, LTGUIProject( Menu ) ], True )
			Case "SoundOn"
				L_CurrentProfile.SoundOn = Not L_CurrentProfile.SoundOn
			Case "MusicOn"
				L_CurrentProfile.MusicOn = Not L_CurrentProfile.MusicOn
		End Select
	End Method
	
	Method OnButtonDown( Gadget:LTGadget, ButtonAction:LTButtonAction )
		Super.OnButtonDown( Gadget, ButtonAction )
		If ButtonAction <> L_ClickButton Then Return
		Select Gadget.GetName()
			Case "SoundVolume"
				L_CurrentProfile.SoundVolume = LTSlider( Gadget ).Size
			Case "MusicVolume"
				L_CurrentProfile.MusicVolume = LTSlider( Gadget ).Size
		End Select
	End Method
End Type