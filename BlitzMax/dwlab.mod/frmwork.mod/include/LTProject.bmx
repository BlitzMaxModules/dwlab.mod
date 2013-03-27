'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_CollisionChecks:Int
Global L_TilesDisplayed:Int
Global L_SpritesDisplayed:Int
Global L_SpritesActed:Int
Global L_SpriteActed:Int

Global L_CurrentProject:LTProject
Global L_Cursor:LTSprite = LTSprite.FromShape( , , , , LTSprite.Pivot )

Rem
bbdoc: Quantity of logic frames per second.
about: See also: #Logic
End Rem
Global L_LogicFPS:Double = 75
Global L_DeltaTime:Double

Global L_MaxLogicStepsWithoutRender:Double = 6

Rem
bbdoc: Current frames per second quantity.
about: See also: #Render
End Rem
Global L_FPS:Int

Rem
bbdoc: Flipping flag.
about: If set to True then Cls will be performed before Render() and Flip will be performed after Render().
End Rem
Global L_Flipping:Int = True

Rem
bbdoc: Class for main project and subprojects.
End Rem
Type LTProject Extends LTObject
	Rem
	bbdoc: Current logic frame number.
	End Rem
	Field Pass:Int
	
	Rem
	bbdoc: Current game time in seconds (starts from 0).
	about: See also: #PerSecond
	End Rem
	Field Time:Double = 0.0
	
	Rem
	bbdoc: Exit flag.
	about: Set it to True to exit project.
	End Rem
	Field Exiting:Int

	Field StartingTime:Int
	
	' ==================== Loading layers and windows ===================	
	
	'Deprecated
	Method LoadAndInitLayer( NewLayer:LTLayer Var, Layer:LTLayer )
		NewLayer = LoadLayer( Layer )
		NewLayer.Init()
	End Method
	
	
	
	Rem
	bbdoc: Loads layer from world.
	End Rem
	Method LoadLayer:LTLayer( Layer:LTLayer )
		Return LTLayer( Layer.Load() )
	End Method
	
	' ==================== Management ===================	
	
	Rem
	bbdoc: Initialization method.
	about: Fill it with project initialization commands.
	
	See also: #InitGraphics, #InitSound, #DeInit
	End Rem
	Method Init()
	End Method
	
	
	
	Rem
	bbdoc: Graphics initialization method.
	about: It will be relaunched after changing graphics driver (via profiles). You should put font loading code there if you have any.
	
	See also: #Init, #InitSound, #DeInit
	End Rem
	Method InitGraphics()
	End Method
	
	
	Rem
	bbdoc: Sound initialization method.
	about: It will be relaunched after changing sound driver (via profiles). You should put sound loading code there if you have any.
	
	See also: #Init, #InitGraphics, #DeInit
	End Rem
	Method InitSound()
	End Method
  
  
	Rem
	bbdoc: Rendering method.
	about: Fill it with objects drawing commands. Will be executed as many times as possible, while keeping logic frame rate.
	
	See also: #MinFPS, #FPS
	End Rem
	Method Render()
	End Method
	
	
	
	Rem
	bbdoc: Logic method. 
	about: Fill it with project mechanics commands. Will be executed "LogicFPS" times per second.
	
	See also: #LogicFPS
	End Rem
	Method Logic()
	End Method
	
	
	
	Rem
	bbdoc: Deinitialization method.
	about: It will be executed before exit from the project.
	
	See also: #Init, #InitGraphics, #InitSound
	End Rem
	Method DeInit()
	End Method
	
	
	
	Rem
	bbdoc: Executes the project.
	about: You cannot use this method to execute more projects if the project is already running, use Insert() method instead.
	End Rem
	Method Execute()
		Local OldProject:LTProject = L_CurrentProject
		L_CurrentProject = Self
	
		FlushKeys
		FlushMouse
	    
		Exiting = False
		Pass = 1
		L_DeltaTime = 0
		
		Init()
		InitGraphics()
		InitSound()
		
		Time = 0.0
		StartingTime = MilliSecs()
				
		Local RealTime:Double = 0
		Local FPSCount:Int
		Local FPSTime:Int
		
		For Local Controller:LTPushable = Eachin L_Controllers
			Controller.Reset()
		Next
		
		Local LogicStepsWithoutRender:Int = 0
		
		Repeat
			L_DeltaTime = 1.0 / L_LogicFPS
			Time :+ L_DeltaTime
			
			?debug
			L_CollisionChecks = 0
			L_SpritesActed = 0
			?
			
			ProcessEvents()
			
			L_Cursor.SetMouseCoords()
			Logic()
			
			WindowsLogic()
			
			For Local Controller:LTPushable = Eachin L_Controllers
				Controller.Reset()
			Next
			
			If Exiting Then Exit
			
			LogicStepsWithoutRender :+ 1
			
			Repeat
				RealTime = 0.001 * ( Millisecs() - StartingTime )
				If RealTime >= Time And LogicStepsWithoutRender <= L_MaxLogicStepsWithoutRender Then Exit
				
				If L_Flipping And GraphicsWidth() Then Cls
				
				?debug
				L_SpritesDisplayed = 0
				L_TilesDisplayed = 0
				?
				
				L_CurrentCamera.SetCameraViewport()
				L_Cursor.SetMouseCoords()
				Render()
				
				WindowsRender()
				
				If L_Flipping And GraphicsWidth() Then Flip( False )
		      
				LogicStepsWithoutRender = 0
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
		L_CurrentProject = OldProject
	End Method
	
	' ==================== Events ===================		
	
	Method ProcessEvents()
		Repeat
			PollEvent()
			For Local Controller:LTPushable = Eachin L_Controllers
				Controller.ProcessEvent()
			Next
			Select EventID()
				Case Event_WindowClose
					OnCloseButton()
				Case Event_WindowSize
					OnWindowResize()
				Case 0
					Exit
			End Select
			OnEvent()
		Forever
	End Method
	
	
	
	Method OnEvent()
	End Method
	
	
	
	Method OnCloseButton()
		Exiting = True
	End Method
	
	
	
	Method OnWindowResize()
	End Method
	
	' ==================== Dummies for GUI project ===================	
	
	Method WindowsLogic()
	End Method
	
	
	
	Method WindowsRender()
	End Method
	
	
	
	Method ReloadWindows()
	End Method
	
	' ==================== Other ===================	
	
	Rem
	bbdoc: Switches the project execution to given.
	about: Use this command instead of calling another Execute() method.
	
	See also: #LTButtonAction example
	End Rem
	Method SwitchTo( Project:LTProject )
		Local FreezingTime:Int = MilliSecs()
		Project.Execute()
		L_DeltaTime = 1.0 / L_LogicFPS
		StartingTime :+ MilliSecs() - FreezingTime
	End Method
	
	
	
	'Deprecated
	Method PerSecond:Double( Value:Double )
		Return Value * L_DeltaTime
	End Method
	
	
	
	Method ShowDebugInfo()
		L_ShowDebugInfo()
	End Method
End Type





Rem
bbdoc: Converts value second to value per logic frame.
returns: Value for logic frame using given per second value.
about: For example, can return coordinate increment for speed per second.

See also: #L_LogicFPS, #SetAsTile example
End Rem
Function L_PerSecond:Double( Value:Double )
	Return Value * L_DeltaTime
End Function




Rem
bbdoc: Draws various debugging information on screen.
about: See also #WedgeOffWithSprite example
End Rem
Function L_ShowDebugInfo()
	DrawText( "FPS: " + L_FPS, 0, 0 )
	DrawText( "Memory: " + Int( GCMemAlloced() / 1024 ) + "kb", 0, 16 )
	
	?debug
	DrawText( "Collision checks: " + L_CollisionChecks, 0, 32 )
	DrawText( "Tiles displayed: " + L_TilesDisplayed, 0, 48 )
	DrawText( "Sprites displayed: " + L_SpritesDisplayed, 0, 64 )
	DrawText( "Sprites acted: " + L_SpritesActed, 0, 80 )
	?
End Function