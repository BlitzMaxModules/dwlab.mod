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

Function L_LoadPanels:LTWorld( Project:LTProject )
	ChangeDir( "mouse_menu" )
	Local Menu:LTWorld = LTWorld.FromFile( "menu.lw" )
	ChangeDir( ".." )
	
	Local Screen:LTSprite = Menu.FindShape( "Screen" )
	Project.GUICamera.JumpTo( Screen )
	Project.GUICamera.SetSize( Screen.Width, Screen.Height )
	Menu.Remove( Screen )
	
	Project.LoadWindow( Menu, , "LTMenuWindow" )
	Project.LoadWindow( Menu, , "LTOptionsWindow" )	
End Function