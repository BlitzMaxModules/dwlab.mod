'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTLanguageSelectionWindow.bmx"
Include "LTAudioWindow.bmx"
Include "LTMenuWindow.bmx"
Include "LTOptionsWindow.bmx"
Include "LTRestartWindow.bmx"
Include "LTSelectProfileWindow.bmx"
Include "LTMenuListBox.bmx"
Include "LTProfilesList.bmx"
Include "LTAddProfileWindow.bmx"
Include "LTRenameProfileWindow.bmx"
Include "LTRemoveProfileWindow.bmx"
Include "LTSettingsWindow.bmx"
Include "LTKeysList.bmx"
Include "LTKeyWindow.bmx"
Include "LTHighScoresList.bmx"
Include "LTAuthorsList.bmx"
Include "LTGameOverWindow.bmx"
Include "LTExitWindow.bmx"

Global L_OldIncbin:String = L_Incbin
Global L_MenuPath:String

Rem
Include "menu_incbin.bmx"

Incbin "russian.lng"
Incbin "english.lng"
Incbin "font.ttf"
Incbin "images\calculator.png"
Incbin "sounds\boss.ogg"
Incbin "sounds\button_click.ogg"
Incbin "sounds\close.ogg"
Incbin "sounds\sound_on.ogg"
EndRem

If L_Incbin Then
	L_MenuPath = L_Incbin
Else
	L_MenuPath = "MouseMenu\"
End If

Global Menu:LTMenu = New LTMenu

Type LTMenu Extends LTGUIProject
	Field Project:LTGUIProject
	Field World:LTWorld
	
	Field ProfileTypeID:TTypeId = TTypeId.ForName( "LTProfile" )
	Field Profiles:TList = New TList
	Field SelectedProfile:LTProfile
	
	Field HighScores:TList = New TList
	Field MaxHighScores:Int = 10
	Field NewHighScore:Int = -1
	
	Field GameState:LTObject
	
	Field Boss:TSound
	Field ButtonClick:TSound
	Field Close:TSound
	Field SoundOn:TSound
	
	Function InitSystem( MainProject:LTGUIProject )
		If FileType( "settings.xml" ) = 1 Then Menu.LoadFromFile( "settings.xml", False )
		Menu.Project = MainProject
		Menu.Execute()
	End Function
	
	Method Init()
		L_TextSize = 0.3
		
		LTProfile.InitSystem()
		If Not L_CurrentProfile Then
			L_CurrentProfile = LTProfile.CreateDefault( ProfileTypeID )
			Profiles.AddLast( L_CurrentProfile )
		End If
		L_CurrentProfile.SetAsCurrent()
		SelectedProfile = L_CurrentProfile

		L_CurrentProfile.Apply( [ Project, LTGUIProject( Self ) ] )
		
		If Not L_Incbin Then ChangeDir( "MouseMenu" )
		World = LTWorld.FromFile( "menu.lw" )
		If Not L_Incbin Then ChangeDir( ".." )
		L_Incbin = L_OldIncbin
		
		LoadWindow( World, "LTLanguageSelectionWindow" )
		SetLocalizationLanguage( LTProfile.GetLanguage( L_CurrentProfile.Language ) )
		
		Rem
		'HighScores.Clear()
		Profiles.Clear()
		For Local N:Int = 1 To 20
			'AddHighScore( "Mighty Matt", N )
			LTProfile.CreateDefault( ProfileTypeID )
			L_CurrentProfile.Name = N
			Profiles.AddLast( L_CurrentProfile )
		Next
		EndRem
	End Method
	
	Method InitGraphics()
		SetImageFont( LoadImageFont( L_MenuPath + "font.ttf", 36 ) )
		L_CurrentProfile.InitCamera( L_GUICamera )
	End Method
	
	Method InitSound()
		Boss = TSound.Load( L_Incbin + "MouseMenu\sounds\boss.ogg", False )
		ButtonClick = TSound.Load( L_Incbin + "MouseMenu\sounds\button_click.ogg", False )
		Close = TSound.Load( L_Incbin + "MouseMenu\sounds\close.ogg", False )
		SoundOn = TSound.Load( L_Incbin + "MouseMenu\sounds\sound_on.ogg", False )
	End Method
	
	Method Logic()
		If L_CurrentProfile.Language Then Exiting = True
	End Method
	
	Method OnCloseButton()
		End
	End Method
	
	Method OnWindowResize()
		Profile.Apply( [ Self ], True, False, False, False )
	End Method

	Method DeInit()
		Windows.Clear()
	End Method
		
	Method AddPanels()
		Project.LoadWindow( World, "LTMenuWindow" )
		Project.LoadWindow( World, "LTOptionsWindow" )
		Project.Locked = True
	End Method
	
	Method AddHighScore( Name:String, Score:Int, Achievements:TList = Null )
		Local Link:TLink = HighScores.FirstLink()
		NewHighScore = 0
		While Link <> Null
			If LTHighScore( Link.Value() ).Score <= Score Then
				HighScores.InsertBeforeLink( LTHighScore.Create( Name, Score, Achievements ), Link )
				If HighScores.Count() > MaxHighScores Then HighScores.RemoveLast()
				Return
			End If
			Link = Link.NextLink()
			NewHighScore :+ 1
		WEnd
		If HighScores.Count() < MaxHighScores Then HighScores.AddLast( LTHighScore.Create( Name, Score, Achievements ) )
	End Method
	
	Method LoadGameOverWindow( Title:String = "Game over" )
		Profile.GameField = Null
		LTLabel( Project.LoadWindow( World, "LTGameOverWindow" ).FindShape( "GameOver" ) ).Text = LocalizeString( "{{" + Title + "}}" )
		Project.Locked = True
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		L_CurrentProfile = LTProfile( XMLObject.ManageObjectAttribute( "current_profile", L_CurrentProfile ) )
		XMLObject.ManageListField( "profiles", Menu.Profiles )
		XMLObject.ManageListField( "high_scores", Menu.HighScores )
	End Method
End Type



Type LTScoresWindow Extends LTAudioWindow
	Method DeInit()
		Menu.NewHighScore = -1
	End Method
End Type



Type LTAuthorsWindow Extends LTAudioWindow
End Type