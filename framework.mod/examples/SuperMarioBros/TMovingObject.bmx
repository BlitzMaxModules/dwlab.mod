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
	
	
	
	Method Bump( CollisionType:Int )
		If CollisionType = Horizontal Then
			DX = -DX
		Else
			DY = 0.0
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, Shape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		Bump( CollisionType )
	End Method
	
	
	
	Method Act()
		Move( DX, 0 )
		CollisionsWithTilemap( Game.Tilemap, Horizontal )
		CollisionsWithCollisionMap( Game.MovingObjects, Horizontal )

		Move( 0, DY )
		CollisionsWithTilemap( Game.Tilemap, Vertical )
		CollisionsWithCollisionMap( Game.MovingObjects, Vertical )
		
		RemoveIfOutside()
	End Method
	
	
	
	Method RemoveIfOutside()
		If TopY() > Game.Tilemap.BottomY() Then
			Game.MainLayer.Remove( Self )
			Game.MovingObjects.RemoveSprite( Self )
		End If
	End Method
End Type