'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTLanguageSelectionWindow Extends LTWindow
	Field LanguageMap:TMap = New TMap

	Method Init()
		For Local Button:LTButton = Eachin Children
			Local LanguageFile:String = Button.GetParameter( "file" )
			If LanguageFile Then
				SetLocalizationMode( Localization_On )
				Local Language:TMaxGuiLanguage = LoadLanguage( LanguageFile )
				SetLanguageName( Language, Button.GetParameter( "text" ) )
				If Button.GetParameter( "default" ) Then SetLocalizationLanguage( Language )
				LanguageMap.Insert( Button, Language )
				L_Languages.AddLast( Language )
			End If
		Next
		Super.Init()
	End Method
	
	Method OnClick( Gadget:LTGadget, Button:Int )
		If LTButton( Gadget ) Then
			L_CurrentProfile.Language = TMaxGuiLanguage( LanguageMap.ValueForKey( Gadget ) )
			SetLocalizationLanguage( L_CurrentProfile.Language )
			Project.Exiting = True
		End If
	End Method
End Type