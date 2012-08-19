'
' Huge isometric maze - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TZombieCollision Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.PushFromSprite( Sprite2 )
		TZombie( Sprite1 ).NewAngle = Rnd( 360.0 )
	End Method
End Type
	
	

Type TZombieAndTileCollision Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		Sprite.PushFromTile( TileMap, TileX, TileY )
		TZombie( Sprite ).NewAngle = Rnd( 360.0 )
	End Method
End Type



Type TActingRegionCollisions Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite2.Act()
	End Method
End Type