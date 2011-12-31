'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGame Extends LTGUIProject
	Const Void:Int = 0
	Const Plate:Int = 1
	
	Const NoBall:Int = 0
	
	Field World:LTWorld
	Field GameField:LTTileMap
	Field Balls:LTTileMap
	Field HiddenBalls:Int[,]
	Field HUD:LTWindow
	Field Background:LTShape
	Field Objects:LTLayer = New LTLayer
	Field Particles:LTLayer = New LTLayer
	
	Field SelectedTileX:Int = -1
	Field SelectedTileY:Int
	Field Selected:TSelected
	Field EmptyCells:TList = New TList
	Field PathFinder:TPathFinder = New TPathFinder
	Field Score:Int
	Field TotalBalls:Int
	Field GameOver:Int
	
	Field Font:LTBitmapFont
	Field TileSelectionHandler:TTileSelectionHandler = New TTileSelectionHandler

	Field SwapSound:TSound
	Field RushSound:TSound
	Field StopSound:TSound
	Field SelectSound:TSound
	Field ExplosionSound:TSound
	
	Method Init()
		SetGraphicsDriver( D3D7Max2DDriver() )
		World = LTWorld.FromFile( "levels.lw" )

		Menu.ProfileTypeID = TTypeID.ForName( "TGameProfile" )
		Menu.InitSystem( Self )
		HUD = LoadWindow( World, "THUD" )
		Menu.AddPanels()
		
		L_CurrentProfile.Load()
	End Method

	Method LoadLevel( Profile:TGameProfile )
		Local Layer:LTLayer = Null
		LoadAndInitLayer( Layer, LTLayer( World.FindShapeWithParameter( "level_num", "1" ) ) )
		Profile.GameField = LTTileMap( Layer.FindShape( "Field" ) )
		Profile.Balls = LTTileMap( Layer.FindShape( "Balls" ) )
		Profile.Balls.Visualizer = TBallTileMapVisualizer.Create( Profile.Balls.Visualizer )
		HiddenBalls = New Int[ Profile.Balls.XQuantity, Profile.Balls.YQuantity ]
		
		For Local N:Int = 1 To Profile.BallsPerTurn
			Repeat
				Local X:Int = Rand( 0, Profile.GameField.XQuantity - 1 )
				Local Y:Int = Rand( 0, Profile.GameField.YQuantity - 1 )
				If Profile.GameField.Value[ X, Y ] = Plate And Profile.Balls.Value[ X, Y ] = NoBall Then
					Profile.Balls.Value[ X, Y ] = Rand( 1, 7 )
					Exit
				End If
			Forever
		Next
		FillNextBalls( Profile )
		
		Locked = True
	End Method
		
	Method InitLevel()
		PathFinder.Map = GameField
		L_CurrentCamera.JumpTo( GameField )
		SetFieldMagnification()
	End Method
	
	Method InitGraphics()
		L_CurrentProfile.InitCamera( L_CurrentCamera )
		L_CurrentProfile.InitCamera( L_GUICamera )
		If GameField Then SetFieldMagnification()
	End Method
	
	Method SetFieldMagnification()
		L_CurrentCamera.SetMagnification( Min( Floor( L_CurrentCamera.Viewport.Height / 3 / GameField.YQuantity ) * 3, ..
				Floor( L_CurrentCamera.Viewport.Width / 4 / GameField.XQuantity ) * 4 ) )
	End Method
	
	Method InitSound()
		SwapSound = LoadSound( L_Incbin + "swap.ogg" )
		RushSound = LoadSound( L_Incbin + "rush.ogg" )
		StopSound = LoadSound( L_Incbin + "stop.ogg" )
		SelectSound = LoadSound( L_Incbin + "select.ogg" )
		ExplosionSound = LoadSound( L_Incbin + "explosion.ogg" )
	End Method
	
	Method Render()
		SetFieldMagnification()
		Background.JumpTo( L_CurrentCamera )
		Background.SetSize( L_CurrentCamera.Width, 0.75 * L_CurrentCamera.Width )
		Background.Draw()
		If Game.SelectedTileX >= 0 Then GameField.SetTile( SelectedTileX, SelectedTileY, 2 )
		GameField.Draw()
		If Game.SelectedTileX >= 0 Then GameField.SetTile( SelectedTileX, SelectedTileY, 1 )
		Balls.Draw()
		Objects.Draw()
		Particles.Draw()
	End Method
	
	Method Logic()
		If Not Locked Then
			Game.SelectedTileX = -1
			L_Cursor.CollisionsWithTileMap( GameField, TileSelectionHandler )
		End If
		FindWindow( "THUD" ).Active = Not Locked
		Local MenuWindow:LTMenuWindow = LTMenuWindow( FindWindow( "LTMenuWindow" ) )
		If ExitToMenu.WasPressed() And MenuWindow.Active Then MenuWindow.Switch()
		Repeat
			Select PollEvent()
				Case EVENT_WINDOWCLOSE
					LoadWindow( Menu.World, "LTExitWindow" )
				Case 0
					Exit
			End Select
		Forever
		Objects.Act()
		Particles.Act()
		L_ClearSoundMaps()
	End Method
	
	Method DeInit()
		L_CurrentProfile.Save()
		Menu.SaveToFile( "settings.xml" )
	End Method
	
	Method CreateBalls()
		Local Profile:TGameProfile = TGameProfile( L_CurrentProfile )
		RefreshEmptyCells()
		If EmptyCells.Count() < Profile.BallsPerTurn Then
			Menu.LoadGameOverWindow()
			Locked = True
			Return
		End If
		For Local BallNum:Int = Eachin Profile.NextBalls
			Local Cell:TCell = TCell.PopFrom( EmptyCells )
			TPopUpBall.Create( Cell.X, Cell.Y, BallNum )
		Next
		FillNextBalls( Profile )
	End Method
	
	Method FillNextBalls( Profile:TGameProfile )
		For Local N:Int = 0 Until Profile.BallsPerTurn
			Profile.NextBalls[ N ] = Rand( 1, 7 )
		Next
	End Method
	
	Method RefreshEmptyCells()
		EmptyCells.Clear()
		For Local Y:Int = 0 Until GameField.YQuantity
			For Local X:Int = 0 Until GameField.XQuantity
				If GameField.Value[ X, Y ] = Plate And Balls.Value[ X, Y ] = NoBall Then
					EmptyCells.AddLast( TCell.Create( X, Y ) )
				End If
			Next
		Next
	End Method
	
	Method TileToSprite:LTSprite( Model:LTBehaviorModel, X:Int, Y:Int, EraseBall:Int = False )
		Local Sprite:LTSprite = New LTSprite
		Sprite.SetAsTile( Balls, X, Y )
		Objects.AddLast( Sprite )
		Sprite.AttachModel( Model )
		If EraseBall Then
			Balls.SetTile( X, Y, NoBall )
		Else
			HiddenBalls[ X, Y ] = True
		End If
		Return Sprite
	End Method
End Type



Type TCell
	Field X:Int, Y:Int
	
	Function Create:TCell( X:Int, Y:Int )
		Local Cell:TCell = New TCell
		Cell.X = X
		Cell.Y = Y
		Return Cell
	End Function
	
	Function PopFrom:TCell( List:TList )
		Local Num:Int = Rand( 0, List.Count() - 1 )
		Local Link:TLink = List.FirstLink()
		For Local N:Int = 1 To Num
			Link = Link.NextLink()
		Next
		Local Cell:TCell = TCell( Link.Value() )
		Link.Remove()
		Return Cell
	End Function
End Type