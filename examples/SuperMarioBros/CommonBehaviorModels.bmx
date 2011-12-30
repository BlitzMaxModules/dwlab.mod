'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type THorizontalMovement Extends LTBehaviorModel
	Field SpriteCollisionHandler:LTSpriteCollisionHandler
	Field TileCollisionHandler:LTSpriteAndTileCollisionHandler
	
	Function Create:THorizontalMovement( SpriteCollisionHandler:LTSpriteCollisionHandler, TileCollisionHandler:LTSpriteAndTileCollisionHandler )
		Local Movement:THorizontalMovement = New THorizontalMovement
		Movement.SpriteCollisionHandler = SpriteCollisionHandler
		Movement.TileCollisionHandler = TileCollisionHandler
		Return Movement
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( Sprite.DX, 0.0 )
		Sprite.CollisionsWithSpriteMap( Game.MovingObjects, SpriteCollisionHandler )
		Sprite.CollisionsWithTilemap( Game.Tilemap, TileCollisionHandler )
	End Method
End Type



Type TVerticalMovement Extends LTBehaviorModel
	Field SpriteCollisionHandler:LTSpriteCollisionHandler
	Field TileCollisionHandler:LTSpriteAndTileCollisionHandler
	
	Function Create:TVerticalMovement( SpriteCollisionHandler:LTSpriteCollisionHandler, TileCollisionHandler:LTSpriteAndTileCollisionHandler )
		Local Movement:TVerticalMovement = New TVerticalMovement
		Movement.SpriteCollisionHandler = SpriteCollisionHandler
		Movement.TileCollisionHandler = TileCollisionHandler
		Return Movement
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( 0.0, Sprite.DY )
		Sprite.CollisionsWithSpriteMap( Game.MovingObjects, SpriteCollisionHandler )
		Sprite.CollisionsWithTilemap( Game.Tilemap, TileCollisionHandler )
	End Method
End Type



Type TGravity Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		LTVectorSprite( Shape ).DY :+ Game.PerSecond( Game.Gravity )
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