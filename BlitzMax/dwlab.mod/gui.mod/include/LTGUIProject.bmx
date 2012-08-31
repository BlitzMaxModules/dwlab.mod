'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_Window:LTWindow
Global L_ActiveTextField:LTTextField

Rem
bbdoc: Camera for displaying windows.
End Rem
Global L_GUICamera:LTCamera = LTCamera.Create()

Rem
bbdoc: Class for GUI project and subprojects.
End Rem
Type LTGUIProject Extends LTProject
	Rem
	bbdoc: List of windows.
	End Rem
	Field Windows:TList = New TList 
	
	Rem
	bbdoc: Flag for locking project controls.
	End Rem
	Field Locked:Int

	' ==================== Loading layers and windows ===================	
	
	Rem
	bbdoc: Window loading function.
	about: Window should be loaded from Lab world file, as layer of the root and has unique class or name (among other layers of root).
	Modal parameter (can be set in editor) set to True forces all existing windows to be inactive while this window is not closed.
	End Rem
	Method LoadWindow:LTWindow( World:LTWorld, Class:String = "", Name:String = "", Add:Int = True )
		L_ActiveTextField = Null
		If Class Then
			L_Window = LTWindow( LoadLayer( LTLayer( World.FindShapeWithParameter( "class", Class ) ) ) )
		Else
			L_Window = LTWindow( LoadLayer( LTLayer( World.FindShape( Name ) ) ) )
		End If
		
		Local Screen:LTShape = L_Window.Bounds
		If Screen Then
			If Windows.IsEmpty() Then L_GUICamera.SetSize( Screen.Width, Screen.Height )
			
			Local DY:Double = 0.5 * ( L_GUICamera.Height - Screen.Height * L_GUICamera.Width / Screen.Width )
			Select L_Window.GetParameter( "vertical" )
				Case "top"
					DY = -DY
				Case "bottom"
				Default 
					DY = 0.0
			End Select
			Local K:Double = L_GUICamera.Width / Screen.Width
			For Local Shape:LTShape = Eachin L_Window.Children	
				Shape.SetCoords( L_GUICamera.X + ( Shape.X - Screen.X ) * K, L_GUICamera.Y + ( Shape.Y - Screen.Y ) * K + DY )
				Shape.SetSize( Shape.Width * K, Shape.Height * K )
			Next
			Screen.JumpTo( L_GUICamera )
			Screen.AlterCoords( 0.0, DY )
			Screen.SetSize( L_GUICamera.Width, Screen.Height * L_GUICamera.Width / Screen.Width )
		End If

		L_Window.Modal = L_Window.ParameterExists( "modal" )
		L_Window.World = World
		L_Window.Project = Self
		L_Window.Init()
		If L_Window.Modal Then
			For Local Window:LTWindow = Eachin Windows
				Window.Active = False
			Next
		End If
		If Add Then Windows.AddLast( L_Window )
		FlushKeys
		Return L_Window
	End Method
	
	
	
	Method ReloadWindows()
		Local Link:TLink = Windows.FirstLink()
		While Link
			Local Window:LTWindow = LTWindow( Link.Value() )
			Link._value = LoadWindow( Window.World, TTypeID.ForObject( Window ).Name(), Window.GetName(), False )
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Rem
	bbdoc: Function which finds a window in opened windows by given name or class.
	returns: Found window.
	End Rem
	Method FindWindow:LTWindow( Class:String = "", Name:String = "" )
		Local TypeID:TTypeId = L_GetTypeID( Class )
		For Local Window:LTWindow = Eachin Windows
			If Name Then If Window.GetName() = Name Then Return Window
			If Class Then If TTypeID.ForObject( Window ) = TypeID Then Return Window
		Next
		L_Error( "Window with name ~q" + Name + "~q and class ~q" + Class + "~q is not found." )
	End Method
	
	
	
	Rem
	bbdoc: Closes given window
	about: Method removes the window from project's windows list.
	End Rem
	Method CloseWindow( Window:LTWindow = Null )
		If Window = Null Then Window = LTWindow( Windows.Last() )
		Windows.Remove( Window )
		If Window.Modal Then
			Local Link:TLink = Windows.LastLink()
			While Link <> Null
				Local Window2:LTWindow = LTWindow( Link.Value() )
				Window2.Active = True
				If Window2.Modal Then Return
				Link = Link.PrevLink()
			Wend
		End If
		Window.DeInit()
		FlushKeys
	End Method
	
	
	
	Method WindowsLogic()
		Local OldCamera:LTCamera = L_CurrentCamera
		L_CurrentCamera = L_GUICamera
		L_Cursor.SetMouseCoords()
		
		For Local Window:LTWindow = Eachin Windows
			If Window.Active Then Window.Act()
		Next
		
		L_CurrentCamera = OldCamera
	End Method
	
	
	
	Method WindowsRender()
		Local OldCamera:LTCamera = L_CurrentCamera
		L_CurrentCamera = L_GUICamera
		L_CurrentCamera.SetCameraViewport()
		L_Cursor.SetMouseCoords()
		For Local Window:LTWindow = Eachin Windows
			If Window.Visible Then Window.Draw()
		Next
		
		L_CurrentCamera = OldCamera
		L_Cursor.SetMouseCoords()
	End Method
End Type