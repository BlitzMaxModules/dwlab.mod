'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TMario.bmx"
Include "TEnemy.bmx"
Include "TBonus.bmx"

Type TMovingObject Extends LTVectorSprite
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		PushFromSprite( Sprite )
		Bump( CollisionType )
	End Method
	
	
	
	Method Bump( CollisionType:Int, Mirror:Int = False )
		If CollisionType = Horizontal Then
			DX = -DX
			If Mirror Then Visualizer.XScale = -Visualizer.XScale
		Else
			DY = 0.0
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		Bump( CollisionType )
	End Method
	
	
	
	Method Act()
		Move( DX, 0 )
		CollisionsWithTilemap( Game.Tilemap, Horizontal )
		CollisionsWithCollisionMap( Game.CollisionMap, Horizontal )
		
		Move( 0, DY )
		CollisionsWithTilemap( Game.Tilemap, Vertical )
		CollisionsWithCollisionMap( Game.CollisionMap, Vertical )
	End Method
End Type