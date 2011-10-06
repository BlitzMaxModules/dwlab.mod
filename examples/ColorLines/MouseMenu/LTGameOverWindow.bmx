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
		LTLabel( FindShape( "YourScore" ) ).Text = LocalizeString( "{{YourScore}}" ).Replace( "*", Game.Score )
		If L_CurrentProfile.Name = "{{P_Player}}" Then
			LTTextField( FindShape( "Name" ) ).Text = LocalizeString( "{{Player}}" )
		Else
			FindShapeWithParameter( "text", "Enter your name" ).Hide()
			FindShape( "Name" ).Hide()
		End If
	End Method
	
	Method Save()
		If L_CurrentProfile.Name = "{{P_Player}}" Then L_CurrentProfile.Name = LTTextField( FindShape( "Name" ) ).Text
		Menu.AddHighScore( L_CurrentProfile.Name, Game.Score )
		
		LTMenuWindow( Menu.Project.FindWindow( , "LTMenuWindow" ) ).DestinationY = 0
		Menu.Project.LoadWindow( Menu.World, , "LTScoresWindow" )
		
		L_CurrentProfile.Flush()
		L_CurrentProfile.Load()
	End Method
End Type