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
	Field CollisionMap:LTTileMap
	
	Method Init()
		World = LTWorld.FromFile( "world.lw" )
		InitLevel()
	End Method
	
	Method InitLevel()
		LoadAndInitLayer( Level, LTLayer( World.FindShape( "LTLayer" ) ) )
		
		Objects = LTSpriteMap( Level.FindShape( "Objects" ) )
		CollisionMap = LTTileMap( World.FindShape( "CollisionMap" ) )
		
		Local Ground:LTTileMap = LTTileMap( Level.FindShape( "Ground" ) )
		Local Walls:LTTileMap = LTTileMap( Level.FindShape( "Walls" ) )
		For Local Y:Int = 0 Until CollisionMap.YQuantity
			For Local X:Int = 0 Until CollisionMap.XQuantity
				CollisionMap.Value[ X, Y ] = EmptyTile
				If Ground.Value[ X, Y ] >= 4 Or Walls.Value[ X, Y ] < 10 Then CollisionMap.Value[ X, Y ] = BlockedTile
			Next
		Next
		
		Player = LTAngularSprite( World.FindShape( "Player" ) )
		LTLayer( World.FindShape( "LTLayer" ) ).Remove( Player )
		Objects.InsertSprite( Player )
		CollisionMap.Value[ Floor( Sprite.X ), Floor( Sprite.Y ) ] = PlayerTile
		
		For Local Sprite:LTSprite = Eachin Objects.GetSprites().Keys()
			CollisionMap.Value[ Floor( Sprite.X ), Floor( Sprite.Y ) ] = EnemyTile
		Next
	End Method
	
	Method Render()
		
		World.Draw()
	End Method

End Type