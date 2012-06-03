'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTGameOverWindow Extends LTAudioWindow
	Method Init()
		Project.Locked = True
		Super.Init()
		LTLabel( FindShape( "ProfileName" ) ).Text = LocalizeString( L_CurrentProfile.Name )
		LTLabel( FindShape( "YourScore" ) ).Text = LocalizeString( "{{YourScore}}" ).Replace( "*", Profile.Score )
		If L_CurrentProfile.Name = "{{P_Player}}" And Profile.Score Then
			LTTextField( FindShape( "Name" ) ).Text = LocalizeString( "{{P_Player}}" )
		Else
			FindShapeWithParameter( "text", "Enter your name" ).Hide()
			FindShape( "Name" ).Hide()
		End If
		
		Repeat
			If Not Profile.Score Then Exit
			If Menu.HighScores.Count() = Menu.MaxHighScores Then
				If LTHighScore( Menu.HighScores.Last() ).Score <= Profile.Score Then Exit
			End If
			LTLabel( FindShape( "GameOver" ) ).Icon.Frame = 20
		 	Exit
		Forever
	End Method
	
	Method Save()
		If Profile.Score Then
			If Profile.Name = "{{P_Player}}" Then Profile.Name = LTTextField( FindShape( "Name" ) ).Text
			If Profile.Name Then Menu.AddHighScore( Profile.Name, Profile.Score )
		End If
		
		DestinationY = 0
		Menu.Project.LoadWindow( Menu.World, "LTScoresWindow" )
		
		Profile.Reset()
		Profile.Load()
	End Method
End Type