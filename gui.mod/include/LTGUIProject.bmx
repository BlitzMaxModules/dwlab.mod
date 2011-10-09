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
Global L_Cursor:LTSprite = New LTSprite
L_Cursor.ShapeType = LTSprite.Pivot

Rem
bbdoc: Class for GUI project and subprojects.
End Rem
Type LTGUIProject Extends LTProject
	Rem
	bbdoc: List of windows.
	End Rem
	Field Windows:TList = New TList 
	
	Rem
	bbdoc: Camera for displaying windows.
	End Rem
	Field GUICamera:LTCamera = LTCamera.Create()
	
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
	Method LoadWindow:LTWindow( World:LTWorld, Name:String = "", Class:String = "" )
		L_ActiveTextField = Null
		If Class Then
			L_Window = LTWindow( LoadLayer( LTLayer( World.FindShapeWithParameter( "class", Class ) ) ) )
		Else
			L_Window = LTWindow( LoadLayer( LTLayer( World.FindShape( Name ) ) ) )
		End If

		Local Screen:LTShape = L_Window.Bounds
		If Screen Then
			If Windows.IsEmpty() Then
				GUICamera.JumpTo( Screen )
				GUICamera.SetSizeAs( Screen )
				GUICamera.Update()
			Else
				Local DWidth:Double = GUICamera.Width / Screen.Width
				Local DHeight:Double = GUICamera.Height / Screen.Height
				For Local Shape:LTShape = Eachin L_Window.Children
					Shape.SetCoords( GUICamera.X + ( Shape.X - Screen.X ) * DWidth, GUICamera.Y + ( Shape.Y - Screen.Y ) * DHeight )
					Shape.SetSize( Shape.Width * DWidth, Shape.Height * DHeight )
				Next
			End If
		End If
		
		L_Window.Modal = ( L_Window.GetParameter( "modal" ) = "true" )
		L_Window.World = World
		L_Window.Project = Self
		L_Window.Init()
		If L_Window.Modal Then
			For Local Window:LTWindow = Eachin Windows
				Window.Active = False
			Next
		End If
		Windows.AddLast( L_Window )
		Return L_Window
	End Method

	
	
	Rem
	bbdoc: Function which finds a window in opened windows by given name or class.
	returns: Found window.
	End Rem
	Method FindWindow:LTWindow( Name:String = "", Class:String = "" )
		For Local Window:LTWindow = Eachin Windows
			If Name Then If Window.GetName() = Name Then Return Window
			If Class Then If TTypeID.ForObject( Window ).Name() = Class Then Return Window
		Next
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
	End Method
	
	
	
	Method Execute()
		FlushKeys
		FlushMouse
	    
		Exiting = False
		Pass = 1
		L_DeltaTime = 0
				
		Init()
		InitGraphics()
		InitSound()
		
		Time = 0.0
		Local StartTime:Int = MilliSecs()
		
		Local RealTime:Double = 0
		Local LastRenderTime:Double = 0
		Local MaxRenderPeriod:Double = 1.0 / MinFPS
		Local FPSCount:Int
		Local FPSTime:Int
		
		L_DeltaTime = 1.0 / LogicFPS
	    
		Repeat
			Time :+  1.0 / LogicFPS
			
			?debug
			L_CollisionChecks = 0
			L_SpritesActed = 0
			?
			
			For Local Controller:LTPushable = Eachin L_Controllers
				Controller.Prepare()
			Next
			
			If Not Paused Then Logic()
			For Local Window:LTWindow = Eachin Windows
				Window.Act()
			Next
			If Exiting Then Exit
			
			For Local Controller:LTPushable = Eachin L_Controllers
				Controller.Reset()
			Next
		
			Repeat
				RealTime = 0.001 * ( Millisecs() - StartTime )
				If RealTime >= Time And ( RealTime - LastRenderTime ) < MaxRenderPeriod Then Exit
				
				If Flipping Then Cls
				
				?debug
				L_SpritesDisplayed = 0
				L_TilesDisplayed = 0
				?
				
				L_CurrentCamera.SetCameraViewport()
				Render()
				
				Local OldCamera:LTCamera = L_CurrentCamera
				L_CurrentCamera = GUICamera
				L_CurrentCamera.SetCameraViewport()
				L_Cursor.SetMouseCoords()
				For Local Window:LTWindow = Eachin Windows
					Window.Draw()
				Next
				L_CurrentCamera = OldCamera
				
				If Flipping Then Flip( False )
		      
				LastRenderTime = 0.001 * ( Millisecs() - StartTime )
				FPSCount :+ 1
			Forever
	      
			If Millisecs() >= 1000 + FPSTime Then
				FPS = FPSCount
				FPSCount = 0
				FPSTime = Millisecs()
			End If
			
			PollSystem()
			Pass :+ 1
		Forever
		
		DeInit()
	End Method
End Type