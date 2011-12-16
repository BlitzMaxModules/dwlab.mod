'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
Rem
bbdoc: Class for GUI project and subprojects.
End Rem
Type LTGUIProject Extends LTProject
	Rem
	bbdoc: List of windows.
	End Rem
	Field Windows:TList = New TList 
	
	
	' ==================== Loading layers and windows ===================	
	
	Rem
	bbdoc: Window loading function.
	about: Window should be loaded from Lab world file, as layer of the root and has unique class or name (among other layers of root).
	Modal parameter (can be set in editor) set to True forces all existing windows to be inactive while this window is not closed.
	End Rem
	Method LoadWindow:LTWindow( World:LTWorld, Name:String = "", Class:String = "", Add:Int = True )
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
				'Window2.Active = True
				If Window2.Modal Then Return
				Link = Link.PrevLink()
			Wend
		End If
		Window.DeInit()
		FlushKeys
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
		Local MaxRenderPeriod:Double = 1.0 / L_MinFPS
		Local FPSCount:Int
		Local FPSTime:Int
		
		L_DeltaTime = 1.0 / L_LogicFPS
	    
		Repeat
			Time :+  1.0 / L_LogicFPS
			
			?debug
			L_CollisionChecks = 0
			L_SpritesActed = 0
			?
			
			For Local Controller:LTPushable = Eachin L_Controllers
				Controller.Prepare()
			Next
			
			Logic()
			If Exiting Then Exit
			
			For Local Controller:LTPushable = Eachin L_Controllers
				Controller.Reset()
			Next
		
			Repeat
				RealTime = 0.001 * ( Millisecs() - StartTime )
				If RealTime >= Time And ( RealTime - LastRenderTime ) < MaxRenderPeriod Then Exit
				
				If L_Flipping Then Cls
				
				?debug
				L_SpritesDisplayed = 0
				L_TilesDisplayed = 0
				?
				
				L_CurrentCamera.SetCameraViewport()
				Render()
				
				Local OldCamera:LTCamera = L_CurrentCamera
				L_CurrentCamera.SetCameraViewport()
				
				For Local Window:LTWindow = Eachin Windows
					'If Window.Visible Then Window.Draw()
				Next
				L_CurrentCamera = OldCamera
				
				If L_Flipping Then Flip( False )
		      
				LastRenderTime = 0.001 * ( Millisecs() - StartTime )
				FPSCount :+ 1
			Forever
	      
			If Millisecs() >= 1000 + FPSTime Then
				L_FPS = FPSCount
				FPSCount = 0
				FPSTime = Millisecs()
			End If
			
			PollSystem()
			Pass :+ 1
		Forever
		
		DeInit()
	End Method
End Type