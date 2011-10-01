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
	Method Init()
		For Local Label:LTLabel = Eachin Children
			If Not Label.Text Then Label.Text = GetText( Label.GetName() )
		Next
		Super.Init()
	End Method

	Method GetText:String( Name:String )
		Select Name
			Case "Language"
				Return L_CurrentProfile.Language.GetName()
			Case "Resolution"
				Return L_CurrentProfile.Resolution.Width + " x " + L_CurrentProfile.Resolution.Height
			Case "ColorDepth"
				Return L_CurrentProfile.ColorDepth.Bits + LocalizeString( " {{bit}}" )
			Case "Frequency"
				Return L_CurrentProfile.Frequency.Hertz + LocalizeString( " {{Hz}}" )
			Case "VideoDriver"
				Return L_CurrentProfile.VideoDriver.Name
			Case "AudioDriver"
				Return L_CurrentProfile.AudioDriver
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
		Local Name:String = Gadget.GetParameter( "gadget" )
		Select Name
			Case "Language"
				SwitchListItem( L_Languages, L_CurrentProfile.Language, Direction )
			Case "Resolution"
				SwitchListItem( L_ScreenResolutions, L_CurrentProfile.Resolution, Direction )
			Case "ColorDepth"
				SwitchListItem( L_CurrentProfile.Resolution.ColorDepths, L_CurrentProfile.ColorDepth, Direction )
			Case "Frequency"
				SwitchListItem( L_CurrentProfile.ColorDepth.Frequencies, L_CurrentProfile.Frequency, Direction )
			Case "VideoDriver"
				SwitchListItem( L_VideoDrivers, L_CurrentProfile.VideoDriver, Direction )
			Case "AudioDriver"
				SwitchListItem( L_AudioDrivers, L_CurrentProfile.AudioDriver, Direction )
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
		L_CurrentProfile.Apply()
		Project.InitGraphics()
		Project.InitSound()
		Menu.InitGraphics()
		Project.Windows.Clear()
		Project.LoadWindow( World, , "LTMenuWindow" )
		Project.LoadWindow( World, , "LTOptionsWindow" )
	End Method
End Type