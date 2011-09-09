'
' Skeleton Slayer - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TPlayer Extends TPerson
	Method Init()
		Game.Player = Self
		Velocity = 5.0
		TileType = Game.PlayerTile
		Super.Init()
	End Method
	
	Method RecalculatePath( Model:TMovingAlongPath )
		Local LastPosition:LTTileMapPosition = Model.Position.LastPosition()
		Model.Position = Game.PathFinder.FindPath( TileX, TileY, LastPosition.X, LastPosition.Y )
	End Method
End Type

