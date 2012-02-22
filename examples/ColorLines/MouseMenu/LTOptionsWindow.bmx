'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTOptionsWindow Extends LTAudioWindow
	Method Init()
		Super.Init()
		LTSlider( FindShape( "SoundVolume" ) ).Size = L_CurrentProfile.SoundVolume
		LTSlider( FindShape( "MusicVolume" ) ).Size = L_CurrentProfile.MusicVolume
	End Method

	Method Act()
		Super.Act()
		Local Label:LTLabel = LTLabel( FindShape( "Fullscreen" ) )
		If L_CurrentProfile.FullScreen Then
			Label.Text = LocalizeString( "{{Windowed}}" )
		Else
			Label.Text = LocalizeString( "{{Fullscreen}}" )
		End If
		LTSprite( Label.Icon ).Frame = 6 + L_CurrentProfile.FullScreen
		LTButton( FindShape( "SoundOn" ) ).State = L_CurrentProfile.SoundOn
		LTButton( FindShape( "MusicOn" ) ).State = L_CurrentProfile.MusicOn
		If BossKey.WasPressed() Then L_Boss
	End Method
	
	Method OnButtonPress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If ButtonAction <> L_LeftMouseButton Then Return
		Select Gadget.GetName()
			Case "SoundOn"
				L_CurrentProfile.SoundOn = Not L_CurrentProfile.SoundOn
				If L_CurrentProfile.SoundOn Then Menu.SoundOn.Play()
			Case "MusicOn"
				L_CurrentProfile.MusicOn = Not L_CurrentProfile.MusicOn
				If L_CurrentProfile.SoundOn Then Menu.ButtonClick.Play()
			Case "Fullscreen"
				If L_CurrentProfile.SoundOn Then Menu.ButtonClick.Play()
				L_CurrentProfile.FullScreen = Not L_CurrentProfile.FullScreen
				L_CurrentProfile.Apply( [ Menu.Project, LTGUIProject( Menu ) ], True, False, False )
			Case "Boss"
				If L_CurrentProfile.SoundOn Then Menu.Boss.Play()
				L_Boss()
		End Select
	End Method
	
	Method OnButtonDown( Gadget:LTGadget, ButtonAction:LTButtonAction )
		Super.OnButtonDown( Gadget, ButtonAction )
		If ButtonAction <> L_LeftMouseButton Then Return
		Select Gadget.GetName()
			Case "SoundVolume"
				L_CurrentProfile.SoundVolume = LTSlider( Gadget ).Size
			Case "MusicVolume"
				L_CurrentProfile.MusicVolume = LTSlider( Gadget ).Size
		End Select
	End Method
End Type



Function L_Boss()
	Local Image:TImage = LoadImage( L_MenuPath + "images\calculator.png" )
	EndGraphics()
	If L_ProjectWindow Then
		FreeGadget( L_ProjectWindow )
		DisablePolledInput()
	End If
	Local OldAppTitle:String = AppTitle
	AppTitle = LocalizeString( "{{Calculator}}" )
	Graphics( Image.Width, Image.Height )
	Repeat
		If AppTerminate() Then
			Menu.Project.DeInit()
			End
		End If
		
		For Local Num:Int = 1 To 3
			If MouseDown( Num ) Or BossKey.IsDown() Then
				AppTitle = OldAppTitle
				Menu.Project.Locked = True
				EndGraphics()
				L_ProjectWindow = Null
				L_CurrentProfile.Apply( [ LTProject( Menu ), LTProject( Menu.Project ) ], True, False, True )
				Return
			End If
		Next
		
		DrawImage( Image, 0, 0 )
		Flip
	Forever
End Function