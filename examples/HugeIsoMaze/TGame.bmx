'
' Huge isometric maze - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGame Extends LTProject
	Const MazeSize:Int = 256
	Const ZombieProbability:Double = 0.1
	
	Field Template:LTWorld
	Field Maze:LTTileMap
	Field Objects:LTSpriteMap
	Field Zombies:Int
	Field ActingRegion:TActingRegion = New TActingRegion
	
	
	
	Method Init()
		L_InitGraphics()
		Template = LTWorld.FromFile( "template.lw" )
		Maze = LTTileMap( Template.FindShape( "LTTileMap" ) )
		Maze.SetResolution( MazeSize, MazeSize )
		( New TMazeGenerator ).Execute( Maze )
		Maze.Stretch( 2, 2 )
		Maze.Enframe()
		Objects = LTSpriteMap( Template.FindShape( "LTSpriteMap" ) )
		Objects.SetCellSize( 2.0, 2.0 )
		Objects.SetResolution( MazeSize, MazeSize )
		
		Local WallSprite:TWall = TWall( CreateShape( Template.FindShape( "TWall" ) ) )
		Local FloorSprite:TFloor = TFloor( CreateShape( Template.FindShape( "TFloor" ) ) )
		Local ZombieSprite:TZombie =  TZombie( CreateShape( Template.FindShape( "TZombie" ) ) )
		For Local Y:Int = 0 Until Maze.YQuantity
			PleaseWait()
			For Local X:Int = 0 Until Maze.XQuantity
				If Maze.Value[ X, Y ] = 1 Then
					InsertSprite( FloorSprite, X, Y, Rand( 0, 3 ) )
					If Rnd() < ZombieProbability Then
						InsertSprite( ZombieSprite, X, Y, Rand( 0, 63 ) )
						Zombies :+ 1
					End If
				ElseIf Maze.Value[ X, Y ] >= 4 Then
					InsertSprite( WallSprite, X, Y, Maze.Value[ X, Y ] )
					If Maze.Value[ X, Y ] = 8 Or Maze.Value[ X, Y ] = 10 Then InsertSprite( FloorSprite, X, Y, Rand( 0, 3 ) )
				End If
			Next
		Next
		
		ActingRegion.ShapeType = LTSprite.Rectangle
		ActingRegion.SetSize( 2.0 * L_CurrentCamera.Width, 2.0 * L_CurrentCamera.Height )
	End Method
	
	
	
	Method InsertSprite( Sprite:LTSprite, X:Int, Y:Int, Frame:Int )
		Local NewSprite:LTSprite = LTSprite( TTypeID.ForObject( Sprite ).NewObject() )
		Sprite.CopyTo( NewSprite )
		NewSprite.X :+ X - Y
		NewSprite.Y :+ 0.5 * ( X + Y )
		NewSprite.Frame = Frame
		NewSprite.Init()
		Objects.InsertSprite( NewSprite )
	End Method
	
	
	
	Method Logic()
		L_CurrentCamera.MoveUsingArrows( 8.0 )
		ActingRegion.JumpTo( L_CurrentCamera )
		ActingRegion.CollisionsWithSpriteMap( Objects )
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		Objects.Draw()
		ShowDebugInfo()
		DrawText( "Zombies: " + Zombies, 0, 96 )
	End Method
End Type
