'
' Skeleton Slayer - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGame Extends LTProject
	Const EmptyTile:Int = 0
	Const BlockedTile:Int = 1
	Const PlayerTile:Int = 2
	Const EnemyTile:Int = 3
	
	Field World:LTWorld
	Field Level:LTLayer
	Field Objects:LTSpriteMap
	Field CollisionMap:LTIntMap
	Field Player:TPlayer
	Field SelectedTile:LTShape
	Field PathFinder:LTTileMapPathFinder
	
	Method Init()
		World = LTWorld.FromFile( "world.lw" )
		L_InitGraphics()
		World.Camera.Viewport = L_CurrentCamera.Viewport
		L_CurrentCamera = World.Camera
		L_CurrentCamera.SetMagnification( 64.0 )
		
		InitLevel()
	End Method
	
	Method InitLevel()
		Local TileMap:LTTileMap = LTTileMap( World.FindShape( "LTTileMap,Ground" ) )
		CollisionMap = New LTIntMap
		CollisionMap.SetResolution( TileMap.XQuantity, TileMap.YQuantity )
		
		PathFinder = LTTileMapPathFinder.Create( CollisionMap, True )
		 
		LoadAndInitLayer( Level, LTLayer( World.FindShape( "LTLayer,Level" ) ) )
		
		Objects = LTSpriteMap( Level.FindShape( "Objects" ) )
		Local Ground:LTTileMap = LTTileMap( Level.FindShape( "Ground" ) )
		Local Walls:LTTileMap = LTTileMap( Level.FindShape( "Fence" ) )
		For Local Y:Int = 0 Until CollisionMap.YQuantity
			For Local X:Int = 0 Until CollisionMap.XQuantity
				If Ground.Value[ X, Y ] >= 4 Or Walls.Value[ X, Y ] < 10 Then CollisionMap.Value[ X, Y ] = BlockedTile
			Next
		Next
		
		SelectedTile = Level.FindShape( "SelectedTile" )
		SelectedTile.Visualizer = New LTMarchingAnts
	End Method
	
	Method Render()
		Level.Draw()
		ShowDebugInfo()
	End Method
	
	Method Logic()
		SelectedTile.SetMouseCoords()
		SelectedTile.SetCoords( Floor( SelectedTile.X ) + 0.5, Floor( SelectedTile.Y ) + 0.5 )
		
		If MouseHit( 1 ) Then
			Local TileX:Int = Floor( SelectedTile.X )
			Local TileY:Int = Floor( SelectedTile.Y )
			Local TileNum:Int = Game.CollisionMap.Value[ TileX, TileY ]
			If TileNum <> Game.BlockedTile Then
				Player.AttachModel( TMovingAlongPath.Create( PathFinder.FindPath( Player.TileX, Player.TileY, TileX, TileY, TileNum <> Game.EmptyTile ) ) )
			End If
		End If

		If KeyHit( Key_Escape ) Or AppTerminate() Then Exiting = True
		Level.Act()
		L_CurrentCamera.JumpTo( Player )
	End Method
End Type