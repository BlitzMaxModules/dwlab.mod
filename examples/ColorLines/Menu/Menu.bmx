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
Include "LTMenuWindow.bmx"
Include "LTOptionsWindow.bmx"
Include "LTSelectProfileWindow.bmx"
Include "LTAddProfileWindow.bmx"
Include "LTRemoveProfileWindow.bmx"
Include "LTSettingsWindow.bmx"

Include "menu_incbin.bmx"

Incbin "russian.lng"

Global Menu:LTMenu = New LTMenu

Type LTMenu
	Field Languages:TList = New TList
	Field VideoModes:TList = New TList
	
	

	Method Init:LTWorld( Project:LTProject )
		ChangeDir( "mouse_menu" )
		Local Menu:LTWorld = LTWorld.FromFile( "menu.lw" )
		ChangeDir( ".." )
		
		Languages.AddLast( LTLanguage.Create( "Russian", "incbin::russian.lng" ) )
		For Local N:Int = 0 Until CountGraphicsModes()
			Local Width:Int, Height:Int, Hertz:Int
			'VideoModes.AddLast( LTVideoMode.Create(
		Next
	
		Local Screen:LTShape = Menu.FindShape( "Screen" )
		Project.GUICamera.Viewport = L_CurrentCamera.Viewport.Clone()
		Project.GUICamera.JumpTo( Screen )
		Project.GUICamera.SetSize( Screen.Width, Screen.Height )
		Menu.Remove( Screen )
		
		Project.LoadWindow( Menu, , "LTMenuWindow" )
		Project.LoadWindow( Menu, , "LTOptionsWindow" )	
	End Method
End Type