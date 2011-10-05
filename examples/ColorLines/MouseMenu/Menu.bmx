'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTProfile.bmx"
Include "LTLanguageSelectionWindow.bmx"
Include "LTMenuWindow.bmx"
Include "LTOptionsWindow.bmx"
Include "LTSelectProfileWindow.bmx"
Include "LTAddProfileWindow.bmx"
Include "LTRemoveProfileWindow.bmx"
Include "LTSettingsWindow.bmx"
Include "LTProfilesList.bmx"
Include "LTHighScoresList.bmx"
Include "LTGameOverWindow.bmx"

Include "menu_incbin.bmx"

Incbin "russian.lng"

Global Menu:LTMenu = New LTMenu

Type LTMenu Extends LTGUIProject
	Field Project:LTGUIProject
	Field World:LTWorld
	Field DesktopAreaWidth:Int = DesktopWidth()
	Field DesktopAreaHeight:Int = DesktopHeight() - 86
	
	Field ProfileTypeID:TTypeId = TTypeId.ForName( "LTProfile" )
	Field Profiles:TList = New TList
	Field SelectedProfile:LTProfile
	
	Field HighScores:TList = New TList
	Field MaxHighScores:Int = 20
	
	Field GameState:LTObject
	
	Function InitSystem( MainProject:LTGUIProject )
		If FileType( "settings.xml" ) = 1 Then Menu.LoadFromFile( "settings.xml", False )
		Menu.Project = MainProject
		Menu.Execute()
	End Function
	
	Method Init()
		LTProfile.InitSystem()
		If Not L_CurrentProfile Then
			LTProfile.CreateDefault( ProfileTypeID )
			L_CurrentProfile.Init()
			Profiles.AddLast( L_CurrentProfile )
		End If
		
		ChangeDir( "MouseMenu" )
		World = LTWorld.FromFile( "menu.lw" )
		
		LoadWindow( World, , "LTLanguageSelectionWindow" )
		ChangeDir( ".." )
		
		L_CurrentProfile.Apply( False )
		
		HighScores.Clear()
		For Local N:Int = 1 To 20
			AddHighScore( "Mighty Matt", Rand( 100, 10000 ) )
		Next
		
		If L_CurrentProfile.Language Then Exiting = True
	End Method
	
	Method InitGraphics()
		SetImageFont( LoadImageFont( "MouseMenu\OpenSans-Regular.ttf", Floor( L_CurrentCamera.Viewport.Width / 80 ) ) )
	End Method
	
	Method AddPanels()
		Project.LoadWindow( World, , "LTMenuWindow" )
		Project.LoadWindow( World, , "LTOptionsWindow" )
	End Method
	
	Method AddHighScore( Name:String, Score:Int, Achievements:TList = Null )
		Local Link:TLink = HighScores.FirstLink()
		While Link <> Null
			If LTHighScore( Link.Value() ).Score <= Score Then
				HighScores.InsertBeforeLink( LTHighScore.Create( Name, Score, Achievements ), Link )
				Return
			End If
			Link = Link.NextLink()
		WEnd
		If HighScores.Count() < MaxHighScores Then HighScores.AddLast( LTHighScore.Create( Name, Score, Achievements ) )
	End Method
	
	Method LoadGameOverWindow()
		Project.LoadWindow( World, , "LTGameOverWindow" )
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		L_CurrentProfile = LTProfile( XMLObject.ManageObjectAttribute( "current_profile", L_CurrentProfile ) )
		XMLObject.ManageListField( "profiles", Menu.Profiles )
		XMLObject.ManageListField( "high_scores", Menu.HighScores )
	End Method
End Type



Type LTHighScore Extends LTObject
	Field Score:Int
	Field Name:String
	Field Achievements:TList
	
	Function Create:LTHighScore( Name:String, Score:Int, Achievements:TList = Null )
		Local HighScore:LTHighScore = New LTHighScore
		HighScore.Name = Name
		HighScore.Score = Score
		HighScore.Achievements = Achievements
		Return HighScore
	End Function
End Type



Type LTScoresWindow Extends LTWindow
End Type



Type LTAuthorsWindow Extends LTWindow	
End Type



Type LTExitWindow Extends LTWindow	
End Type