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

Include "menu_incbin.bmx"

Incbin "russian.lng"

Global Menu:LTMenu = New LTMenu

Type LTMenu Extends LTProject
	Field Project:LTProject
	Field World:LTWorld
	Field ProfileTypeID:TTypeId = TTypeId.ForName( "LTProfile" )
	Field Profiles:TList = New TList
	
	Method InitSystem( MainProject:LTProject )
		Project = MainProject
		'DebugStop
		Execute()
	End Method
	
	Method Init()
		LTProfile.Init()
		
		ChangeDir( "mouse_menu" )
		World = LTWorld.FromFile( "menu.lw" )
		
		LoadWindow( World, , "LTLanguageSelectionWindow" )
		ChangeDir( ".." )
		
		If L_CurrentProfile.Language Then Exiting = True
	End Method
	
	Method InitGraphics()
		SetImageFont( LoadImageFont( "mouse_menu\OpenSans-Regular.ttf", Floor( L_CurrentCamera.Viewport.Width / 80 ) ) )
		
		Local Screen:LTShape = World.FindShape( "Screen" )
		GUICamera = Project.GUICamera
		Project.GUICamera.Viewport = L_CurrentCamera.Viewport.Clone()
		Project.GUICamera.JumpTo( Screen )
		Project.GUICamera.SetSize( Screen.Width, Screen.Height )		
	End Method
	
	Method DeInit()
		Project.LoadWindow( World, , "LTMenuWindow" )
		Project.LoadWindow( World, , "LTOptionsWindow" )
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageObjectAttribute( "current_profile", L_CurrentProfile )
		XMLObject.ManageChildList( Profiles )
	End Method
End Type

Type LTScoresWindow Extends LTWindow
End Type

Type LTAuthorsWindow Extends LTWindow	
End Type

Type LTExitWindow Extends LTWindow	
End Type