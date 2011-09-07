'
' Skeleton Slayer - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TPlayer Extends LTAngularSprite
	Const TotalActionFrames:Int = 32
	Const StandingAnimationStart:Int = 0
	Const StandingAnimationSize:Int = 4
	Const StandingAnimationSpeed:Double = 0.3
	Const WalkingAnimationStart:Int = 4
	Const WalkingAnimationSize:Int = 8
	Const WalkingAnimationSpeed:Double = 0.1
	Const WalkingSpeed:Double = 4.0
	
	Field TileX:Int, TileY:Int
	Field Position:LTTileMapPosition
	Field Phase:Int
	Field StartingTime:Int

	Method Init()
		Game.Player = Self
		TileX = Floor( X )
		TileY = Floor( Y )
		Game.CollisionMap.Value[ TileX, TileY ] = Game.PlayerTile
	End Method
	
	Method Act()
		If Position Then
			Local PosX:Double = 0.5 + TileX
			Local PosY:Double = 0.5 + TileY
			If X = PosX And Y = PosY Then
				Position = Position.NextPosition
				If Position = Null Then
					StartingTime = Game.Time
				Else
					'Game.CollisionMap.Value[ TileX, TileY ] = Game.EmptyTile
					TileX = Position.X
					TileY = Position.Y
					'Game.CollisionMap.Value[ TileX, TileY ] = Game.PlayerTile
				End If
			Else
				Phase = ( 5 + L_Round( DirectionToPoint( PosX, PosY ) / 45.0 ) ) Mod 8
				MoveTowardsPoint( PosX, PosY, WalkingSpeed )
			End If
			Animate( Game, WalkingAnimationSpeed, WalkingAnimationSize, WalkingAnimationStart, StartingTime )
		Else
			Animate( Game, StandingAnimationSpeed, StandingAnimationSize, StandingAnimationStart, StartingTime, True )
		End If
		Frame = ( Frame Mod TotalActionFrames ) + TotalActionFrames * Phase
	End Method
End Type