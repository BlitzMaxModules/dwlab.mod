'
' Skeleton Slayer - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TSkeleton Extends TPlayer
	Method Init()
		TileX = L_Round( X - 0.5 )
		TileY = L_Round( Y - 0.5 )
		Game.CollisionMap.Value[ TileX, TileY ] = Game.EnemyTile
	End Method
End Type