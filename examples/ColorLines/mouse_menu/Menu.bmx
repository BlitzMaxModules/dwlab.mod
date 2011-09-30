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
	Field ScreenWidthGrain:Int = 48
	Field ScreenHeightGrain:Int = 48
	Field Languages:TList = New TList
	Field VideoDrivers:TList = New TList
	Field AudioDrivers:TList = New TList
	Field ScreenResolutions:TList = New TList
	
	

	Method Init:LTWorld( Project:LTProject )
		ChangeDir( "mouse_menu" )
		
		SetLocalizationMode( Localization_On )
		
		Local Menu:LTWorld = LTWorld.FromFile( "menu.lw" )
		
		Languages.AddLast( LoadLanguage( "incbin::russian.lng" ) )
		'SetLocalizationLanguage( Language.Handle )
		
		For Local N:Int = 0 Until CountGraphicsModes()
			Local Width:Int, Height:Int, Depth:Int, Hertz:Int
			GetGraphicsMode( N, Width, Height, Depth, Hertz )
			If Width >= 640 Then LTScreenResolution.Add( Width, Height, Depth, Hertz )
		Next
		
		For Local DriverTypeID:TTypeId = Eachin TTypeID.ForName( "TMax2DDriver" ).DerivedTypes()
			DebugLog DriverTypeID.Name()
			For Local CreateMethod:TMethod = Eachin DriverTypeID.EnumMethods()
				DebugLog " " + CreateMethod.Name()
				If CreateMethod.Name().ToLower() = "create" Then VideoDrivers.AddLast( CreateMethod.Invoke( DriverTypeID.NewObject(), Null ) )
			Next
		Next
		'Debugstop
		
		If Not L_CurrentProfile Then LTProfile.CreateDefault()
		InitScreen()
		SetImageFont( LoadImageFont( "OpenSans-Regular.ttf", 14 ) )
		
		ChangeDir( ".." )
		
		Local Screen:LTShape = Menu.FindShape( "Screen" )
		Project.GUICamera.Viewport = L_CurrentCamera.Viewport.Clone()
		Project.GUICamera.JumpTo( Screen )
		Project.GUICamera.SetSize( Screen.Width, Screen.Height )
		Menu.Remove( Screen )
		
		Project.LoadWindow( Menu, , "LTMenuWindow" )
		Project.LoadWindow( Menu, , "LTOptionsWindow" )
	End Method
	
	Method InitScreen()
		Local Width:Int, Height:Int 
		If L_CurrentProfile.FullScreen Then
			Width = DesktopWidth()
			Height = DesktopHeight() - 86
		Else
			Width = L_CurrentProfile.ScreenWidth
			Height = L_CurrentProfile.ScreenHeight
		End If
		Width = Floor( Width / ScreenWidthGrain ) * ScreenWidthGrain
		Height = Floor( Height / ScreenHeightGrain ) * ScreenHeightGrain
		Local BlockSize:Int = Min( Height / ScreenWidthGrain, Width / ScreenHeightGrain )
		If L_CurrentProfile.FullScreen Then
			L_InitGraphics( L_CurrentProfile.ScreenWidth, L_CurrentProfile.ScreenHeight, 64.0, L_CurrentProfile.ColorDepth )
			L_CurrentCamera.Viewport.Width = ScreenWidthGrain * BlockSize
			L_CurrentCamera.Viewport.Height = ScreenHeightGrain * BlockSize
		Else
    		L_InitGraphics( ScreenWidthGrain * BlockSize, ScreenHeightGrain * BlockSize, 64.0 )
		End If
	End Method
End Type

Type LTScoresWindow Extends LTWindow
End Type

Type LTAuthorsWindow Extends LTWindow	
End Type

Type LTExitWindow Extends LTWindow	
End Type