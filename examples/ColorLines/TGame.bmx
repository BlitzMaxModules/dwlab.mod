'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global Profile:TGameProfile
Global GameCamera:LTCamera = L_CurrentCamera

Type TGame Extends LTGUIProject
	Field World:LTWorld
	Field HUD:LTWindow
	Field Background:LTShape
	Field Objects:LTLayer = New LTLayer
	Field Particles:LTLayer = New LTLayer
	
	Field SelectedTileX:Int = -1
	Field SelectedTileY:Int
	Field Selected:TSelected
	Field GameOver:Int
	Field TotalBalls:Int
	
	Field TileIsPassable:Int[] = [ 0, 1, 1, 1, 1, 1 ]
	
	Field EmptyCells:TList = New TList
	Field PathFinder:TPathFinder = New TPathFinder
	Field HiddenBalls:Int[,]
	
	Field Font:LTBitmapFont
	Field TileSelectionHandler:TTileSelectionHandler = New TTileSelectionHandler

	Field LeftMouse:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 1 ), "Click" )
	Field RightMouse:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 2 ), "Swap" )

	Field SwapSound:TSound
	Field RushSound:TSound
	Field StopSound:TSound
	Field SelectSound:TSound
	Field ExplosionSound:TSound
	Field WrongTurnSound:TSound
	
	Method Init()
		SetGraphicsDriver( D3D7Max2DDriver() )
		World = LTWorld.FromFile( "levels.lw" )

		Menu.ProfileTypeID = TTypeID.ForName( "TGameProfile" )
		Menu.InitSystem( Self )
		HUD = LoadWindow( World, "THUD" )
		Menu.AddPanels()
		
		Profile = TGameProfile( L_CurrentProfile )
		Profile.Load()
	End Method
	
	Method InitGraphics()
		If Profile Then Profile.InitGraphics()
	End Method
	
	Method InitSound()
		SwapSound = LoadSound( L_Incbin + "swap.ogg" )
		RushSound = LoadSound( L_Incbin + "rush.ogg" )
		StopSound = LoadSound( L_Incbin + "stop.ogg" )
		SelectSound = LoadSound( L_Incbin + "select.ogg" )
		ExplosionSound = LoadSound( L_Incbin + "explosion.ogg" )
		WrongTurnSound = LoadSound( L_Incbin + "wrong_turn.ogg" )
	End Method
	
	Method Logic()
		'Delay 10
	
		If Not Locked Then
			If Not Profile.GameField Then
				LoadWindow( World, "TLevelSelectionWindow" )
				Locked = True
			Else
				Game.SelectedTileX = -1
				L_Cursor.CollisionsWithTileMap( Profile.GameField, TileSelectionHandler )
				If Profile.Goals.IsEmpty() Then Menu.LoadGameOverWindow( "Level completed" )
			End If
		End If
		
		FindWindow( "THUD" ).Active = Not Locked
		Local MenuWindow:LTMenuWindow = LTMenuWindow( FindWindow( "LTMenuWindow" ) )
		If Profile.ExitToMenu.WasPressed() And MenuWindow.Active Then MenuWindow.Switch()
		
		Events()
		
		Objects.Act()
		Particles.Act()
		L_ClearSoundMaps()
		
		For Local Goal:TGoal = Eachin Profile.Goals
			If Goal.Count = 0 Then Profile.Goals.Remove( Goal )
		Next
	End Method
	
	Method Events:Int()
		Repeat
			Select PollEvent()
				Case Event_WindowClose
					If Not Menu.ExitWindow Then LoadWindow( Menu.World, "LTExitWindow" )
					Menu.ExitWindow = True
					Return True
				Case Event_WindowSize
					Profile.Apply( [ LTGUIProject( Self ), LTGUIProject( Menu ) ], True, False, False, False )
				Case 0
					Exit
			End Select
		Forever
	End Method
	
	Method Render()
		Background.JumpTo( GameCamera )
		Background.SetSize( GameCamera.Width, 0.75 * GameCamera.Width )
		Background.Draw()
		If Profile.GameField Then
			Profile.SetFieldMagnification()
			Profile.GameField.Draw()
		End If
		Particles.Draw()
	End Method
	
	Method DeInit()
		Menu.SaveToFile( "settings.xml" )
	End Method
End Type