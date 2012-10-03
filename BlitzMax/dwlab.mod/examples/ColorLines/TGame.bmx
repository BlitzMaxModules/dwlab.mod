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
	Field LevelTime:Int
	
	Field TileIsPassable:Int[] = [ 0, 1, 0, 1, 1, 0, 1, 1 ]
	
	Field EmptyCells:TList = New TList
	Field PathFinder:TPathFinder = New TPathFinder
	Field HiddenBalls:Int[,]
	
	Field Font:LTBitmapFont
	Field TileSelectionHandler:TTileSelectionHandler = New TTileSelectionHandler

	Field LeftMouse:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 1 ), "Click" )
	Field RightMouse:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 2 ), "Swap" )
	
	Field SwapSound:TSound = LoadSound( L_Incbin + "sound\swap.ogg" )
	Field RushSound:TSound = LoadSound( L_Incbin + "sound\rush.ogg" )
	Field StopSound:TSound = LoadSound( L_Incbin + "sound\stop.ogg" )
	Field SelectSound:TSound = LoadSound( L_Incbin + "sound\select.ogg" )
	Field ExplosionSound:TSound = LoadSound( L_Incbin + "sound\explosion.ogg" )
	Field WrongTurnSound:TSound = LoadSound( L_Incbin + "sound\wrong_turn.ogg" )
	
	Field ExitWindow:Int
	
	Method Init()
		LTProfile.MusicLoadingTime = [ 3619, 1815 ]
		LTProfile.TotalMusicLoadingTime = 5432
		
		SetGraphicsDriver( D3D7Max2DDriver() )
		Interface = LTWorld.FromFile( "interface.lw" )
		Menu.Levels = LTWorld.FromFile( "levels.lw" )

		Menu.ProfileTypeID = TTypeID.ForName( "TGameProfile" )
		Menu.InitSystem( Self )
		HUD = LoadWindow( Interface, "THUD" )
		Menu.AddPanels()
		
		Profile = TGameProfile( L_CurrentProfile )
		Profile.Load()
		
		If FileType( "stats.xml" ) = 1 Then TStatList.Instance = TStatList( LoadFromFile( "stats.xml" ) )
		
		If L_CurrentProfile.MusicQuantity > 0 Then L_CurrentProfile.MusicMode = L_CurrentProfile.Normal
		L_CurrentProfile.StartMusic()
	End Method
	
	Method InitGraphics()
		If Profile Then Profile.InitGraphics()
	End Method
	
	Method Logic()
		
		Delay 5
		L_CurrentProfile.ManageSounds()
	
		If Not Locked Then
			Profile.LevelTime :+ MilliSecs() - LevelTime
			If Not Profile.GameField Then
				Menu.LoadFirstLevel()
			Else
				Game.SelectedTileX = -1
				L_Cursor.CollisionsWithTileMap( Profile.GameField, TileSelectionHandler )
				If Profile.Goals.IsEmpty() Then
					Locked = True
					LoadWindow( Menu.Interface, "LTLevelCompletedWindow" )
				End If
			End If
		End If
		
		LevelTime = MilliSecs()
		
		FindWindow( "THUD" ).Active = Not Locked
		Local MenuWindow:LTMenuWindow = LTMenuWindow( FindWindow( "LTMenuWindow" ) )
		If Profile.ExitToMenu.WasPressed() And MenuWindow.Active Then MenuWindow.Switch()
		
		Objects.Act()
		Particles.Act()
		
		For Local Goal:TGoal = Eachin Profile.Goals
			If Goal.Count <= 0 Then Profile.Goals.Remove( Goal )
		Next
	End Method
	
	Method OnCloseButton()
		If Not ExitWindow Then LoadWindow( Menu.Interface, "LTExitWindow" )
		ExitWindow = True
	End Method
	
	Method OnWindowResize()
		Profile.Apply( [ LTGUIProject( Self ), LTGUIProject( Menu ) ], True, False )
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
	
	Method CheckBall( Shape:LTShape, X:Int, Y:Int, CheckLines:Int )
		Game.HiddenBalls[ X, Y ] = False
		If LTSprite( Shape ).Frame = Profile.BlackBall And Profile.GameField.GetTile( X, Y ) = Profile.ClosedPocket Then
			Shape.AttachModel( TFallIntoPocket.Create( X, Y ) )
		Else
			Game.Objects.Remove( Shape )
			If CheckLines Then TCheckLines.Execute( LTSprite( Shape ).Frame )
		End If
		Game.Selected = Null
		Game.Locked = False
	End Method
End Type