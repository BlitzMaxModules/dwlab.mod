'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TCollisions Extends LTBehaviorModel
	Field CheckCollisionsWithTilemap:Int = True
	Field CheckCollisionsWithSprites:Int = True

	
	
	Method ApplyTo( Shape:LTShape )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Shape )
	
		VectorSprite.Move( VectorSprite.DX, 0.0 )
		If CheckCollisionsWithTilemap Then VectorSprite.CollisionsWithTilemap( Game.Tilemap, LTSprite.Horizontal )
		If CheckCollisionsWithSprites Then VectorSprite.CollisionsWithSpriteMap( Game.MovingObjects, LTSprite.Horizontal )

		VectorSprite.Move( 0.0, VectorSprite.DY )
		If CheckCollisionsWithTilemap Then VectorSprite.CollisionsWithTilemap( Game.Tilemap, LTSprite.Vertical )
		If CheckCollisionsWithSprites Then VectorSprite.CollisionsWithSpriteMap( Game.MovingObjects, LTSprite.Vertical )
	End Method
	
	
	
	Method SetCollisions( WithTilemap:Int, WithSprites:Int )
		CheckCollisionsWithTilemap:Int = WithTilemap
		CheckCollisionsWithSprites:Int = WithSprites
	End Method
End Type





Type TGravity Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		LTVectorSprite( Shape ).DY :+ Game.PerSecond( Game.Gravity )
	End Method
End Type





Type TBumpingTiles Extends LTBehaviorModel
	Method HandleCollisionWithTile( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
		VectorSprite.PushFromTile( TileMap, TileX, TileY )
		If CollisionType = LTSprite.Vertical Then
			VectorSprite.DY = 0
		Else
			VectorSprite.DX = -VectorSprite.DX
			If TKoopaTroopa( Sprite ) Then Game.Bump.Play()
		End If
	End Method
End Type





Type TBumpingSprites Extends LTBehaviorModel
	Method HandleCollisionWithSprite( Sprite1:LTSprite, Sprite2:LTSprite, CollisionType:Int )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite1 )
		If TBonus( Sprite2 ) Then Return
		Sprite1.PushFromSprite( Sprite2 )
		If CollisionType = LTSprite.Vertical Then
			VectorSprite.DY = 0
		Else
			VectorSprite.DX = -VectorSprite.DX
		End If
	End Method
End Type





Type TRemoveIfOutside Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTSprite = LTSprite( Shape )
		If Sprite.TopY() > Game.Tilemap.BottomY() Then
			Game.Level.Remove( Sprite )
			Game.MovingObjects.RemoveSprite( Sprite )
		End If
	End Method
End Type