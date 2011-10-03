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
	Field Language:TMaxGuiLanguage
	Field Resolution:LTScreenResolution
	Field ColorDepth:LTColorDepth
	Field Frequency:LTFrequency
	Field VideoDriver:LTVideoDriver
	Field AudioDriver:String

	Method Init()
		Language = LTProfile.GetLanguage( L_CurrentProfile.Language )
		Resolution = LTScreenResolution.Get( L_CurrentProfile.ScreenWidth, L_CurrentProfile.ScreenHeight )
		ColorDepth = LTColorDepth.Get( Resolution, L_CurrentProfile.ColorDepth )
		Frequency = LTFrequency.Get( ColorDepth, L_CurrentProfile.Frequency )
		VideoDriver = LTVideoDriver.Get( L_CurrentProfile.VideoDriver )
		AudioDriver = L_CurrentProfile.AudioDriver
		
		For Local Label:LTLabel = Eachin Children
			If Not Label.Text Then Label.Text = GetText( Label.GetName() )
		Next
		
		Super.Init()
	End Method

	Method GetText:String( Name:String )
		Select Name
			Case "Language"
				Return Language.GetName()
			Case "Resolution"
				Return Resolution.Width + " x " + Resolution.Height
			Case "ColorDepth"
				Return ColorDepth.Bits + LocalizeString( " {{bit}}" )
			Case "Frequency"
				Return Frequency.Hertz + LocalizeString( " {{Hz}}" )
			Case "VideoDriver"
				Return VideoDriver.Name
			Case "AudioDriver"
				Return AudioDriver
		End Select
	End Method
	
	Method OnClick( Gadget:LTGadget, Button:Int )
		Select Gadget.GetParameter( "action" )
			Case "scroll_up"
				ChangeListItem( Gadget, -1 )
			Case "scroll_down"
				ChangeListItem( Gadget, +1 )
			Default
				Super.OnClick( Gadget, Button )
		End Select
	End Method
	
	Method ChangeListItem( Gadget:LTGadget, Direction:Int = 0 )
		Local Name:String = Gadget.GetParameter( "gadget_name" )
		Select Name
			Case "Language"
				SwitchListItem( L_Languages, Language, Direction )
			Case "Resolution"
				SwitchListItem( L_ScreenResolutions, Resolution, Direction )
			Case "ColorDepth"
				SwitchListItem( Resolution.ColorDepths, ColorDepth, Direction )
			Case "Frequency"
				SwitchListItem( ColorDepth.Frequencies, Frequency, Direction )
			Case "VideoDriver"
				SwitchListItem( L_VideoDrivers, VideoDriver, Direction )
			Case "AudioDriver"
				SwitchListItem( L_AudioDrivers, AudioDriver, Direction )
		End Select
		For Local Label:LTLabel = Eachin Children
			If Label.GetName() = Name Then Label.Text = GetText( Name )
		Next
	End Method
	
	Method SwitchListItem( List:TList, Item:Object Var, Direction:Int )
		Local Link:TLink = List.FirstLink()
		While Link
			If Link.Value() = Item Then
				If Direction < 0 Then
					Link = Link._pred
					If Link.Value() = Link Then Link = Link._pred
				Else
					Link = Link._succ
					If Link.Value() = Link Then Link = Link._succ
				End If
				Item = Link.Value()
				Exit
			End If
			Link = Link.NextLink()
		WEnd
	End Method
	
	Method Save()
		Local NewScreen:Int, NewVideoDriver:Int, NewAudioDriver:Int
		L_CurrentProfile.Language = Language.GetName()
		
		If L_CurrentProfile.ScreenWidth <> Resolution.Width Or L_CurrentProfile.ScreenHeight <> Resolution.Height Or ..
				L_CurrentProfile.ColorDepth <> ColorDepth.Bits Or L_CurrentProfile.Frequency <> Frequency.Hertz Then NewScreen = True
		L_CurrentProfile.ScreenWidth = Resolution.Width
		L_CurrentProfile.ScreenHeight = Resolution.Height
		L_CurrentProfile.ColorDepth = ColorDepth.Bits
		L_CurrentProfile.Frequency = Frequency.Hertz
		
		If L_CurrentProfile.VideoDriver <> VideoDriver.Name Then NewVideoDriver = True
		L_CurrentProfile.VideoDriver = VideoDriver.Name
		
		If L_CurrentProfile.AudioDriver <> AudioDriver Then NewAudioDriver = True
		L_CurrentProfile.AudioDriver = AudioDriver
		
		L_CurrentProfile.Apply( True, [ LTProject( Project ), LTProject( Menu ) ], NewScreen, NewVideoDriver, NewAudioDriver )
		
		Project.Windows.Clear()
		Project.LoadWindow( World, , "LTMenuWindow" )
		Project.LoadWindow( World, , "LTOptionsWindow" )
	End Method
End Type