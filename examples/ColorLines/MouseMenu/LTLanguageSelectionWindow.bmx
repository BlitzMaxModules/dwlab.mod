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
				Local Language:TMaxGuiLanguage = LoadLanguage( L_MenuPath + LanguageFile )
				SetLanguageName( Language, Button.GetParameter( "text" ) )
				If Button.GetParameter( "default" ) Then SetLocalizationLanguage( Language )
				LanguageMap.Insert( Button, Language )
				L_Languages.AddLast( Language )
			End If
		Next
		Super.Init()
	End Method
	
	Method Act()
		Super.Act()
	End Method
	
	Method OnButtonUnpress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If ButtonAction <> L_LeftMouseButton Then Return
		If LTButton( Gadget ) Then
			Local Language:TMaxGuiLanguage = TMaxGuiLanguage( LanguageMap.ValueForKey( Gadget ) )
			SetLocalizationLanguage( Language )
			L_CurrentProfile.Language = Language.GetName()
			Project.Exiting = True
		End If
	End Method
End Type