'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTGameOverWindow Extends LTWindow
	Method Init()
		Super.Init()
		LTLabel( FindShapeWithParameter( "LTLabel", "text", "YourScore" ) ).Text.Replace( "*", L_CurrentProfile.Score )
		If L_CurrentProfile.Name = "{{Player}}" Then
			LTTextField( FindShape( "Name" ) ).Text = LocalizeString( "{{Player}}" )
		Else
			FindShape( "EnterYourName" ).Hide()
			FindShape( "Name" ).Hide()
		End If
	End Method
	
	Method Save()
		If L_CurrentProfile.Name = "{{Player}}" Then L_CurrentProfile.Name = LTTextField( FindShape( "Name" ) ).Text
		Menu.AddHighScore( L_CurrentProfile.Name, L_CurrentProfile.Score )
		L_CurrentProfile.Score = 0
		L_CurrentProfile.Init()
	End Method
End Type