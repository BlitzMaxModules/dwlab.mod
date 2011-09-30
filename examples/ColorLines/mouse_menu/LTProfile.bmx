'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_CurrentProfile:LTProfile

Type LTProfile Extends LTObject
	Field Name:String
	Field Language:TMaxGUILanguage
	Field AudioDriver:TAudioDriver
	Field VideoDriver:TMax2DDriver
	Field FullScreen:Int
	Field ScreenWidth:Int
	Field ScreenHeight:Int
	Field ColorDepth:Int
	Field Frequency:Int
	
	Function CreateDefault()
		L_CurrentProfile = New LTProfile
		L_CurrentProfile.Name = "{{Player}}"
		Rem
		?win32
		L_CurrentProfile.VideoDriver = "DirectX7"
		L_CurrentProfile.AudioDriver = "DirectSound"
		?linux
		L_CurrentProfile.VideoDriver = "OpenGL"
		L_CurrentProfile.AudioDriver = "OpenAL"
		?macos
		L_CurrentProfile.VideoDriver = "OpenGL"
		L_CurrentProfile.AudioDriver = "OpenAL"
		?
		EndRem
		L_CurrentProfile.ScreenWidth = 1280
		L_CurrentProfile.ScreenHeight = 1024
		L_CurrentProfile.ColorDepth = 32
		L_CurrentProfile.Frequency = 60
	End Function
	
	Method SetLanguage( Name:String )
		For Local NewLanguage:TMaxGuiLanguage = Eachin Menu.Languages
			If NewLanguage.GetName() = Name Then Language = NewLanguage
		Next
	End Method
	
	Method SetVideoDriver( Name:String )
		For Local NewLanguage:TMaxGuiLanguage = Eachin Menu.Languages
			If NewLanguage.GetName() = Name Then Language = NewLanguage
		Next
	End Method
	
	Function Apply()
		
	End Function
End Type



Type LTScreenResolution Extends LTTextListItem
	Field Width:Int
	Field Height:Int
	Field ColorDepths:TList = New TList
	
	Function Add( Width:Int, Height:Int, Bits:Int, Hertz:Int )
		For Local Resolution:LTScreenResolution = Eachin Menu.ScreenResolutions
			If Resolution.Width = Width And Resolution.Height Then
				LTColorDepth.Add( Resolution, Bits, Hertz )
				Return
			End If
		Next
		
		Local Resolution:LTScreenResolution = New LTScreenResolution
		Resolution.Width = Width
		Resolution.Height = Height
		LTColorDepth.Add( Resolution, Bits, Hertz )
	End Function
End Type



Type LTColorDepth Extends LTTextListItem
	Field Bits:Int
	Field Frequencies:TList = New TList
	
	Function Add( Resolution:LTScreenResolution, Bits:Int, Hertz:Int )
		For Local ColorDepth:LTColorDepth = Eachin Resolution.ColorDepths
			If ColorDepth.Bits = Bits Then
				LTFrequency.Add( ColorDepth, Hertz )
				Return
			End If
		Next
		
		Local ColorDepth:LTColorDepth = New LTColorDepth
		ColorDepth.Bits = Bits
		LTFrequency.Add( ColorDepth, Hertz )
	End Function
End Type



Type LTFrequency Extends LTTextListItem
	Field Hertz:Int
	
	Function Add( ColorDepth:LTColorDepth, Hertz:Int )
		Local Frequency:LTFrequency = New LTFrequency
		Frequency.Hertz = Hertz
		ColorDepth.Frequencies.AddLast( Frequency )
	End Function
End Type