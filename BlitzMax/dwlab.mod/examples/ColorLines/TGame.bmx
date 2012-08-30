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
	Field Levels:LTWorld
	Field Interface:LTWorld
	
	Field HUD:LTWindow
	Field Background:LTShape
	Field Objects:LTLayer = New LTLayer
	Field Particles:LTLayer = New LTLayer
	
	Field SelectedTileX:Int = -1
	Field SelectedTileY:Int
	Field Selected:TSelected
	Field GameOver:Int
	Field TotalBalls:Int
	
	Field TileIsPassable:Int[] = [ 0, 1, 0, 1, 1, 0, 1, 1 ]
	
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
	
	Field ExitWindow:Int
	
	Method Init()
		SetGraphicsDriver( D3D7Max2DDriver() )
		Interface = LTWorld.FromFile( "interface.lw" )
		Levels = LTWorld.FromFile( "levels.lw" )

		Menu.ProfileTypeID = TTypeID.ForName( "TGameProfile" )
		Menu.InitSystem( Self )
		HUD = LoadWindow( Interface, "THUD" )
		Menu.AddPanels()
		
		Profile = TGameProfile( L_CurrentProfile )
		Profile.Load()
	End Method
	
	Method InitGraphics()
		If Profile Then Profile.InitGraphics()
	End Method
	
	Method InitSound()
		SwapSound = LoadSound( L_Incbin + "sound\swap.ogg" )
		RushSound = LoadSound( L_Incbin + "sound\rush.ogg" )
		StopSound = LoadSound( L_Incbin + "sound\stop.ogg" )
		SelectSound = LoadSound( L_Incbin + "sound\select.ogg" )
		ExplosionSound = LoadSound( L_Incbin + "sound\explosion.ogg" )
		WrongTurnSound = LoadSound( L_Incbin + "sound\wrong_turn.ogg" )
	End Method
	
	Method Logic()
		Delay 5
		L_CurrentProfile.ManageSounds()
	
		If Not Locked Then
			If Not Profile.GameField Then
				LoadWindow( Interface, "TLevelSelectionWindow" )
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
		
		Objects.Act()
		Particles.Act()
		
		For Local Goal:TGoal = Eachin Profile.Goals
			If Goal.Count = 0 Then Profile.Goals.Remove( Goal )
		Next
	End Method
	
	Method OnCloseButton()
		If Not ExitWindow Then LoadWindow( Menu.World, "LTExitWindow" )
		ExitWindow = True
	End Method
	
	Method OnWindowResize()
		Profile.Apply( [ LTGUIProject( Self ), LTGUIProject( Menu ) ], True, False, False, False )
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