'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TCursor Extends LTSprite
	Field LeftMouse:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 1 ), "Click" )
	Field RightMouse:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 2 ), "Swap" )

	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
	End Method
End Type