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
		Project.Locked = True
		Super.Init()
		LTLabel( FindShape( "ProfileName" ) ).Text = LocalizeString( L_CurrentProfile.Name )
		LTLabel( FindShape( "YourScore" ) ).Text = LocalizeString( "{{YourScore}}" ).Replace( "*", Game.Score )
		If L_CurrentProfile.Name = "{{P_Player}}" And Game.Score Then
			LTTextField( FindShape( "Name" ) ).Text = LocalizeString( "{{P_Player}}" )
		Else
			FindShapeWithParameter( "text", "Enter your name" ).Hide()
			FindShape( "Name" ).Hide()
		End If
		
		Repeat
			If Not Game.Score Then Exit
			If Menu.HighScores.Count() = Menu.MaxHighScores Then
				If LTHighScore( Menu.HighScores.Last() ).Score <= Game.Score Then Exit
			End If
			LTLabel( FindShapeWithParameter( "text", "Game over" ) ).Icon.Frame = 20
		 	Exit
		Forever
	End Method
	
	Method Save()
		If Game.Score Then
			If L_CurrentProfile.Name = "{{P_Player}}" Then L_CurrentProfile.Name = LTTextField( FindShape( "Name" ) ).Text
			If L_CurrentProfile.Name Then Menu.AddHighScore( L_CurrentProfile.Name, Game.Score )
		End If
		
		LTMenuWindow( Menu.Project.FindWindow( "LTMenuWindow" ) ).DestinationY = 0
		Menu.Project.LoadWindow( Menu.World, "LTScoresWindow" )
		
		L_CurrentProfile.Reset()
		L_CurrentProfile.Load()
	End Method
End Type