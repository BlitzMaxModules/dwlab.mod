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

Global L_ProjectsList:TList = New TList

Rem
bbdoc: Quantity of logic frames per second.
about: See also: #Logic
End Rem
Global L_LogicFPS:Double = 75
Global L_DeltaTime:Double

Rem
bbdoc: Minimal frames per second
about: Game will start to go slower if this threshold will be reached.

See also: #Render
End Rem
Global L_MinFPS:Double = 15

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
	Field StartingTime:Int
	Field FreezingTime:Int
	
	Rem
	bbdoc: Exit flag.
	about: Set it to True to exit project.
	End Rem
	Field Exiting:Int

	' ==================== Loading layers and windows ===================	
	
	Rem
	bbdoc: Loads and initializes layer and all its child objects from previously loaded world.
	End Rem
	Method LoadAndInitLayer( NewLayer:LTLayer Var, Layer:LTLayer )
		NewLayer = LoadLayer( Layer )
		NewLayer.Init()
	End Method
	
	
	
	Rem
	bbdoc: Loads layer from world.
	End Rem
	Method LoadLayer:LTLayer( Layer:LTLayer )
		Local NewLayer:LTLayer = LTLayer( CreateShape( Layer ) )
		For Local Shape:LTShape = Eachin Layer.Children
			Local NewShape:LTShape
			Local ChildLayer:LTLayer = LTLayer( Shape )
			If ChildLayer Then
				NewShape = LoadLayer( ChildLayer )
			Else
				Local SpriteMap:LTSpriteMap = LTSpriteMap( Shape )
				If SpriteMap Then
					Local NewSpriteMap:LTSpriteMap = LTSpriteMap( CreateShape( Shape ) )
					For Local ChildSprite:LTSprite = Eachin SpriteMap.Sprites.Keys()
						NewSpriteMap.InsertSprite( LTSprite( CreateShape( ChildSprite ) ) )
					Next
					NewShape = NewSpriteMap
				Else
					NewShape = CreateShape( Shape )
				End If
			End If
			NewLayer.AddLast( NewShape )
		Next
		Return NewLayer
	End Method
	
	
	
	Method CreateShape:LTShape( Shape:LTShape )
		Local TypeName:String = Shape.GetParameter( "class" )
		Local NewShape:LTShape
		If TypeName Then 
			NewShape = LTShape( L_GetTypeID( TypeName ).NewObject() )
		Else
			NewShape = LTShape( TTypeId.ForObject( Shape ).NewObject() )
		End If
		Shape.CopyTo( NewShape )
		Return NewShape
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
	bbdoc: Method for executing projects after first
	about: Only new project's Logic() method will be executed in cycle instead of old project's, so old projects will be frozen until
	exit from this project will be performed.
	
	See also: #Init, #InitGraphics, #InitSound
	End Rem
	Method Insert()
		If Not L_ProjectsList.IsEmpty() Then LTProject( L_ProjectsList.Last() ).FreezingTime = MilliSecs()
	
		L_ProjectsList.AddLast( Self )
		
		FlushKeys
		FlushMouse
	    
		Exiting = False
				
		Init()
		InitGraphics()
		InitSound()
		
		Time = 0.0
		StartingTime = MilliSecs()
	End Method
	
	
	
	Rem
	bbdoc: Executes the project.
	about: You cannot use this method to execute more projects if the project is already running, use Insert() method instead.
	End Rem
	Method Execute()
		Insert()
		
		Local RealTime:Double = 0
		Local LastRenderTime:Double = 0
		Local MaxRenderPeriod:Double = 1.0 / L_MinFPS
		Local FPSCount:Int
		Local FPSTime:Int
		
		Repeat
			
			?debug
			L_CollisionChecks = 0
			L_SpritesActed = 0
			?
			
			L_CurrentProject = LTProject( L_ProjectsList.Last() )
			L_DeltaTime = 1.0 / L_LogicFPS
			L_CurrentProject.Time :+ L_DeltaTime
			L_CurrentProject.Logic()
			
			If L_CurrentProject.Exiting Then
				L_CurrentProject.DeInit()
				L_ProjectsList.RemoveLast()
				If L_ProjectsList.IsEmpty() Then Exit
				LTProject( L_ProjectsList.Last() ).StartingTime :+ MilliSecs() - FreezingTime
			End If
		
			Repeat
				RealTime = 0.001 * ( Millisecs() - StartingTime )
				If RealTime >= Time And ( RealTime - LastRenderTime ) < MaxRenderPeriod Then Exit
				
				If L_Flipping Then Cls
				
				?debug
				L_SpritesDisplayed = 0
				L_TilesDisplayed = 0
				?
				
				For L_CurrentProject = Eachin L_ProjectsList
					L_CurrentProject.Render()
				Next
				
				If L_Flipping Then Flip( False )
		      
				LastRenderTime = 0.001 * ( Millisecs() - StartingTime )
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
	End Method
	
	' ==================== Other ===================	
	
	Method ReloadWindows()
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

See also: #L_LogicFPS
End Rem
Function L_PerSecond:Double( Value:Double )
	Return Value * L_DeltaTime
End Function




Rem
bbdoc: Draws various debugging information on screen.
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