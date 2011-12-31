'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TGoomba.bmx"
Include "TKoopaTroopa.bmx"

Type TEnemy Extends LTVectorSprite
	Method Stomp()
	End Method
End Type



Global BumpingWalls:TBumpingWalls = New TBumpingWalls
Type TBumpingWalls Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
		VectorSprite.PushFromTile( TileMap, TileX, TileY )
		VectorSprite.DX = -VectorSprite.DX
		If TKoopaTroopa( Sprite ) Then Game.Bump.Play()
	End Method
End Type



Global BumpingSprites:TBumpingSprites = New TBumpingSprites
Type TBumpingSprites Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite1 )
		If TBonus( Sprite2 ) Then Return
		Sprite1.PushFromSprite( Sprite2 )
		VectorSprite.DX = -VectorSprite.DX
	End Method
End Type



Global PushFromSprites:TPushFromSprites = New TPushFromSprites
Type TPushFromSprites Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.PushFromSprite( Sprite2 )
	End Method
End Type



Global PushFromFloor:TPushFromFloor = New TPushFromFloor
Type TPushFromFloor Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		Sprite.PushFromTile( TileMap, TileX, TileY )
		LTVectorSprite( Sprite ).DY = 0
	End Method
End Type